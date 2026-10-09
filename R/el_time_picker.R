#' Element Plus Time Picker
#'
#' Pick a time of day. `el_time_picker()` takes any time, or a range of them
#' with `is_range = TRUE`; `el_time_select()` offers fixed times at a set
#' interval, such as every half hour between nine and six.
#'
#' @param id Picker ID. Auto-generated if `NULL`.
#' @param value Initial time, as `"HH:mm:ss"` text -- two of them for a
#'   range.
#' @param is_range Pick a start and an end rather than a single time.
#' @param value_format Format of the value reported to Shiny, in day.js's
#'   tokens. Default `"HH:mm:ss"`.
#' @param format Format of the time shown in the input, in day.js's tokens.
#' @param arrow_control Whether hours, minutes and seconds are changed with
#'   arrow buttons rather than by scrolling.
#' @param placeholder,start_placeholder,end_placeholder Placeholder text, the
#'   latter two for a range.
#' @param range_separator Text between the two times of a range. Default `"-"`.
#' @param clearable,disabled,editable,readonly As for an input.
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param popper_class,popper_style Extra class name and style for the panel.
#' @param popper_options,placement,fallback_placements Where the panel opens,
#'   as Element Plus's tooltip takes them.
#' @param default_value Time the panel opens on when nothing is picked.
#' @param disabled_hours,disabled_minutes,disabled_seconds [JS()] functions
#'   returning the hours, minutes or seconds that cannot be picked -- what
#'   Element UI's `selectableRange` did.
#' @param prefix_icon,clear_icon Icons, by name: `"Clock"`, `"CircleClose"`.
#' @param teleported Whether the panel is moved to `<body>`.
#' @param tabindex,aria_label Native attributes of the input.
#' @param empty_values,value_on_clear What counts as empty, and the value a
#'   cleared picker reports. See Element Plus's config provider.
#' @param save_on_blur Whether the time typed is kept when the input loses
#'   focus.
#' @param include_end_time,start,end,step,min_time,max_time For
#'   `el_time_select()`: the first and last time offered, the interval,
#'   whether `end` itself is offered, and the bounds of what can be picked.
#' @param effect `"light"` (default) or `"dark"` panel, for `el_time_select()`.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents.
#' @param session In `el_time_picker()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_time_picker()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @template events
#' @template on
#' @section Shiny inputs:
#' `r .el_events_md("el_time_picker")`
#'
#' `el_time_select()`:
#'
#' `r .el_events_md("el_time_select")`
#'
#' @section Element methods:
#' Callable with [call_el()]: `focus()`, `blur()`; and for `el_time_picker()`,
#' `handleOpen()` and `handleClose()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_time_picker("start", value = "09:30:00")
#'
#' # Only office hours
#' el_time_picker(
#'   "start",
#'   disabled_hours = JS(
#'     "function() {",
#'     "  var h = [];",
#'     "  for (var i = 0; i < 24; i++) if (i < 9 || i > 18) h.push(i);",
#'     "  return h;",
#'     "}"
#'   )
#' )
#'
#' # A range
#' el_time_picker("shift", is_range = TRUE, value = c("09:00:00", "17:30:00"))
#'
#' # Every half hour between nine and six
#' el_time_select("slot", start = "09:00", step = "00:30", end = "18:00")
#' @export
el_time_picker <- function(
  id = NULL,
  value = NULL,
  is_range = FALSE,
  value_format = "HH:mm:ss",
  arrow_control = NULL,
  placeholder = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  range_separator = NULL,
  clearable = NULL,
  disabled = NULL,
  editable = NULL,
  readonly = NULL,
  size = NULL,
  popper_class = NULL,
  default_value = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  format = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placement = NULL,
  fallback_placements = NULL,
  disabled_hours = NULL,
  disabled_minutes = NULL,
  disabled_seconds = NULL,
  teleported = NULL,
  tabindex = NULL,
  aria_label = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  save_on_blur = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
) {
  .el_check_choices("el_time_picker", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_time_picker")
  }
  ns_id <- .el_ui_id(id, session)
  init <- if (is.null(value)) {
    if (isTRUE(is_range)) list() else ""
  } else if (isTRUE(is_range)) {
    as.list(value)
  } else {
    value
  }
  .el_time_widget(
    "el-time-picker",
    ns_id,
    init,
    list(
      is_range = is_range,
      value_format = value_format,
      format = format,
      arrow_control = arrow_control,
      placeholder = placeholder,
      start_placeholder = start_placeholder,
      end_placeholder = end_placeholder,
      range_separator = range_separator,
      clearable = clearable,
      disabled = disabled,
      editable = editable,
      readonly = readonly,
      size = size,
      popper_class = popper_class,
      popper_style = popper_style,
      popper_options = popper_options,
      placement = placement,
      fallback_placements = fallback_placements,
      default_value = default_value,
      disabled_hours = disabled_hours,
      disabled_minutes = disabled_minutes,
      disabled_seconds = disabled_seconds,
      prefix_icon = .el_icon_name(prefix_icon),
      clear_icon = .el_icon_name(clear_icon),
      teleported = teleported,
      tabindex = tabindex,
      aria_label = aria_label,
      empty_values = empty_values,
      value_on_clear = value_on_clear,
      save_on_blur = save_on_blur
    ),
    "el_time_picker",
    events,
    on,
    width,
    slots,
    list(
      label = label,
      label_position = label_position,
      label_width = label_width,
      label_suffix = label_suffix,
      required = required,
      error = error,
      show_message = show_message,
      inline_message = inline_message
    )
  )
}


