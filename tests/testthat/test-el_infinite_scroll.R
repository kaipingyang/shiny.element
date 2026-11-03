test_that("on's load is the directive's handler, after the one reporting", {
  html <- paste(
    as.character(el_infinite_scroll("feed", on = list(load = "n += 2"))),
    collapse = ""
  )
  expect_match(
    html,
    "v-infinite-scroll=\"(...a) =&gt; { handleLoad(...a);",
    fixed = TRUE
  )
  expect_match(html, "n += 2", fixed = TRUE)
  expect_false(grepl("@load", html, fixed = TRUE))
})
