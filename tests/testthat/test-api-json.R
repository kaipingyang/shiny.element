# The component pages' API tables come from a generated file,
# vignettes/articles/components/api.json (tools/api-coverage.py
# --write-api). Generated once, it drifts when a function is renamed: it
# named el_call() for a release after el_call() became call_el().

test_that("every function the API tables name exists", {
  path <- testthat::test_path(
    "..",
    "..",
    "vignettes",
    "articles",
    "components",
    "api.json"
  )
  skip_if_not(file.exists(path), "the source tree's vignettes are not here")
  text <- paste(
    readLines(path, warn = FALSE, encoding = "UTF-8"),
    collapse = ""
  )
  named <- unique(regmatches(
    text,
    gregexpr("`[a-z][a-z0-9_.]*(?=\\()", text, perl = TRUE)
  )[[1]])
  named <- sub("^`", "", named)
  # names inside code an entry quotes, not functions of the package
  named <- setdiff(named, "callback")
  exported <- getNamespaceExports("shiny.element")
  expect_equal(setdiff(named, exported), character())
})
