# A page's theme compiled once per machine: a new R process finds it in
# sass's cache, where it used to compile it again (R/el_theme_cache.R).

test_that("el_page() draws its theme through the cache", {
  theme <- el_theme(primary = "#7c3aed")
  page <- el_page(el_input("x"), theme = theme)
  wrapped <- Filter(function(f) inherits(f, "shiny.tag.function"), page)
  expect_length(wrapped, 1)
  # Shiny's own tag function, taken over: its theme is no longer in reach
  expect_false(identical(environment(wrapped[[1]])$theme, NULL))
  expect_identical(environment(wrapped[[1]])$theme, theme)
  expect_true(is.function(environment(wrapped[[1]])$f))
})

test_that("a theme sass has cached is placed where bslib's output goes", {
  skip_on_cran()
  withr::local_options(sass.cache = withr::local_tempdir())
  theme <- el_theme(primary = "#123456")
  counter <- new.env()
  counter$n <- 0
  trace(
    "compile_data",
    bquote(assign("n", get("n", .(counter)) + 1, envir = .(counter))),
    print = FALSE,
    where = asNamespace("sass")
  )
  on.exit(untrace("compile_data", where = asNamespace("sass")), add = TRUE)

  # compiled once, as before
  first <- bslib::bs_theme_dependencies(theme)
  expect_equal(counter$n, 1)
  css <- readBin(
    file.path(first[[2]]$src$file, "bootstrap.min.css"),
    "raw",
    1e7
  )
  files <- sort(list.files(first[[2]]$src$file, recursive = TRUE))

  # a new process: nothing under tempdir() yet
  unlink(first[[2]]$src$file, recursive = TRUE)
  options(sass.cache = .el_theme_cache(theme))
  again <- bslib::bs_theme_dependencies(theme)
  expect_equal(counter$n, 1)
  dir <- again[[2]]$src$file
  expect_identical(
    readBin(file.path(dir, "bootstrap.min.css"), "raw", 1e7),
    css
  )
  expect_identical(sort(list.files(dir, recursive = TRUE)), files)
})

test_that("with sass's caching off, the theme compiles as bslib has it", {
  withr::local_options(sass.cache = FALSE)
  expect_null(.el_theme_cache(el_theme()))
})

compiles_while <- function(code) {
  counter <- new.env()
  counter$n <- 0
  trace(
    "compile_data",
    bquote(assign("n", get("n", .(counter)) + 1, envir = .(counter))),
    print = FALSE,
    where = asNamespace("sass")
  )
  on.exit(untrace("compile_data", where = asNamespace("sass")), add = TRUE)
  force(code)
  counter$n
}

theme_css <- function(deps) {
  boot <- Filter(function(d) d$name == "bootstrap", deps)[[1]]
  readBin(file.path(boot$src$file, "bootstrap.min.css"), "raw", 1e8)
}

test_that("the default theme ships compiled, for the bslib and sass it was made with", {
  made <- jsonlite::fromJSON(.vue_file("el-theme", "versions.json"))
  expect_named(made, c("bslib", "sass"))
  expect_true(nzchar(.vue_file("el-theme", "bootstrap.min.css.gz")))
  expect_true(.el_theme_is_default(el_theme()))
  expect_false(.el_theme_is_default(el_theme(primary = "#000000")))
})

test_that("a machine that never compiled the default theme uses the shipped one", {
  skip_on_cran()
  withr::local_options(sass.cache = withr::local_tempfile())
  local_mocked_bindings(.el_theme_versions_match = function() TRUE)
  theme <- el_theme()
  cache <- .el_theme_cache(theme)
  n <- compiles_while({
    withr::with_options(list(sass.cache = cache), {
      deps <- bslib::bs_theme_dependencies(theme)
    })
  })
  expect_equal(n, 0)
  expect_identical(rawToChar(theme_css(deps)), .el_theme_shipped())
})

test_that("another theme, or other versions, compile as bslib has it", {
  skip_on_cran()
  withr::local_options(sass.cache = withr::local_tempfile())
  local_mocked_bindings(.el_theme_versions_match = function() TRUE)
  other <- el_theme(primary = "#123456")
  n <- compiles_while({
    withr::with_options(list(sass.cache = .el_theme_cache(other)), {
      bslib::bs_theme_dependencies(other)
    })
  })
  expect_equal(n, 1)

  local_mocked_bindings(.el_theme_versions_match = function() FALSE)
  withr::local_options(sass.cache = withr::local_tempfile())
  theme <- el_theme()
  n <- compiles_while({
    withr::with_options(list(sass.cache = .el_theme_cache(theme)), {
      bslib::bs_theme_dependencies(theme)
    })
  })
  expect_equal(n, 1)
})

test_that("the shipped CSS is what bslib compiles, where the versions match", {
  skip_on_cran()
  skip_if_not(
    .el_theme_versions_match(),
    "bslib or sass is not the shipped CSS's"
  )
  compiled <- bslib::bs_theme_dependencies(el_theme(), cache = FALSE)
  expect_identical(rawToChar(theme_css(compiled)), .el_theme_shipped())
})
