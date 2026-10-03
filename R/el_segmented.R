#' Element Plus Segmented
#'
#' A row of options, one of them selected: a compact radio group.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value Binding value: Element Plus's `model-value`, reported as
#'   `input$<id>`.
#' @param options The options: a named vector `c(Label = value)`, a vector,
#'   or a list of `list(value =, label =, disabled =)`, as Element Plus takes them.
#' @param size Size of component. Element Plus's `size` ('' | 'large' |
#'   'default' | 'small').
#' @param block Fit width of parent content. Element Plus's `block` (boolean).
#' @param disabled Whether segmented is disabled. Element Plus's `disabled`
#'   (boolean).
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param aria_label Native `aria-label` attribute. Element Plus's
#'   `aria-label` (string).
#' @param props Which field of an option holds what, when the options are
#'   records named otherwise: `list(value =, label =, disabled =)`, Element
#'   Plus's `props`.
#' @param direction Display direction. Element Plus's `direction`
#'   ('horizontal' | 'vertical').
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the value, on load and on every change.
#' - `input$<id>_change` -- Element Plus's `change` event.
#'
#' @return A Shiny UI element.
#' @examples
#' el_segmented(
#'   "period",
#'   options = c(Day = "d", Week = "w", Month = "m"),
#'   value = "w"
#' )
#' @export
el_segmented <- function(
  id = NULL,
  value = NULL,
  options = NULL,
  size = NULL,
  block = NULL,
  disabled = NULL,
  validate_event = NULL,
  aria_label = NULL,
  direction = NULL,
  props = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_segmented", environment())
  # A named vector c(Label = value), as the choice components take, or
  # Element Plus's list(value =, label =)
  if (!is.null(options)) {
    options <- .el_normalize_choices(options)
  }
  if (is.null(id)) {
    id <- paste0("el_segmented_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
  attrs <- c(
    list("v-model" = "value", "@change" = "handleChange"),
    events$attrs
  )
  el_widget(
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tag("el-segmented", attrs),
    props = .el_props(list(
      options = options,
      size = size,
      block = block,
      disabled = disabled,
      validate_event = validate_event,
      aria_label = aria_label,
      direction = direction,
      props = props
    )),
    data = list(value = .el_restore(ns_id, if (is.null(value)) NA else value)),
    methods = c(
      events$methods,
      list(
        handleChange = JS(sprintf(
          "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }",
          ns_id
        ))
      )
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width = width,
    slots = slots
  )
}


#' Update Element Plus Segmented
#'
#' Server-side update for [el_segmented()].
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
#'   observeEvent(input$reset, update_el_segmented(session, "x", value = NULL))
#' }
#' @export
update_el_segmented <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}
