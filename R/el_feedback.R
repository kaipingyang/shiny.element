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
#' @return A Shiny UI element.
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
#' @return A Shiny UI element.
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


#' Element UI Message Box
#'
#' A modal that asks something and waits for an answer: a confirmation, an
#' acknowledgement, or a line of text.
#'
#' Unlike [el_message()] and [el_notification()], this one answers back. The
#' reply arrives as `input$<id>`, so read it with `observeEvent()` -- the
#' input is set with event priority and Shiny clears it after each flush.
#'
#' @param session Shiny session object.
#' @param id Input ID the answer is reported to.
#' @param message The question or statement.
#' @param title Title of the box.
#' @param type Icon shown: `"success"`, `"info"`, `"warning"` or `"error"`.
#' @param box_type `"confirm"` (default) offers two buttons, `"alert"` one,
#'   and `"prompt"` asks for text.
#' @param confirm_button_text,cancel_button_text Button labels.
#' @param show_cancel_button Whether to offer a cancel button. Default `TRUE`
#'   for `"confirm"` and `"prompt"`.
#' @param show_close Whether to show the close cross. Default `TRUE`.
#' @param center Whether to centre the content.
#' @param round_button Whether the buttons are rounded.
#' @param dangerously_use_html_string Whether `message` is rendered as HTML.
#'   Only pass `TRUE` for markup you control -- it is inserted unescaped.
#' @param custom_class,icon_class Extra class names.
#' @param close_on_click_modal Whether clicking the backdrop closes it.
#' @param close_on_press_escape Whether Escape closes it.
#' @param input_placeholder,input_value For `box_type = "prompt"`: the
#'   placeholder and the initial text.
#' @param input_pattern Regular expression the text must match, as a string.
#' @param input_error_message Message shown when it does not match.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- `"confirm"`, `"cancel"` or `"close"`. For a prompt that
#'   was confirmed, a list of `action` and `value`, where `value` is the text
#'   the user typed.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'
#'   ui <- el_page(el_button("del", "Delete", type = "danger"),
#'                 verbatimTextOutput("answer"))
#'
#'   server <- function(input, output, session) {
#'     observeEvent(input$del, {
#'       el_message_box(session, "confirm_delete",
#'                      "This cannot be undone.",
#'                      title = "Delete the row?", type = "warning")
#'     })
#'     observeEvent(input$confirm_delete, {
#'       output$answer <- renderPrint(input$confirm_delete)
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_message_box <- function(session, id, message, title = NULL,
                           type = NULL,
                           box_type = c("confirm", "alert", "prompt"),
                           confirm_button_text = NULL,
                           cancel_button_text = NULL,
                           show_cancel_button = NULL,
                           show_close = NULL,
                           center = FALSE,
                           round_button = FALSE,
                           dangerously_use_html_string = FALSE,
                           custom_class = NULL,
                           icon_class = NULL,
                           close_on_click_modal = NULL,
                           close_on_press_escape = NULL,
                           input_placeholder = NULL,
                           input_value = NULL,
                           input_pattern = NULL,
                           input_error_message = NULL) {
  box_type <- match.arg(box_type)

  session$sendCustomMessage("elMessageBox", list(
    id                       = session$ns(id),
    boxType                  = box_type,
    message                  = message,
    title                    = title,
    type                     = type,
    confirmButtonText        = confirm_button_text,
    cancelButtonText         = cancel_button_text,
    showCancelButton         = show_cancel_button,
    showClose                = show_close,
    center                   = center,
    roundButton              = round_button,
    dangerouslyUseHTMLString = dangerously_use_html_string,
    customClass              = custom_class,
    iconClass                = icon_class,
    closeOnClickModal        = close_on_click_modal,
    closeOnPressEscape       = close_on_press_escape,
    inputPlaceholder         = input_placeholder,
    inputValue               = input_value,
    inputPattern             = input_pattern,
    inputErrorMessage        = input_error_message
  ))
  invisible(NULL)
}


#' Element UI Loading Mask
#'
#' Cover the page, or one element, while something is being worked out.
#' Each mask is named, and stays until [el_loading_close()] is called with the
#' same `id`.
#'
#' @param session Shiny session object.
#' @param id Name for this mask, used to close it again.
#' @param text Text shown under the spinner.
#' @param target CSS selector of the element to cover. `NULL` covers the page.
#' @param fullscreen Whether the mask covers the viewport. Default `TRUE` when
#'   no `target` is given.
#' @param lock Whether to stop the page scrolling underneath.
#' @param body Whether the mask is inserted into `body` rather than the
#'   target.
#' @param spinner Class name of a custom spinner.
#' @param background Background colour of the mask.
#' @param custom_class Extra class name.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'
#'   ui <- el_page(el_button("go", "Fetch"), el_table("out"))
#'
#'   server <- function(input, output, session) {
#'     observeEvent(input$go, {
#'       el_loading(session, "fetching", text = "Fetching rows...")
#'       on.exit(el_loading_close(session, "fetching"), add = TRUE)
#'       update_el_table(session, "out", data = slow_query())
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_loading <- function(session, id = "default", text = NULL, target = NULL,
                       fullscreen = NULL, lock = NULL, body = NULL,
                       spinner = NULL, background = NULL,
                       custom_class = NULL) {
  session$sendCustomMessage("elLoading", list(
    id          = session$ns(id),
    text        = text,
    target      = target,
    fullscreen  = fullscreen,
    lock        = lock,
    body        = body,
    spinner     = spinner,
    background  = background,
    customClass = custom_class
  ))
  invisible(NULL)
}


#' Close a loading mask
#'
#' Closes the mask [el_loading()] opened under this `id`. Closing one that is
#' not open does nothing.
#'
#' @param session Shiny session object.
#' @param id The `id` the mask was opened with.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$done, {
#'     el_loading_close(session, "fetching")
#'   })
#' }
#' @export
el_loading_close <- function(session, id = "default") {
  session$sendCustomMessage("elLoading", list(id = session$ns(id), close = TRUE))
  invisible(NULL)
}
