#' Show Element UI Notification
#'
#' Server-side function to show a desktop-corner notification popup.
#' Requires `use_element()` or `el_page()` in the UI to load the JS handler.
#'
#' @param session Shiny session object.
#' @param message Notification body text.
#' @param title Notification title. Default `""`.
#' @param type Notification type: `"info"`, `"success"`, `"warning"`,
#'   or `"error"`. Default `"info"`.
#' @param duration Auto-close delay in milliseconds. `0` disables auto-close.
#'   Default `4500`.
#' @param position Screen corner: `"top-right"`, `"top-left"`,
#'   `"bottom-right"`, or `"bottom-left"`. Default `"top-right"`.
#' @param show_close Whether to show the close button. Default `TRUE`.
#' @param offset Distance from the corner edge in pixels. Default `0`.
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_button("btn", "Notify", type = "primary")
#'   )
#'   server <- function(input, output, session) {
#'     observeEvent(input$btn, {
#'       el_notification(session,
#'         message = "Operation successful!",
#'         title   = "Success",
#'         type    = "success"
#'       )
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_notification <- function(
    session,
    message,
    title      = "",
    type       = "info",
    duration   = 4500,
    position   = "top-right",
    show_close = TRUE,
    offset     = 0
) {
  session$sendCustomMessage("elNotification", list(
    title     = title,
    message   = message,
    type      = type,
    duration  = duration,
    position  = position,
    showClose = show_close,
    offset    = offset
  ))
}


#' Show Element UI Message
#'
#' Server-side function to show a top-centre message toast.
#' Requires `use_element()` or `el_page()` in the UI to load the JS handler.
#'
#' @param session Shiny session object.
#' @param message Message text.
#' @param type Message type: `"info"`, `"success"`, `"warning"`, or `"error"`.
#'   Default `"info"`.
#' @param duration Auto-close delay in milliseconds. `0` disables auto-close.
#'   Default `3000`.
#' @param show_close Whether to show the close button. Default `FALSE`.
#' @param center Whether to centre the message text. Default `FALSE`.
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_button("btn", "Message", type = "primary")
#'   )
#'   server <- function(input, output, session) {
#'     observeEvent(input$btn, {
#'       el_message(session,
#'         message = "This is a message toast.",
#'         type    = "warning"
#'       )
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_message <- function(
    session,
    message,
    type       = "info",
    duration   = 3000,
    show_close = FALSE,
    center     = FALSE
) {
  session$sendCustomMessage("elMessage", list(
    message   = message,
    type      = type,
    duration  = duration,
    showClose = show_close,
    center    = center
  ))
}
