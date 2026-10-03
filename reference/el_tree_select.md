# Element Plus Tree Select

A select whose options are a tree: Element Plus's `el-tree-select`,
which takes the props of both
[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md)
and
[`el_tree()`](https://kaipingyang.github.io/shiny.element/reference/el_tree.md).

## Usage

``` r
el_tree_select(
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
)
```

## Arguments

- id:

  Component ID; the value is reported as `input$<id>`.

- data:

  The tree: a list of nodes, each
  `list(value =, label =, children = list(...))`.

- value:

  The selected value, or several with `multiple = TRUE`.

- multiple:

  Whether several nodes can be selected.

- show_checkbox:

  Whether nodes have checkboxes.

- check_strictly:

  Whether any node can be selected, not only leaves.

- check_on_click_node:

  Whether clicking a node checks it, with `show_checkbox`.

- filterable:

  Whether the options can be searched by typing.

- clearable:

  Whether the selection can be cleared.

- placeholder:

  Placeholder text.

- node_key:

  The field that identifies a node. Default `"value"`.

- props:

  Where the tree's fields are:
  `list(label =, children =, disabled =, isLeaf =)`.

- default_expand_all:

  Whether every node starts expanded.

- render_after_expand:

  Whether a node's children are drawn only once it is expanded. Default
  `TRUE`.

- collapse_tags, collapse_tags_tooltip:

  With `multiple`, whether the selection is shown as one tag and a
  count, with the rest in a tooltip.

- size:

  `"large"`, `"default"` or `"small"`.

- disabled:

  Whether it can be changed.

- cache_data:

  The nodes behind a value not yet loaded, for a lazy tree.

- lazy:

  Whether child nodes are loaded on demand – from the server, which
  answers `input$<id>_load` with
  [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md),
  unless `load` is given.

- load:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function loading child nodes in the browser instead of from the
  server. Needs `lazy = TRUE`.

- ...:

  Any other prop of Element Plus's select or tree, in snake_case:
  `max_collapse_tags = 2`, `expand_on_click_node = FALSE`.

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

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the selected value, or several, on load and on change.

- `input$<id>_load` – with `lazy = TRUE`, a node asking for its
  children: `level`, `key` (its `node_key` field) and `data`. Answer
  with
  [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md).

- `input$<id>_visible_change`, `input$<id>_clear`,
  `input$<id>_remove_tag`, `input$<id>_node_click`, `input$<id>_check` –
  Element Plus's events.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):
`focus()`, `blur()`.

## Examples

``` r
el_tree_select(
  "dept",
  placeholder = "Department",
  data = list(
    list(
      value = "eng",
      label = "Engineering",
      children = list(
        list(value = "web", label = "Web"),
        list(value = "data", label = "Data")
      )
    ),
    list(value = "ops", label = "Operations")
  )
)
#> <div id="dept" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dept_container" style="display: contents">
#>   <el-tree-select v-model="value" :data="data" @change="handleChange" :load="load === null ? elLoad : load" @visible-change="elEmitVisibleChange" @clear="elEmitClear" @remove-tag="elEmitRemoveTag" @node-click="elEmitNodeClick" @check="elEmitCheck" :multiple="multiple === null ? undefined : multiple" :show-checkbox="showCheckbox === null ? undefined : showCheckbox" :check-strictly="checkStrictly === null ? undefined : checkStrictly" :check-on-click-node="checkOnClickNode === null ? undefined : checkOnClickNode" :filterable="filterable === null ? undefined : filterable" :clearable="clearable === null ? undefined : clearable" :placeholder="placeholder === null ? undefined : placeholder" :node-key="nodeKey === null ? undefined : nodeKey" :props="props === null ? undefined : props" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :render-after-expand="renderAfterExpand === null ? undefined : renderAfterExpand" :collapse-tags="collapseTags === null ? undefined : collapseTags" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :size="size === null ? undefined : size" :disabled="disabled === null ? undefined : disabled" :cache-data="cacheData === null ? undefined : cacheData" :lazy="lazy === null ? undefined : lazy"></el-tree-select>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":null,"data":[{"value":"eng","label":"Engineering","children":[{"value":"web","label":"Web"},{"value":"data","label":"Data"}]},{"value":"ops","label":"Operations"}],"load":null,"multiple":null,"showCheckbox":null,"checkStrictly":null,"checkOnClickNode":null,"filterable":null,"clearable":null,"placeholder":"Department","nodeKey":null,"props":null,"defaultExpandAll":null,"renderAfterExpand":null,"collapseTags":null,"collapseTagsTooltip":null,"size":null,"disabled":null,"cacheData":null,"lazy":null},"methods":{"elEmitVisibleChange":"function() { window.shinyVue.emit('dept', 'visible_change', arguments); }","elEmitClear":"function() { window.shinyVue.emit('dept', 'clear', arguments); }","elEmitRemoveTag":"function() { window.shinyVue.emit('dept', 'remove_tag', arguments); }","elEmitNodeClick":"function() { window.shinyVue.emit('dept', 'node_click', arguments); }","elEmitCheck":"function() { window.shinyVue.emit('dept', 'check', arguments); }","elLoad":"function(node, resolve, reject) {\n  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n  window.shinyVue.ask('dept_load', {level: node.level, key: key,\n      data: node.level ? node.data : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { if (reject) reject(); else resolve([]); });\n}","handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitVisibleChange","options.methods.elEmitClear","options.methods.elEmitRemoveTag","options.methods.elEmitNodeClick","options.methods.elEmitCheck","options.methods.elLoad","options.methods.handleChange"]}</script>
#> </div>
```
