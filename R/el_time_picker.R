#' Element UI Time Picker
#'
#' Pick a time of day. `el_time_picker()` takes any time, or a range of them
#' with `is_range = TRUE`; `el_time_select()` offers fixed times at a set
#' interval, such as every half hour between nine and six.
#'
#' @param id Picker ID. Auto-generated if `NULL`.
#' @param value Initial time, as `"HH:mm:ss"` text -- two of them for a
#'   range.
#' @param is_range Pick a start and an end rather than a single time.
#' @param value_format Format of the value reported to Shiny. Default
#'   `"HH:mm:ss"`.
#' @param arrow_control Whether hours, minutes and seconds are changed with
#'   arrow buttons rather than by scrolling.
#' @param placeholder,start_placeholder,end_placeholder Placeholder text, the
#'   latter two for a range.
#' @param range_separator Text between the two times of a range. Default `"-"`.
#' @param picker_options Further options, as a named list -- for
#'   `el_time_picker()`, `selectableRange` and `format`; for
#'   `el_time_select()`, `start`, `end`, `step`, `minTime` and `maxTime`.
#' @param clearable,disabled,editable,readonly As for an input.
#' @param size `"medium"`, `"small"` or `"mini"`.
#' @param align Alignment of the panel: `"left"` (default), `"center"`,
#'   `"right"`.
#' @param popper_class Extra class name for the panel.
#' @param default_value Time the panel opens on when nothing is picked.
#' @param name Native `name` attribute.
#' @param prefix_icon,clear_icon Icon classes.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the time, or two for a range, on load and on change.
#' - `input$<id>_blur`, `input$<id>_focus` -- as the field loses and gains
#'   focus.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `focus()` -- focus the input
#'
#' @return A Shiny UI element.
#' @examples
#' el_time_picker("start", value = "09:30:00")
#'
#' # Only office hours
#' el_time_picker("start", picker_options = list(selectableRange = "09:00:00 - 18:00:00"))
#'
#' # A range
#' el_time_picker("shift", is_range = TRUE, value = c("09:00:00", "17:30:00"))
#'
#' # Every half hour between nine and six
#' el_time_select("slot", picker_options = list(start = "09:00", step = "00:30",
#'                                              end = "18:00"))
#' @export
el_time_picker <- function(id = NULL,
                           value = NULL,
                           is_range = FALSE,
                           value_format = "HH:mm:ss",
                           arrow_control = NULL,
                           placeholder = NULL,
                           start_placeholder = NULL,
                           end_placeholder = NULL,
                           range_separator = NULL,
                           picker_options = NULL,
                           clearable = NULL,
                           disabled = NULL,
                           editable = NULL,
                           readonly = NULL,
                           size = NULL,
                           align = NULL,
                           popper_class = NULL,
                           default_value = NULL,
                           name = NULL,
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
                           width = NULL,
                           slots = NULL,
                           session = NULL) {
  .el_check_choices("el_time_picker", environment())
  .el_time_widget("el-time-picker", id, value, is_range, value_format,
                  arrow_control, placeholder, start_placeholder, end_placeholder,
                  range_separator, picker_options, clearable, disabled, editable,
                  readonly, size, align, popper_class, default_value, name,
                  prefix_icon, clear_icon, width, slots, session,
                  label = label, label_position = label_position,
                  label_width = label_width, label_suffix = label_suffix,
                  required = required, error = error, show_message = show_message,
                  inline_message = inline_message)
}


#' @rdname el_time_picker
#' @export
el_time_select <- function(id = NULL,
                           value = NULL,
                           picker_options = NULL,
                           placeholder = NULL,
                           clearable = NULL,
                           disabled = NULL,
                           editable = NULL,
                           readonly = NULL,
                           size = NULL,
                           align = NULL,
                           popper_class = NULL,
                           default_value = NULL,
                           name = NULL,
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
                           width = NULL,
                           slots = NULL,
                           session = NULL) {
  .el_check_choices("el_time_select", environment())
  .el_time_widget("el-time-select", id, value, FALSE, NULL, NULL, placeholder,
                  NULL, NULL, NULL, picker_options, clearable, disabled, editable,
                  readonly, size, align, popper_class, default_value, name,
                  prefix_icon, clear_icon, width, slots, session,
                  label = label, label_position = label_position,
                  label_width = label_width, label_suffix = label_suffix,
                  required = required, error = error, show_message = show_message,
                  inline_message = inline_message)
}


