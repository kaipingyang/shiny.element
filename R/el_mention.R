#' Element Plus Mention
#'
#' A text input that offers options after a trigger character, as @mentions
#'   do.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value Input value: Element Plus's `model-value`, reported as
#'   `input$<id>`.
#' @param options The options: a named vector `c(Label = value)`, a vector,
#'   or a list of `list(value =, label =, disabled =)`, as Element Plus takes them.
#' @param props Configuration options. Element Plus's `props`
#'   (MentionOptionProps).
#' @param prefix Prefix character to trigger mentions. The string length must
#'   be exactly 1. Element Plus's `prefix` (`string / string[]`).
#' @param split Character to split mentions. The string length must be exactly
#'   1. Element Plus's `split` (string).
#' @param filter_option Customize filter option logic. Element Plus's
#'   `filter-option` (false / (pattern: string, option: MentionOption) =>
#'   boolean). Give it as [JS()].
#' @param placement Set popup placement. Element Plus's `placement` ('bottom'
#'   | 'top').
#' @param show_arrow Whether the dropdown panel has an arrow. Element Plus's
#'   `show-arrow` (boolean).
#' @param offset Offset of the dropdown panel. Element Plus's `offset`
#'   (number).
#' @param whole When backspace is pressed to delete, whether the mention
#'   content is deleted as a whole. Element Plus's `whole` (boolean).
#' @param check_is_whole When backspace is pressed to delete, check if the
#'   mention is a whole. Element Plus's `check-is-whole` ((pattern: string,
#'   prefix: string) => boolean). Give it as [JS()].
#' @param loading Whether the dropdown panel of mentions is in a loading
#'   state. Element Plus's `loading` (boolean).
#' @param popper_class Custom class name for dropdown panel. Element Plus's
#'   `popper-class` (string / object).
#' @param popper_style Custom style for dropdown panel. Element Plus's
#'   `popper-style` (string / object).
#' @param popper_options Popper.js parameters. Element Plus's `popper-options`
#'   (object).
#' @param placeholder,disabled,type,rows As for [el_input()]: the placeholder
#'   text, whether it can be changed, and
#'   `type = "textarea"` with its number of rows for a longer message.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `label`, `loading`,
#'   `header`, `footer`. A scoped slot is written with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the value, on load and on every change.
#' - `input$<id>_search` -- Element Plus's `search` event.
#' - `input$<id>_select` -- Element Plus's `select` event.
#' - `input$<id>_whole_remove` -- Element Plus's `whole-remove` event.
#'
#' @return A Shiny UI element.
#' @examples
#' el_mention("msg", options = c("Ada", "Grace", "Linus"), placeholder = "Type @")
#' @export
el_mention <- function(
  id = NULL,
  value = NULL,
  options = NULL,
  props = NULL,
  prefix = NULL,
  split = NULL,
  filter_option = NULL,
  placement = NULL,
  show_arrow = NULL,
  offset = NULL,
  whole = NULL,
  check_is_whole = NULL,
  loading = NULL,
  popper_class = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placeholder = NULL,
  disabled = NULL,
  type = NULL,
  rows = NULL,
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
  .el_check_choices("el_mention", environment())
  # A named vector c(Label = value), as the choice components take, or
  # Element Plus's list(value =, label =)
  if (!is.null(options)) {
    options <- .el_normalize_choices(options)
  }
  if (is.null(id)) {
    id <- .el_auto_id("el_mention")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, c("search", "select", "whole-remove"))
  attrs <- c(list("v-model" = "value"), events$attrs)
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
    markup = htmltools::tag("el-mention", attrs),
    props = .el_props(list(
      options = options,
      props = props,
      prefix = prefix,
      split = split,
      filter_option = filter_option,
      placement = placement,
      show_arrow = show_arrow,
      offset = offset,
      whole = whole,
      check_is_whole = check_is_whole,
      loading = loading,
      popper_class = popper_class,
      popper_style = popper_style,
      popper_options = popper_options,
      placeholder = placeholder,
      disabled = disabled,
      type = type,
      rows = rows
    )),
    data = list(value = .el_restore(ns_id, if (is.null(value)) NA else value)),
    methods = events$methods,
    watch = list(
      value = JS(sprintf(
        "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }",
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width = width,
    slots = slots
  )
}


#' @rdname el_mention
#' @section Updating from the server:
#' Server-side update for [el_mention()].
#'
#' Every other argument of [el_mention()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_mention()` is called for its side effect and returns `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$reset, update_el_mention(session, "x", value = NULL))
#' }
#' @export
update_el_mention <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  props = NULL,
  prefix = NULL,
  split = NULL,
  filter_option = NULL,
  placement = NULL,
  show_arrow = NULL,
  offset = NULL,
  whole = NULL,
  check_is_whole = NULL,
  loading = NULL,
  popper_class = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placeholder = NULL,
  type = NULL,
  rows = NULL
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
  msg <- c(
    msg,
    .el_update_props(
      "el_mention",
      Filter(
        Negate(is.null),
        list(
          props = props,
          prefix = prefix,
          split = split,
          filter_option = filter_option,
          placement = placement,
          show_arrow = show_arrow,
          offset = offset,
          whole = whole,
          check_is_whole = check_is_whole,
          loading = loading,
          popper_class = popper_class,
          popper_style = popper_style,
          popper_options = popper_options,
          placeholder = placeholder,
          type = type,
          rows = rows
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
