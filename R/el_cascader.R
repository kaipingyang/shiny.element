#' Element Plus Cascader
#'
#' Pick a path through nested options -- a region, then a country, then a
#' city -- from a dropdown of side-by-side columns.
#'
#' @param id Cascader ID (auto-generated if NULL)
#' @param options Nested options, each `list(value =, label =, children =)`.
#'   [df_to_cascader_options()] builds them from a data.frame.
#' @param value Initially selected path, as a vector of values from the top
#'   level down -- or a list of paths with `props = list(multiple = TRUE)`.
#' @param placeholder Placeholder text
#' @param props Element's `props`, as a named list: `multiple`,
#'   `checkStrictly`, `expandTrigger` (`"click"` or `"hover"`), `lazy`,
#'   `lazyLoad`, and the field names `value`, `label`, `children`,
#'   `disabled`, `leaf`. With `lazy = TRUE` and no `lazyLoad` of your own,
#'   the server loads each column: see "Shiny inputs".
#' @param clearable Whether clearable
#' @param filterable Whether filterable (searchable)
#' @param disabled Whether disabled
#' @param size Size of cascader: `"large"`, `"default"` or `"small"`.
#' @param show_all_levels Whether to show all levels in input
#' @param collapse_tags Whether to collapse tags in multiple mode
#' @param separator Separator for display
#' @param debounce Debounce delay for filter
#' @param clear_icon Custom clear icon component. Element Plus's `clear-icon`
#'   (string / Component). An icon's name, such as `"Search"`.
#' @param collapse_tags_tooltip Whether show all selected tags when mouse
#'   hover text of collapse-tags. To use this, `collapse-tags` must be true.
#'   Element Plus's `collapse-tags-tooltip` (boolean).
#' @param effect Tooltip theme, built-in theme: `dark` / `light`. Element
#'   Plus's `effect` ('dark' | 'light' / string).
#' @param empty_values Empty values of component, see config-provider. Element
#'   Plus's `empty-values` (array).
#' @param fallback_placements List of possible positions for Tooltip
#'   popper.js. Element Plus's `fallback-placements` (`Placement[]`).
#' @param fit_input_width Whether the width of the suggestion panel is the
#'   same as the input, if the value is `number`, then the width is fixed.
#'   Element Plus's `fit-input-width` (boolean / number).
#' @param height Menu height for virtual scrolling (px). Element Plus's
#'   `height` (number).
#' @param item_size Node height for virtual scrolling (px). Element Plus's
#'   `item-size` (number).
#' @param max_collapse_tags The max tags number to be shown. To use this,
#'   `collapse-tags` must be true. Element Plus's `max-collapse-tags`
#'   (number).
#' @param max_collapse_tags_tooltip_height Max height of collapse-tags
#'   tooltip. Element Plus's `max-collapse-tags-tooltip-height` (string /
#'   number).
#' @param persistent When dropdown is inactive and `persistent` is `false`,
#'   dropdown will be destroyed. Element Plus's `persistent` (boolean).
#' @param placement Position of dropdown. Element Plus's `placement` (enum).
#' @param popper_append_to_body Whether to append the popper menu to body. If
#'   the positioning of the popper is wrong, you can try to set this prop to
#'   false. Element Plus's `popper-append-to-body` (boolean).
#' @param popper_style Custom style for Cascader's dropdown and tags' tooltip.
#'   Element Plus's `popper-style` (string / object).
#' @param show_checked_strategy Strategy for displaying checked nodes in
#'   multiple selection mode. Use `parent` when you want things tidy. Use
#'   `child` when every single item matters. Element Plus's
#'   `show-checked-strategy` ('parent' | 'child').
#' @param tag_effect Tag effect. Element Plus's `tag-effect` ('light' | 'dark'
#'   | 'plain').
#' @param tag_type Tag type. Element Plus's `tag-type` ('success' | 'info' |
#'   'warning' | 'danger').
#' @param teleported Whether cascader popup is teleported. Element Plus's
#'   `teleported` (boolean).
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param value_on_clear Clear return value, see config-provider. Element
#'   Plus's `value-on-clear` (string / number / boolean / Function, or `null`,
#'   which its documentation names): a value as it is, a function as [JS()],
#'   `null` as `JS("null")`. `NULL` leaves Element's default.
#' @param virtual_scroll Whether to enable virtual scrolling for large data.
#'   Element Plus's `virtual-scroll` (boolean).
#' @param session In `el_cascader()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_cascader()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param popper_class Extra class name for the dropdown panel.
#' @param filter_method `JS()` function filtering the options as the user types.
#' @param before_filter `JS()` function called before filtering; returning `false` cancels it.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#' @param level_inputs Each level of the path as an input of its own, beside
#'   `input$<id>`: input ids, one per level from the top, such as
#'   `c("compound", "study", "analysis")` for `input$compound`,
#'   `input$study` and `input$analysis`. `NULL`, the default, reports the
#'   path alone. See "Shiny inputs".
#' @template events
#' @template on
#' @section Shiny inputs:
#' `r .el_events_md("el_cascader")`
#'
#' With `level_inputs`, each level of the path is an input too, named as
#' given -- not prefixed with the cascader's id, as the levels are the
#' cascader's value in parts rather than something it does. Each holds
#' that level's value, `NULL` where the path stops short (nothing
#' selected, or `checkStrictly`), and follows the path wherever it
#' changes: on load, when the user picks, when `update_el_cascader()` sets
#' it. Like any input, it notifies its observers only when its value
#' changes, so an observer of `input$compound` does not run again when
#' only the study changes. The ids are the page's: in a module, give them
#' through `ns()`, `level_inputs = ns(c("compound", "study"))`, as the
#' cascader's own id. It needs the value to be one path, so not with
#' `props = list(multiple = TRUE)` or `emitPath = FALSE`.
#'
#' `input$<id>_lazy_load` carries `level` (0 for the first column), `value`
#' and `path` of the option opened, and `request`. Answer with
#' [el_load_children()], passing the input back; each child is `list(value
#' =, label =, leaf = TRUE)` for one with nothing below.
#'
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `getCheckedNodes()` -- Get an array of currently selected node
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' # Basic cascader usage
#' cascader_options <- list(
#'   list(
#'     value = "guide",
#'     label = "Guide",
#'     children = list(
#'       list(value = "principle", label = "Principle"),
#'       list(value = "navigation", label = "Navigation")
#'     )
#'   ),
#'   list(
#'     value = "component",
#'     label = "Component",
#'     children = list(
#'       list(value = "basic", label = "Basic"),
#'       list(value = "form", label = "Form", disabled = TRUE)
#'     )
#'   )
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_cascader(
#'       id = "cascader1",
#'       options = cascader_options,
#'       placeholder = "Please select",
#'       clearable = TRUE
#'     ),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$cascader1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' # Advanced: custom props and update
#' custom_props <- list(
#'   expandTrigger = "hover",
#'   multiple = FALSE,
#'   checkStrictly = FALSE,
#'   emitPath = TRUE,
#'   lazy = FALSE,
#'   value = "value",
#'   label = "label",
#'   children = "children"
#' )
#'
#' # Update cascader options in server:
#' # update_el_cascader(session, "cascader1", options = new_options)
el_cascader <- function(
  id = NULL,
  options = list(),
  value = NULL,
  placeholder = "Please select",
  props = NULL,
  clearable = FALSE,
  filterable = FALSE,
  disabled = FALSE,
  size = NULL,
  show_all_levels = TRUE,
  collapse_tags = FALSE,
  separator = " / ",
  debounce = 300,
  popper_class = NULL,
  filter_method = NULL,
  before_filter = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  height = NULL,
  item_size = NULL,
  max_collapse_tags = NULL,
  max_collapse_tags_tooltip_height = NULL,
  persistent = NULL,
  placement = NULL,
  popper_append_to_body = NULL,
  popper_style = NULL,
  show_checked_strategy = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  virtual_scroll = NULL,
  width = NULL,
  slots = NULL,
  level_inputs = NULL,
  events = NULL,
  on = NULL,
  session = NULL
) {
  .el_check_choices("el_cascader", environment())
  # R reads these to draw the component
  .vue_unbound(level_inputs = level_inputs)
  if (is.null(id)) {
    id <- .vue_auto_id("el_cascader")
  }
  ns_id <- .vue_ui_id(id, session)

  cascader_attrs <- list(
    ":options" = "options",
    "v-model" = "value",
    ":placeholder" = "placeholder",
    ":clearable" = "clearable",
    ":filterable" = "filterable",
    ":disabled" = "disabled",
    ":show-all-levels" = "showAllLevels",
    ":collapse-tags" = "collapseTags",
    ":separator" = "separator",
    ":debounce" = "debounce",
    "@change" = "handleChange"
  )
  # props carries lazyLoad; without one of the user's, the server loads
  cascader_attrs[[":props"]] <- "elProps"

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(
    ns_id,
    "el_cascader",
    events,
    on = on
  )
  cascader_attrs <- c(cascader_attrs, events$attrs)
  levels <- .el_cascader_levels(level_inputs, props)

  vue_data <- list(
    options = options,
    # always an array, a path of one level too: "c1" alone would arrive as a
    # string
    value = .vue_array(value),
    placeholder = placeholder,
    clearable = clearable,
    filterable = filterable,
    disabled = disabled,
    showAllLevels = show_all_levels,
    collapseTags = collapse_tags,
    separator = separator,
    debounce = debounce
  )
  vue_data$props <- .vue_or_na(props)
  el_widget(
    props = .el_props(list(
      size = size,
      popper_class = popper_class,
      filter_method = filter_method,
      before_filter = before_filter,
      clear_icon = .el_icon_name(clear_icon),
      collapse_tags_tooltip = collapse_tags_tooltip,
      effect = effect,
      empty_values = empty_values,
      fallback_placements = fallback_placements,
      fit_input_width = fit_input_width,
      height = height,
      item_size = item_size,
      max_collapse_tags = max_collapse_tags,
      max_collapse_tags_tooltip_height = max_collapse_tags_tooltip_height,
      persistent = persistent,
      placement = placement,
      popper_append_to_body = popper_append_to_body,
      popper_style = popper_style,
      show_checked_strategy = show_checked_strategy,
      tag_effect = tag_effect,
      tag_type = tag_type,
      teleported = teleported,
      validate_event = validate_event,
      value_on_clear = value_on_clear,
      virtual_scroll = virtual_scroll
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
    markup = tag("el-cascader", cascader_attrs),
    data = vue_data,
    methods = c(
      events$methods,
      list(
        handleChange = JS(sprintf(
          "function(value) {\n  window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value);\n}",
          ns_id
        ))
      )
    ),
    mounted = .vue_mounted_report(stats::setNames("value", ns_id)),
    watch = levels,
    computed = list(elProps = .el_lazy_props(ns_id)),
    width = width,
    slots = slots
  )
}

#' Each level of a cascader's path as an input of its own
#'
#' A watcher of the value, run at once: it sets each level's input on
#' load -- once Shiny is connected -- and whenever the value changes,
#' whoever changes it. A Vue event would miss the value given at first and
#' the one `update_el_cascader()` sets, which Element emits nothing for.
#'
#' @param level_inputs Input ids, one per level, or `NULL`.
#' @param props The cascader's `props`.
#' @return A `watch` list for [el_widget()], or `NULL`.
#' @keywords internal
.el_cascader_levels <- function(level_inputs, props) {
  if (is.null(level_inputs)) {
    return(NULL)
  }
  if (
    !is.character(level_inputs) ||
      !length(level_inputs) ||
      anyNA(level_inputs) ||
      !all(nzchar(level_inputs)) ||
      anyDuplicated(level_inputs)
  ) {
    stop(
      "`level_inputs` must be input ids, one per level and each once: ",
      "c(\"compound\", \"study\").",
      call. = FALSE
    )
  }
  one_path <- !isTRUE(props$multiple) &&
    !identical(props$emitPath, FALSE) &&
    !identical(props$emit_path, FALSE)
  if (!one_path) {
    stop(
      "`level_inputs` needs the value to be one path: not with ",
      "`props = list(multiple = TRUE)` or `emitPath = FALSE`.",
      call. = FALSE
    )
  }
  list(
    value = list(
      immediate = TRUE,
      deep = TRUE,
      handler = JS(sprintf(
        paste0(
          "function(path) { if (!window.Shiny || !Shiny.setInputValue) return; ",
          "var names = %s; ",
          "var send = function() { var v = Array.isArray(path) ? path : ",
          "(path === null || path === undefined || path === '' ? [] : [path]); ",
          "names.forEach(function(name, i) { ",
          "Shiny.setInputValue(name, v[i] === undefined ? null : v[i]); }); }; ",
          "if (Shiny.shinyapp && Shiny.shinyapp.isConnected && Shiny.shinyapp.isConnected()) send(); ",
          "else if (window.jQuery) jQuery(document).one('shiny:connected', send); }"
        ),
        jsonlite::toJSON(unname(level_inputs))
      ))
    )
  )
}

#' @rdname el_cascader
#' @section Updating from the server:
#' `update_el_cascader()` changes the component from the server.
#'
#' Every other argument of [el_cascader()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_cascader()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_cascader(session, "region", value = list("zj", "hz"))
#'   })
#' }
#' @export
update_el_cascader <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  options = NULL,
  value = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  props = NULL,
  size = NULL,
  show_all_levels = NULL,
  collapse_tags = NULL,
  separator = NULL,
  debounce = NULL,
  popper_class = NULL,
  filter_method = NULL,
  before_filter = NULL,
  clear_icon = NULL,
  collapse_tags_tooltip = NULL,
  effect = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  fit_input_width = NULL,
  height = NULL,
  item_size = NULL,
  max_collapse_tags = NULL,
  max_collapse_tags_tooltip_height = NULL,
  persistent = NULL,
  placement = NULL,
  popper_append_to_body = NULL,
  popper_style = NULL,
  show_checked_strategy = NULL,
  tag_effect = NULL,
  tag_type = NULL,
  teleported = NULL,
  validate_event = NULL,
  value_on_clear = NULL,
  virtual_scroll = NULL
) {
  .vue_check_session(session)
  ns_id <- session$ns(id)
  message <- list(id = ns_id)
  if (!is.null(options)) {
    message$options <- options
  }
  if (!is.null(value)) {
    message$value <- as.list(value)
  }
  if (!is.null(placeholder)) {
    message$placeholder <- placeholder
  }
  if (!is.null(clearable)) {
    message$clearable <- clearable
  }
  if (!is.null(filterable)) {
    message$filterable <- filterable
  }
  if (!is.null(disabled)) {
    message$disabled <- disabled
  }

  message <- .el_form_item_update(message, label, error)
  message <- c(
    message,
    .el_update_props(
      "el_cascader",
      Filter(
        Negate(is.null),
        list(
          props = props,
          size = size,
          show_all_levels = show_all_levels,
          collapse_tags = collapse_tags,
          separator = separator,
          debounce = debounce,
          popper_class = popper_class,
          filter_method = filter_method,
          before_filter = before_filter,
          clear_icon = clear_icon,
          collapse_tags_tooltip = collapse_tags_tooltip,
          effect = effect,
          empty_values = empty_values,
          fallback_placements = fallback_placements,
          fit_input_width = fit_input_width,
          height = height,
          item_size = item_size,
          max_collapse_tags = max_collapse_tags,
          max_collapse_tags_tooltip_height = max_collapse_tags_tooltip_height,
          persistent = persistent,
          placement = placement,
          popper_append_to_body = popper_append_to_body,
          popper_style = popper_style,
          show_checked_strategy = show_checked_strategy,
          tag_effect = tag_effect,
          tag_type = tag_type,
          teleported = teleported,
          validate_event = validate_event,
          value_on_clear = value_on_clear,
          virtual_scroll = virtual_scroll
        )
      )
    )
  )
  .vue_send_update(session, message)
  invisible(NULL)
}

#' Convert a data.frame with custom value/label columns to Element-UI Cascader options list
#'
#' @param df Data frame with hierarchical columns
#' @param value_cols Character vector of value column names (e.g. c("value1", "value2", ...))
#' @param label_cols Character vector of label column names (e.g. c("label1", "label2", ...)), can be NULL or contain NA for levels without label
#' @return Nested list for cascader options
#' @examples
#' df <- data.frame(
#'   province = c("Zhejiang", "Zhejiang", "Jiangsu"),
#'   city = c("Hangzhou", "Ningbo", "Nanjing"),
#'   stringsAsFactors = FALSE
#' )
#' df_to_cascader_options(df, c("province", "city"))
#'
#' # Separate value and label columns
#' df$province_label <- paste(df$province, "Province")
#' df_to_cascader_options(df, c("province", "city"), c("province_label", NA))
#' @export
df_to_cascader_options <- function(df, value_cols, label_cols = NULL) {
  n <- length(value_cols)
  build_level <- function(df, level) {
    if (level > n) {
      return(NULL)
    }
    split_df <- split(df, df[[value_cols[level]]])
    lapply(names(split_df), function(val) {
      item <- list(value = val)
      # label_cols may be NULL or NA at a level: the label falls back to the value
      if (!is.null(label_cols) && !is.na(label_cols[level])) {
        label_val <- split_df[[val]][[label_cols[level]]][1]
        item$label <- if (!is.na(label_val) && nzchar(label_val)) {
          label_val
        } else {
          val
        }
      } else {
        item$label <- val
      }
      if (level < n) {
        children <- build_level(split_df[[val]], level + 1)
        if (!is.null(children)) item$children <- children
      }
      item
    })
  }
  build_level(df, 1)
}
