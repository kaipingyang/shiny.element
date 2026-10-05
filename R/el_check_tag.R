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


#' @rdname el_check_tag
#' @section Updating from the server:
#' `update_el_check_tag()` changes the component from the server.
#'
#' Every other argument of [el_check_tag()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_check_tag()` is called for its side effect and returns `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateCheckboxInput()].
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
  disabled = NULL,
  type = NULL
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
  msg <- c(
    msg,
    .el_update_props(
      "el_check_tag",
      Filter(
        Negate(is.null),
        list(
          type = type
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