#' Build either time picker
#'
#' @param tag `"el-time-picker"` or `"el-time-select"`.
#' @inheritParams el_time_picker
#' @return A Shiny UI element.
#' @keywords internal
.el_time_widget <- function(tag, id, value, is_range, value_format,
                            arrow_control, placeholder, start_placeholder,
                            end_placeholder, range_separator, picker_options,
                            clearable, disabled, editable, readonly, size, align,
                            popper_class, default_value, name, prefix_icon,
                            clear_icon, width, slots, session, label = NULL,
                            label_position = "top", label_width = NULL,
                            label_suffix = NULL, required = FALSE, error = NULL,
                            show_message = TRUE, inline_message = FALSE) {
  prefix <- gsub("-", "_", tag)
  if (is.null(id)) id <- paste0(prefix, "_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  init <- if (is.null(value)) {
    if (isTRUE(is_range)) list() else ""
  } else if (isTRUE(is_range)) {
    as.list(value)
  } else {
    value
  }

  fields <- list(
    isRange = is_range, valueFormat = value_format, arrowControl = arrow_control,
    placeholder = placeholder, startPlaceholder = start_placeholder,
    endPlaceholder = end_placeholder, rangeSeparator = range_separator,
    pickerOptions = picker_options, clearable = clearable, disabled = disabled,
    editable = editable, readonly = readonly, size = size, align = align,
    popperClass = popper_class, defaultValue = default_value, name = name,
    prefixIcon = prefix_icon, clearIcon = clear_icon
  )
  # el-time-select has no range, value format or arrows of its own
  if (tag == "el-time-select") {
    fields <- fields[setdiff(names(fields), c("isRange", "valueFormat", "arrowControl",
                                              "startPlaceholder", "endPlaceholder",
                                              "rangeSeparator"))]
  }

  attrs <- list("v-model" = "value", "@change" = "handleChange")
  for (f in names(fields)) {
    attrs[[paste0(":", .el_kebab_case(f))]] <- .el_optional_bind(f)
  }
  events <- .el_event_bindings(ns_id, c("blur", "focus"))
  attrs <- c(attrs, events$attrs)

  el_widget(
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = htmltools::tag(tag, attrs),
    data   = c(list(value = init), lapply(fields, .el_or_na)),
    methods = c(events$methods, list(
      handleChange = JS(sprintf(
        "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }", ns_id
      ))
    )),
    mounted    = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Time Picker
#'
#' Server-side update for [el_time_picker()] and [el_time_select()];
#' `update_el_time_select()` is the same function under the select's name.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Picker ID (un-namespaced).
#' @param value,disabled,picker_options New values; `NULL` leaves one
#'   unchanged.
#'
#' @param label New label, as for [shiny::updateTextInput()]: text, or
#'   tags or `HTML()` drawn as markup. Only a component built with a `label`
#'   has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$reset, update_el_time_picker(session, "start", value = "09:00:00"))
#' }
#' @export
update_el_time_picker <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL, disabled = NULL,
                                  picker_options = NULL,
                                  label = NULL, error = NULL) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value))          msg$value         <- if (length(value) > 1) as.list(value) else value
  if (!is.null(disabled))       msg$disabled      <- disabled
  if (!is.null(picker_options)) msg$pickerOptions <- picker_options
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}


#' @rdname update_el_time_picker
#' @export
update_el_time_select <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL,
                                  disabled = NULL, picker_options = NULL,
                                  label = NULL, error = NULL) {
  .el_check_session(session)
  update_el_time_picker(session, id, value = value, disabled = disabled,
                        picker_options = picker_options, label = label, error = error)
}


