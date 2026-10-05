#' Element Plus Input Tag
#'
#' A text input that turns each entry into a tag: keywords, e-mail addresses,
#'   labels.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value Binding value: Element Plus's `model-value`, reported as
#'   `input$<id>`.
#' @param max Max number tags that can be enter. Element Plus's `max`
#'   (number).
#' @param tag_type Tag type. Element Plus's `tag-type` ('' | 'success' |
#'   'info' | 'warning' | 'danger').
#' @param tag_effect Tag effect. Element Plus's `tag-effect` ('' | 'light' |
#'   'dark' | 'plain').
#' @param effect Tooltip theme, built-in theme: `dark` / `light`. Element
#'   Plus's `effect` ('dark' | 'light' / string).
#' @param trigger The key to trigger input tag. Element Plus's `trigger`
#'   ('Enter' | 'Space').
#' @param draggable Whether tags can be dragged. Element Plus's `draggable`
#'   (boolean).
#' @param delimiter Add a tag when a delimiter is matched. Element Plus's
#'   `delimiter` (string / regex).
#' @param size Input box size. Element Plus's `size` ('large' | 'default' |
#'   'small').
#' @param collapse_tags Whether to collapse tags to a text when multiple
#'   selecting. Element Plus's `collapse-tags` (boolean).
#' @param collapse_tags_tooltip Whether show all selected tags when mouse
#'   hover text of collapse-tags. To use this, collapse-tags must be true.
#'   Element Plus's `collapse-tags-tooltip` (boolean).
#' @param save_on_blur Whether to save the input value when the input loses
#'   focus. Element Plus's `save-on-blur` (boolean).
#' @param clearable Whether to show clear button. Element Plus's `clearable`
#'   (boolean).
#' @param clear_icon Custom clear icon component. Element Plus's `clear-icon`
#'   (string / Component). An icon's name, such as `"Search"`.
#' @param disabled Whether to disable input-tag. Element Plus's `disabled`
#'   (boolean).
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param readonly Same as `readonly` in native input. Element Plus's
#'   `readonly` (boolean).
#' @param autofocus Same as `autofocus` in native input. Element Plus's
#'   `autofocus` (boolean).
#' @param tabindex Same as `tabindex` in native input. Element Plus's
#'   `tabindex` (string / number).
#' @param max_collapse_tags The max tags number to be shown. To use this,
#'   collapse-tags must be true. Element Plus's `max-collapse-tags` (number).
#' @param maxlength Same as `maxlength` in native input. Element Plus's
#'   `maxlength` (string / number).
#' @param minlength Same as `minlength` in native input. Element Plus's
#'   `minlength` (string / number).
#' @param placeholder Placeholder of input. Element Plus's `placeholder`
#'   (string).
#' @param autocomplete Same as `autocomplete` in native input. Element Plus's
#'   `autocomplete` (string).
#' @param aria_label Native `aria-label` attribute. Element Plus's
#'   `aria-label` (string).
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `tag`, `prefix`,
#'   `suffix`. A scoped slot is written with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the value, on load and on every change.
#' - `input$<id>_change` -- Element Plus's `change` event.
#' - `input$<id>_input` -- Element Plus's `input` event.
#' - `input$<id>_add_tag` -- Element Plus's `add-tag` event.
#' - `input$<id>_remove_tag` -- Element Plus's `remove-tag` event.
#' - `input$<id>_drag_tag` -- Element Plus's `drag-tag` event.
#' - `input$<id>_focus` -- Element Plus's `focus` event.
#' - `input$<id>_blur` -- Element Plus's `blur` event.
#' - `input$<id>_clear` -- Element Plus's `clear` event.
#'
#' @section Element methods:
#' Callable with [call_el()]: `focus()`, `blur()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_input_tag(
#'   "keywords",
#'   value = c("shiny", "element"),
#'   placeholder = "Add a keyword"
#' )
#' @export
el_input_tag <- function(
  id = NULL,
  value = list(),
  max = NULL,
  tag_type = NULL,
  tag_effect = NULL,
  effect = NULL,
  trigger = NULL,
  draggable = NULL,
  delimiter = NULL,
  size = NULL,
  collapse_tags = NULL,
  collapse_tags_tooltip = NULL,
  save_on_blur = NULL,
  clearable = NULL,
  clear_icon = NULL,
  disabled = NULL,
  validate_event = NULL,
  readonly = NULL,
  autofocus = NULL,
  tabindex = NULL,
  max_collapse_tags = NULL,
  maxlength = NULL,
  minlength = NULL,
  placeholder = NULL,
  autocomplete = NULL,
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
  slots = NULL
) {
  .el_check_choices("el_input_tag", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_input_tag")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    c("input", "add-tag", "remove-tag", "drag-tag", "focus", "blur", "clear")
  )
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
    markup = htmltools::tag("el-input-tag", attrs),
    props = .el_props(list(
      max = max,
      tag_type = tag_type,
      tag_effect = tag_effect,
      effect = effect,
      trigger = trigger,
      draggable = draggable,
      delimiter = delimiter,
      size = size,
      collapse_tags = collapse_tags,
      collapse_tags_tooltip = collapse_tags_tooltip,
      save_on_blur = save_on_blur,
      clearable = clearable,
      clear_icon = .el_icon_name(clear_icon),
      disabled = disabled,
      validate_event = validate_event,
      readonly = readonly,
      autofocus = autofocus,
      tabindex = tabindex,
      max_collapse_tags = max_collapse_tags,
      maxlength = maxlength,
      minlength = minlength,
      placeholder = placeholder,
      autocomplete = autocomplete,
      aria_label = aria_label
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


#' @rdname el_input_tag
#' @section Updating from the server:
#' Server-side update for [el_input_tag()].
#'
#' Every other argument of [el_input_tag()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_input_tag()` is called for its side effect and returns `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$reset, update_el_input_tag(session, "x", value = NULL))
#' }
#' @export
update_el_input_tag <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  max = NULL,
  tag_type = NULL,
  tag_effect = NULL,
  effect = NULL,
  trigger = NULL,
  draggable = NULL,
  delimiter = NULL,
  size = NULL,
  collapse_tags = NULL,
  collapse_tags_tooltip = NULL,
  save_on_blur = NULL,
  clearable = NULL,
  clear_icon = NULL,
  validate_event = NULL,
  readonly = NULL,
  autofocus = NULL,
  tabindex = NULL,
  max_collapse_tags = NULL,
  maxlength = NULL,
  minlength = NULL,
  placeholder = NULL,
  autocomplete = NULL,
  aria_label = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value)) {
    msg$value <- as.list(value)
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  msg <- .el_form_item_update(msg, label, error)
  msg <- c(
    msg,
    .el_update_props(
      "el_input_tag",
      Filter(
        Negate(is.null),
        list(
          max = max,
          tag_type = tag_type,
          tag_effect = tag_effect,
          effect = effect,
          trigger = trigger,
          draggable = draggable,
          delimiter = delimiter,
          size = size,
          collapse_tags = collapse_tags,
          collapse_tags_tooltip = collapse_tags_tooltip,
          save_on_blur = save_on_blur,
          clearable = clearable,
          clear_icon = clear_icon,
          validate_event = validate_event,
          readonly = readonly,
          autofocus = autofocus,
          tabindex = tabindex,
          max_collapse_tags = max_collapse_tags,
          maxlength = maxlength,
          minlength = minlength,
          placeholder = placeholder,
          autocomplete = autocomplete,
          aria_label = aria_label
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
