# Components folded into one Vue instance: their fields renamed apart.

test_that("renaming is one pass: a renamed field is not renamed again", {
  rename <- c(label = "el3_label", el3_label = "el3_el3_label")
  expect_equal(
    .el_rewrite_expr("label + el3_label + x.label + 'label'", rename),
    "el3_label + el3_el3_label + x.label + 'label'"
  )
  expect_equal(
    as.character(.el_rewrite_js(JS("this.label = self.el3_label;"), rename)),
    "this.el3_label = self.el3_el3_label;"
  )
})

test_that("two buttons in a popover keep their own labels", {
  # the body's second button is el3_, and the body, clashing with the
  # reference, is el3_ again: absorbed twice over
  pop <- el_popover(
    "p",
    reference = el_button("ref", "Delete"),
    body = htmltools::tagList(
      el_button("no", "cancel"),
      el_button("yes", "confirm")
    )
  )
  html <- paste(as.character(pop), collapse = "")
  labels <- regmatches(html, gregexpr("\\{\\{[a-z0-9_]*label\\}\\}", html))[[1]]
  expect_equal(length(unique(labels)), 3)
})
