#' Element Plus Color Picker Panel
#'
#' The colour picker's panel, always open, without the trigger.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value Binding value: Element Plus's `model-value`, reported as
#'   `input$<id>`.
#' @param border Whether the color picker panel is bordered. Element Plus's
#'   `border` (boolean).
#' @param disabled Whether to disable the color picker. Element Plus's
#'   `disabled` (boolean).
#' @param show_alpha Whether to display the alpha slider. Element Plus's
#'   `show-alpha` (boolean).
#' @param color_format Color format of v-model. Element Plus's `color-format`
#'   (enum).
#' @param predefine Predefined color options. Element Plus's `predefine`
#'   (string[]).
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param hue_slider_class Class names will be passed to hue-slider. Element
#'   Plus's `hue-slider-class` (string | string[] | Record<string, boolean>).
#' @param hue_slider_style Styles will be passed to hue-slider. Element Plus's
#'   `hue-slider-style` (string / StyleValue).
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `footer`. A scoped slot
#'   is written with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the value, on load and on every change.
#'
#' @section Element methods:
#' Callable with [call_el()]: `update()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_color_picker_panel("brand", value = "#409EFF")
#' @export
el_color_picker_panel <- function(
  id = NULL,
  value = NULL,
  border = NULL,
  disabled = NULL,
  show_alpha = NULL,
  color_format = NULL,
  predefine = NULL,
  validate_event = NULL,
  hue_slider_class = NULL,
  hue_slider_style = NULL,
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
  .el_check_choices("el_color_picker_panel", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_color_picker_panel")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, character())
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
    markup = htmltools::tag("el-color-picker-panel", attrs),
    props = .el_props(list(
      border = border,
      disabled = disabled,
      # Element Plus 2.14.7 hands an unset show-alpha on to its predefined
      # swatches as undefined, a Boolean prop: Vue warns. FALSE is its default.
      show_alpha = if (is.null(show_alpha)) FALSE else show_alpha,
      color_format = color_format,
      predefine = predefine,
      validate_event = validate_event,
      hue_slider_class = hue_slider_class,
      hue_slider_style = hue_slider_style
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


#' @rdname el_color_picker_panel
#' @section Updating from the server:
#' Server-side update for [el_color_picker_panel()].
#'
#' Every other argument of [el_color_picker_panel()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_color_picker_panel()` is called for its side effect and returns `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$reset,
#'     update_el_color_picker_panel(session, "x", value = NULL)
#'   )
#' }
#' @export
update_el_color_picker_panel <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  border = NULL,
  show_alpha = NULL,
  color_format = NULL,
  predefine = NULL,
  validate_event = NULL,
  hue_slider_class = NULL,
  hue_slider_style = NULL
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
      "el_color_picker_panel",
      Filter(
        Negate(is.null),
        list(
          border = border,
          show_alpha = show_alpha,
          color_format = color_format,
          predefine = predefine,
          validate_event = validate_event,
          hue_slider_class = hue_slider_class,
          hue_slider_style = hue_slider_style
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
