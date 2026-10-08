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

test_that("a form inside a container keeps its directives as it is renamed", {
  # el_form()'s template is a string; renamed whole, a field named `model`
  # made `v-model` into `v-el3_model`, a directive Vue could not resolve
  html <- paste(
    as.character(el_space(
      el_form(id = "f1", el_form_field("a", "input", label = "A")),
      el_form(id = "f2", el_form_field("b", "input", label = "B"))
    )),
    collapse = ""
  )
  expect_false(grepl("v-el[0-9]+_model", html))
  expect_match(html, 'v-model="el[0-9]+_model\\[f.prop\\]"')
  expect_match(html, 'v-for="f in el[0-9]+_fields"')
})

test_that("a component folded into another is listed under its id", {
  # its updates and method calls find it through the host that took it in
  html <- paste(
    as.character(el_space(
      id = "sp",
      el_button("b1", "One"),
      el_button("b2", "Two")
    )),
    collapse = ""
  )
  json <- regmatches(
    html,
    regexpr(
      '<script type="application/json" data-shiny-vue-options>[^<]*',
      html
    )
  )
  spec <- jsonlite::fromJSON(sub("^[^>]*>", "", json), simplifyVector = FALSE)
  expect_setequal(names(spec$absorbed), c("b1", "b2"))
  # fields that clash are renamed, each button's its own way
  expect_match(spec$absorbed$b1$fields$label, "^(el[0-9]+_)?label$")
  expect_match(spec$absorbed$b2$fields$label, "^el[0-9]+_label$")
  expect_false(identical(
    spec$absorbed$b1$fields$label,
    spec$absorbed$b2$fields$label
  ))
  expect_true(all(
    unlist(spec$absorbed$b2$fields) %in%
      names(spec$options$data) |
      unlist(spec$absorbed$b2$fields) %in% names(spec$options$methods)
  ))
  expect_identical(spec$absorbed$b2$ref, "sv_b2")
  expect_match(html, 'ref="sv_b2"', fixed = TRUE)
})

test_that("a component folded twice over is still listed", {
  html <- paste(
    as.character(el_space(
      id = "outer",
      el_button_group(el_button("inner_btn", "In"))
    )),
    collapse = ""
  )
  expect_match(html, '"inner_btn":{"fields":', fixed = TRUE)
})

test_that("text in a renamed component stays text", {
  # renaming made a text child HTML(), unescaped: markup in user text ran
  html <- paste(
    as.character(el_space(
      el_text("first"),
      el_text("<img src=x onerror=alert(1)> {{ label }}")
    )),
    collapse = ""
  )
  expect_false(grepl("<img src=x", html, fixed = TRUE))
  expect_match(html, "&lt;img src=x", fixed = TRUE)
})

test_that("a watcher on a path follows its field's renaming", {
  html <- paste(
    as.character(el_space(
      el_form(id = "f0", el_form_field("a", "input", label = "A")),
      el_form(
        id = "f1",
        el_form_field("sz", "radio-group", choices = c("a", "b"), report = TRUE)
      )
    )),
    collapse = ""
  )
  expect_match(html, '"el[0-9]+_model\\.sz"')
  expect_false(grepl('"model.sz"', html, fixed = TRUE))
})
