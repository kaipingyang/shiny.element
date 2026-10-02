# Element UI Tree

A tree view, optionally with checkboxes.

## Usage

``` r
el_tree(
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
  icon_class = NULL,
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
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Tree ID (auto-generated if NULL).

- data:

  A list of nodes. Each is a list with the key and label fields named by
  `node_key` and `label_field`, and optionally `children`, `disabled`
  for an uncheckable node, or `isLeaf`.

- node_key:

  Field holding each node's unique key. The keys are what the server
  sees and what `expanded` and `checked` refer to.

- label_field, children_field:

  Fields holding a node's label and its children.

- disabled_field:

  Field marking a node disabled. Default `"disabled"`.

- is_leaf_field:

  Field marking a node as a leaf, so lazy loading knows not to ask it
  for children. Default `"isLeaf"`. Element replaces its whole field map
  at once, so all four are sent together.

- show_checkbox:

  Show a checkbox beside every node.

- check_strictly:

  Treat a parent's checkbox as independent of its children, rather than
  checking them together.

- default_expand_all:

  Expand every node initially.

- expand_on_click_node:

  Expand a node when its label is clicked, as well as its arrow. Set
  `FALSE` to make clicking select rather than expand.

- accordion:

  Keep only one node expanded per level.

- highlight_current:

  Highlight the clicked node.

- expanded, checked:

  Keys to expand and to check initially.

- empty_text:

  Text shown when `data` is empty.

- indent:

  Horizontal indent between levels, in pixels. Default `16`.

- icon_class:

  Icon class of the expand arrow.

- lazy:

  Whether child nodes are loaded on demand – from the server, unless
  `load` is given. See "Shiny inputs".

- draggable:

  Whether nodes can be dragged.

- auto_expand_parent:

  Whether expanding a node expands its parents. Default `TRUE`.

- check_on_click_node:

  Whether clicking a node's label also checks it.

- current_node_key:

  Key of the node that starts out highlighted.

- render_after_expand:

  Whether child nodes are rendered only once expanded. Default `TRUE`.

- load:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function loading child nodes in the browser instead of from the
  server. Needs `lazy = TRUE`.

- filter_node_method:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding whether a node survives filtering. By default a node
  is kept when its label contains the text, ignoring case, so
  `el_call(session, id, "filter", list(text))` works as it stands.

- render_content:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  render function for a node's content.

- allow_drag:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding whether a node may be dragged.

- allow_drop:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function deciding whether a node may be dropped somewhere.

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Details

Unlike the menu, a tree takes its whole structure through a `data` prop
rather than nested tags, so the nesting is plain R data all the way
down.

## Shiny inputs

`input$<id>` holds the key of the most recently clicked node, and
`input$<id>_checked` the keys of all checked nodes, as a character
vector. Both are reported on load, where they start empty and therefore
arrive as `NULL`, as Shiny reports any empty selection.

With `lazy = TRUE` and no `load` of your own, the server loads each
node's children: `input$<id>_load` asks, with `level` (0 for the top),
`key` (the node's `node_key` field), `data` (the node) and `request`;
answer with
[`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md).

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- [`append()`](https://rdrr.io/r/base/append.html) – Append a child node
  to a given node in the tree

- [`filter()`](https://rdrr.io/r/stats/filter.html) – Filter all tree
  nodes, filtered nodes will be hidden

- `getCheckedKeys()` – If the node can be selected (show-checkbox is
  true), it returns the currently selected array of node's keys

- `getCheckedNodes()` – If the node can be selected (show-checkbox is
  true), it returns the currently selected array of nodes

- `getCurrentKey()` – Return the highlight node's key (null if no node
  is highlighted)

- `getCurrentNode()` – Return the highlight node's data (null if no node
  is highlighted)

- `getHalfCheckedKeys()` – If the node can be selected (show-checkbox is
  true), it returns the currently half selected array of...

- `getHalfCheckedNodes()` – If the node can be selected (show-checkbox
  is true), it returns the currently half selected array of nodes

- `getNode()` – Get node by data or key

- `insertAfter()` – Insert a node after a given node in the tree

- `insertBefore()` – Insert a node before a given node in the tree

