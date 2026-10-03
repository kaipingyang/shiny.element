# A bookmarked page reopens with every component as it was left. Each
# component's value goes through shiny::restoreInput() as its UI is built.

test_that("a bookmark brings every component back", {
  skip_if_no_browser()
  app <- testthat::test_path("apps", "bookmark.R")
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
  b <- chromote::ChromoteSession$new()
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  go <- function(url) {
    loaded <- b$Page$loadEventFired(wait_ = FALSE)
    b$Page$navigate(url, wait_ = FALSE)
    b$wait_for(loaded)
    Sys.sleep(3)
  }
  dump <- function() {
    txt <- strsplit(js("document.getElementById('vals').innerText"), "\n")[[1]]
    stats::setNames(
      trimws(sub("^[^=]*=", "", txt)),
      trimws(sub("=.*", "", txt))
    )
  }

  go(sprintf("http://127.0.0.1:%d/", port))
  js(
    "Shiny.addCustomMessageHandler('bookmarked', function(u) { window.__bookmark = u; })"
  )
  js(
    "var i = document.querySelector('#name_container input'); i.value = 'Grace';
      i.dispatchEvent(new Event('input')); i.dispatchEvent(new Event('change'));"
  )
  js("shinyVue.find('cities').instance.value = ['sh', 'gz']")
  js("document.querySelector('#on_container .el-switch').click()")
  js("document.querySelectorAll('#tabs .el-tabs__item')[1].click()")
  js("document.querySelectorAll('#pg_container .el-pager li')[2].click()")
  Sys.sleep(1.5)
  before <- dump()

  js("document.getElementById('._bookmark_').click()")
  Sys.sleep(2)
  url <- js("window.__bookmark")
  expect_match(url, "_inputs_", fixed = TRUE)
  go(sub("^https?://[^/]+", sprintf("http://127.0.0.1:%d", port), url))

  after <- dump()
  expect_equal(after, before)
  expect_equal(after[["name"]], "Grace")
  expect_equal(after[["cities"]], "sh,gz")
  # and on screen, not only in input$
  expect_equal(
    js("document.querySelector('#name_container input').value"),
    "Grace"
  )
  expect_equal(
    js("document.querySelector('#tabs .el-tabs__item.is-active').innerText"),
    "B"
  )
  expect_equal(
    js(
      "document.querySelector('#pg_container .el-pager li.is-active').innerText"
    ),
    "3"
  )
})
