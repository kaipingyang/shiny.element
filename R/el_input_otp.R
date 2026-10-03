#' Element Plus Input OTP
#'
#' A one-time password or verification code, typed one character per field.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value The value of the OTP fields. Since numbers must not have
#'   leading zeros, `modelValue` is allowed to be a number only during
#'   initialization: Element Plus's `model-value`, reported as `input$<id>`.
#' @param length The OTP fields length. Element Plus's `length` (number).
#' @param validator Custom validator function. Element Plus's `validator`
#'   ((char: string, index: number) => boolean). Give it as [JS()].
#' @param inputmode Native `inputmode` attribute. Element Plus's `inputmode`
#'   (string).
#' @param type The type of the OTP fields. Element Plus's `type` ('outlined' |
#'   'filled' | 'underlined').
#' @param size The size of the OTP fields. Element Plus's `size` ('large' |
#'   'default' | 'small').
#' @param mask Whether to enable password mode. Element Plus's `mask`
#'   (boolean).
#' @param disabled Whether the OTP fields are disabled. Element Plus's
#'   `disabled` (boolean).
#' @param separator The separator between OTP fields. Element Plus's
#'   `separator` (string / VNode / () => string | VNode). Give it as [JS()].
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param readonly Same as `readonly` in native input. Element Plus's
#'   `readonly` (boolean).
#' @param aria_label Native `aria-label` attribute. Element Plus's
#'   `aria-label` (string).
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `separator`. A scoped
#'   slot is written with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the value, on load and on every change.
#' - `input$<id>_change` -- Element Plus's `change` event.
#' - `input$<id>_finish` -- Element Plus's `finish` event.
#' - `input$<id>_focus` -- Element Plus's `focus` event.
#' - `input$<id>_blur` -- Element Plus's `blur` event.
#'
#' @section Element methods:
#' Callable with [el_call()]: `focus()`, `blur()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_input_otp("code", length = 6)
#' el_input_otp("pin", length = 4, mask = TRUE, type = "underlined")
#' @export
el_input_otp <- function(id = NULL,
                         value = NULL,
                         length = NULL,
                         validator = NULL,
                         inputmode = NULL,
                         type = NULL,
                         size = NULL,
                         mask = NULL,
                         disabled = NULL,
                         separator = NULL,
                         validate_event = NULL,
                         readonly = NULL,
                         aria_label = NULL,
                         label = NULL,
                         label_position = c("top", "left", "right"),
                         label_width = NULL,
                         label_suffix = NULL,
                         required = FALSE,
                         error = NULL,
                         show_message = TRUE,
                         inline_message = FALSE,
                         width = NULL,
                         slots = NULL) {
  .el_check_choices("el_input_otp", environment())
  if (is.null(id)) id <- paste0("el_input_otp_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, c("change", "finish", "focus", "blur"))
  attrs <- c(list("v-model" = "value"), events$attrs)
  el_widget(
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id      = ns_id,
    markup  = htmltools::tag("el-input-otp", attrs),
    props   = .el_props(list(
      length = length,
      validator = validator,
      inputmode = inputmode,
      type = type,
      size = size,
      mask = mask,
      disabled = disabled,
      separator = separator,
      validate_event = validate_event,
      readonly = readonly,
      aria_label = aria_label)),
    data    = list(value = .el_restore(ns_id, if (is.null(value)) NA else value)),
    methods = events$methods,
    watch   = list(value = JS(sprintf(
      "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }", ns_id))),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width   = width,
    slots   = slots
  )
}


#' Update Element Plus Input OTP
#'
#' Server-side update for [el_input_otp()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Component ID (un-namespaced).
#' @param value,disabled New values; `NULL` leaves one unchanged.
#' @param label New label, as for [shiny::updateTextInput()]: text, or
#'   tags or `HTML()` drawn as markup. Only a component built with a `label`
#'   has one to change.
#' @param error An error message to show on the component; `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$reset, update_el_input_otp(session, "x", value = NULL))
#' }
#' @export
update_el_input_otp <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL,
                              disabled = NULL, label = NULL, error = NULL) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value))    msg$value    <- value
  if (!is.null(disabled)) msg$disabled <- disabled
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}
