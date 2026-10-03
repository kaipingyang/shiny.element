#' Element Plus Tree Select
#'
#' A select whose options are a tree: Element Plus's `el-tree-select`, which
#' takes the props of both [el_select()] and [el_tree()].
#'
#' @param id Component ID; the value is reported as `input$<id>`.
#' @param data The tree: a list of nodes, each `list(value =, label =,
#'   children = list(...))`.
#' @param value The selected value, or several with `multiple = TRUE`.
#' @param multiple Whether several nodes can be selected.
#' @param show_checkbox Whether nodes have checkboxes.
#' @param check_strictly Whether any node can be selected, not only leaves.
#' @param check_on_click_node Whether clicking a node checks it, with
#'   `show_checkbox`.
#' @param filterable Whether the options can be searched by typing.
#' @param clearable Whether the selection can be cleared.
#' @param placeholder Placeholder text.
#' @param node_key The field that identifies a node. Default `"value"`.
#' @param props Where the tree's fields are: `list(label =, children =,
#'   disabled =, isLeaf =)`.
#' @param default_expand_all Whether every node starts expanded.
#' @param render_after_expand Whether a node's children are drawn only once
#'   it is expanded. Default `TRUE`.
#' @param collapse_tags,collapse_tags_tooltip With `multiple`, whether the
#'   selection is shown as one tag and a count, with the rest in a tooltip.
#' @param size `"large"`, `"default"` or `"small"`.
#' @param disabled Whether it can be changed.
#' @param cache_data The nodes behind a value not yet loaded, for a lazy tree.
#' @param lazy Whether child nodes are loaded on demand -- from the server,
#'   which answers `input$<id>_load` with [el_load_children()], unless `load`
#'   is given.
#' @param load [JS()] function loading child nodes in the browser instead of
#'   from the server. Needs `lazy = TRUE`.
#' @param ... Any other prop of Element Plus's select or tree, in snake_case:
#'   `max_collapse_tags = 2`, `expand_on_click_node = FALSE`.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the selected value, or several, on load and on change.
#' - `input$<id>_load` -- with `lazy = TRUE`, a node asking for its
#'   children: `level`, `key` (its `node_key` field) and `data`. Answer with
#'   [el_load_children()].
#' - `input$<id>_visible_change`, `input$<id>_clear`, `input$<id>_remove_tag`,
#'   `input$<id>_node_click`, `input$<id>_check` -- Element Plus's events.
#'
#' @section Element methods:
#' Callable with [el_call()]: `focus()`, `blur()`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_tree_select(
#'   "dept",
#'   placeholder = "Department",
#'   data = list(
#'     list(
#'       value = "eng",
#'       label = "Engineering",
#'       children = list(
#'         list(value = "web", label = "Web"),
#'         list(value = "data", label = "Data")
#'       )
#'     ),
#'     list(value = "ops", label = "Operations")
#'   )
#' )
#' @export
el_tree_select <- function(
  id,
  data = list(),
  value = NULL,
  multiple = NULL,
  show_checkbox = NULL,
  check_strictly = NULL,
  check_on_click_node = NULL,
  filterable = NULL,
  clearable = NULL,
  placeholder = NULL,
  node_key = NULL,
  props = NULL,
  default_expand_all = NULL,
  render_after_expand = NULL,
  collapse_tags = NULL,
  collapse_tags_tooltip = NULL,
  size = NULL,
  disabled = NULL,
  cache_data = NULL,
  lazy = NULL,
  load = NULL,
  ...,
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
  .el_check_choices("el_tree_select", environment())
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    c("visible-change", "clear", "remove-tag", "node-click", "check")
  )
  value <- .el_restore(
    ns_id,
    if (is.null(value)) {
      if (isTRUE(multiple)) list() else NA
    } else if (isTRUE(multiple)) {
      as.list(value)
    } else {
      value
    }
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
    markup = htmltools::tag(
      "el-tree-select",
      c(
        list(
          "v-model" = "value",
          ":data" = "data",
          "@change" = "handleChange",
          # the server loads a lazy tree's nodes unless `load` is given
          ":load" = "load === null ? elLoad : load"
        ),
        events$attrs
      )
    ),
    props = .el_props(c(
      list(
        multiple = multiple,
        show_checkbox = show_checkbox,
        check_strictly = check_strictly,
        check_on_click_node = check_on_click_node,
        filterable = filterable,
        clearable = clearable,
        placeholder = placeholder,
        node_key = node_key,
        props = props,
        default_expand_all = default_expand_all,
        render_after_expand = render_after_expand,
        collapse_tags = collapse_tags,
        collapse_tags_tooltip = collapse_tags_tooltip,
        size = size,
        disabled = disabled,
        cache_data = cache_data,
        lazy = lazy
      ),
      list(...)
    )),
    data = list(value = value, data = data, load = .el_or_na(load)),
    methods = c(
      events$methods,
      list(
        elLoad = .el_lazy_load_method(ns_id, "tree"),
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


#' Update Element Plus Tree Select
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateSelectInput()].
#' @param id Component ID (un-namespaced).
#' @param value,data,disabled New values; `NULL` leaves one unchanged.
#' @param label New label, as for [shiny::updateTextInput()].
#' @param error An error message to show on the component; `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$reset,
#'     update_el_tree_select(session, "dept", value = "ops")
#'   )
#' }
#' @export
update_el_tree_select <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  data = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(data)) {
    msg$data <- data
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}
