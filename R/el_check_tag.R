#' Element Plus Check Tag
#'
#' A tag that toggles on and off when clicked, as a checkbox does.
#'
#' @param id Tag ID; the state is reported as `input$<id>`.
#' @param label The tag's text.
#' @param value Whether it starts checked: Element Plus's `checked`.
#' @param disabled Whether it can be toggled.
#' @param type `"primary"` (the default), `"success"`, `"info"`, `"warning"`
#'   or `"danger"`.
#' @param width Component width, as a CSS unit.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- `TRUE` or `FALSE`, on load and on every change.
#'
#' @return A Shiny UI element.
#' @examples
#' el_check_tag("pinned", "Pinned", value = TRUE)
#' el_check_tag("urgent", "Urgent", type = "danger")
#' @export
el_check_tag <- function(
  id,
  label,
  value = FALSE,
  disabled = NULL,
  type = NULL,
  width = NULL
) {
  .el_check_choices("el_check_tag", environment())
  ns_id <- .el_ui_id(id, NULL)
  el_widget(
    id = ns_id,
    markup = htmltools::tag(
      "el-check-tag",
      list(
        ":checked" = "value",
        "@change" = "handleChange",
        "{{ text }}"
      )
    ),
    props = .el_props(list(disabled = disabled, type = type)),
    data = list(value = isTRUE(.el_restore(ns_id, value)), text = label),
    methods = list(
      handleChange = JS(sprintf(
        paste0(
          "function(v) { this.value = v; window.Shiny && Shiny.setInputValue && ",
          "Shiny.setInputValue('%s', v); }"
        ),
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width = width
  )
}


#' Update Element Plus Check Tag
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateCheckboxInput()].
#' @param id Tag ID (un-namespaced).
#' @param value,label,disabled New values; `NULL` leaves one unchanged.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$clear,
#'     update_el_check_tag(session, "pinned", value = FALSE)
#'   )
#' }
#' @export
update_el_check_tag <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  label = NULL,
  disabled = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(label)) {
    msg$text <- label
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
