#' Element UI Confirmation Bubble
#'
#' A small confirmation prompt anchored to the element that triggers it,
#' for actions that warrant a check but not a dialog.
#'
#' @param id Popconfirm ID. Auto-generated if `NULL`.
#' @param reference The element that opens the prompt. Any Shiny UI,
#'   including another shiny.element component -- that component is folded
#'   into this one's Vue instance rather than nested inside it, so its inputs
#'   keep reporting. Its `update_el_*()` no longer reaches it, though.
#' @param title The question.
#' @param confirm_button_text,cancel_button_text Button labels.
#' @param confirm_button_type,cancel_button_type Button types, as in
#'   [el_button()]. Default `"primary"` and `"text"`.
#' @param icon Icon class shown beside the question.
#' @param icon_color Colour of that icon.
#' @param hide_icon Whether to leave the icon out. Default `FALSE`.
#' @param width Component width, as a CSS unit.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
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
                          slots   = NULL,
                          session = NULL) {
  inner <- .el_absorb(reference)

  if (is.null(id)) id <- paste0("el_popconfirm_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    ":title"               = .el_optional_bind("pcTitle"),
    ":confirm-button-text" = .el_optional_bind("pcConfirmButtonText"),
    ":cancel-button-text"  = .el_optional_bind("pcCancelButtonText"),
    ":confirm-button-type" = .el_optional_bind("pcConfirmButtonType"),
    ":cancel-button-type"  = .el_optional_bind("pcCancelButtonType"),
    ":icon"                = .el_optional_bind("pcIcon"),
    ":icon-color"          = .el_optional_bind("pcIconColor"),
    ":hide-icon"           = .el_optional_bind("pcHideIcon"),
    # Element 2.13 emitted these as onConfirm and onCancel; 2.15 renamed them
    # to confirm and cancel. Bound under the old names they are simply never
    # heard, so the prompt still opens and closes but reports nothing.
    "@confirm"             = "handleConfirm",
    "@cancel"              = "handleCancel"
  )



  own <- list(
    markup = NULL,
    data = list(
      pcTitle             = .el_or_na(title),
      pcConfirmButtonText = .el_or_na(confirm_button_text),
      pcCancelButtonText  = .el_or_na(cancel_button_text),
      pcConfirmButtonType = .el_or_na(confirm_button_type),
      pcCancelButtonType  = .el_or_na(cancel_button_type),
      pcIcon              = .el_or_na(icon),
      pcIconColor         = .el_or_na(icon_color),
      pcHideIcon          = .el_or_na(hide_icon)
    ),
    watch = list(), computed = list(), mounted = NULL, dependencies = list(),
    methods = list(
      handleConfirm = JS(sprintf(
        "function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_confirm', true, {priority: 'event'}); }",
        ns_id
      )),
      handleCancel = JS(sprintf(
        "function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_cancel', true, {priority: 'event'}); }",
        ns_id
      ))
    )
  )
  merged <- .el_absorb_merge(own, inner)
  ref_markup <- merged$markups[[2]]
  children <- if (is.null(ref_markup)) list() else list(
    htmltools::tags$span(slot = "reference", ref_markup)
  )

  el_widget(
    id       = ns_id,
    markup   = htmltools::tag("el-popconfirm", c(attrs, children)),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    slots      = slots,
    dependency = merged$dependencies
  )
}


#' Update Element UI Confirmation Bubble
#'
#' Server-side update for [el_popconfirm()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
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
update_el_popconfirm <- function(session = shiny::getDefaultReactiveDomain(), id, title = NULL,
                                 confirm_button_text = NULL,
                                 cancel_button_text = NULL) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  # The popconfirm's fields carry a prefix, kept apart from its reference's
  if (!is.null(title))               msg$pcTitle             <- title
  if (!is.null(confirm_button_text)) msg$pcConfirmButtonText <- confirm_button_text
  if (!is.null(cancel_button_text))  msg$pcCancelButtonText  <- cancel_button_text
  .el_send_update(session, msg)
  invisible(NULL)
}


