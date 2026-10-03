#' Element Plus Virtualized Select
#'
#' A select drawing only the options in view, for lists of thousands.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value Binding value: Element Plus's `model-value`, reported as
#'   `input$<id>`.
#' @param options The options: a named vector `c(Label = value)`, a vector,
#'   or a list of `list(value =, label =, disabled =)`, as Element Plus takes them.
#' @param multiple Is multiple. Element Plus's `multiple` (boolean).
#' @param disabled Is disabled. Element Plus's `disabled` (boolean).
#' @param value_key Unique identity key name for value, required when value is
#'   an object. Element Plus's `value-key` (string).
#' @param size Size of component. Element Plus's `size` ('' | 'large' |
#'   'default' | 'small').
#' @param clearable Whether select can be cleared. Element Plus's `clearable`
#'   (boolean).
#' @param clear_icon Custom clear icon. Element Plus's `clear-icon` (string /
#'   Component). An icon's name, such as `"Search"`.
#' @param collapse_tags Whether to collapse tags to a text when multiple
#'   selecting. Element Plus's `collapse-tags` (boolean).
#' @param multiple_limit Maximum number of options user can select when
#'   multiple is true. No limit when set to 0. Element Plus's `multiple-limit`
#'   (number).
#' @param effect Tooltip theme, built-in theme: `dark` / `light`. Element
#'   Plus's `effect` ('dark' | 'light' / string).
#' @param autocomplete Autocomplete of select input. Element Plus's
#'   `autocomplete` (string).
#' @param placeholder Placeholder. Element Plus's `placeholder` (string).
#' @param filterable Whether Select is filterable. Element Plus's `filterable`
#'   (boolean).
#' @param allow_create Whether creating new items is allowed. To use this,
#'   `filterable` must be true. Element Plus's `allow-create` (boolean).
#' @param filter_method Custom filter method, the first parameter is the
#'   current input value. To use this, `filterable` must be true method.
#'   Element Plus's `filter-method` ((query: string) => void). Give it as
#'   [JS()].
#' @param loading Whether Select is loading data from server. Element Plus's
#'   `loading` (boolean).
#' @param loading_text Displayed text while loading data from server, default
#'   is 'Loading'. Element Plus's `loading-text` (string).
#' @param reserve_keyword Whether reserve the keyword after select filtered
#'   option. Element Plus's `reserve-keyword` (boolean).
#' @param default_first_option Select first matching option on enter key. Use
#'   with `filterable` or `remote`. Element Plus's `default-first-option`
#'   (boolean).
#' @param no_match_text Displayed text when no data matches the filtering
#'   query, you can also use slot `empty`, default is 'No matching data'.
#'   Element Plus's `no-match-text` (string).
#' @param no_data_text Displayed text when there is no options, you can also
#'   use slot empty. Element Plus's `no-data-text` (string).
#' @param popper_class Custom class name for Select's dropdown and tags'
#'   tooltip. Element Plus's `popper-class` (string / object).
#' @param popper_style Custom style for Select's dropdown and tags' tooltip.
#'   Element Plus's `popper-style` (string / object).
#' @param teleported Whether select dropdown is teleported, if `true` it will
#'   be teleported to where `append-to` sets. Element Plus's `teleported`
#'   (boolean).
#' @param append_to Which element the select dropdown appends to. Element
#'   Plus's `append-to` (CSSSelector / HTMLElement).
#' @param persistent When select dropdown is inactive and `persistent` is
#'   `false`, select dropdown will be destroyed. Element Plus's `persistent`
#'   (boolean).
#' @param popper_options Popper.js parameters. Element Plus's `popper-options`
#'   (object).
#' @param automatic_dropdown For non-filterable Select, this prop decides if
#'   the option menu pops up when the input is focused. Element Plus's
#'   `automatic-dropdown` (boolean).
#' @param fit_input_width Whether the width of the dropdown is the same as the
#'   input, if the value is `number`, then the width is fixed. Element Plus's
#'   `fit-input-width` (boolean / number).
#' @param suffix_icon Custom suffix icon component. Element Plus's
#'   `suffix-icon` (string / Component). An icon's name, such as `"Search"`.
#' @param height The height of the dropdown panel, 34px for each item. Element
#'   Plus's `height` (number).
#' @param item_height The height of the dropdown item. Element Plus's
#'   `item-height` (number).
#' @param estimated_option_height Controls virtual-list sizing mode: if
#'   undefined, the list uses fixed item height from `item-height`; if
#'   provided, the list uses dynamic item sizing and this value as the
#'   estimated item height. Element Plus's `estimated-option-height` (number).
#' @param scrollbar_always_on Controls whether the scrollbar is always
#'   displayed. Element Plus's `scrollbar-always-on` (boolean).
#' @param remote Whether search data from server. Element Plus's `remote`
#'   (boolean).
#' @param debounce Debounce delay during remote search, in milliseconds.
#'   Element Plus's `debounce` (number).
#' @param remote_method Function that gets called when the input value
#'   changes. Its parameter is the current input value. To use this,
#'   `filterable` must be true. Element Plus's `remote-method` ((query:
#'   string) => void). Give it as [JS()].
#' @param remote_show_suffix In remote search method show suffix icon. Element
#'   Plus's `remote-show-suffix` (boolean).
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param offset Offset of the dropdown. Element Plus's `offset` (number).
#' @param show_arrow Whether the dropdown has an arrow. Element Plus's
#'   `show-arrow` (boolean).
#' @param placement Position of dropdown. Element Plus's `placement` (enum).
#' @param fallback_placements List of possible positions for dropdown
#'   popper.js. Element Plus's `fallback-placements` (`Placement[]`).
#' @param collapse_tags_tooltip Whether show all selected tags when mouse
#'   hover text of collapse-tags. To use this, `collapse-tags` must be true.
#'   Element Plus's `collapse-tags-tooltip` (boolean).
#' @param max_collapse_tags The max tags number to be shown. To use this,
#'   `collapse-tags` must be true. Element Plus's `max-collapse-tags`
#'   (number).
#' @param props Which field of an option holds what, when the options are
#'   records named otherwise: `list(value =, label =, disabled =, options =)`,
#'   Element Plus's `props`.
#' @param tag_tooltip Settings for the tooltip listing collapsed tags, with
#'   `collapse_tags` and `collapse_tags_tooltip`: a named list of tooltip
#'   attributes (`placement`, `effect`, ...). Element Plus's `tag-tooltip`.
#' @param tag_type Tag type. Element Plus's `tag-type` ('' | 'success' |
#'   'info' | 'warning' | 'danger').
#' @param tag_effect Tag effect. Element Plus's `tag-effect` ('' | 'light' |
#'   'dark' | 'plain').
#' @param aria_label Same as `aria-label` in native input. Element Plus's
#'   `aria-label` (string).
#' @param empty_values Empty values of component, see config-provider. Element
#'   Plus's `empty-values` (array).
#' @param value_on_clear Clear return value, see config-provider. Element
#'   Plus's `value-on-clear` (string / number / boolean / Function). Give it
#'   as [JS()].
#' @param popper_append_to_body Whether to append the popper menu to body. If
#'   the positioning of the popper is wrong, you can try to set this prop to
#'   false. Element Plus's `popper-append-to-body` (boolean).
#' @param tabindex Tabindex for input. Element Plus's `tabindex` (string /
#'   number).
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `header`, `footer`,
#'   `empty`, `prefix`, `tag`, `loading`, `label`. A scoped slot is written
#'   with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the value, on load and on every change.
#' - `input$<id>_change` -- Element Plus's `change` event.
#' - `input$<id>_visible_change` -- Element Plus's `visible-change` event.
#' - `input$<id>_remove_tag` -- Element Plus's `remove-tag` event.
#' - `input$<id>_clear` -- Element Plus's `clear` event.
#' - `input$<id>_blur` -- Element Plus's `blur` event.
#' - `input$<id>_focus` -- Element Plus's `focus` event.
#' - `input$<id>_end_reached` -- Element Plus's `end-reached` event.
#'
#' @section Element methods:
#' Callable with [el_call()]: `focus()`, `blur()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_select_v2("city", options = paste("City", 1:10000), filterable = TRUE)
#' @export
el_select_v2 <- function(
  id = NULL,
  value = NULL,
  options = NULL,
  multiple = NULL,
  disabled = NULL,
  value_key = NULL,
  size = NULL,
  clearable = NULL,
  clear_icon = NULL,
  collapse_tags = NULL,
  multiple_limit = NULL,
  effect = NULL,
  autocomplete = NULL,
  placeholder = NULL,
  filterable = NULL,
  allow_create = NULL,
  filter_method = NULL,
  loading = NULL,
  loading_text = NULL,
  reserve_keyword = NULL,
  default_first_option = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  popper_class = NULL,
  popper_style = NULL,
  teleported = NULL,
  append_to = NULL,
  persistent = NULL,
  popper_options = NULL,
  automatic_dropdown = NULL,
  fit_input_width = NULL,
  suffix_icon = NULL,
  height = NULL,
  item_height = NULL,
  estimated_option_height = NULL,
  scrollbar_always_on = NULL,
  remote = NULL,
  debounce = NULL,
  remote_method = NULL,
  remote_show_suffix = NULL,
  validate_event = NULL,
  offset = NULL,
  show_arrow = NULL,
  placement = NULL,
  fallback_placements = NULL,
  collapse_tags_tooltip = NULL,
  max_collapse_tags = NULL,
  tag_type = NULL,
  tag_effect = NULL,
  aria_label = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  popper_append_to_body = NULL,
  tabindex = NULL,
  props = NULL,
  tag_tooltip = NULL,
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
  .el_check_choices("el_select_v2", environment())
  # A named vector c(Label = value), as the choice components take, or
  # Element Plus's list(value =, label =)
  # Groups -- list(label =, options =) -- are passed as Element Plus takes them
  grouped <- is.list(options) &&
    any(vapply(options, function(o) is.list(o) && !is.null(o$options), TRUE))
  if (!is.null(options) && !grouped) {
    options <- .el_normalize_choices(options)
  }
  if (is.null(id)) {
    id <- paste0("el_select_v2_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    c("visible-change", "remove-tag", "clear", "blur", "focus", "end-reached")
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
    markup = htmltools::tag("el-select-v2", attrs),
    props = .el_props(list(
      # Element Plus iterates its options as soon as it mounts: none is an
      # empty list, as a remote search starts
      options = if (is.null(options)) list() else options,
      multiple = multiple,
      disabled = disabled,
      value_key = value_key,
      size = size,
      clearable = clearable,
      clear_icon = .el_icon_name(clear_icon),
      collapse_tags = collapse_tags,
      multiple_limit = multiple_limit,
      effect = effect,
      autocomplete = autocomplete,
      placeholder = placeholder,
      filterable = filterable,
      allow_create = allow_create,
      filter_method = filter_method,
      loading = loading,
      loading_text = loading_text,
      reserve_keyword = reserve_keyword,
      default_first_option = default_first_option,
      no_match_text = no_match_text,
      no_data_text = no_data_text,
      popper_class = popper_class,
      popper_style = popper_style,
      teleported = teleported,
      append_to = append_to,
      persistent = persistent,
      popper_options = popper_options,
      automatic_dropdown = automatic_dropdown,
      fit_input_width = fit_input_width,
      suffix_icon = .el_icon_name(suffix_icon),
      height = height,
      item_height = item_height,
      estimated_option_height = estimated_option_height,
      scrollbar_always_on = scrollbar_always_on,
      remote = remote,
      debounce = debounce,
      remote_method = remote_method,
      remote_show_suffix = remote_show_suffix,
      validate_event = validate_event,
      offset = offset,
      show_arrow = show_arrow,
      placement = placement,
      fallback_placements = fallback_placements,
      collapse_tags_tooltip = collapse_tags_tooltip,
      max_collapse_tags = max_collapse_tags,
      tag_type = tag_type,
      props = props,
      tag_tooltip = tag_tooltip,
      tag_effect = tag_effect,
      aria_label = aria_label,
      empty_values = empty_values,
      value_on_clear = value_on_clear,
      popper_append_to_body = popper_append_to_body,
      tabindex = tabindex
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


#' Update Element Plus Virtualized Select
#'
#' Server-side update for [el_select_v2()].
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
#'   observeEvent(input$reset, update_el_select_v2(session, "x", value = NULL))
#' }
#' @export
update_el_select_v2 <- function(
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
