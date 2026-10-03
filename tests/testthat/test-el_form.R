render_html <- function(tag) {
  paste(as.character(tag), collapse = "")
}

sent_message <- function(expr) {
  captured <- NULL
  session <- list(
    ns = function(id) id,
    sendCustomMessage = function(type, msg) captured <<- list(type = type, msg = msg)
  )
  expr(session)
  captured
}

# ── helpers ───────────────────────────────────────────────────────────────────

test_that(".el_camel: snake_case becomes camelCase", {
  expect_equal(.el_camel("show_password"), "showPassword")
  expect_equal(.el_camel(c("min", "controls_position")), c("min", "controlsPosition"))
})

test_that(".el_form_empty_value: each type gets a value of the right JSON shape", {
  expect_equal(.el_form_empty_value("input"), "")
  expect_equal(.el_form_empty_value("input-number"), 0)
  expect_false(.el_form_empty_value("switch"))
  # Multi-value controls must serialise as [] rather than "".
  expect_equal(.el_form_empty_value("checkbox-group"), list())
  expect_equal(.el_form_empty_value("cascader"), list())
})

test_that(".el_form_options: el-option takes the text as its label attribute", {
  opts <- .el_form_options(c(Beijing = "bj"), "el-option")
  expect_equal(opts[[1]], list(label = "Beijing", value = "bj", text = ""))
})

test_that(".el_form_options: el-radio uses label as the value and text as the slot", {
  # Element UI's radio and checkbox differ from option here; one template
  # renders all three only because this is normalised first.
  opts <- .el_form_options(c(Basic = "a"), "el-radio")
  expect_equal(opts[[1]], list(label = "a", text = "Basic"))
  expect_null(opts[[1]]$value)
})

test_that(".el_form_options: NULL choices give NULL", {
  expect_null(.el_form_options(NULL, "el-option"))
})

test_that(".el_normalize_rules: one rule is wrapped, several pass through", {
  one <- el_rule(required = TRUE, message = "r")
  expect_length(.el_normalize_rules(one), 1)
  expect_equal(.el_normalize_rules(one)[[1]]$message, "r")

  many <- list(el_rule(required = TRUE), el_rule(min = 2))
  expect_length(.el_normalize_rules(many), 2)

  expect_null(.el_normalize_rules(NULL))
  expect_null(.el_normalize_rules(list()))
})

# ── el_rule ───────────────────────────────────────────────────────────────────

test_that("el_rule: keeps only the fields that were given", {
  r <- el_rule(required = TRUE, message = "Required")
  expect_equal(r, list(required = TRUE, message = "Required", trigger = "blur"))
  expect_null(r$min)
  expect_null(r$pattern)
})

test_that("el_rule: every async-validator field is passed through", {
  r <- el_rule(min = 2, max = 20, len = 5, pattern = "^a", type = "email",
               message = "m", trigger = "change")
  expect_equal(r$min, 2)
  expect_equal(r$max, 20)
  expect_equal(r$len, 5)
  expect_equal(r$pattern, "^a")
  expect_equal(r$type, "email")
  expect_equal(r$trigger, "change")
})

# ── el_form_field ─────────────────────────────────────────────────────────────

test_that("el_form_field: maps the type to its Element tag", {
  expect_equal(el_form_field("a", "input")$tag, "el-input")
  expect_equal(el_form_field("a", "input-number")$tag, "el-input-number")
  expect_equal(el_form_field("a", "color-picker")$tag, "el-color-picker")
})

test_that("el_form_field: choice controls also get their option tag", {
  expect_equal(el_form_field("a", "select", choices = c(A = "a"))$optionTag, "el-option")
  expect_equal(el_form_field("a", "radio-group", choices = c(A = "a"))$optionTag, "el-radio")
  expect_equal(el_form_field("a", "checkbox-group", choices = c(A = "a"))$optionTag, "el-checkbox")
  # Single-value controls have no option tag at all.
  expect_null(el_form_field("a", "input")$optionTag)
})

test_that("el_form_field: an unknown type fails with the allowed list", {
  expect_error(el_form_field("a", "nope"), "Unknown field type")
  expect_error(el_form_field("a", "nope"), "input-number")
})

test_that("el_form_field: extra arguments become camelCase props", {
  f <- el_form_field("a", "input", placeholder = "hi", show_password = TRUE)
  expect_equal(f$props$placeholder, "hi")
  expect_true(f$props$showPassword)
  expect_null(f$props$show_password)
})

test_that("el_form_field: value defaults to the type's empty value", {
  expect_equal(el_form_field("a", "input")$value, "")
  expect_equal(el_form_field("a", "input-number")$value, 0)
  expect_equal(el_form_field("a", "input-number", value = 18)$value, 18)
})

test_that("el_form_field: rules are normalised to a list", {
  f <- el_form_field("a", "input", rules = el_rule(required = TRUE))
  expect_length(f$rules, 1)
  expect_true(f$rules[[1]]$required)
})

# ── el_form ───────────────────────────────────────────────────────────────────

demo_form <- function(...) {
  el_form(
    id = "f1",
    el_form_field("name", "input", label = "Name",
                  rules = el_rule(required = TRUE, message = "req")),
    el_form_field("age", "input-number", label = "Age", value = 18),
    ...
  )
}

test_that("el_form: returns a tagList with the container id", {
  expect_true(inherits(demo_form(), "shiny.tag.list"))
  expect_match(render_html(demo_form()), 'id="f1_container"')
})

