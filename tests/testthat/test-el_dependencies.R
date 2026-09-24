# ── element_ui_dependency ─────────────────────────────────────────────────────

test_that("element_ui_dependency: serves from the package by default", {
  # A runtime CDN dependency leaves the page blank on an intranet or offline,
  # so the bundled copy is the default.
  dep <- element_ui_dependency()
  expect_equal(dep$name, "element-ui")
  expect_equal(dep$version, "2.13.2")
  expect_false(grepl("unpkg", paste(unlist(dep$src), collapse = " ")))
  expect_true(dir.exists(unname(dep$src[["file"]])))
})

test_that("element_ui_dependency: offline = FALSE falls back to the CDN", {
  dep <- element_ui_dependency(offline = FALSE)
  expect_match(unname(dep$src[["href"]]), "^https://unpkg\\.com/element-ui@2\\.13\\.2/")
})

test_that("element_ui_dependency: serves the whole directory", {
  # index.css references fonts/element-icons.woff relatively; naming only the
  # script and stylesheet would leave every icon as a blank box.
  expect_true(element_ui_dependency()$all_files)
})

test_that("element_ui_dependency: the bundled files are actually there", {
  root <- system.file("element-ui", package = "shiny.element")
  for (f in c("index.js", "theme-chalk/index.css",
              "theme-chalk/fonts/element-icons.woff",
              "theme-chalk/fonts/element-icons.ttf")) {
    expect_true(file.exists(file.path(root, f)), info = f)
  }
})

test_that("element_ui_dependency: the bundled files are not truncated", {
  root <- system.file("element-ui", package = "shiny.element")
  expect_gt(file.size(file.path(root, "index.js")), 400 * 1024)
  expect_gt(file.size(file.path(root, "theme-chalk/index.css")), 150 * 1024)
  expect_gt(file.size(file.path(root, "theme-chalk/fonts/element-icons.woff")), 20 * 1024)
})

test_that("element_ui_dependency: the stylesheet keeps its relative font paths", {
  css <- readLines(
    system.file("element-ui", "theme-chalk", "index.css", package = "shiny.element"),
    warn = FALSE, n = 200
  )
  css <- paste(css, collapse = "\n")
  expect_match(css, "fonts/element-icons.woff", fixed = TRUE)
  # An absolute or CDN-rooted url() would defeat bundling them.
  expect_false(grepl("url\\(['\"]?https?://", css))
})

# ── wiring ────────────────────────────────────────────────────────────────────

test_that("el_page: passes offline through to the dependency", {
  local_src <- function(tags) {
    deps <- htmltools::findDependencies(tags)
    dep  <- Filter(function(d) identical(d$name, "element-ui"), deps)[[1]]
    paste(unlist(dep$src), collapse = " ")
  }
  expect_false(grepl("unpkg", local_src(el_page())))
  expect_true(grepl("unpkg", local_src(el_page(offline = FALSE))))
})

test_that("use_element: passes offline through to the dependency", {
  src_of <- function(tags) {
    deps <- htmltools::findDependencies(tags)
    dep  <- Filter(function(d) identical(d$name, "element-ui"), deps)[[1]]
    paste(unlist(dep$src), collapse = " ")
  }
  expect_false(grepl("unpkg", src_of(use_element())))
  expect_true(grepl("unpkg", src_of(use_element(offline = FALSE))))
})

test_that("Vue is served locally too", {
  # vueR bundles it; this guards against a future switch to its CDN mode.
  src <- paste(unlist(vueR::html_dependency_vue()$src), collapse = " ")
  expect_false(grepl("unpkg|cdn", src))
})

test_that("every handler dependency resolves to a file that exists", {
  deps <- list(
    el_button_handler_dependency(), el_input_handler_dependency(),
    el_select_handler_dependency(), el_table_handler_dependency(),
    el_form_handler_dependency(), el_cascader_handler_dependency(),
    el_steps_handler_dependency(), el_calendar_handler_dependency()
  )
  for (d in deps) {
    expect_true(
      file.exists(file.path(unname(d$src[["file"]]), d$script)),
      info = d$name
    )
  }
})
