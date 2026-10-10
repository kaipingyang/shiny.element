# Element Plus Tree

A tree view, optionally with checkboxes.

## Usage

``` r
el_tree(
  id = NULL,
  data = list(),
  node_key = "id",
  props = NULL,
  show_checkbox = FALSE,
  check_strictly = FALSE,
  default_expand_all = FALSE,
  expand_on_click_node = TRUE,
  accordion = FALSE,
  highlight_current = FALSE,
  default_expanded_keys = NULL,
  default_checked_keys = NULL,
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
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_tree(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data = NULL,
  default_expanded_keys = NULL,
  default_checked_keys = NULL,
  props = NULL,
  label = NULL,
  error = NULL,
  node_key = NULL,
  show_checkbox = NULL,
  check_strictly = NULL,
  expand_on_click_node = NULL,
  accordion = NULL,
  highlight_current = NULL,
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
  check_on_click_leaf = NULL,
  icon = NULL
)
```

## Arguments

- id:

  Tree ID (auto-generated if NULL).

- data:

  A list of nodes. Each is a list with its key (`node_key`) and its
  label, and optionally `children`, `disabled` for an uncheckable node,
  or `isLeaf` – under these names, or those `props` gives.

- node_key:

  Field holding each node's unique key. The keys are what the server
  sees and what `default_expanded_keys` and `default_checked_keys` refer
  to.

- props:

  Which field of a node holds what, as Element Plus's `props`:
  `list(label =, children =, disabled =, isLeaf =, class =)`, each a
  field name or a
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function of the node's data (and node) – `class` gives a node a class
  of its own. Those left out are Element's: `"label"`, `"children"`,
  `"disabled"`, `"isLeaf"`. `is_leaf` is read as `isLeaf`.

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

- default_expanded_keys, default_checked_keys:

  Keys of the nodes to expand and to check, as Element Plus's
  `default-expanded-keys` and `default-checked-keys`: the tree keeps its
  own state from there, and reports the checked ones as
  `input$<id>_checked`. `update_el_tree()` sets them again.

- empty_text:

  Text shown when `data` is empty.

- indent:

  Horizontal indent between levels, in pixels. Default `16`.

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
  `call_el(session, id, "filter", list(text))` works as it stands.

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

- check_on_click_leaf:

  Whether to check or uncheck node when clicking on leaf node (last
  children). Element Plus's `check-on-click-leaf` (boolean).

- icon:

  Custom tree node icon component. Element Plus's `icon` (string /
  Component). An icon's name, such as `"Search"`.

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

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_tree()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_tree()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Details

Unlike the menu, a tree takes its whole structure through a `data` prop
rather than nested tags, so the nesting is plain R data all the way
down.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the key of the node last clicked |
| `input$<id>_checked` | unasked | the keys of the checked nodes |
| `input$<id>_load` | unasked | with `lazy = TRUE`, a node asking for its children; answer with [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md) |
| `input$<id>_check_change` | `events = "check_change"` | `list(data, checked, indeterminate)` |
| `input$<id>_current_change` | `events = "current_change"` | `list(data, key, level)` of the current node |
| `input$<id>_node_expand` | `events = "node_expand"` | `list(data, key, level)` |
| `input$<id>_node_collapse` | `events = "node_collapse"` | `list(data, key, level)` |
| `input$<id>_node_contextmenu` | `events = "node_contextmenu"` | `list(data, key, level)` |
| `input$<id>_node_drag_start` | `events = "node_drag_start"` | `list(data)` of the dragged node |
| `input$<id>_node_drag_enter` | `events = "node_drag_enter"` | `list(dragging, drop)`, the nodes' data |
| `input$<id>_node_drag_leave` | `events = "node_drag_leave"` | `list(dragging, drop)`, the nodes' data |
| `input$<id>_node_drag_over` | `events = "node_drag_over"` | `list(dragging, drop)`, the nodes' data, at most every 200 ms |
| `input$<id>_node_drag_end` | `events = "node_drag_end"` | `list(dragging, drop, type)` |
| `input$<id>_node_drop` | `events = "node_drop"` | `list(dragging, drop, type)`: `type` `"before"`, `"after"` or `"inner"` |

The same list as `el_events("el_tree")`, which says how an event's
arguments travel.

`input$<id>` and `input$<id>_checked` are reported on load, where they
start empty and therefore arrive as `NULL`, as Shiny reports any empty
selection.

