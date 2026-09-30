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
