# What the second pass over upstream added: a single checkbox, a button
# group, a badge and a link the server can change, JS in updates, and the
# form's custom rules and field types.

test_that("JS() marks JavaScript as htmlwidgets does, and its paths are found", {
  f <- JS("function() {", "return 1; }")
  expect_s3_class(f, "JS_EVAL")
  expect_equal(as.character(f), "function() {\nreturn 1; }")
  expect_null(JS())
  expect_error(JS(1), "character vector")
  x <- list(a = list(b = f, c = "x"), `d.e` = f, l = list(f, 2))
  expect_setequal(.el_js_paths(x), c("a.b", "d\\.e", "l.0"))
  expect_equal(.el_js_paths(list(a = 1)), character(0))
})

test_that("an update carrying a function lists it for the page to revive", {
  captured <- NULL
  session <- list(ns = function(id) id,
                  sendCustomMessage = function(type, msg) captured <<- msg)
  update_vue_data(session, "x", list(formatter = JS("function(v) { return v; }")))
  expect_equal(as.character(captured[[".evals"]]), "formatter")
  update_vue_data(session, "x", list(value = 1))
  expect_null(captured[[".evals"]])
})

test_that("el_checkbox is one box with its own text", {
  d <- vue_data_of(el_checkbox("agree", "I agree", value = TRUE))
  expect_true(d$value)
  expect_equal(d$text, "I agree")
  expect_equal(vue_spec_of(el_checkbox("agree"))$input, "value")
  expect_error(el_checkbox("x", size = "large"), "should be one of")
})

test_that("without an id, a link and a badge are plain markup", {
  expect_false(grepl("data-shiny-vue", as.character(el_link("Docs", href = "#")), fixed = TRUE))
  expect_false(grepl("data-shiny-vue", as.character(el_badge("x", value = 2)), fixed = TRUE))
  # with one, a component: the link an action link
  spec <- vue_spec_of(el_link("More", id = "more"))
  expect_equal(spec$input, "count")
  expect_equal(spec$type, "shiny.action")
})

test_that("a badge with an id folds the component it wraps into itself", {
  html <- paste(as.character(htmltools::renderTags(
    el_badge(el_button("inbox", "Inbox"), value = 3, id = "unread"))$html), collapse = "")
  # one host, the badge's -- the button absorbed, not nested
  expect_equal(lengths(regmatches(html, gregexpr("data-shiny-vue ", html, fixed = TRUE))), 1)
  expect_match(html, "<el-button", fixed = TRUE)
})

test_that("el_rule takes Element's custom validator and the rest of async-validator", {
  r <- el_rule(validator = JS("function(r, v, cb) { cb(); }"), enum = c("a", "b"),
               type = "enum", whitespace = TRUE, trigger = c("blur", "change"))
  expect_s3_class(r$validator, "JS_EVAL")
  expect_equal(r$enum, list("a", "b"))
  expect_equal(r$trigger, list("blur", "change"))
  expect_error(el_rule(type = "emial"), "should be one of")
})

test_that("form fields cover every control Element's form holds", {
  for (type in c("checkbox", "time-select", "transfer", "cascader-panel", "autocomplete")) {
    expect_silent(el_form_field("x", type, label = "L"))
  }
  box <- el_form_field("agree", "checkbox", label = "I agree")
  expect_equal(box$text, "I agree")
  expect_false(box$value)
  ac <- el_form_field("city", "autocomplete", choices = c("Beijing", "Shanghai"))
  expect_s3_class(ac$props$fetchSuggestions, "JS_EVAL")
  expect_match(ac$props$fetchSuggestions, '"Beijing"', fixed = TRUE)
})

test_that("update_el_form sends whole field lists and server errors", {
  captured <- NULL
  session <- list(ns = function(id) id,
                  sendCustomMessage = function(type, msg) captured <<- msg)
  update_el_form(session, "f", fields = list(el_form_field("a", "input")),
                 errors = list(a = "Taken"))
  expect_equal(captured[[".fields"]][[1]]$prop, "a")
  expect_equal(captured[[".errors"]]$a, "Taken")
})

test_that("a watcher reporting the value is stripped, so the rate policy holds", {
  spec <- vue_spec_of(el_autocomplete("city"))
  expect_false(grepl("setInputValue('city'", spec$options$watch$value, fixed = TRUE))
})

test_that("a field's form-item props go on the item, the rest on the control", {
  f <- el_form_field("email", "input", label = "Email", required = TRUE,
                     error = "Taken", label_width = "120px", placeholder = "you@")
  expect_true(f$required)
  expect_equal(f$error, "Taken")
  expect_equal(f$labelWidth, "120px")
  expect_equal(f$props, list(placeholder = "you@"))
})
