#' Element Plus Tree
#'
#' A tree view, optionally with checkboxes.
#'
#' Unlike the menu, a tree takes its whole structure through a `data` prop
#' rather than nested tags, so the nesting is plain R data all the way down.
#'
#' @param id Tree ID (auto-generated if NULL).
#' @param data A list of nodes. Each is a list with the key and label fields
#'   named by `node_key` and `label_field`, and optionally `children`,
#'   `disabled` for an uncheckable node, or `isLeaf`.
#' @param node_key Field holding each node's unique key. The keys are what the
#'   server sees and what `expanded` and `checked` refer to.
#' @param label_field,children_field Fields holding a node's label and its
#'   children.
#' @param disabled_field Field marking a node disabled. Default `"disabled"`.
#' @param is_leaf_field Field marking a node as a leaf, so lazy loading knows
#'   not to ask it for children. Default `"isLeaf"`. Element replaces its
#'   whole field map at once, so all four are sent together.
#' @param show_checkbox Show a checkbox beside every node.
#' @param check_strictly Treat a parent's checkbox as independent of its
#'   children, rather than checking them together.
#' @param default_expand_all Expand every node initially.
#' @param expand_on_click_node Expand a node when its label is clicked, as
#'   well as its arrow. Set `FALSE` to make clicking select rather than
#'   expand.
#' @param accordion Keep only one node expanded per level.
#' @param highlight_current Highlight the clicked node.
#' @param expanded,checked Keys to expand and to check initially.
#' @param empty_text Text shown when `data` is empty.
#' @param check_on_click_leaf Whether to check or uncheck node when clicking
#'   on leaf node (last children). Element Plus's `check-on-click-leaf`
#'   (boolean).
#' @param icon Custom tree node icon component. Element Plus's `icon` (string
#'   / Component). An icon's name, such as `"Search"`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param indent Horizontal indent between levels, in pixels. Default `16`.
#' @param lazy Whether child nodes are loaded on demand -- from the server,
#'   unless `load` is given. See "Shiny inputs".
#' @param draggable Whether nodes can be dragged.
#' @param auto_expand_parent Whether expanding a node expands its parents. Default `TRUE`.
#' @param check_on_click_node Whether clicking a node's label also checks it.
#' @param current_node_key Key of the node that starts out highlighted.
#' @param render_after_expand Whether child nodes are rendered only once expanded. Default `TRUE`.
#' @param load `JS()` function loading child nodes in the
#'   browser instead of from the server. Needs `lazy = TRUE`.
#' @param filter_node_method `JS()` function deciding whether a
#'   node survives filtering. By default a node is kept when its label
#'   contains the text, ignoring case, so `el_call(session, id, "filter",
#'   list(text))` works as it stands.
#' @param render_content `JS()` render function for a node's content.
#' @param allow_drag `JS()` function deciding whether a node may be dragged.
#' @param allow_drop `JS()` function deciding whether a node may be dropped somewhere.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' `input$<id>` holds the key of the most recently clicked node, and
#' `input$<id>_checked` the keys of all checked nodes, as a character vector.
#' Both are reported on load, where they start empty and therefore arrive as
#' `NULL`, as Shiny reports any empty selection.
#'
#' With `lazy = TRUE` and no `load` of your own, the server loads each node's
#' children: `input$<id>_load` asks, with `level` (0 for the top), `key` (the
#' node's `node_key` field), `data` (the node) and `request`; answer with
#' [el_load_children()].
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `append()` -- Append a child node to a given node in the tree
#' - `filter()` -- Filter all tree nodes, filtered nodes will be hidden
#' - `getCheckedKeys()` -- If the node can be selected (show-checkbox is true), it returns the currently selected array of node's keys
#' - `getCheckedNodes()` -- If the node can be selected (show-checkbox is true), it returns the currently selected array of nodes
#' - `getCurrentKey()` -- Return the highlight node's key (null if no node is highlighted)
#' - `getCurrentNode()` -- Return the highlight node's data (null if no node is highlighted)
#' - `getHalfCheckedKeys()` -- If the node can be selected (show-checkbox is true), it returns the currently half selected array of...
#' - `getHalfCheckedNodes()` -- If the node can be selected (show-checkbox is true), it returns the currently half selected array of nodes
#' - `getNode()` -- Get node by data or key
#' - `insertAfter()` -- Insert a node after a given node in the tree
#' - `insertBefore()` -- Insert a node before a given node in the tree
#' - `remove()` -- Remove a node, only works when node-key is assigned
#' - `setChecked()` -- Set node to be checked or not, only works when node-key is assigned
#' - `setCheckedKeys()` -- Set certain nodes to be checked, only works when node-key is assigned
#' - `setCheckedNodes()` -- Set certain nodes to be checked, only works when node-key is assigned
#' - `setCurrentKey()` -- Set highlighted node by key, only works when node-key is assigned
#' - `setCurrentNode()` -- Set highlighted node, only works when node-key is assigned
#' - `updateKeyChildren()` -- Set new data to node, only works when node-key is assigned
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' nodes <- list(
#'   list(
#'     id = "fruit",
#'     label = "Fruit",
#'     children = list(
#'       list(id = "apple", label = "Apple"),
#'       list(id = "cherry", label = "Cherry")
#'     )
#'   ),
#'   list(
#'     id = "veg",
#'     label = "Vegetables",
#'     children = list(
#'       list(id = "leek", label = "Leek", disabled = TRUE)
#'     )
#'   )
#' )
#'
#' el_tree(id = "picker", data = nodes)
#'
#' # With checkboxes, two nodes checked and the first branch open
#' el_tree(
#'   id = "picker",
#'   data = nodes,
#'   show_checkbox = TRUE,
#'   checked = c("apple", "cherry"),
#'   expanded = "fruit"
#' )
el_tree <- function(
  id = NULL,
  data = list(),
  node_key = "id",
  label_field = "label",
  children_field = "children",
  disabled_field = "disabled",
  is_leaf_field = "isLeaf",
  show_checkbox = FALSE,
  check_strictly = FALSE,
  default_expand_all = FALSE,
  expand_on_click_node = TRUE,
  accordion = FALSE,
  highlight_current = FALSE,
  expanded = NULL,
  checked = NULL,
  empty_text = NULL,
  indent = NULL,
  lazy = NULL,
  draggable = NULL,
  auto_expand_parent = NULL,
  check_on_click_node = NULL,
  current_node_key = NULL,
  render_after_expand = NULL,
  load = NULL,
  filter_node_method = NULL,
  render_content = NULL,
  allow_drag = NULL,
  allow_drop = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  check_on_click_leaf = NULL,
  icon = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- paste0("el_tree_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  tree_attrs <- list(
    # Named so the handler can call setCheckedKeys(): assigning
    # default-checked-keys only adds to the selection, never clears it.
    ref = "tree",
    ":data" = "treeData",
    ":props" = "treeProps",
    ":node-key" = "nodeKey",
    ":show-checkbox" = "showCheckbox",
    ":check-strictly" = "checkStrictly",
    ":default-expand-all" = "defaultExpandAll",
    ":expand-on-click-node" = "expandOnClickNode",
    ":accordion" = "accordion",
    ":highlight-current" = "highlightCurrent",
    ":default-expanded-keys" = "expandedKeys",
    ":default-checked-keys" = "checkedKeys",
    ":empty-text" = .el_optional_bind("emptyText"),
    "@node-click" = "handleNodeClick",
    "@check" = "handleCheck"
  )

  tree_attrs[[":indent"]] <- .el_optional_bind("indent")

  tree_attrs[[":lazy"]] <- .el_optional_bind("lazy")

  tree_attrs[[":draggable"]] <- .el_optional_bind("draggable")

  tree_attrs[[":auto-expand-parent"]] <- .el_optional_bind("autoExpandParent")

  tree_attrs[[":check-on-click-node"]] <- .el_optional_bind("checkOnClickNode")

  tree_attrs[[":current-node-key"]] <- .el_optional_bind("currentNodeKey")

  tree_attrs[[":render-after-expand"]] <- .el_optional_bind("renderAfterExpand")

  tree_attrs[[":load"]] <- "load === null ? elLoad : load" # the server, by default

  # Element requires one before filter() can be called; by default, a node
  # is kept when its label contains the text, ignoring case
  tree_attrs[[
    ":filter-node-method"
  ]] <- "filterNodeMethod === null ? elFilterNode : filterNodeMethod"

  tree_attrs[[":render-content"]] <- .el_optional_bind("renderContent")

  tree_attrs[[":allow-drag"]] <- .el_optional_bind("allowDrag")

  tree_attrs[[":allow-drop"]] <- .el_optional_bind("allowDrop")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().

  events <- .el_event_bindings(
    ns_id,
    c(
      "check-change",

      "current-change",

      "node-expand",

      "node-collapse",

      "node-contextmenu",

      "node-drag-start",

      "node-drag-enter",

      "node-drag-leave",

      "node-drag-over",

      "node-drag-end",

      "node-drop"
    ),
    shapes = .el_tree_event_shapes()
  )

  tree_attrs <- c(tree_attrs, events$attrs)

  vue_data <- list(
    treeData = data,
    # Element's default props map is replaced wholesale, not merged, so
    # `disabled` has to be named here or a disabled node renders as normal.
    treeProps = list(
      label = label_field,
      children = children_field,
      disabled = disabled_field,
      isLeaf = is_leaf_field
    ),
    nodeKey = node_key,
    showCheckbox = show_checkbox,
    checkStrictly = check_strictly,
    defaultExpandAll = default_expand_all,
    expandOnClickNode = expand_on_click_node,
    accordion = accordion,
    highlightCurrent = highlight_current,
    expandedKeys = if (is.null(expanded)) list() else as.list(expanded),
    checkedKeys = if (is.null(checked)) list() else as.list(checked),
    emptyText = if (is.null(empty_text)) NA else empty_text,
    current = "",
    checked = if (is.null(checked)) list() else as.list(checked)
  )

  vue_data$indent <- .el_or_na(indent)

  vue_data$lazy <- .el_or_na(lazy)

  vue_data$draggable <- .el_or_na(draggable)

  vue_data$autoExpandParent <- .el_or_na(auto_expand_parent)

  vue_data$checkOnClickNode <- .el_or_na(check_on_click_node)

  vue_data$currentNodeKey <- .el_or_na(current_node_key)

  vue_data$renderAfterExpand <- .el_or_na(render_after_expand)

  vue_data$load <- .el_or_na(load)

  vue_data$filterNodeMethod <- .el_or_na(filter_node_method)

  vue_data$renderContent <- .el_or_na(render_content)

  vue_data$allowDrag <- .el_or_na(allow_drag)

  vue_data$allowDrop <- .el_or_na(allow_drop)

  el_widget(
    props = .el_props(list(
      check_on_click_leaf = check_on_click_leaf,
      icon = .el_icon_name(icon)
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
    markup = htmltools::tag("el-tree", tree_attrs),
    data = vue_data,
    methods = c(
      events$methods,
      list(
        elLoad = .el_lazy_load_method(ns_id, "tree"),
        elFilterNode = JS(paste0(
          "function(value, data) { if (!value) return true; ",
          "var label = data[(this.treeProps && this.treeProps.label) || 'label']; ",
          "return String(label === undefined ? '' : label).toLowerCase()",
          ".indexOf(String(value).toLowerCase()) !== -1; }"
        )),
        # update_el_tree(checked =): Element's setCheckedKeys(), which also
        # updates the half-checked parents a plain assignment would leave alone
        shinyVueReceive = JS(paste0(
          "function(d) { if ('checkedKeys' in d) { var keys = d.checkedKeys || []; ",
          "if (this.$refs.tree) this.$refs.tree.setCheckedKeys(keys); ",
          "this.checked = keys; delete d.checkedKeys; } return d; }"
        )),
        handleNodeClick = JS(sprintf(
          paste0(
            "function(data) { this.current = data[this.nodeKey]; ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', this.current); }"
          ),
          ns_id
        )),
        handleCheck = JS(sprintf(
          paste0(
            # Element hands the check event the node plus a summary object;
            # checkedKeys is the part worth reporting.
            "function(node, info) { this.checked = info.checkedKeys; ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_checked', this.checked); }"
          ),
          ns_id
        ))
      )
    ),
    mounted = .el_mounted_init(stats::setNames(
      c("current", "checked"),
      paste0(ns_id, c("", "_checked"))
    )),
    width = width,
    slots = slots
  )
}

#' Update an Element Plus Tree
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Tree ID (un-namespaced).
#' @param data Replacement node data.
#' @param expanded Keys to expand. Expanding is additive: a node already open
#'   is not closed by leaving it out, because Element's default-expanded-keys
#'   only ever opens nodes.
#' @param checked Keys to check, replacing the current selection entirely.
#'   Pass `list()` to clear it.
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
#'   observeEvent(input$go, {
#'     update_el_tree(session, "picker", checked = c("apple"))
#'   })
#' }
#' @export
update_el_tree <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  expanded = NULL,
  checked = NULL,
  label = NULL,
  error = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  # data and expandedKeys are watched props; checkedKeys is not replaceable
  # that way and the handler calls setCheckedKeys() instead.
  if (!is.null(data)) {
    msg$treeData <- data
  }
  if (!is.null(expanded)) {
    msg$expandedKeys <- as.list(expanded)
  }
  if (!is.null(checked)) {
    msg$checkedKeys <- as.list(checked)
  }
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}

#' Build tree data from a data frame
#'
#' Turns hierarchical columns into the nested node lists [el_tree()] expects,
#' one level per column. Keys are built by joining a row's values down to that
#' level, so a label repeated under different parents still gets a unique key.
#'
#' @param df A data frame.
#' @param cols Column names, outermost level first.
#' @param sep Separator used when joining values into a key.
#' @return A list of nodes.
#' @export
#' @examples
#' df <- data.frame(
#'   region = c("North", "North", "South"),
#'   city = c("Leeds", "York", "Bath"),
#'   stringsAsFactors = FALSE
#' )
#' df_to_tree_data(df, c("region", "city"))
df_to_tree_data <- function(df, cols, sep = "/") {
  build <- function(sub, level, prefix) {
    if (level > length(cols)) {
      return(NULL)
    }
    values <- unique(as.character(sub[[cols[level]]]))

    lapply(values, function(value) {
      key <- if (nzchar(prefix)) paste(prefix, value, sep = sep) else value
      rows <- sub[as.character(sub[[cols[level]]]) == value, , drop = FALSE]
      node <- list(id = key, label = value)
      kids <- build(rows, level + 1, key)
      if (length(kids)) {
        node$children <- kids
      }
      node
    })
  }
  build(df, 1, "")
}


#' What each tree event reports
#'
#' Element hands tree events the node's data, its internal TreeNode -- which
#' points at its parent and children -- and sometimes the component. Each is
#' shaped into a named list of the node's `data`, its `key` and its `level`.
#'
#' @return A named list of JavaScript functions, one per event.
#' @keywords internal
.el_tree_event_shapes <- function() {
  node <- "function(data, node) { return {data: data, key: node && node.key, level: node && node.level}; }"
  list(
    "node-expand" = node,
    "node-collapse" = node,
    "current-change" = node,
    "node-contextmenu" = "function(event, data, node) { return {data: data, key: node && node.key, level: node && node.level}; }",
    "check-change" = "function(data, checked, indeterminate) { return {data: data, checked: checked, indeterminate: indeterminate}; }",
    "node-drag-start" = "function(node) { return {data: node && node.data}; }",
    "node-drag-enter" = "function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }",
    "node-drag-leave" = "function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }",
    "node-drag-over" = "function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }",
    "node-drag-end" = "function(dragging, drop, type) { return {dragging: dragging && dragging.data, drop: drop && drop.data, type: type}; }",
    "node-drop" = "function(dragging, drop, type) { return {dragging: dragging && dragging.data, drop: drop && drop.data, type: type}; }"
  )
}
