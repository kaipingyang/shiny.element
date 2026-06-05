#' Element UI Alert
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
#' @param close_text Custom text for the close button. `""` for the default ×.
#' @param show_icon Whether to display the type icon. Default `FALSE`.
#' @param center Whether to centre the content. Default `FALSE`.
#' @param effect Visual effect: `"light"` (default) or `"dark"`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed alert component.
#'
#' @section Shiny input:
#' `input$<id>_closed` — set to `1` (with `priority = "event"`) when the
#' user closes the alert.
#'
#' @examples
#' el_alert("al1", "Operation successful", type = "success", show_icon = TRUE)
#' el_alert("al2", "Warning!", description = "Please review.", type = "warning")
#'
#' @export
el_alert <- function(
    id           = NULL,
    title        = "",
    description  = NULL,
    type         = "info",
    closable     = TRUE,
    close_text   = "",
    show_icon    = FALSE,
    center       = FALSE,
    effect       = "light",
    session      = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_alert_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  alert_attrs <- list(
    ":title"       = "title",
    ":type"        = "type",
    ":closable"    = "closable",
    ":close-text"  = "closeText",
    ":show-icon"   = "showIcon",
    ":center"      = "center",
    ":effect"      = "effect",
    "@close"       = "handleClose"
  )
  if (!is.null(description)) alert_attrs[[":description"]] <- "description"

  vue_data <- list(
    title       = title,
    type        = type,
    closable    = closable,
    closeText   = close_text,
    showIcon    = show_icon,
    center      = center,
    effect      = effect
  )
  if (!is.null(description)) vue_data$description <- description

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-alert", alert_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleClose = htmlwidgets::JS(sprintf(
            "function() { Shiny.setInputValue('%s_closed', 1, {priority: 'event'}); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_alert_handler_dependency())
}


#' Update Element UI Alert
#'
#' Server-side update for [el_alert()].
#'
#' @param session Shiny session object.
#' @param id Alert ID (un-namespaced).
#' @param title New title text.
#' @param type New alert type.
#' @param description New description text. Use `NULL` to leave unchanged.
#'
#' @export
update_el_alert <- function(session, id, title = NULL, type = NULL,
                            description = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(title))       msg$title       <- title
  if (!is.null(type))        msg$type        <- type
  if (!is.null(description)) msg$description <- description
  session$sendCustomMessage("updateElAlert", msg)
}


#' @keywords internal
el_alert_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-alert-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-alert-handler.js",
    all_files = FALSE
  )
}
