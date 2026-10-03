#' Element Plus Virtualized Tree
#'
#' A tree drawing only the nodes in view, for tens of thousands of nodes.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param data Tree data. Element Plus's `data` (`Array<{[key: string]: any}>`).
#' @param empty_text Text displayed when data is void. Element Plus's
#'   `empty-text` (string).
#' @param highlight_current Whether current node is highlighted. Element
#'   Plus's `highlight-current` (boolean).
#' @param expand_on_click_node Whether to expand or collapse node when
#'   clicking on the node, if false, then expand or collapse node only when
#'   clicking on the arrow icon. Element Plus's `expand-on-click-node`
#'   (boolean).
#' @param check_on_click_node Whether to check or uncheck node when clicking
#'   on the node, if false, the node can only be checked or unchecked by
#'   clicking on the checkbox. Element Plus's `check-on-click-node` (boolean).
#' @param check_on_click_leaf Whether to check or uncheck node when clicking
#'   on leaf node (last children). Element Plus's `check-on-click-leaf`
#'   (boolean).
#' @param default_expanded_keys Array of keys of initially expanded nodes.
#'   Element Plus's `default-expanded-keys` (Array<string | number>).
#' @param show_checkbox Whether node is selectable. Element Plus's
#'   `show-checkbox` (boolean).
#' @param check_strictly Whether checked state of a node not affects its
#'   father and child nodes when `show-checkbox` is `true`. Element Plus's
#'   `check-strictly` (boolean).
#' @param default_checked_keys Array of keys of initially checked nodes.
#'   Element Plus's `default-checked-keys` (Array<string | number>).
#' @param current_node_key Key of initially selected node. Element Plus's
#'   `current-node-key` (string / number).
#' @param filter_method This function will be executed on each node when use
#'   filter method. if return `false`, tree node will be hidden. Element
#'   Plus's `filter-method` ((query: string, data: TreeNodeData, node:
#'   TreeNode) => boolean). Give it as [JS()].
#' @param indent Horizontal indentation of nodes in adjacent levels in pixels.
#'   Element Plus's `indent` (number).
#' @param icon Custom tree node icon component. Element Plus's `icon` (string
#'   / Component). An icon's name, such as `"Search"`.
#' @param item_size Custom tree node height. Element Plus's `item-size`
#'   (number).
#' @param scrollbar_always_on Always show scrollbar. Element Plus's
#'   `scrollbar-always-on` (boolean).
#' @param height Height of the tree. Element Plus's `height` (number).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `empty`. A scoped slot is
#'   written with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>_node_click` -- Element Plus's `node-click` event.
#' - `input$<id>_node_drop` -- Element Plus's `node-drop` event.
#' - `input$<id>_node_contextmenu` -- Element Plus's `node-contextmenu` event.
#' - `input$<id>_check_change` -- Element Plus's `check-change` event.
#' - `input$<id>_check` -- Element Plus's `check` event.
#' - `input$<id>_current_change` -- Element Plus's `current-change` event.
#' - `input$<id>_node_expand` -- Element Plus's `node-expand` event.
#' - `input$<id>_node_collapse` -- Element Plus's `node-collapse` event.
#'
#' @return A Shiny UI element.
#' @examples
#' el_tree_v2("big", data = lapply(1:1000, function(i) list(id = i, label = paste("Node", i))), height = 300)
#' @export
el_tree_v2 <- function(id = NULL,
                       data = NULL,
                       empty_text = NULL,
                       highlight_current = NULL,
                       expand_on_click_node = NULL,
                       check_on_click_node = NULL,
                       check_on_click_leaf = NULL,
                       default_expanded_keys = NULL,
                       show_checkbox = NULL,
                       check_strictly = NULL,
                       default_checked_keys = NULL,
                       current_node_key = NULL,
                       filter_method = NULL,
                       indent = NULL,
                       icon = NULL,
                       item_size = NULL,
                       scrollbar_always_on = NULL,
                       height = NULL,
                       width = NULL,
                       slots = NULL) {
  .el_check_choices("el_tree_v2", environment())
  if (is.null(id)) id <- paste0("el_tree_v2_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(ns_id, c("node-click", "node-drop", "node-contextmenu", "check-change", "check", "current-change", "node-expand", "node-collapse"))
  attrs <- c(list(), events$attrs)
  el_widget(
    id      = ns_id,
    markup  = htmltools::tag("el-tree-v2", attrs),
    props   = .el_props(list(
      data = data,
      empty_text = empty_text,
      highlight_current = highlight_current,
      expand_on_click_node = expand_on_click_node,
      check_on_click_node = check_on_click_node,
      check_on_click_leaf = check_on_click_leaf,
      default_expanded_keys = default_expanded_keys,
      show_checkbox = show_checkbox,
      check_strictly = check_strictly,
      default_checked_keys = default_checked_keys,
      current_node_key = current_node_key,
      filter_method = filter_method,
      indent = indent,
      icon = .el_icon_name(icon),
      item_size = item_size,
      scrollbar_always_on = scrollbar_always_on,
      height = height)),
    data    = list(),
    methods = events$methods,
    width   = width,
    slots   = slots
  )
}
