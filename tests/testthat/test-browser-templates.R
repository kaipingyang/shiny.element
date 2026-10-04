`%||%` <- function(a, b) if (is.null(a)) b else a

# How far htmltools tags go as Vue templates: each case in apps/templates.R
# is written with tags, and Vue (development build) must draw what it says.

test_that("Vue template syntax written with htmltools tags compiles", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "templates.R")
  pkg <- normalizePath(testthat::test_path("..", ".."))
  port <- httpuv::randomPort()
  log <- tempfile(fileext = ".log")
  proc <- callr::r_bg(
    function(app, pkg, port, libs) {
      .libPaths(libs)
      pkgload::load_all(
        pkg,
        quiet = TRUE,
        helpers = FALSE,
        attach_testthat = FALSE
      )
      shiny::runApp(
        app,
        host = "127.0.0.1",
        port = port,
        launch.browser = FALSE
      )
    },
    args = list(app = app, pkg = pkg, port = port, libs = .libPaths()),
    stdout = log,
    stderr = "2>&1"
  )
  on.exit(proc$kill(), add = TRUE)
  for (i in seq_len(120)) {
    Sys.sleep(0.5)
    if (any(grepl("Listening on", readLines(log, warn = FALSE)))) break
  }
  use_browser_args()
  b <- chromote::ChromoteSession$new(width = 1000, height = 900)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  b$Page$enable()
  b$Page$addScriptToEvaluateOnNewDocument(
    "window.__w = []; ['warn', 'error'].forEach(function(k) {
       var o = console[k];
       console[k] = function() { window.__w.push(Array.prototype.join.call(arguments, ' ').slice(0, 300)); return o.apply(console, arguments); };
     });"
  )
  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  Sys.sleep(6)
  res <- jsonlite::fromJSON(
    b$Runtime$evaluate(
      "JSON.stringify(Array.from(document.querySelectorAll('.case')).map(function(c) {
       var root = c.querySelector('[data-shiny-vue-root]');
       var got = root ? root.innerText.replace(/\\s+/g, ' ').trim() : 'NOT MOUNTED';
       if (c.dataset.case === 'c_html') got = root.querySelector('span').innerText + root.querySelectorAll('span')[1].innerText;
       if (c.dataset.case === 'c_inject') got = root.innerText.replace(/\\s+/g, '');
       if (c.dataset.case === 'c_for') got = root.textContent.replace(/\\s+/g, ' ').trim();
       return { id: c.dataset.case, got: got, want: c.dataset.expect };
     }))"
    )$result$value
  )
  for (i in seq_len(nrow(res))) {
    want <- if (res$id[i] == "c_inject") {
      gsub("\\s+", "", res$want[i])
    } else {
      res$want[i]
    }
    expect_equal(res$got[i], want, info = res$id[i])
  }
  # the title attribute held the escaped expression too
  expect_equal(
    b$Runtime$evaluate(
      "document.querySelector('[data-case=c_expr] [title]').title"
    )$result$value,
    "lt"
  )
  warns <- b$Runtime$evaluate(
    "JSON.stringify(window.__w.filter(function(w){ return /Vue warn|shiny-vue/.test(w); }))"
  )$result$value
  expect_equal(jsonlite::fromJSON(warns), list())
})
