# tools/external-props.csv: Element's props that need something outside
# Element to work, each with how the package gives it and where that is
# shown working. tools/external-props.py finds them in Element's docs and
# lists any the file does not.

test_that("every prop needing something outside Element says how, and where it is shown", {
  path <- testthat::test_path("..", "..", "tools", "external-props.csv")
  skip_if_not(file.exists(path), "tools/ not in this build")
  props <- utils::read.csv(path, stringsAsFactors = FALSE)
  expect_named(props, c("page", "prop", "needs", "section", "how", "check"))
  expect_true(all(nzchar(props$how)))
  expect_true(all(
    props$needs %in%
      c(
        "vue-router",
        "dayjs",
        "popper",
        "async-validator",
        "date",
        "element",
        "locale"
      )
  ))
  root <- testthat::test_path("..", "..")
  for (f in unique(props$check)) {
    expect_true(file.exists(file.path(root, f)), info = f)
  }
  # what needs a router is shown working with one
  expect_true(all(
    props$check[props$needs == "vue-router"] ==
      "tests/testthat/test-browser-router.R"
  ))
})
