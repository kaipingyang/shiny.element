#' Element Plus Alert
#'
#' An inline alert banner with optional close button. Fires a Shiny input when
#' the user closes it.
#'
#' @param id Alert ID. Auto-generated UUID if `NULL`.
#' @param title Main alert title text.
#' @param description Optional secondary description text. When supplied, the
#'   icon is rendered at the larger size.
#' @param type Alert type: `"info"` (default), `"success"`, `"warning"`,
#'   `"error"`.
#' @param closable Whether to show a close button. Default `TRUE`.
#' @param close_text Custom text for the close button. `""` for the default cross.
#' @param show_icon Whether to display the type icon. Default `FALSE`.
#' @param center Whether to centre the content. Default `FALSE`.
#' @param effect Visual effect: `"light"` (default) or `"dark"`.
#' @param session In `el_alert()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_alert()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed alert component.
#'
#' @section Shiny inputs:
#' `input$<id>_closed` -- set to `1` (with `priority = "event"`) when the
#' user closes the alert.
#'
#' @examples
#' el_alert("al1", "Operation successful", type = "success", show_icon = TRUE)
#' el_alert("al2", "Warning!", description = "Please review.", type = "warning")
#' @export
el_alert <- function(
  id = NULL,
  title = "",
  description = NULL,
  type = "info",
  closable = TRUE,
  close_text = "",
  show_icon = FALSE,
  center = FALSE,
  effect = "light",
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_choices("el_alert", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_alert")
  }
  ns_id <- .el_ui_id(id, session)

  alert_attrs <- list(
    ":title" = "title",
    ":type" = "type",
    ":closable" = "closable",
    ":close-text" = "closeText",
    ":show-icon" = "showIcon",
    ":center" = "center",
    ":effect" = "effect",
    "@close" = "handleClose"
  )
  alert_attrs[[":description"]] <- .el_optional_bind("description")
  vue_data <- list(
    title = title,
    type = type,
    closable = closable,
    closeText = close_text,
    showIcon = show_icon,
    center = center,
    effect = effect
  )
  vue_data$description <- if (is.null(description)) NA else description
  el_widget(
    id = ns_id,
    markup = htmltools::tag("el-alert", alert_attrs),
    data = vue_data,
    methods = list(
      handleClose = JS(sprintf(
        "function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_closed', 1, {priority: 'event'}); }",
        ns_id
      ))
    ),
    width = width,
    slots = slots
  )
}


#' @rdname el_alert
#' @section Updating from the server:
#' Server-side update for [el_alert()].
#'
#' Every other argument of [el_alert()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_alert()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_alert(session, "hint", title = "Saved", type = "success")
#'   })
#' }
#' @export
update_el_alert <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  type = NULL,
  description = NULL,
  closable = NULL,
  close_text = NULL,
  show_icon = NULL,
  center = NULL,
  effect = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(title)) {
    msg$title <- title
  }
  if (!is.null(type)) {
    msg$type <- type
  }
  if (!is.null(description)) {
    msg$description <- description
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_alert",
      Filter(
        Negate(is.null),
        list(
          closable = closable,
          close_text = close_text,
          show_icon = show_icon,
          center = center,
          effect = effect
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
