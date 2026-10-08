test_that("a multiple select-v2's one choice is an array", {
  html <- paste(
    as.character(el_select_v2(
      "s",
      options = c("a", "b"),
      value = "a",
      multiple = TRUE
    )),
    collapse = ""
  )
  expect_match(html, '"value":["a"]', fixed = TRUE)
})
