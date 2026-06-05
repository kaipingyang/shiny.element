#' Element UI Dialog Component
#'
#' Creates an Element UI dialog (modal) with Vue instance.
#' The dialog visibility can be controlled from the server via [update_el_dialog()].
#'
#' @param id Dialog ID. Auto-generated UUID if `NULL`.
#' @param title Dialog title text. Default `""`.
#' @param content Optional tagList/tag for the dialog body. `NULL` for empty.
#' @param footer Optional tagList/tag for the dialog footer slot. `NULL` for none.
#' @param visible Whether the dialog is initially visible. Default `FALSE`.
#' @param width Dialog width. Default `"50%"`.
#' @param fullscreen Whether the dialog occupies the full screen. Default `FALSE`.
#' @param close_on_click_modal Whether clicking the overlay closes the dialog.
#'   Default `TRUE`.
#' @param close_on_press_escape Whether pressing Escape closes the dialog.
#'   Default `TRUE`.
#' @param show_close Whether to show the close button in the header. Default `TRUE`.
#' @param center Whether to align the header and footer to center. Default `FALSE`.
#' @param destroy_on_close Whether to destroy child components on close. Default `FALSE`.
#' @param append_to_body Whether to append the dialog to `document.body`. Default `FALSE`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed dialog component.
#'
#' @section Shiny input:
#' `input$<id>_visible` — Logical (`TRUE` when dialog opens, `FALSE` when it closes).
#'
#' @examples
#' # Basic dialog (initially hidden)
#' el_dialog(
#'   id      = "dlg1",
#'   title   = "My Dialog",
#'   content = shiny::tags$p("Dialog body text."),
#'   footer  = shiny::tagList(
#'     el_button("dlg_ok",  "OK",     type = "primary"),
#'     el_button("dlg_cancel", "Cancel")
#'   )
#' )
#'
#' # Controlled open/close from server
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_button("open_btn", "Open Dialog", type = "primary"),
#'     el_dialog(
#'       id      = "dlg1",
#'       title   = "Confirm",
#'       content = shiny::tags$p("Are you sure?"),
#'       footer  = el_button("confirm_btn", "Yes", type = "danger")
#'     ),
#'     verbatimTextOutput("state")
#'   )
#'   server <- function(input, output, session) {
#'     observeEvent(input$open_btn, {
#'       update_el_dialog(session, "dlg1", visible = TRUE)
#'     })
#'     observeEvent(input$confirm_btn, {
#'       update_el_dialog(session, "dlg1", visible = FALSE)
#'     })
#'     output$state <- renderPrint(input$dlg1_visible)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_dialog <- function(
    id                    = NULL,
    title                 = "",
    content               = NULL,
    footer                = NULL,
    visible               = FALSE,
    width                 = "50%",
    fullscreen            = FALSE,
    close_on_click_modal  = TRUE,
    close_on_press_escape = TRUE,
    show_close            = TRUE,
    center                = FALSE,
    destroy_on_close      = FALSE,
    append_to_body        = FALSE,
    session               = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_dialog_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Build dialog children (body content + optional footer slot)
  dialog_children <- list()
  if (!is.null(content)) dialog_children <- c(dialog_children, list(content))
  if (!is.null(footer)) {
    footer_slot     <- shiny::tags$span(slot = "footer", footer)
    dialog_children <- c(dialog_children, list(footer_slot))
  }

  # Build el-dialog attributes
  dialog_attrs <- list(
    ":title"                = "title",
    ":visible.sync"         = "visible",
    ":width"                = "width",
    ":fullscreen"           = "fullscreen",
    ":close-on-click-modal" = "closeOnClickModal",
    ":close-on-press-escape"= "closeOnPressEscape",
    ":show-close"           = "showClose",
    ":center"               = "center",
    ":destroy-on-close"     = "destroyOnClose",
    ":append-to-body"       = "appendToBody",
    "@open"                 = "handleOpen",
    "@close"                = "handleClose"
  )

  # Vue data
  vue_data <- list(
    title              = title,
    visible            = visible,
    width              = width,
    fullscreen         = fullscreen,
    closeOnClickModal  = close_on_click_modal,
    closeOnPressEscape = close_on_press_escape,
    showClose          = show_close,
    center             = center,
    destroyOnClose     = destroy_on_close,
    appendToBody       = append_to_body
  )

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-dialog", c(dialog_attrs, dialog_children))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleOpen  = htmlwidgets::JS(sprintf(
            "function() { Shiny.setInputValue('%s_visible', true); }",
            ns_id
          )),
          handleClose = htmlwidgets::JS(sprintf(
            "function() { Shiny.setInputValue('%s_visible', false); this.visible = false; }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_dialog_handler_dependency())
}


#' Update Element UI Dialog
#'
#' Server-side update for [el_dialog()]. Use `visible = TRUE` to open the dialog
#' and `visible = FALSE` to close it programmatically.
#'
#' @param session Shiny session object.
#' @param id Dialog ID (un-namespaced).
#' @param visible Logical. `TRUE` to open, `FALSE` to close.
#' @param title New dialog title text.
#' @param width New dialog width (e.g. `"60%"`, `"400px"`).
#'
#' @export
update_el_dialog <- function(session, id, visible = NULL, title = NULL, width = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(visible)) msg$visible <- visible
  if (!is.null(title))   msg$title   <- title
  if (!is.null(width))   msg$width   <- width
  session$sendCustomMessage("updateElDialog", msg)
}


#' Dialog Handler Dependency
#' @keywords internal
el_dialog_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-dialog-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-dialog-handler.js",
    all_files = FALSE
  )
}
