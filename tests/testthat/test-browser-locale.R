# A locale packed in more.tar.gz is taken out into the session's temporary
# directory: the page must still get it, from Shiny and from a saved file.

test_that("a packed locale reaches the page, served or saved", {
  skip_if_no_browser()
  pkg <- normalizePath(testthat::test_path("..", ".."))
  port <- httpuv::randomPort()
  log <- tempfile(fileext = ".log")
  proc <- callr::r_bg(
    function(pkg, port, libs) {
      .libPaths(libs)
      pkgload::load_all(
        pkg,
        quiet = TRUE,
        helpers = FALSE,
        attach_testthat = FALSE
      )
      ui <- el_page(
        locale = "uk",
        el_pagination("p", total = 50, layout = "total, prev, pager, next"),
        el_date_picker("d", value = "2026-10-27")
      )
      shiny::runApp(
        shiny::shinyApp(ui, function(input, output) {}),
        host = "127.0.0.1",
        port = port,
        launch.browser = FALSE
      )
    },
    args = list(pkg = pkg, port = port, libs = .libPaths()),
    stdout = log,
    stderr = "2>&1"
  )
  on.exit(proc$kill(), add = TRUE)
  for (i in seq_len(120)) {
    Sys.sleep(0.5)
    if (any(grepl("Listening on", readLines(log, warn = FALSE)))) break
  }
  use_browser_args()
  b <- chromote::ChromoteSession$new(width = 800, height = 400)
  on.exit(try(b$close(), silent = TRUE), add = TRUE)
  js <- function(x) b$Runtime$evaluate(x, awaitPromise = TRUE)$result$value
  total <- "(document.querySelector('.el-pagination__total') || {}).textContent"

  b$Page$navigate(sprintf("http://127.0.0.1:%d", port))
  Sys.sleep(4)
  expect_equal(trimws(js(total)), "\u0412\u0441\u044c\u043e\u0433\u043e 50")

  # Day.js's locale, packed too: a Ukrainian week starts on Monday, as
  # Element Plus's own labels name the days
  js("document.querySelector('#d_container input').click()")
  Sys.sleep(1)
  heads <- js(paste0(
    "Array.from(document.querySelectorAll('.el-date-table th'))",
    ".map(function(e) { return e.textContent.trim(); }).join('|')"
  ))
  weeks <- jsonlite::fromJSON(js(
    "JSON.stringify(ElementPlusLocaleUk.el.datepicker.weeks)"
  ))
  expect_equal(strsplit(heads, "|", fixed = TRUE)[[1]][1], weeks$mon)
  expect_equal(js("ElementPlus.dayjs.locale()"), "uk")

  # saved as a file, the locale is copied beside it
  dir <- withr::local_tempdir()
  htmltools::save_html(
    el_page(
      locale = "uk",
      el_pagination("p", total = 50, layout = "total, prev, pager, next")
    ),
    file.path(dir, "page.html"),
    libdir = "lib"
  )
  expect_true(any(grepl(
    "uk.min.js",
    list.files(file.path(dir, "lib"), recursive = TRUE),
    fixed = TRUE
  )))
  b$Page$navigate(paste0("file://", file.path(dir, "page.html")))
  Sys.sleep(3)
  expect_equal(trimws(js(total)), "\u0412\u0441\u044c\u043e\u0433\u043e 50")
})
