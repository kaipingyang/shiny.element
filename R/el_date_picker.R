#' Element Plus Date Picker Component
#'
#' Creates an Element Plus date picker with Vue instance, supporting single date,
#' datetime, month, year, week, and date range selection modes.
#'
#' @param id Date picker ID. Auto-generated UUID if `NULL`.
#' @param value Initial value. A `Date` object, a string in the format matching
#'   `value_format`, or a two-element character vector for range types. `NULL`
#'   (default) leaves the picker empty.
#' @param type Picker type: `"date"` (default), `"datetime"`, `"daterange"`,
#'   `"datetimerange"`, `"month"`, `"year"`, `"week"`.
#' @param value_format Format string returned to Shiny when a date is selected,
#'   in day.js's tokens, as Element Plus takes it (e.g., `"YYYY-MM-DD"`).
#'   `NULL` (default) is `"YYYY-MM-DD HH:mm:ss"` for `"datetime"` and
#'   `"datetimerange"` and `"YYYY-MM-DD"` for the rest. Element UI's tokens
#'   -- `"yyyy-MM-dd"`, `"timestamp"` -- are translated.
#' @param format Display format shown in the input box, in day.js's tokens.
#'   `NULL` (default) is Element's for the type: `"YYYY-MM-DD HH:mm:ss"` for
#'   a datetime, `"YYYY-MM"` for a month, `"YYYY"` for a year, and so on.
#' @param placeholder Placeholder text for non-range types.
#' @param start_placeholder Placeholder for the start input in range types.
#' @param end_placeholder Placeholder for the end input in range types.
#' @param clearable Whether to show the clear button. Default `TRUE`.
#' @param disabled Whether the picker is disabled. Default `FALSE`.
#' @param editable Whether the user can type directly in the input. Default `TRUE`.
#' @param readonly Whether the picker is read-only. Default `FALSE`.
#' @param range_separator Separator string displayed between start and end in
#'   range types. Default `"-"`.
#' @param arrow_control Whether to pick time using arrow buttons. Element
#'   Plus's `arrow-control` (boolean).
#' @param automatic_dropdown This prop decides if the date picker panel pops
#'   up when the input is focused. (The default value will be set to false in
#'   version 3.0). Element Plus's `automatic-dropdown` (boolean).
#' @param cell_class_name Set custom className. Element Plus's
#'   `cell-class-name` ((data: Date) => string).
#' @param date_format Optional, format of the date displayed in input's inner
#'   panel. Element Plus's `date-format` (string).
#' @param disabled_date A function determining if a date is disabled with that
#'   date as its parameter. Should return a Boolean. Element Plus's
#'   `disabled-date` ((data: Date) => boolean).
#' @param disabled_hours To specify the array of hours that cannot be
#'   selected. Element Plus's `disabled-hours` ((role: string, comparingDate?:
#'   Dayjs) => number[]).
#' @param disabled_minutes To specify the array of minutes that cannot be
#'   selected. Element Plus's `disabled-minutes` ((hour: number, role: string,
#'   comparingDate?: Dayjs) => number[]).
#' @param disabled_seconds To specify the array of seconds that cannot be
#'   selected. Element Plus's `disabled-seconds` (Function). Give it as
#'   [JS()].
#' @param empty_values Empty values of component, see config-provider. Element
#'   Plus's `empty-values` (array).
#' @param fallback_placements List of possible positions for Tooltip
#'   popper.js. Element Plus's `fallback-placements` (`Placement[]`).
#' @param placement Position of dropdown. Element Plus's `placement`.
#' @param popper_options Customized popper option see more at popper.js.
#'   Element Plus's `popper-options` (`Partial<PopperOptions>`).
#' @param popper_style Custom style for DatePicker's dropdown. Element Plus's
#'   `popper-style` (string / object).
#' @param shortcuts An object array to set shortcut options. Element Plus's
#'   `shortcuts` (`Array<{ text: string, value: Date | Function }>`). Give it as
#'   [JS()].
#' @param show_confirm Whether to show the confirm button. Element Plus's
#'   `show-confirm` (boolean).
#' @param show_footer Whether to show footer where the date picker is one
#'   `'dates' | 'months' | 'years' | 'quarters'`. Element Plus's
#'   `show-footer` (boolean).
#' @param show_now Whether to show the now button. Element Plus's `show-now`
#'   (boolean).
#' @param show_week_number Show the week number besides the week. Element
#'   Plus's `show-week-number` (boolean).
#' @param single_panel Show only one panel in range-picker. Element Plus's
#'   `single-panel` (boolean).
#' @param teleported Whether date-picker dropdown is teleported to the body.
#'   Element Plus's `teleported` (boolean).
#' @param time_format Optional, format of the time displayed in input's inner
#'   panel. Element Plus's `time-format` (string).
#' @param value_on_clear Clear return value, see config-provider. Element
#'   Plus's `value-on-clear` (string / number / boolean / Function). Give it
#'   as [JS()].
#' @param session In `el_date_picker()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_date_picker()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param name Native `name` attribute.
#' @param prefix_icon Icon class shown at the start of the input.
#' @param clear_icon Icon class of the clear button.
#' @param popper_class Extra class name for the picker panel.
#' @param default_value Date the panel opens on when nothing is selected.
#' @param default_time Time part used when a date is picked, as `"HH:mm:ss"`.
#' @param unlink_panels Whether the two panels of a range picker move independently.
#' @param validate_event Whether a change triggers form validation. Default `TRUE`.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `focus()` -- Focus the Input component
#'
#' @return An `htmltools` tagList with a Vue-managed date picker component.
#'
#' @section Shiny inputs:
#' `input$<id>` -- for `type` `"date"`, `"dates"` and `"daterange"` with the
#' default `value_format`, a `Date` (two for a range, several for `"dates"`),
#' as [shiny::dateInput()] gives one; `NULL` while empty. Any other type or
#' `value_format` reports the text the picker produces, in that format -- you
#' asked for that format, so it is not converted.
#'
#' @examples
#' # Basic date picker
#' el_date_picker("dp1")
#'
#' # Pre-filled with today's date
#' el_date_picker("dp2", value = Sys.Date())
#'
#' # Date range picker
#' el_date_picker(
#'   "dp3",
#'   type = "daterange",
#'   start_placeholder = "Start date",
#'   end_placeholder = "End date"
#' )
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_date_picker("dp1", placeholder = "Pick a date"),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$dp1)
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_date_picker <- function(
  id = NULL,
  value = NULL,
  type = "date",
  value_format = NULL,
  format = NULL,
  placeholder = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  clearable = TRUE,
  disabled = FALSE,
  editable = TRUE,
  readonly = FALSE,
  range_separator = "-",
  size = NULL,
  name = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  popper_class = NULL,
  default_value = NULL,
  default_time = NULL,
  unlink_panels = NULL,
  validate_event = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  slots = NULL,
  arrow_control = NULL,
  automatic_dropdown = NULL,
  cell_class_name = NULL,
  date_format = NULL,
  disabled_date = NULL,
  disabled_hours = NULL,
  disabled_minutes = NULL,
  disabled_seconds = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  shortcuts = NULL,
  show_confirm = NULL,
  show_footer = NULL,
  show_now = NULL,
  show_week_number = NULL,
  single_panel = NULL,
  teleported = NULL,
  time_format = NULL,
  value_on_clear = NULL,
  session = NULL
) {
  .el_check_choices("el_date_picker", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_date_picker")
  }
  ns_id <- .el_ui_id(id, session)

  # Determine if this is a range-type picker
  is_range_type <- grepl("range", type)

  # Process initial value
  init_value <- if (is.null(value)) {
    if (is_range_type) list() else ""
  } else if (inherits(value, "Date")) {
    base::format(value, "%Y-%m-%d")
  } else if (is.character(value) && length(value) == 2) {
    as.list(value)
  } else {
    value
  }

  # Element UI's date tokens, as day.js spells them
  # Element emits a Date without a value format; Shiny is given a string
  value_format <- .el_dayjs_format(value_format) %||%
    if (grepl("^datetime", type)) "YYYY-MM-DD HH:mm:ss" else "YYYY-MM-DD"
  format <- .el_dayjs_format(format)

  # Vue binding attributes
  picker_attrs <- list(
    "v-model" = "value",
    ":type" = "type",
    ":value-format" = "valueFormat",
    ":format" = .el_optional_bind("displayFormat"),
    ":clearable" = "clearable",
    ":disabled" = "disabled",
    ":editable" = "editable",
    ":readonly" = "readonly",
    ":range-separator" = "rangeSeparator",
    "@change" = "handleChange"
  )
  picker_attrs[[":placeholder"]] <- .el_optional_bind("placeholder")
  picker_attrs[[":start-placeholder"]] <- .el_optional_bind("startPlaceholder")
  picker_attrs[[":end-placeholder"]] <- .el_optional_bind("endPlaceholder")
  picker_attrs[[":size"]] <- .el_optional_bind("size")
  picker_attrs[[":name"]] <- .el_optional_bind("name")
  picker_attrs[[":prefix-icon"]] <- .el_optional_bind("prefixIcon")
  picker_attrs[[":clear-icon"]] <- .el_optional_bind("clearIcon")
  picker_attrs[[":popper-class"]] <- .el_optional_bind("popperClass")
  # Dates in Element Plus, text from R: $elDate (el-events.js) converts
  picker_attrs[[":default-value"]] <- "$elDate(defaultValue)"
  picker_attrs[[":default-time"]] <- "$elDate(defaultTime)"
  picker_attrs[[":unlink-panels"]] <- .el_optional_bind("unlinkPanels")
  picker_attrs[[":validate-event"]] <- .el_optional_bind("validateEvent")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(
    ns_id,
    c(
      "blur",
      "focus",
      "calendar-change",
      "clear",
      "panel-change",
      "visible-change"
    )
  )
  picker_attrs <- c(picker_attrs, events$attrs)
  # Vue data
  vue_data <- list(
    value = init_value,
    type = type,
    valueFormat = value_format,
    displayFormat = .el_or_na(format),
    clearable = clearable,
    disabled = disabled,
    editable = editable,
    readonly = readonly,
    rangeSeparator = range_separator
  )
  vue_data$placeholder <- if (is.null(placeholder)) NA else placeholder
  vue_data$startPlaceholder <- .el_or_na(start_placeholder)
  vue_data$endPlaceholder <- .el_or_na(end_placeholder)
  vue_data$size <- .el_or_na(size)
  vue_data$name <- .el_or_na(name)
  vue_data$prefixIcon <- .el_or_na(prefix_icon)
  vue_data$clearIcon <- .el_or_na(clear_icon)
  vue_data$popperClass <- .el_or_na(popper_class)
  vue_data$defaultValue <- .el_or_na(default_value)
  vue_data$defaultTime <- .el_or_na(default_time)
  vue_data$unlinkPanels <- .el_or_na(unlink_panels)
  vue_data$validateEvent <- .el_or_na(validate_event)
  el_widget(
    props = .el_props(list(
      arrow_control = arrow_control,
      automatic_dropdown = automatic_dropdown,
      cell_class_name = cell_class_name,
      date_format = date_format,
      disabled_date = disabled_date,
      disabled_hours = disabled_hours,
      disabled_minutes = disabled_minutes,
      disabled_seconds = disabled_seconds,
      empty_values = empty_values,
      fallback_placements = fallback_placements,
      placement = placement,
      popper_options = popper_options,
      popper_style = popper_style,
      shortcuts = shortcuts,
      show_confirm = show_confirm,
      show_footer = show_footer,
      show_now = show_now,
      show_week_number = show_week_number,
      single_panel = single_panel,
      teleported = teleported,
      time_format = time_format,
      value_on_clear = value_on_clear
    )),
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tag("el-date-picker", picker_attrs),
    data = vue_data,
    # The value is the binding's: reported on load and on every change, and
    # converted on the way in. A change handler sending it too would send it
    # unconverted, overwriting the Date.
    methods = c(
      events$methods,
      list(
        handleChange = JS("function() {}")
      )
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    type = if (
      type %in%
        c("date", "dates", "daterange") &&
        identical(value_format, "YYYY-MM-DD")
    ) {
      "shiny.element.date"
    },
    width = width,
    slots = slots
  )
}


#' @rdname el_date_picker
#' @section Updating from the server:
#' Server-side update for [el_date_picker()]. Supports updating value, disabled
#' state, type, clearable, readonly, and placeholder text.
#'
#' Every other argument of [el_date_picker()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_date_picker()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_date_picker(session, "when", value = "2026-06-01")
#'   })
#' }
#' @export
update_el_date_picker <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  type = NULL,
  clearable = NULL,
  readonly = NULL,
  placeholder = NULL,
  label = NULL,
  error = NULL,
  value_format = NULL,
  format = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  editable = NULL,
  range_separator = NULL,
  size = NULL,
  name = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  popper_class = NULL,
  unlink_panels = NULL,
  validate_event = NULL,
  arrow_control = NULL,
  automatic_dropdown = NULL,
  cell_class_name = NULL,
  date_format = NULL,
  disabled_date = NULL,
  disabled_hours = NULL,
  disabled_minutes = NULL,
  disabled_seconds = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  shortcuts = NULL,
  show_confirm = NULL,
  show_footer = NULL,
  show_now = NULL,
  show_week_number = NULL,
  single_panel = NULL,
  teleported = NULL,
  time_format = NULL,
  value_on_clear = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  if (!is.null(type)) {
    msg$type <- type
  }
  if (!is.null(format)) {
    msg$displayFormat <- .el_dayjs_format(format)
  }
  if (!is.null(clearable)) {
    msg$clearable <- clearable
  }
  if (!is.null(readonly)) {
    msg$readonly <- readonly
  }
  if (!is.null(placeholder)) {
    msg$placeholder <- placeholder
  }
  msg <- .el_form_item_update(msg, label, error)
  msg <- c(
    msg,
    .el_update_props(
      "el_date_picker",
      Filter(
        Negate(is.null),
        list(
          value_format = value_format,
          start_placeholder = start_placeholder,
          end_placeholder = end_placeholder,
          editable = editable,
          range_separator = range_separator,
          size = size,
          name = name,
          prefix_icon = prefix_icon,
          clear_icon = clear_icon,
          popper_class = popper_class,
          unlink_panels = unlink_panels,
          validate_event = validate_event,
          arrow_control = arrow_control,
          automatic_dropdown = automatic_dropdown,
          cell_class_name = cell_class_name,
          date_format = date_format,
          disabled_date = disabled_date,
          disabled_hours = disabled_hours,
          disabled_minutes = disabled_minutes,
          disabled_seconds = disabled_seconds,
          empty_values = empty_values,
          fallback_placements = fallback_placements,
          placement = placement,
          popper_options = popper_options,
          popper_style = popper_style,
          shortcuts = shortcuts,
          show_confirm = show_confirm,
          show_footer = show_footer,
          show_now = show_now,
          show_week_number = show_week_number,
          single_panel = single_panel,
          teleported = teleported,
          time_format = time_format,
          value_on_clear = value_on_clear
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
