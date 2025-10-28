#' Generate a `<template>` tag for Vue/Element UI slot usage
#'
#' @param ... Content inside the template
#' @param slot Slot name (optional)
#' @param scope Slot scope or v-slot syntax (optional)
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
#'   slot = "dateCell",
#'   scope = "{date, data}"
#' )
template <- function(..., slot = NULL, scope = NULL) {
  attrs <- c(
    if (!is.null(slot)) sprintf('slot="%s"', slot),
    if (!is.null(scope)) sprintf('slot-scope="%s"', scope)
  )
  attr_str <- if (length(attrs) > 0) paste(attrs, collapse = " ") else ""
  htmltools::HTML(
    sprintf('<template %s>%s</template>', attr_str, paste0(..., collapse = ""))
  )
}