test_that("el_form: attaches the shared bridge", {
  deps <- htmltools::findDependencies(demo_form())
  expect_true("shiny-vue" %in% vapply(deps, function(d) d$name, character(1)))
})

test_that("el_form: collects the fields' values into one model", {
  html <- render_html(demo_form())
  expect_match(html, '"model":\\{"name":"","age":18\\}')
})

test_that("el_form: collects rules keyed by prop, omitting fields without any", {
  html <- render_html(demo_form())
  expect_match(html, '"rules":\\{"name":\\[\\{"required":true')
  # age declared no rules, so it must not appear as an empty entry.
  expect_false(grepl('"age":\\[\\]', html))
})

test_that("el_form: value and rules are stripped from the field specs", {
  # They belong to the form's model and rules; leaving them on the field would
  # send each value twice and pass `rules` down as a control prop.
  html <- render_html(demo_form())
  fields <- regmatches(html, regexpr('"fields":\\[.*?\\](?=,")', html, perl = TRUE))
  expect_no_match(fields, '"value"')
  expect_no_match(fields, '"rules"')
})

test_that("el_form: one template renders every control via component :is", {
  html <- render_html(demo_form())
  expect_match(html, 'v-for="f in fields"')
  expect_match(html, ':is="f.tag"')
  expect_match(html, 'v-model="model\\[f.prop\\]"')
  expect_match(html, 'v-bind="f.props"')
})

test_that("el_form: the form is bound to model and rules", {
  html <- render_html(demo_form())
  expect_match(html, ':model="model"')
  expect_match(html, ':rules="rules"')
  expect_match(html, 'ref="form"')
})

test_that("el_form: buttons are rendered only when labelled", {
  # Assert on the template's @click, not on the whole page: both methods are
  # always defined in the widget's JSON regardless of which buttons render.
  default <- render_html(demo_form())
  expect_match(default, '@click="handleSubmit"', fixed = TRUE)
  expect_false(grepl('@click="handleReset"', default, fixed = TRUE))

  both <- render_html(demo_form(reset_label = "Reset"))
  expect_match(both, '@click="handleSubmit"', fixed = TRUE)
  expect_match(both, '@click="handleReset"', fixed = TRUE)

  none <- render_html(el_form(id = "f1", submit_label = NULL))
  expect_false(grepl("<el-button", none, fixed = TRUE))
})

test_that("el_form: reports model, verdict and a submit counter", {
  html <- render_html(demo_form())
  expect_match(html, "_valid", fixed = TRUE)
  expect_match(html, "_submit", fixed = TRUE)
  # The model is reported on load too, like every other component: it is the
  # value the binding reads.
  expect_equal(vue_spec_of(demo_form())$input, "model")
})

test_that("el_form: layout options reach the data", {
  html <- render_html(el_form(id = "f1", label_width = "150px",
                              label_position = "top", inline = TRUE, size = "small"))
  expect_match(html, '"labelWidth":"150px"')
  expect_match(html, '"labelPosition":"top"')
  expect_match(html, '"inline":true')
  expect_match(html, '"size":"small"')
  expect_match(html, ':size="size === null \\? undefined : size"')
})

test_that("el_form: size is bound even when not supplied", {
  # Always bound, so update_el_form(size = ) can reach it later.
  expect_true(binds_attr(demo_form(), "size"))
  expect_null(vue_data_of(demo_form())$size)
})

test_that("el_form: an empty form still renders", {
  html <- render_html(el_form(id = "f1", submit_label = NULL))
  expect_match(html, "<el-form")
  expect_match(html, '"fields":\\[\\]')
})

# ── server-side functions ─────────────────────────────────────────────────────

test_that("update_el_form: sends a partial model for merging", {
  out <- sent_message(function(s) update_el_form(s, "f1", model = list(name = "Ada")))
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg$id, "f1")
  expect_equal(out$msg$model, list(name = "Ada"))
})

test_that("update_el_form: rules are normalised per prop", {
  out <- sent_message(function(s) {
    update_el_form(s, "f1", rules = list(name = el_rule(required = TRUE, message = "r")))
  })
  expect_length(out$msg$rules$name, 1)
  expect_true(out$msg$rules$name[[1]]$required)
})

test_that("update_el_form: NULL fields are excluded", {
  out <- sent_message(function(s) update_el_form(s, "f1", label_width = "200px"))
  expect_equal(out$msg$labelWidth, "200px")
  expect_null(out$msg$model)
  expect_null(out$msg$rules)
})

test_that("el_form_validate: sends the id and the operation", {
  out <- sent_message(function(s) el_form_validate(s, "f1"))
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg, list(id = "f1", .action = "validate"))
})

test_that("el_form_reset: sends the id and the operation", {
  out <- sent_message(function(s) el_form_reset(s, "f1"))
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg, list(id = "f1", .action = "reset"))
})

test_that("el_form_clear_validate: props are optional", {
  out <- sent_message(function(s) el_form_clear_validate(s, "f1"))
  expect_equal(out$type, "shinyVueUpdate")
  expect_equal(out$msg$.action, "clearValidate")
  expect_null(out$msg$props)

  scoped <- sent_message(function(s) el_form_clear_validate(s, "f1", c("name", "age")))
  expect_equal(scoped$msg$props, list("name", "age"))
})

test_that("the form's receiver handles every operation it is sent", {
  m <- vue_payload_of(demo_form())$methods
  for (op in c("validate", "reset", "clearValidate", "self.model[k] = d.model[k]")) {
    expect_match(m$shinyVueReceive, op, fixed = TRUE)
  }
})
