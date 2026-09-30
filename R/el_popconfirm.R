#' Element UI Confirmation Bubble
#'
#' A small confirmation prompt anchored to the element that triggers it,
#' for actions that warrant a check but not a dialog.
#'
#' @param id Popconfirm ID. Auto-generated if `NULL`.
#' @param reference The element that opens the prompt. Markup only -- raw
#'   Element tags from [el], or ordinary Shiny UI. It cannot be another
#'   shiny.element component: the prompt compiles this into its own Vue
#'   instance, which would discard a mounted one.
#' @param title The question.
#' @param confirm_button_text,cancel_button_text Button labels.
#' @param confirm_button_type,cancel_button_type Button types, as in
#'   [el_button()]. Default `"primary"` and `"text"`.
#' @param icon Icon class shown beside the question.
#' @param icon_color Colour of that icon.
#' @param hide_icon Whether to leave the icon out. Default `FALSE`.
#' @param width Component width, as a CSS unit.
#' @param session Shiny session for module support.
#'
#' @section Shiny inputs:
#' - `input$<id>_confirm` -- fires when the user confirms.
#' - `input$<id>_cancel` -- fires when the user backs out.
#'
#' Both are event inputs, so read them with `observeEvent()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_popconfirm("del",
#'   reference = el$button(type = "danger", "Delete"),
#'   title = "Delete this row?"
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'   ui <- el_page(
#'     el_popconfirm("del",
#'       reference = el$button(type = "danger", "Delete"),
#'       title = "Delete this row?")
#'   )
#'   server <- function(input, output, session) {
#'     observeEvent(input$del_confirm, {
#'       showNotification("Deleted")
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_popconfirm <- function(id = NULL,
                          reference = NULL,
                          title = NULL,
                          confirm_button_text = NULL,
                          cancel_button_text = NULL,
                          confirm_button_type = NULL,
                          cancel_button_type = NULL,
                          icon = NULL,
                          icon_color = NULL,
                          hide_icon = NULL,
                          width = NULL,
                          session = shiny::getDefaultReactiveDomain()) {
  reference <- .el_reject_widgets(reference, "reference", "el_popconfirm")

  if (is.null(id)) id <- paste0("el_popconfirm_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  attrs <- list(
    ":title"               = .el_optional_bind("title"),
    ":confirm-button-text" = .el_optional_bind("confirmButtonText"),
    ":cancel-button-text"  = .el_optional_bind("cancelButtonText"),
    ":confirm-button-type" = .el_optional_bind("confirmButtonType"),
    ":cancel-button-type"  = .el_optional_bind("cancelButtonType"),
    ":icon"                = .el_optional_bind("icon"),
    ":icon-color"          = .el_optional_bind("iconColor"),
    ":hide-icon"           = .el_optional_bind("hideIcon"),
    # Upstream emits these in camelCase, unlike every other Element event
    "@onConfirm"           = "handleConfirm",
    "@onCancel"            = "handleCancel"
  )

  children <- if (is.null(reference)) list() else list(
    htmltools::tags$span(slot = "reference", reference)
  )

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-popconfirm", c(attrs, children)),
    data   = list(
      title             = .el_or_na(title),
      confirmButtonText = .el_or_na(confirm_button_text),
      cancelButtonText  = .el_or_na(cancel_button_text),
      confirmButtonType = .el_or_na(confirm_button_type),
      cancelButtonType  = .el_or_na(cancel_button_type),
      icon              = .el_or_na(icon),
      iconColor         = .el_or_na(icon_color),
      hideIcon          = .el_or_na(hide_icon)
    ),
    methods = list(
      handleConfirm = htmlwidgets::JS(sprintf(
        "function() { Shiny.setInputValue('%s_confirm', true, {priority: 'event'}); }",
        ns_id
      )),
      handleCancel = htmlwidgets::JS(sprintf(
        "function() { Shiny.setInputValue('%s_cancel', true, {priority: 'event'}); }",
        ns_id
      ))
    ),
    width      = width,
    dependency = el_popconfirm_handler_dependency()
  )
}


#' Update Element UI Confirmation Bubble
#'
#' Server-side update for [el_popconfirm()].
#'
#' @param session Shiny session object.
#' @param id Popconfirm ID (un-namespaced).
#' @param title,confirm_button_text,cancel_button_text New values; `NULL`
#'   leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$row_click, {
#'     update_el_popconfirm(session, "del",
#'                          title = paste0("Delete ", selected_name(), "?"))
#'   })
#' }
#' @export
update_el_popconfirm <- function(session, id, title = NULL,
                                 confirm_button_text = NULL,
                                 cancel_button_text = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(title))               msg$title             <- title
  if (!is.null(confirm_button_text)) msg$confirmButtonText <- confirm_button_text
  if (!is.null(cancel_button_text))  msg$cancelButtonText  <- cancel_button_text
  session$sendCustomMessage("updateElPopconfirm", msg)
  invisible(NULL)
}


#' @keywords internal
el_popconfirm_handler_dependency <- function() {
  .el_handler_dependency("popconfirm")
}
