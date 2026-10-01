# Infrastructure for the browser integration tests.
#
# The unit tests assert on generated HTML, which cannot see any of the failures
# these components actually had: a Vue watch that never fires on mount, a
# handler script that was never loaded, a template that fails to compile, a
# custom tag that nothing ever compiles. Those only show up in a real browser,
# so these helpers boot the app in a background R process and drive headless
# Chromium over CDP, reading the DOM as ground truth.

.browser_env <- new.env(parent = emptyenv())

#' Is a browser integration run possible here?
skip_if_no_browser <- function() {
  skip_on_cran()
  skip_if_not_installed("chromote")
  skip_if_not_installed("callr")
  skip_if_not_installed("httpuv")
  chrome <- tryCatch(chromote::find_chrome(), error = function(e) NULL)
  skip_if(is.null(chrome), "no Chrome/Chromium binary available")
  skip_if(
    nzchar(Sys.getenv("SHINY_ELEMENT_SKIP_BROWSER")),
    "SHINY_ELEMENT_SKIP_BROWSER is set"
  )
}

#' Chrome's flags for every browser test
#'
#' /dev/shm is tiny in containers, which crashes the renderer on heavier pages.
#' The flags only apply to a Chrome not yet running, so every test file that
#' opens a session calls this first: the bookmark test, running first, once
#' started Chrome without them, and the integration page crashed it later.
use_browser_args <- function() {
  chromote::set_chrome_args(c(
    chromote::default_chrome_args(),
    "--disable-dev-shm-usage", "--no-sandbox", "--disable-gpu"
  ))
}

#' Boot the fixture app once and hand back a live browser session
#'
#' The app and the session are cached: booting Shiny and Chromium costs several
#' seconds, and every test reads a different part of the same page.
browser_session <- function() {
  if (!is.null(.browser_env$session)) return(.browser_env$session)

  app  <- testthat::test_path("apps", "integration.R")
  pkg  <- normalizePath(testthat::test_path("..", ".."))
  port <- httpuv::randomPort()
  log  <- tempfile(fileext = ".log")

  proc <- callr::r_bg(
    function(app, pkg, port, libs) {
      .libPaths(libs)
      # Prefer the sources under test over anything installed, so the app
      # exercises the working tree. helpers = FALSE matters: load_all() would
      # otherwise source this very file in a process that is not a test run,
      # where teardown_env() does not exist.
      loaded <- FALSE
      if (requireNamespace("pkgload", quietly = TRUE)) {
        loaded <- tryCatch({
          pkgload::load_all(pkg, quiet = TRUE, helpers = FALSE, attach_testthat = FALSE)
          TRUE
        }, error = function(e) FALSE)
      }
      if (!loaded) library(shiny.element)
      shiny::runApp(app, host = "127.0.0.1", port = port, launch.browser = FALSE)
    },
    args = list(app = app, pkg = pkg, port = port, libs = .libPaths()),
    stdout = log, stderr = "2>&1"
  )

  ready <- FALSE
  for (i in seq_len(120)) {
    Sys.sleep(0.5)
    if (!proc$is_alive()) break
    if (any(grepl("Listening on", readLines(log, warn = FALSE)))) {
      ready <- TRUE
      break
    }
  }
  if (!ready) {
    proc$kill()
    stop("fixture app failed to start:\n", paste(readLines(log, warn = FALSE), collapse = "\n"))
  }

  use_browser_args()
  b <- chromote::ChromoteSession$new()

  errs <- new.env(parent = emptyenv())
  errs$seen <- character(0)
  b$Runtime$enable()
  b$Runtime$exceptionThrown(callback_ = function(m) {
    errs$seen <- c(errs$seen, sub("\n.*", "", m$exceptionDetails$exception$description))
  })

  # Capture console.error/warn from inside the page. Page$enable() is required
  # first -- without it addScriptToEvaluateOnNewDocument silently does nothing
  # and every console read comes back empty, which reads exactly like "no
  # warnings were raised".
  # Needed by tests that drive a file input through DOM.setFileInputFiles.
  b$DOM$enable()

  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(source = paste0(
    "window.__elLogs = [];",
    "['error','warn'].forEach(function(k){",
    "  var orig = console[k];",
    "  console[k] = function(){",
    "    try { window.__elLogs.push(Array.prototype.slice.call(arguments)",
    "          .map(String).join(' ').slice(0, 300)); } catch(e) {}",
    "    orig.apply(console, arguments);",
    "  };",
    "});"
  ))

  b$Page$navigate(sprintf("http://127.0.0.1:%d/", port))
  b$Page$loadEventFired()
  # Vue mounts, widgets render and the Shiny socket settles.
  Sys.sleep(5)

  .browser_env$session <- list(b = b, proc = proc, log = log, errs = errs)
  .browser_env$session
}

#' Evaluate JS in the page and return the value to R
bev <- function(js) {
  browser_session()$b$Runtime$evaluate(js)$result$value
}

#' Click an element by CSS selector, then wait for a reactive round-trip
bclick <- function(selector, wait = 2) {
  bev(sprintf("(function(){var e=document.querySelector('%s'); if(e) e.click(); return !!e})()", selector))
  Sys.sleep(wait)
  invisible(NULL)
}

#' Read the text of a verbatim output, as a named character vector
#'
#' The fixture app prints one `key = value` line per input it reports.
bdump <- function(id = "dump") {
  txt <- bev(sprintf(
    "(function(){var e=document.getElementById('%s'); return e?e.innerText:''})()", id
  ))
  lines <- trimws(strsplit(txt, "\n")[[1]])
  lines <- lines[grepl("=", lines, fixed = TRUE)]
  if (!length(lines)) return(character(0))
  keys <- trimws(sub("=.*", "", lines))
  vals <- trimws(sub("^[^=]*=", "", lines))
  stats::setNames(vals, keys)
}

#' JS errors seen on the page so far
bjs_errors <- function() {
  unique(browser_session()$errs$seen)
}

#' console.error / console.warn messages raised inside the page
#'
#' The fixture app loads Vue's development build, so this also surfaces
#' `[Vue warn]` messages. The production build strips them, which is how a
#' template that fails to compile renders nothing and reports nothing.
bconsole <- function() {
  unique(bev("JSON.stringify(window.__elLogs || [])") |>
           jsonlite::fromJSON(simplifyVector = TRUE) |>
           as.character())
}

#' Tear the fixture down
browser_cleanup <- function() {
  s <- .browser_env$session
  if (is.null(s)) return(invisible(NULL))
  try(s$b$close(), silent = TRUE)
  try(s$b$parent$get_browser()$get_process()$kill(), silent = TRUE)
  try(s$proc$kill(), silent = TRUE)
  .browser_env$session <- NULL
  invisible(NULL)
}

# Helpers are also sourced by pkgload::load_all(), where teardown_env() does
# not exist yet, so only register the teardown during an actual test run.
# teardown_env() only exists inside a real test run, and this file is also
# sourced by pkgload::load_all().
try(withr::defer(browser_cleanup(), teardown_env()), silent = TRUE)