#' @rdname el_time_picker
#' @export
el_time_select <- function(
  id = NULL,
  value = NULL,
  placeholder = NULL,
  clearable = NULL,
  disabled = NULL,
  editable = NULL,
  size = NULL,
  popper_class = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  start = NULL,
  end = NULL,
  step = NULL,
  min_time = NULL,
  max_time = NULL,
  include_end_time = NULL,
  format = NULL,
  effect = NULL,
  popper_style = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
) {
  .el_check_choices("el_time_select", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_time_select")
  }
  ns_id <- .el_ui_id(id, session)
  .el_time_widget(
    "el-time-select",
    ns_id,
    if (is.null(value)) "" else value,
    list(
      start = start,
      end = end,
      step = step,
      min_time = min_time,
      max_time = max_time,
      include_end_time = include_end_time,
      format = format,
      placeholder = placeholder,
      clearable = clearable,
      disabled = disabled,
      editable = editable,
      size = size,
      effect = effect,
      popper_class = popper_class,
      popper_style = popper_style,
      prefix_icon = .el_icon_name(prefix_icon),
      clear_icon = .el_icon_name(clear_icon),
      empty_values = empty_values,
      value_on_clear = value_on_clear
    ),
    "el_time_select",
    events,
    on,
    width,
    slots,
    list(
      label = label,
      label_position = label_position,
      label_width = label_width,
      label_suffix = label_suffix,
      required = required,
      error = error,
      show_message = show_message,
      inline_message = inline_message
    )
  )
}


