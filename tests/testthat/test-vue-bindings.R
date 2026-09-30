# Every identifier a template binding references must be declared on the Vue
# instance. Vue only warns about an undeclared one at render time, in the
# browser, with the development build -- so a missing declaration otherwise
# shows up as a prop that silently does nothing.
#
# This catches the case where a binding is added without a matching field in
# `data`, which is also what makes update_el_*() unable to reach it.

# Components that will not render without an argument
binding_fixtures <- list(
  el_checkbox_group = list("cg", choices = c("A", "B")),
  el_radio_group    = list("rg", choices = c("A", "B")),
  el_select         = list("sel", choices = c("A", "B")),
  el_form_field     = list(prop = "f", label = "F"),
  el_icon           = list("edit"),
  el_pagination     = list("pg", total = 100)
)

# Server-side helpers and dependency getters render no Vue instance
binding_skip <- paste0(
  "_dependency$|^el$|^el_page$|^el_rule$|^el_table_config$|",
  "^el_form_(validate|reset|clear)|^el_upload_clear$|^el_message$|^el_notification$"
)

quoted_values <- function(html, pattern) {
  m <- regmatches(html, gregexpr(pattern, html, perl = TRUE))[[1]]
  sub('^[^"]*"', "", sub('"$', "", m))
}

undeclared_refs <- function(ui) {
  payload <- vue_payload_of(ui)
  declared <- c(names(payload$data), names(payload$methods), names(payload$computed))
  html <- paste(as.character(ui), collapse = "")

  exprs <- c(quoted_values(html, ':[a-z-]+="[^"]*"'),
             quoted_values(html, '@[a-z-]+="[^"]*"'))
  # A string literal inside an expression names nothing: 'is-selected' in
  # :class="data.isSelected ? 'is-selected' : ''" is a class name, not a field.
  bare <- gsub("'[^']*'", "", exprs)
  refs <- unique(unlist(lapply(bare, function(e)
    regmatches(e, gregexpr("[A-Za-z_$][A-Za-z0-9_$]*", e))[[1]])))

  # v-for aliases, and the fields read off them (item.timestamp)
  locals <- unique(unlist(lapply(quoted_values(html, 'v-for="[^"]*"'), function(v)
    regmatches(v, gregexpr("[A-Za-z_$][A-Za-z0-9_$]*", v))[[1]])))
  # slot-scope destructures its own names
  scoped <- unique(unlist(lapply(quoted_values(html, 'slot-scope="[^"]*"'), function(v)
    regmatches(v, gregexpr("[A-Za-z_$][A-Za-z0-9_$]*", v))[[1]])))
  members <- unique(unlist(lapply(bare, function(e)
    regmatches(e, gregexpr("(?<=\\.)[A-Za-z_$][A-Za-z0-9_$]*", e, perl = TRUE))[[1]])))

  literals <- c("null", "undefined", "true", "false", "Shiny", "Math", "JSON",
                "this", "self", "window", "document",
                # Vue's own template variables
                "$event", "$refs", "$emit")
  setdiff(refs, c(declared, locals, scoped, members, literals))
}

test_that("every template binding references a declared field", {
  exports <- getNamespaceExports("shiny.element")
  fns <- setdiff(grep("^el_", exports, value = TRUE),
                 grep(binding_skip, exports, value = TRUE))

  offenders <- list()
  for (f in sort(fns)) {
    args <- if (!is.null(binding_fixtures[[f]])) binding_fixtures[[f]] else list()
    ui <- tryCatch(do.call(f, args), error = function(e) NULL)
    if (is.null(ui)) next
    missing <- tryCatch(undeclared_refs(ui), error = function(e) character(0))
    if (length(missing)) offenders[[f]] <- missing
  }

  # Reported as "component: field, field" so a failure names the culprit
  report <- if (length(offenders)) {
    paste0(names(offenders), ": ",
           vapply(offenders, paste, character(1), collapse = ", "))
  } else {
    character(0)
  }
  expect_equal(report, character(0))
})

# ── the shared widget constructor ─────────────────────────────────────────────

test_that("the package's own components go through el_widget()", {
  # This is a rule for the package, not for its users: el_widget() is exported
  # and vueR::vue() is not hidden, so an app or another package can assemble a
  # Vue instance however it likes. What the rule protects is the three things
  # el_widget() carries, each added to fix a bug -- display:contents on the
  # host, a zero-sized widget element, and the `el` selector. A component here
  # that went around it would silently lose whichever one it forgot.
  sources <- list.files("../../R", pattern = "^el_.*[.]R$", full.names = TRUE)
  sources <- setdiff(sources, grep("el_widget[.]R$", sources, value = TRUE))

  offenders <- vapply(sources, function(path) {
    any(grepl("vueR::vue(", readLines(path, warn = FALSE), fixed = TRUE))
  }, logical(1))

  expect_equal(basename(sources[offenders]), character(0))
})

test_that("el_widget() lets a user wrap a component the package does not cover", {
  # el-avatar has no wrapper here. Building one should need nothing but
  # exported functions -- and should not need the user to know about
  # display:contents or the widget's size.
  avatar <- el_widget(
    id         = "face",
    markup     = el$avatar(":src" = "src", ":size" = "size"),
    data       = list(src = "a.png", size = 50),
    dependency = element_ui_dependency()
  )
  html <- paste(as.character(htmltools::renderTags(avatar)$html), collapse = "")

  expect_match(html, "<el-avatar")
  expect_match(html, "display: contents", fixed = TRUE)
  expect_match(html, "width:0px;height:0px", fixed = TRUE)
  expect_equal(names(vue_data_of(avatar)), c("src", "size"))
})

