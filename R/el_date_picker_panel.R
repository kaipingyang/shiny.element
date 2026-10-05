#' Element Plus Date Picker Panel
#'
#' The date picker's panel, always open, without the input.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value Binding value, if it is an `range` picker, the length of the
#'   array should be 2: Element Plus's `model-value`, reported as
#'   `input$<id>`.
#' @param border Whether the date picker is bordered. Element Plus's `border`
#'   (boolean).
#' @param disabled Whether DatePicker is disabled. Element Plus's `disabled`
#'   (boolean).
#' @param clearable Whether to show clear button. Element Plus's `clearable`
#'   (boolean).
#' @param editable Whether the input is editable. Element Plus's `editable`
#'   (boolean).
#' @param type Type of the picker. `quarter`, `quarters`, and `quarterrange`
#'   are supported. Element Plus's `type` (enum).
#' @param default_value Optional, default date of the calendar. Element Plus's
#'   `default-value` (`Date | [Date, Date]`).
#' @param default_time Optional, the time value to use when selecting date
#'   range. Element Plus's `default-time` (`Date | [Date, Date]`).
#' @param value_format Optional, format of binding value. If not specified,
#'   the binding value will be a Date object. Element Plus's `value-format`
#'   (string).
#' @param date_format Optional, format of the date displayed in input's inner
#'   panel. Element Plus's `date-format` (string).
#' @param time_format Optional, format of the time displayed in input's inner
#'   panel. Element Plus's `time-format` (string).
#' @param unlink_panels Unlink two date-panels in range-picker. Element Plus's
#'   `unlink-panels` (boolean).
#' @param single_panel Show only one panel in range-picker. Element Plus's
#'   `single-panel` (boolean).
#' @param disabled_date A function determining if a date is disabled with that
#'   date as its parameter. Should return a Boolean. Element Plus's
#'   `disabled-date` ((data: Date) => boolean). Give it as [JS()].
#' @param shortcuts An object array to set shortcut options. Element Plus's
#'   `shortcuts` (`Array<{ text: string, value: Date | Function }>`). Give it as
#'   [JS()].
#' @param cell_class_name Set custom className. Element Plus's
#'   `cell-class-name` ((data: Date) => string). Give it as [JS()].
#' @param show_footer Whether to show footer where the date picker is one
#'   `'dates' | 'months' | 'years' | 'quarters' | 'datetime' |
#'   'datetimerange'`. Element Plus's `show-footer` (boolean).
#' @param show_confirm Whether to show the confirm button. Element Plus's
#'   `show-confirm` (boolean).
#' @param show_week_number Show the week number besides the week. Element
#'   Plus's `show-week-number` (boolean).
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `prev-month`,
#'   `next-month`, `prev-year`, `next-year`. A scoped slot is written with
#'   [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the value, on load and on every change.
#' - `input$<id>_calendar_change` -- Element Plus's `calendar-change` event.
#' - `input$<id>_panel_change` -- Element Plus's `panel-change` event.
#' - `input$<id>_clear` -- Element Plus's `clear` event.
#'
#' @return A Shiny UI element.
#' @examples
#' el_date_picker_panel("day", value = Sys.Date(), value_format = "YYYY-MM-DD")
#' @export
el_date_picker_panel <- function(
  id = NULL,
  value = NULL,
  border = NULL,
  disabled = NULL,
  clearable = NULL,
  editable = NULL,
  type = NULL,
  default_value = NULL,
  default_time = NULL,
  value_format = NULL,
  date_format = NULL,
  time_format = NULL,
  unlink_panels = NULL,
  single_panel = NULL,
  disabled_date = NULL,
  shortcuts = NULL,
  cell_class_name = NULL,
  show_footer = NULL,
  show_confirm = NULL,
  show_week_number = NULL,
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
  .el_check_choices("el_date_picker_panel", environment())
  if (inherits(value, "Date")) {
    value <- format(value, "%Y-%m-%d")
  }
  if (length(value) > 1) {
    value <- as.list(value)
  }
  value_format <- .el_dayjs_format(value_format)
  date_format <- .el_dayjs_format(date_format)
  time_format <- .el_dayjs_format(time_format)
  if (is.null(id)) {
    id <- .el_auto_id("el_date_picker_panel")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    c("calendar-change", "panel-change", "clear")
  )
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
    markup = htmltools::tag("el-date-picker-panel", attrs),
    props = .el_props(list(
      border = border,
      disabled = disabled,
      clearable = clearable,
      editable = editable,
      type = type,
      default_value = default_value,
      default_time = default_time,
      value_format = value_format,
      date_format = date_format,
      time_format = time_format,
      unlink_panels = unlink_panels,
      single_panel = single_panel,
      disabled_date = disabled_date,
      shortcuts = shortcuts,
      cell_class_name = cell_class_name,
      show_footer = show_footer,
      show_confirm = show_confirm,
      show_week_number = show_week_number
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


#' @rdname el_date_picker_panel
#' @section Updating from the server:
#' Server-side update for [el_date_picker_panel()].
#'
#' Every other argument of [el_date_picker_panel()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_date_picker_panel()` is called for its side effect and returns `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$reset,
#'     update_el_date_picker_panel(session, "x", value = NULL)
#'   )
#' }
#' @export
update_el_date_picker_panel <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  border = NULL,
  clearable = NULL,
  editable = NULL,
  type = NULL,
  value_format = NULL,
  date_format = NULL,
  time_format = NULL,
  unlink_panels = NULL,
  single_panel = NULL,
  disabled_date = NULL,
  shortcuts = NULL,
  cell_class_name = NULL,
  show_footer = NULL,
  show_confirm = NULL,
  show_week_number = NULL
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
      "el_date_picker_panel",
      Filter(
        Negate(is.null),
        list(
          border = border,
          clearable = clearable,
          editable = editable,
          type = type,
          value_format = value_format,
          date_format = date_format,
          time_format = time_format,
          unlink_panels = unlink_panels,
          single_panel = single_panel,
          disabled_date = disabled_date,
          shortcuts = shortcuts,
          cell_class_name = cell_class_name,
          show_footer = show_footer,
          show_confirm = show_confirm,
          show_week_number = show_week_number
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