#' Build either time picker
#'
#' @param tag `"el-time-picker"` or `"el-time-select"`.
#' @param ns_id The namespaced id.
#' @param init The initial value.
#' @param fields The props, by their R names, for `.el_props()`.
#' @param fn The component's function, its entry in [el_events()].
#' @param events,on The user's `events` and `on`.
#' @param width,slots As for [el_widget()].
#' @param form_item The label and message arguments, for [el_widget()].
#' @return A Shiny UI element.
#' @keywords internal
.el_time_widget <- function(
  tag,
  ns_id,
  init,
  fields,
  fn,
  events,
  on,
  width,
  slots,
  form_item
) {
  forwarded <- .el_event_bindings(ns_id, fn, events, on = on)
  attrs <- c(
    list("v-model" = "value", "@change" = "handleChange"),
    forwarded$attrs
  )
  do.call(
    el_widget,
    c(
      form_item,
      list(
        id = ns_id,
        markup = htmltools::tag(tag, attrs),
        props = .el_props(fields),
        data = list(value = init),
        methods = c(
          forwarded$methods,
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
    )
  )
}


#' @rdname el_time_picker
#' @section Updating from the server:
#' Server-side update for [el_time_picker()] and [el_time_select()];
#' `update_el_time_select()` is the time select's, with its own arguments.
#'
#' Every other argument of [el_time_picker()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_time_picker()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$reset,
#'     update_el_time_picker(session, "start", value = "09:00:00")
#'   )
#' }
#' @export
update_el_time_picker <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  is_range = NULL,
  value_format = NULL,
  arrow_control = NULL,
  placeholder = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  range_separator = NULL,
  clearable = NULL,
  editable = NULL,
  readonly = NULL,
  size = NULL,
  popper_class = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  format = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placement = NULL,
  fallback_placements = NULL,
  disabled_hours = NULL,
  disabled_minutes = NULL,
  disabled_seconds = NULL,
  teleported = NULL,
  tabindex = NULL,
  aria_label = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  save_on_blur = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value)) {
    msg$value <- if (length(value) > 1) as.list(value) else value
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  msg <- .el_form_item_update(msg, label, error)
  msg <- c(
    msg,
    .el_update_props(
      "el_time_picker",
      Filter(
        Negate(is.null),
        list(
          is_range = is_range,
          value_format = value_format,
          arrow_control = arrow_control,
          placeholder = placeholder,
          start_placeholder = start_placeholder,
          end_placeholder = end_placeholder,
          range_separator = range_separator,
          clearable = clearable,
          editable = editable,
          readonly = readonly,
          size = size,
          popper_class = popper_class,
          prefix_icon = prefix_icon,
          clear_icon = clear_icon,
          format = format,
          popper_style = popper_style,
          popper_options = popper_options,
          placement = placement,
          fallback_placements = fallback_placements,
          disabled_hours = disabled_hours,
          disabled_minutes = disabled_minutes,
          disabled_seconds = disabled_seconds,
          teleported = teleported,
          tabindex = tabindex,
          aria_label = aria_label,
          empty_values = empty_values,
          value_on_clear = value_on_clear,
          save_on_blur = save_on_blur
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}


#' @rdname el_time_picker
#' @section Updating a time select:
#' `update_el_time_select()` changes the time select from the server: every
#' argument of [el_time_select()] that can change once it is drawn, under the
#' same name. One left `NULL` stays as it is; `NA` returns it to Element's
#' default.
#'
#' `update_el_time_select()` is called for its side effect and returns `NULL` invisibly.
#' @export
update_el_time_select <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  placeholder = NULL,
  clearable = NULL,
  editable = NULL,
  size = NULL,
  popper_class = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  start = NULL,
  end = NULL,
  step = NULL,
  min_time = NULL,
  max_time = NULL,
  include_end_time = NULL,
  format = NULL,
  effect = NULL,
  popper_style = NULL,
  empty_values = NULL,
  value_on_clear = NULL
) {
  .el_check_session(session)
  msg <- c(
    list(id = session$ns(id)),
    .el_update_props(
      "el_time_select",
      Filter(
        Negate(is.null),
        list(
          placeholder = placeholder,
          clearable = clearable,
          editable = editable,
          size = size,
          popper_class = popper_class,
          prefix_icon = prefix_icon,
          clear_icon = clear_icon,
          start = start,
          end = end,
          step = step,
          min_time = min_time,
          max_time = max_time,
          include_end_time = include_end_time,
          format = format,
          effect = effect,
          popper_style = popper_style,
          empty_values = empty_values,
          value_on_clear = value_on_clear
        )
      )
    )
  )
  if (length(msg) > 1L) {
    .el_send_update(session, msg)
  }
  update_el_time_picker(
    session,
    id,
    value = value,
    disabled = disabled,
    label = label,
    error = error
  )
}
