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
  slots = NULL,
  events = NULL,
  on = NULL
)

update_el_tree_select(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  data = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  multiple = NULL,
  show_checkbox = NULL,
  check_strictly = NULL,
  check_on_click_node = NULL,
  filterable = NULL,
  clearable = NULL,
  placeholder = NULL,
  node_key = NULL,
  props = NULL,
  render_after_expand = NULL,
  collapse_tags = NULL,
  collapse_tags_tooltip = NULL,
  size = NULL,
  cache_data = NULL,
  lazy = NULL,
  load = NULL
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

  Shiny session; the current one by default, as for
  [`shiny::updateSelectInput()`](https://rdrr.io/pkg/shiny/man/updateSelectInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the value, several with `multiple` |
| `input$<id>_load` | unasked | with `lazy = TRUE`, a node asking for its children; answer with [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md) |
| `input$<id>_visible_change` | `events = "visible_change"` | triggers when the dropdown appears/disappears |
| `input$<id>_clear` | `events = "clear"` | triggers when the clear icon is clicked in a clearable Select |
| `input$<id>_remove_tag` | `events = "remove_tag"` | triggers when a tag is removed in multiple mode |
| `input$<id>_node_click` | `events = "node_click"` | triggers when a node is clicked |
| `input$<id>_check` | `events = "check"` | triggers after clicking the checkbox of a node |

The same list as `el_events("el_tree_select")`, which says how an
event's arguments travel.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`focus()`, `blur()`.

## Updating from the server

`update_el_tree_select()` changes the component from the server.

Every other argument of `el_tree_select()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_tree_select()` is called for its side effect and returns
`NULL` invisibly.

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
#>   <el-tree-select v-model="value" :data="data" @change="handleChange" :load="load === null ? elLoad : load" :multiple="multiple === null ? undefined : multiple" :show-checkbox="showCheckbox === null ? undefined : showCheckbox" :check-strictly="checkStrictly === null ? undefined : checkStrictly" :check-on-click-node="checkOnClickNode === null ? undefined : checkOnClickNode" :filterable="filterable === null ? undefined : filterable" :clearable="clearable === null ? undefined : clearable" :placeholder="placeholder === null ? undefined : placeholder" :node-key="nodeKey === null ? undefined : nodeKey" :props="props === null ? undefined : props" :default-expand-all="defaultExpandAll === null ? undefined : defaultExpandAll" :render-after-expand="renderAfterExpand === null ? undefined : renderAfterExpand" :collapse-tags="collapseTags === null ? undefined : collapseTags" :collapse-tags-tooltip="collapseTagsTooltip === null ? undefined : collapseTagsTooltip" :size="size === null ? undefined : size" :disabled="disabled === null ? undefined : disabled" :cache-data="cacheData === null ? undefined : cacheData" :lazy="lazy === null ? undefined : lazy"></el-tree-select>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":null,"data":[{"value":"eng","label":"Engineering","children":[{"value":"web","label":"Web"},{"value":"data","label":"Data"}]},{"value":"ops","label":"Operations"}],"load":null,"multiple":null,"showCheckbox":null,"checkStrictly":null,"checkOnClickNode":null,"filterable":null,"clearable":null,"placeholder":"Department","nodeKey":null,"props":null,"defaultExpandAll":null,"renderAfterExpand":null,"collapseTags":null,"collapseTagsTooltip":null,"size":null,"disabled":null,"cacheData":null,"lazy":null},"methods":{"elLoad":"function(node, resolve, reject) {\n  var key = node.level && this.nodeKey ? node.data[this.nodeKey] : null;\n  window.shinyVue.ask('dept_load', {level: node.level, key: key,\n      data: node.level ? node.data : null}, this)\n    .then(function(children) { resolve(children || []); },\n          function() { if (reject) reject(); else resolve([]); });\n}","handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elLoad","options.methods.handleChange"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_tree_select(session, "dept", value = "ops")
  )
}
```