- [`remove()`](https://rdrr.io/r/base/rm.html) – Remove a node, only
  works when node-key is assigned

- `setChecked()` – Set node to be checked or not, only works when
  node-key is assigned

- `setCheckedKeys()` – Set certain nodes to be checked, only works when
  node-key is assigned

- `setCheckedNodes()` – Set certain nodes to be checked, only works when
  node-key is assigned

- `setCurrentKey()` – Set highlighted node by key, only works when
  node-key is assigned

- `setCurrentNode()` – Set highlighted node, only works when node-key is
  assigned

- `updateKeyChildren()` – Set new data to node, only works when node-key
  is assigned

## Examples

``` r
nodes <- list(
  list(id = "fruit", label = "Fruit", children = list(
    list(id = "apple",  label = "Apple"),
    list(id = "cherry", label = "Cherry")
  )),
  list(id = "veg", label = "Vegetables", children = list(
    list(id = "leek", label = "Leek", disabled = TRUE)
  ))
)

el_tree(id = "picker", data = nodes)
#> <div id="picker" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="picker_container" style="display: contents">
#>   <el-tree ref="tree" :data="treeData" :props="treeProps" :node-key="nodeKey" :show-checkbox="showCheckbox" :check-strictly="checkStrictly" :default-expand-all="defaultExpandAll" :expand-on-click-node="expandOnClickNode" :accordion="accordion" :highlight-current="highlightCurrent" :default-expanded-keys="expandedKeys" :default-checked-keys="checkedKeys" :empty-text="emptyText === null ? undefined : emptyText" @node-click="handleNodeClick" @check="handleCheck" :indent="indent === null ? undefined : indent" :icon-class="iconClass === null ? undefined : iconClass" :lazy="lazy === null ? undefined : lazy" :draggable="draggable === null ? undefined : draggable" :auto-expand-parent="autoExpandParent === null ? undefined : autoExpandParent" :check-on-click-node="checkOnClickNode === null ? undefined : checkOnClickNode" :current-node-key="currentNodeKey === null ? undefined : currentNodeKey" :render-after-expand="renderAfterExpand === null ? undefined : renderAfterExpand" :load="load === null ? elLoad : load" :filter-node-method="filterNodeMethod === null ? elFilterNode : filterNodeMethod" :render-content="renderContent === null ? undefined : renderContent" :allow-drag="allowDrag === null ? undefined : allowDrag" :allow-drop="allowDrop === null ? undefined : allowDrop" @check-change="elEmitCheckChange" @current-change="elEmitCurrentChange" @node-expand="elEmitNodeExpand" @node-collapse="elEmitNodeCollapse" @node-contextmenu="elEmitNodeContextmenu" @node-drag-start="elEmitNodeDragStart" @node-drag-enter="elEmitNodeDragEnter" @node-drag-leave="elEmitNodeDragLeave" @node-drag-over="elEmitNodeDragOver" @node-drag-end="elEmitNodeDragEnd" @node-drop="elEmitNodeDrop"></el-tree>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"treeData":[{"id":"fruit","label":"Fruit","children":[{"id":"apple","label":"Apple"},{"id":"cherry","label":"Cherry"}]},{"id":"veg","label":"Vegetables","children":[{"id":"leek","label":"Leek","disabled":true}]}],"treeProps":{"label":"label","children":"children","disabled":"disabled","isLeaf":"isLeaf"},"nodeKey":"id","showCheckbox":false,"checkStrictly":false,"defaultExpandAll":false,"expandOnClickNode":true,"accordion":false,"highlightCurrent":false,"expandedKeys":[],"checkedKeys":[],"emptyText":null,"current":"","checked":[],"indent":null,"iconClass":null,"lazy":null,"draggable":null,"autoExpandParent":null,"checkOnClickNode":null,"currentNodeKey":null,"renderAfterExpand":null,"load":null,"filterNodeMethod":null,"renderContent":null,"allowDrag":null,"allowDrop":null},"methods":{"elEmitCheckChange":"function() { var shape = function(data, checked, indeterminate) { return {data: data, checked: checked, indeterminate: indeterminate}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'check_change', [v]); }","elEmitCurrentChange":"function() { var shape = function(data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'current_change', [v]); }","elEmitNodeExpand":"function() { var shape = function(data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_expand', [v]); }","elEmitNodeCollapse":"function() { var shape = function(data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_collapse', [v]); }","elEmitNodeContextmenu":"function() { var shape = function(event, data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_contextmenu', [v]); }","elEmitNodeDragStart":"function() { var shape = function(node) { return {data: node && node.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_start', [v]); }","elEmitNodeDragEnter":"function() { var shape = function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_enter', [v]); }","elEmitNodeDragLeave":"function() { var shape = function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_leave', [v]); }","elEmitNodeDragOver":"function() { var shape = function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_over', [v]); }","elEmitNodeDragEnd":"function() { var shape = function(dragging, drop, type) { return {dragging: dragging && dragging.data, drop: drop && drop.data, type: type}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_end', [v]); }","elEmitNodeDrop":"function() { var shape = function(dragging, drop, type) { return {dragging: dragging && dragging.data, drop: drop && drop.data, type: type}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drop', [v]); }","elLoad":"function(node, resolve) {\n  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n  window.shinyVue.ask('picker_load', {level: node.level, key: key,\n      data: node.level ? node.data : null}, this)\n    .then(function(children) { resolve(children || []); });\n}","elFilterNode":"function(value, data) { if (!value) return true; var label = data[(this.treeProps && this.treeProps.label) || 'label']; return String(label === undefined ? '' : label).toLowerCase().indexOf(String(value).toLowerCase()) !== -1; }","shinyVueReceive":"function(d) { if ('checkedKeys' in d) { var keys = d.checkedKeys || []; if (this.$refs.tree) this.$refs.tree.setCheckedKeys(keys); this.checked = keys; delete d.checkedKeys; } return d; }","handleNodeClick":"function(data) { this.current = data[this.nodeKey]; }","handleCheck":"function(node, info) { this.checked = info.checkedKeys; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('picker_checked', this.checked); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"picker_checked\", self.checked); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"current","rate":null,"type":null,"evals":["options.methods.elEmitCheckChange","options.methods.elEmitCurrentChange","options.methods.elEmitNodeExpand","options.methods.elEmitNodeCollapse","options.methods.elEmitNodeContextmenu","options.methods.elEmitNodeDragStart","options.methods.elEmitNodeDragEnter","options.methods.elEmitNodeDragLeave","options.methods.elEmitNodeDragOver","options.methods.elEmitNodeDragEnd","options.methods.elEmitNodeDrop","options.methods.elLoad","options.methods.elFilterNode","options.methods.shinyVueReceive","options.methods.handleNodeClick","options.methods.handleCheck","options.mounted"]}</script>
#> </div>

# With checkboxes, two nodes checked and the first branch open
el_tree(id = "picker", data = nodes, show_checkbox = TRUE,
        checked = c("apple", "cherry"), expanded = "fruit")
#> <div id="picker" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="picker_container" style="display: contents">
#>   <el-tree ref="tree" :data="treeData" :props="treeProps" :node-key="nodeKey" :show-checkbox="showCheckbox" :check-strictly="checkStrictly" :default-expand-all="defaultExpandAll" :expand-on-click-node="expandOnClickNode" :accordion="accordion" :highlight-current="highlightCurrent" :default-expanded-keys="expandedKeys" :default-checked-keys="checkedKeys" :empty-text="emptyText === null ? undefined : emptyText" @node-click="handleNodeClick" @check="handleCheck" :indent="indent === null ? undefined : indent" :icon-class="iconClass === null ? undefined : iconClass" :lazy="lazy === null ? undefined : lazy" :draggable="draggable === null ? undefined : draggable" :auto-expand-parent="autoExpandParent === null ? undefined : autoExpandParent" :check-on-click-node="checkOnClickNode === null ? undefined : checkOnClickNode" :current-node-key="currentNodeKey === null ? undefined : currentNodeKey" :render-after-expand="renderAfterExpand === null ? undefined : renderAfterExpand" :load="load === null ? elLoad : load" :filter-node-method="filterNodeMethod === null ? elFilterNode : filterNodeMethod" :render-content="renderContent === null ? undefined : renderContent" :allow-drag="allowDrag === null ? undefined : allowDrag" :allow-drop="allowDrop === null ? undefined : allowDrop" @check-change="elEmitCheckChange" @current-change="elEmitCurrentChange" @node-expand="elEmitNodeExpand" @node-collapse="elEmitNodeCollapse" @node-contextmenu="elEmitNodeContextmenu" @node-drag-start="elEmitNodeDragStart" @node-drag-enter="elEmitNodeDragEnter" @node-drag-leave="elEmitNodeDragLeave" @node-drag-over="elEmitNodeDragOver" @node-drag-end="elEmitNodeDragEnd" @node-drop="elEmitNodeDrop"></el-tree>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"treeData":[{"id":"fruit","label":"Fruit","children":[{"id":"apple","label":"Apple"},{"id":"cherry","label":"Cherry"}]},{"id":"veg","label":"Vegetables","children":[{"id":"leek","label":"Leek","disabled":true}]}],"treeProps":{"label":"label","children":"children","disabled":"disabled","isLeaf":"isLeaf"},"nodeKey":"id","showCheckbox":true,"checkStrictly":false,"defaultExpandAll":false,"expandOnClickNode":true,"accordion":false,"highlightCurrent":false,"expandedKeys":["fruit"],"checkedKeys":["apple","cherry"],"emptyText":null,"current":"","checked":["apple","cherry"],"indent":null,"iconClass":null,"lazy":null,"draggable":null,"autoExpandParent":null,"checkOnClickNode":null,"currentNodeKey":null,"renderAfterExpand":null,"load":null,"filterNodeMethod":null,"renderContent":null,"allowDrag":null,"allowDrop":null},"methods":{"elEmitCheckChange":"function() { var shape = function(data, checked, indeterminate) { return {data: data, checked: checked, indeterminate: indeterminate}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'check_change', [v]); }","elEmitCurrentChange":"function() { var shape = function(data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'current_change', [v]); }","elEmitNodeExpand":"function() { var shape = function(data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_expand', [v]); }","elEmitNodeCollapse":"function() { var shape = function(data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_collapse', [v]); }","elEmitNodeContextmenu":"function() { var shape = function(event, data, node) { return {data: data, key: node && node.key, level: node && node.level}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_contextmenu', [v]); }","elEmitNodeDragStart":"function() { var shape = function(node) { return {data: node && node.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_start', [v]); }","elEmitNodeDragEnter":"function() { var shape = function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_enter', [v]); }","elEmitNodeDragLeave":"function() { var shape = function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_leave', [v]); }","elEmitNodeDragOver":"function() { var shape = function(dragging, drop) { return {dragging: dragging && dragging.data, drop: drop && drop.data}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_over', [v]); }","elEmitNodeDragEnd":"function() { var shape = function(dragging, drop, type) { return {dragging: dragging && dragging.data, drop: drop && drop.data, type: type}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drag_end', [v]); }","elEmitNodeDrop":"function() { var shape = function(dragging, drop, type) { return {dragging: dragging && dragging.data, drop: drop && drop.data, type: type}; }; var v = shape.apply(this, arguments); if (v === undefined) return; window.shinyVue.emit('picker', 'node_drop', [v]); }","elLoad":"function(node, resolve) {\n  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n  window.shinyVue.ask('picker_load', {level: node.level, key: key,\n      data: node.level ? node.data : null}, this)\n    .then(function(children) { resolve(children || []); });\n}","elFilterNode":"function(value, data) { if (!value) return true; var label = data[(this.treeProps && this.treeProps.label) || 'label']; return String(label === undefined ? '' : label).toLowerCase().indexOf(String(value).toLowerCase()) !== -1; }","shinyVueReceive":"function(d) { if ('checkedKeys' in d) { var keys = d.checkedKeys || []; if (this.$refs.tree) this.$refs.tree.setCheckedKeys(keys); this.checked = keys; delete d.checkedKeys; } return d; }","handleNodeClick":"function(data) { this.current = data[this.nodeKey]; }","handleCheck":"function(node, info) { this.checked = info.checkedKeys; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('picker_checked', this.checked); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"picker_checked\", self.checked); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"current","rate":null,"type":null,"evals":["options.methods.elEmitCheckChange","options.methods.elEmitCurrentChange","options.methods.elEmitNodeExpand","options.methods.elEmitNodeCollapse","options.methods.elEmitNodeContextmenu","options.methods.elEmitNodeDragStart","options.methods.elEmitNodeDragEnter","options.methods.elEmitNodeDragLeave","options.methods.elEmitNodeDragOver","options.methods.elEmitNodeDragEnd","options.methods.elEmitNodeDrop","options.methods.elLoad","options.methods.elFilterNode","options.methods.shinyVueReceive","options.methods.handleNodeClick","options.methods.handleCheck","options.mounted"]}</script>
#> </div>
```