test_that("a user's component can report to Shiny the same way", {
  w <- el_widget(
    id      = "score",
    markup  = el$rate("v-model" = "value", "@change" = "onChange"),
    data    = list(value = 3),
    methods = list(onChange = htmlwidgets::JS(
      "function(v) { Shiny.setInputValue('score', v); }"
    )),
    dependency = element_ui_dependency()
  )
  expect_equal(names(vue_payload_of(w)$methods), "onChange")
  expect_true("onChange" %in% unlist(vue_payload_of(w)$evals) ||
                grepl("setInputValue", vue_payload_of(w)$methods$onChange))
})

test_that("the widget element takes up no space", {
  # The widget element is only a carrier for the payload -- the Vue instance
  # renders into the host div beside it, which is display:contents. Left to
  # htmlwidgets' sizing policy it would be 960x500 of empty space, which is
  # exactly the layout jump el_widget() exists to prevent. A component's own
  # size comes from Element's props (el_table's height, el_slider's height),
  # which have nothing to do with this.
  exports <- getNamespaceExports("shiny.element")
  fns <- setdiff(grep("^el_", exports, value = TRUE),
                 grep(binding_skip, exports, value = TRUE))

  sized <- character(0)
  for (f in sort(fns)) {
    args <- if (!is.null(binding_fixtures[[f]])) binding_fixtures[[f]] else list()
    ui <- tryCatch(do.call(f, args), error = function(e) NULL)
    if (is.null(ui)) next
    html <- paste(as.character(ui), collapse = "")
    if (!grepl("html-widget", html, fixed = TRUE)) next
    if (!grepl("width:0px;height:0px", html, fixed = TRUE)) sized <- c(sized, f)
  }
  expect_equal(sized, character(0))
})

# ── width ─────────────────────────────────────────────────────────────────────

test_that("width lands on the Element markup, not on the host", {
  # The host is display:contents and generates no box, so a width set there
  # would be ignored by the browser -- measured at 953px either way.
  html <- paste(as.character(el_input("i", width = 200)), collapse = "")
  expect_match(html, '<el-input[^>]*style="width: 200px"')
  expect_no_match(html, 'id="i_container" style="display: contents; width')
})

test_that("width replaces a width the component already declares", {
  # el_table's markup carries width: 100%. htmltools joins repeated attributes
  # with a space, so appending a second style would produce
  # style="width: 100% width: 300px" and neither would apply.
  html <- paste(as.character(el_table("t", data = head(iris, 2), width = "300px")),
                collapse = "")
  expect_match(html, 'style="width: 300px"')
  expect_no_match(html, "width: 100% width")

  # and without it, the default stands
  expect_match(paste(as.character(el_table("t", data = head(iris, 2))), collapse = ""),
               'style="width: 100%"')
})

test_that("width accepts what a Shiny input accepts", {
  expect_match(paste(as.character(el_select("s", choices = "A", width = "50%")), collapse = ""),
               "width: 50%")
  # a bare number means pixels, as in shiny::textInput()
  expect_match(paste(as.character(el_select("s", choices = "A", width = 150)), collapse = ""),
               "width: 150px")
})

# ── absorbing components into a wrapper ───────────────────────────────────────

test_that("a wrapper absorbs a component rather than nesting it", {
  ui <- el_tooltip("tip", el_button("btn", "Save"), content = "hint")
  # One instance, carrying both components' markup and both their fields
  html <- paste(as.character(htmltools::renderTags(ui)$html), collapse = "")
  expect_equal(length(gregexpr("html-widget", html)[[1]]), 1L)
  expect_match(html, "<el-tooltip[^>]*>\\s*<el-button")

  data <- vue_data_of(ui)
  expect_true("tipContent" %in% names(data))   # the wrapper's, prefixed
  expect_true("label" %in% names(data))        # the button's, as they were
})

test_that("a second absorbed component has its fields renamed", {
  # el_button and el_tag both declare label, type, size, disabled and
  # handleClick
  ui <- el_popover("pop", el_button("b", "Open"), body = el_tag("t", "inside"))
  payload <- vue_payload_of(ui)

  expect_true("label" %in% names(payload$data))
  expect_true(any(grepl("^el3_", names(payload$data))))
  expect_true(any(grepl("^el3_", names(payload$methods))))

  # and the markup refers to the renamed fields, not the originals
  html <- paste(as.character(ui), collapse = "")
  expect_match(html, '<el-tag[^>]*:type="el3_type"')
})

test_that("renaming leaves string literals alone", {
  # :class="data.isSelected ? 'is-selected' : ''" names a CSS class
  expr <- ":class=\"data.isSelected ? 'is-selected' : ''\""
  out <- .el_rewrite_expr(expr, c(isSelected = "x_isSelected"))
  expect_match(out, "'is-selected'", fixed = TRUE)
  # a member access is not a field of the instance either
  expect_match(out, "data.isSelected", fixed = TRUE)
})
