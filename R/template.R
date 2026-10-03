#' Generate a `<template>` tag for Vue/Element Plus slot usage
#'
#' @param ... Content inside the template
#' @param slot Slot name (optional)
#' @param scope Slot scope or v-slot syntax (optional)
#' @return A Shiny UI element.
#' @export
#' @examples
#' # Basic usage with text
#' template("Hello World")
#'
#' # With slot name
#' template("Custom content", slot = "header")
#'
#' # With HTML tag content
#' template(shiny::tags$a(href = "https://posit.co", "Posit"), slot = "footer")
#'
#' # Combine multiple tags
#' template(
#'   shiny::tags$span("A"),
#'   shiny::tags$span("B"),
#'   slot = "extra"
#' )
#'
#' # Custom dateCell slot with check mark (Unicode)
#' template(
#'   shiny::tags$p(
#'     `:class` = "data.isSelected ? 'is-selected' : ''",
#'     "{{ data.day.split('-').slice(1).join('-') }}",
#'     shiny::tags$span("\u2714\ufe0f", `v-if` = "data.isSelected")
#'   ),
#'   slot = "date-cell",
#'   scope = "{date, data}"
#' )
template <- function(..., slot = NULL, scope = NULL) {
  # Vue 3's slot syntax: v-slot:name="scope". Element Plus names its slots in
  # kebab-case, and Vue 3 matches them as written: dateCell is date-cell.
  if (!is.null(slot)) {
    slot <- gsub("([a-z0-9])([A-Z])", "\\1-\\L\\2", slot, perl = TRUE)
  }
  attrs <- if (!is.null(slot) || !is.null(scope)) {
    paste0(
      "v-slot:",
      if (is.null(slot)) "default" else slot,
      if (!is.null(scope)) sprintf('="%s"', scope) else ""
    )
  }
  attr_str <- if (length(attrs) > 0) paste(attrs, collapse = " ") else ""
  htmltools::HTML(
    sprintf('<template %s>%s</template>', attr_str, paste0(..., collapse = ""))
  )
}
