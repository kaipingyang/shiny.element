# Components put together, as an app does: each app under
# inst/examples/combinations/ is run in a browser and driven through its
# steps (tools/combinations/<name>.R), every check reported, with every
# console warning and error, and the server's.
#
#   Rscript tools/combinations.R              # all of them
#   Rscript tools/combinations.R drawn-later  # one
#
# A step file uses:
#   act(js, wait)    run JavaScript, then wait for the server
#   check(label, js) a JavaScript expression that must be true
#   show(label, js)  print a value, to look at
#   iv(id)           JavaScript reading input$<id>, whatever type it was sent with
#   vis(selector)    JavaScript for the visible elements matching a selector
#   z(selector)      JavaScript for an element's z-index
#   ev(js)           a JavaScript value, in R
#
# Exits non-zero when a check fails or the page logs a warning or an error.

options(chromote.timeout = 90)
suppressMessages({
  library(chromote)
  library(callr)
})

PKG <- normalizePath(".")
apps <- list.dirs(
  file.path(PKG, "inst", "examples", "combinations"),
  recursive = FALSE
)
wanted <- commandArgs(TRUE)
if (length(wanted)) {
  apps <- apps[basename(apps) %in% wanted]
}
if (!length(apps)) {
  stop("no app matched")
}

chromote::set_chrome_args(c(
  chromote::default_chrome_args(),
  "--disable-dev-shm-usage",
  "--no-sandbox",
  "--disable-gpu"
))

iv <- function(k) {
  sprintf(
    "(function(){ var v = Shiny.shinyapp.$inputValues; var k = Object.keys(v).filter(function(x){ return x === '%1$s' || x.indexOf('%1$s:') === 0; })[0]; return k ? v[k] : undefined; })()",
    k
  )
}
vis <- function(sel) {
  sprintf(
    "Array.from(document.querySelectorAll('%s')).filter(function(e){ return e.offsetParent; })",
    sel
  )
}
z <- function(sel) {
  sprintf(
    "(function(){ var e = document.querySelector('%s'); return e ? parseInt(getComputedStyle(e).zIndex) || 0 : -1; })()",
    sel
  )
}

failed <- character()
for (app in apps) {
  name <- basename(app)
  steps <- file.path(PKG, "tools", "combinations", paste0(name, ".R"))
  cat(sprintf("\n# %s\n", name))
  port <- httpuv::randomPort()
  log <- tempfile(fileext = ".log")
  proc <- callr::r_bg(
    function(app, pkg, port) {
      pkgload::load_all(pkg, quiet = TRUE, helpers = FALSE)
      # Vue's development build, so its warnings reach the console
      options(shiny.element.dev = TRUE)
      shiny::runApp(
        app,
        host = "127.0.0.1",
        port = port,
        launch.browser = FALSE
      )
    },
    args = list(app = app, pkg = PKG, port = port),
    stdout = log,
    stderr = "2>&1"
  )
  for (i in 1:120) {
    Sys.sleep(0.5)
    if (any(grepl("Listening", readLines(log, warn = FALSE)))) break
  }
  b <- ChromoteSession$new(width = 1280, height = 1000)
  b$Page$enable()
  b$Runtime$enable()
  b$Page$addScriptToEvaluateOnNewDocument(
    source = paste0(
      "window.__L=[];['error','warn'].forEach(function(k){var o=console[k];",
      "console[k]=function(){try{window.__L.push(k+': '+Array.prototype.slice.call(arguments)",
      ".map(String).join(' ').slice(0,240))}catch(e){};o.apply(console,arguments)}});",
      "window.addEventListener('error',function(e){window.__L.push('exception: '+e.message)});",
      "window.addEventListener('unhandledrejection',function(e){window.__L.push('rejection: '+(e.reason&&e.reason.message))});"
    )
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d/", port))
  Sys.sleep(7)
  ev <- function(js) {
    r <- b$Runtime$evaluate(js, awaitPromise = TRUE)
    if (!is.null(r$exceptionDetails)) {
      paste("JS ERROR:", r$exceptionDetails$exception$description)
    } else {
      r$result$value
    }
  }
  fails <- 0
  act <- function(js, wait = 1.5) {
    r <- ev(js)
    if (is.character(r) && length(r) == 1 && startsWith(r, "JS ERROR")) {
      fails <<- fails + 1
      cat("  !!  ", substr(r, 1, 200), "\n")
    }
    Sys.sleep(wait)
    invisible(r)
  }
  check <- function(label, js) {
    r <- ev(js)
    ok <- isTRUE(r)
    if (!ok) {
      fails <<- fails + 1
    }
    cat(sprintf(
      "  %s %s%s\n",
      if (ok) "ok  " else "FAIL",
      label,
      if (ok) {
        ""
      } else {
        paste0("  -> ", substr(paste(format(r), collapse = " "), 1, 200))
      }
    ))
  }
  show <- function(label, js) {
    cat(sprintf(
      "  ..  %s: %s\n",
      label,
      substr(paste(format(ev(js)), collapse = " "), 1, 300)
    ))
  }
  sys.source(steps, envir = environment())
  logs <- jsonlite::fromJSON(ev("JSON.stringify(window.__L)"))
  if (length(logs)) {
    fails <- fails + length(logs)
    cat("  console:\n")
    cat(paste0("    ", unique(substr(logs, 1, 240))), sep = "\n")
  }
  srv <- readLines(log, warn = FALSE)
  srv <- srv[grepl("Warning|Error", srv)]
  if (length(srv)) {
    fails <- fails + length(srv)
    cat("  server:\n")
    cat(paste0("    ", head(unique(srv), 10)), sep = "\n")
  }
  if (fails) {
    failed <- c(failed, name)
  }
  try(b$close(), silent = TRUE)
  proc$kill()
}

cat("\n")
if (length(failed)) {
  cat("failed:", paste(failed, collapse = ", "), "\n")
  quit(status = 1)
}
cat("every combination ran cleanly\n")
