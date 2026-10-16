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
