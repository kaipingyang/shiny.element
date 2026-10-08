test_that("the provider's scope names its own fields, whatever its children's", {
  # a button inside shares `size` with the provider; renamed with the
  # button, the scope's binding read the button's size
  html <- paste(
    as.character(el_config_provider(size = "small", el_button("b", "B"))),
    collapse = ""
  )
  expect_match(html, "&#39;size&#39;: size,", fixed = TRUE)
  expect_match(
    html,
    ':data-card-shadow="card &amp;&amp; card.shadow',
    fixed = TRUE
  )
  expect_false(grepl("&#39;el[0-9]+_size&#39;", html))
})