With `lazy = TRUE` and no `load` of your own, the server loads each
node's children: `input$<id>_load` asks, with `level` (0 for the top),
`key` (the node's `node_key` field), `data` (the node) and `request`;
answer with
[`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md).

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

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

## Updating from the server

`update_el_tree()` changes the component from the server.

Every other argument of `el_tree()` that can change once it is drawn is
an argument here too, under the same name. One left `NULL` stays as it
is; `NA` returns it to Element's default.

`update_el_tree()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
nodes <- list(
  list(
    id = "fruit",
    label = "Fruit",
    children = list(
      list(id = "apple", label = "Apple"),
      list(id = "cherry", label = "Cherry")
    )
  ),
  list(
    id = "veg",
    label = "Vegetables",
    children = list(
      list(id = "leek", label = "Leek", disabled = TRUE)
    )
  )
)

el_tree(id = "picker", data = nodes)
#> <div id="picker" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="picker_container" style="display: contents">
#>   <el-tree ref="tree" :data="treeData" :props="treeProps" :node-key="nodeKey" :show-checkbox="showCheckbox" :check-strictly="checkStrictly" :default-expand-all="defaultExpandAll" :expand-on-click-node="expandOnClickNode" :accordion="accordion" :highlight-current="highlightCurrent" :default-expanded-keys="expandedKeys" :default-checked-keys="checkedKeys" :empty-text="emptyText === null ? undefined : emptyText" @node-click="handleNodeClick" @check="handleCheck" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :draggable="draggable === null ? undefined : draggable" :auto-expand-parent="autoExpandParent === null ? undefined : autoExpandParent" :check-on-click-node="checkOnClickNode === null ? undefined : checkOnClickNode" :current-node-key="currentNodeKey === null ? undefined : currentNodeKey" :render-after-expand="renderAfterExpand === null ? undefined : renderAfterExpand" :load="load === null ? elLoad : load" :filter-node-method="filterNodeMethod === null ? elFilterNode : filterNodeMethod" :render-content="renderContent === null ? undefined : renderContent" :allow-drag="allowDrag === null ? undefined : allowDrag" :allow-drop="allowDrop === null ? undefined : allowDrop" @check-change="svEmitCheckChange" :check-on-click-leaf="checkOnClickLeaf === null ? undefined : checkOnClickLeaf" :icon="icon === null ? undefined : icon"></el-tree>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"treeData":[{"id":"fruit","label":"Fruit","children":[{"id":"apple","label":"Apple"},{"id":"cherry","label":"Cherry"}]},{"id":"veg","label":"Vegetables","children":[{"id":"leek","label":"Leek","disabled":true}]}],"treeProps":{"label":"label","children":"children","disabled":"disabled","isLeaf":"isLeaf"},"nodeKey":"id","showCheckbox":false,"checkStrictly":false,"defaultExpandAll":false,"expandOnClickNode":true,"accordion":false,"highlightCurrent":false,"expandedKeys":[],"checkedKeys":[],"emptyText":null,"current":"","checked":[],"indent":null,"lazy":null,"draggable":null,"autoExpandParent":null,"checkOnClickNode":null,"currentNodeKey":null,"renderAfterExpand":null,"load":null,"filterNodeMethod":null,"renderContent":null,"allowDrag":null,"allowDrop":null,"checkOnClickLeaf":null,"icon":null},"methods":{"svEmitCheckChange":"function() { var self = this; (function() {}).apply(this, arguments); Promise.resolve().then(function() { if (!self.$refs.tree) return; self.checked = self.$refs.tree.getCheckedKeys(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('picker_checked', self.checked); }); }","elLoad":"function(node, resolve, reject) {\n  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n  window.shinyVue.ask('picker_load', {level: node.level, key: key,\n      data: node.level ? node.data : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { if (reject) reject(); else resolve([]); });\n}","elFilterNode":"function(value, data) { if (!value) return true; var label = data[(this.treeProps && this.treeProps.label) || 'label']; return String(label === undefined ? '' : label).toLowerCase().indexOf(String(value).toLowerCase()) !== -1; }","shinyVueReceive":"function(d) { if ('checkedKeys' in d) { var keys = d.checkedKeys || []; if (this.$refs.tree) this.$refs.tree.setCheckedKeys(keys); this.checked = keys; delete d.checkedKeys; } return d; }","handleNodeClick":"function(data) { this.current = data[this.nodeKey]; }","handleCheck":"function(node, info) { this.checked = info.checkedKeys; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('picker_checked', this.checked); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"picker_checked\", self.checked); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"current","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitCheckChange","options.methods.elLoad","options.methods.elFilterNode","options.methods.shinyVueReceive","options.methods.handleNodeClick","options.methods.handleCheck","options.mounted"]}</script>
#> </div>

# With checkboxes, two nodes checked and the first branch open
el_tree(
  id = "picker",
  data = nodes,
  show_checkbox = TRUE,
  default_checked_keys = c("apple", "cherry"),
  default_expanded_keys = "fruit"
)
#> <div id="picker" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="picker_container" style="display: contents">
#>   <el-tree ref="tree" :data="treeData" :props="treeProps" :node-key="nodeKey" :show-checkbox="showCheckbox" :check-strictly="checkStrictly" :default-expand-all="defaultExpandAll" :expand-on-click-node="expandOnClickNode" :accordion="accordion" :highlight-current="highlightCurrent" :default-expanded-keys="expandedKeys" :default-checked-keys="checkedKeys" :empty-text="emptyText === null ? undefined : emptyText" @node-click="handleNodeClick" @check="handleCheck" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :draggable="draggable === null ? undefined : draggable" :auto-expand-parent="autoExpandParent === null ? undefined : autoExpandParent" :check-on-click-node="checkOnClickNode === null ? undefined : checkOnClickNode" :current-node-key="currentNodeKey === null ? undefined : currentNodeKey" :render-after-expand="renderAfterExpand === null ? undefined : renderAfterExpand" :load="load === null ? elLoad : load" :filter-node-method="filterNodeMethod === null ? elFilterNode : filterNodeMethod" :render-content="renderContent === null ? undefined : renderContent" :allow-drag="allowDrag === null ? undefined : allowDrag" :allow-drop="allowDrop === null ? undefined : allowDrop" @check-change="svEmitCheckChange" :check-on-click-leaf="checkOnClickLeaf === null ? undefined : checkOnClickLeaf" :icon="icon === null ? undefined : icon"></el-tree>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"treeData":[{"id":"fruit","label":"Fruit","children":[{"id":"apple","label":"Apple"},{"id":"cherry","label":"Cherry"}]},{"id":"veg","label":"Vegetables","children":[{"id":"leek","label":"Leek","disabled":true}]}],"treeProps":{"label":"label","children":"children","disabled":"disabled","isLeaf":"isLeaf"},"nodeKey":"id","showCheckbox":true,"checkStrictly":false,"defaultExpandAll":false,"expandOnClickNode":true,"accordion":false,"highlightCurrent":false,"expandedKeys":["fruit"],"checkedKeys":["apple","cherry"],"emptyText":null,"current":"","checked":["apple","cherry"],"indent":null,"lazy":null,"draggable":null,"autoExpandParent":null,"checkOnClickNode":null,"currentNodeKey":null,"renderAfterExpand":null,"load":null,"filterNodeMethod":null,"renderContent":null,"allowDrag":null,"allowDrop":null,"checkOnClickLeaf":null,"icon":null},"methods":{"svEmitCheckChange":"function() { var self = this; (function() {}).apply(this, arguments); Promise.resolve().then(function() { if (!self.$refs.tree) return; self.checked = self.$refs.tree.getCheckedKeys(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('picker_checked', self.checked); }); }","elLoad":"function(node, resolve, reject) {\n  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n  window.shinyVue.ask('picker_load', {level: node.level, key: key,\n      data: node.level ? node.data : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { if (reject) reject(); else resolve([]); });\n}","elFilterNode":"function(value, data) { if (!value) return true; var label = data[(this.treeProps && this.treeProps.label) || 'label']; return String(label === undefined ? '' : label).toLowerCase().indexOf(String(value).toLowerCase()) !== -1; }","shinyVueReceive":"function(d) { if ('checkedKeys' in d) { var keys = d.checkedKeys || []; if (this.$refs.tree) this.$refs.tree.setCheckedKeys(keys); this.checked = keys; delete d.checkedKeys; } return d; }","handleNodeClick":"function(data) { this.current = data[this.nodeKey]; }","handleCheck":"function(node, info) { this.checked = info.checkedKeys; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('picker_checked', this.checked); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"picker_checked\", self.checked); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"current","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitCheckChange","options.methods.elLoad","options.methods.elFilterNode","options.methods.shinyVueReceive","options.methods.handleNodeClick","options.methods.handleCheck","options.mounted"]}</script>
#> </div>

# Nodes whose fields are named otherwise
el_tree(
  data = list(list(
    id = 1,
    name = "Docs",
    kids = list(list(id = 2, name = "R"))
  )),
  props = list(label = "name", children = "kids")
)
#> <div id="el_tree_6b68670f-fea4-4941-8529-65c34e7cd845" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_tree_6b68670f-fea4-4941-8529-65c34e7cd845_container" style="display: contents">
#>   <el-tree ref="tree" :data="treeData" :props="treeProps" :node-key="nodeKey" :show-checkbox="showCheckbox" :check-strictly="checkStrictly" :default-expand-all="defaultExpandAll" :expand-on-click-node="expandOnClickNode" :accordion="accordion" :highlight-current="highlightCurrent" :default-expanded-keys="expandedKeys" :default-checked-keys="checkedKeys" :empty-text="emptyText === null ? undefined : emptyText" @node-click="handleNodeClick" @check="handleCheck" :indent="indent === null ? undefined : indent" :lazy="lazy === null ? undefined : lazy" :draggable="draggable === null ? undefined : draggable" :auto-expand-parent="autoExpandParent === null ? undefined : autoExpandParent" :check-on-click-node="checkOnClickNode === null ? undefined : checkOnClickNode" :current-node-key="currentNodeKey === null ? undefined : currentNodeKey" :render-after-expand="renderAfterExpand === null ? undefined : renderAfterExpand" :load="load === null ? elLoad : load" :filter-node-method="filterNodeMethod === null ? elFilterNode : filterNodeMethod" :render-content="renderContent === null ? undefined : renderContent" :allow-drag="allowDrag === null ? undefined : allowDrag" :allow-drop="allowDrop === null ? undefined : allowDrop" @check-change="svEmitCheckChange" :check-on-click-leaf="checkOnClickLeaf === null ? undefined : checkOnClickLeaf" :icon="icon === null ? undefined : icon"></el-tree>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"treeData":[{"id":1,"name":"Docs","kids":[{"id":2,"name":"R"}]}],"treeProps":{"label":"name","children":"kids","disabled":"disabled","isLeaf":"isLeaf"},"nodeKey":"id","showCheckbox":false,"checkStrictly":false,"defaultExpandAll":false,"expandOnClickNode":true,"accordion":false,"highlightCurrent":false,"expandedKeys":[],"checkedKeys":[],"emptyText":null,"current":"","checked":[],"indent":null,"lazy":null,"draggable":null,"autoExpandParent":null,"checkOnClickNode":null,"currentNodeKey":null,"renderAfterExpand":null,"load":null,"filterNodeMethod":null,"renderContent":null,"allowDrag":null,"allowDrop":null,"checkOnClickLeaf":null,"icon":null},"methods":{"svEmitCheckChange":"function() { var self = this; (function() {}).apply(this, arguments); Promise.resolve().then(function() { if (!self.$refs.tree) return; self.checked = self.$refs.tree.getCheckedKeys(); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_tree_6b68670f-fea4-4941-8529-65c34e7cd845_checked', self.checked); }); }","elLoad":"function(node, resolve, reject) {\n  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n  window.shinyVue.ask('el_tree_6b68670f-fea4-4941-8529-65c34e7cd845_load', {level: node.level, key: key,\n      data: node.level ? node.data : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { if (reject) reject(); else resolve([]); });\n}","elFilterNode":"function(value, data) { if (!value) return true; var label = data[(this.treeProps && this.treeProps.label) || 'label']; return String(label === undefined ? '' : label).toLowerCase().indexOf(String(value).toLowerCase()) !== -1; }","shinyVueReceive":"function(d) { if ('checkedKeys' in d) { var keys = d.checkedKeys || []; if (this.$refs.tree) this.$refs.tree.setCheckedKeys(keys); this.checked = keys; delete d.checkedKeys; } return d; }","handleNodeClick":"function(data) { this.current = data[this.nodeKey]; }","handleCheck":"function(node, info) { this.checked = info.checkedKeys; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('el_tree_6b68670f-fea4-4941-8529-65c34e7cd845_checked', this.checked); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"el_tree_6b68670f-fea4-4941-8529-65c34e7cd845_checked\", self.checked); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":"current","rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.svEmitCheckChange","options.methods.elLoad","options.methods.elFilterNode","options.methods.shinyVueReceive","options.methods.handleNodeClick","options.methods.handleCheck","options.mounted"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tree(session, "picker", default_checked_keys = "apple")
  })
}
```
