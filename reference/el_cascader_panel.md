# Element Plus Cascader Panel

The panel of an
[`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md)
on its own, always open: nested options in side-by-side columns, for
when there is room to show them rather than tuck them into a dropdown.

## Usage

``` r
el_cascader_panel(
  id = NULL,
  options = list(),
  value = NULL,
  props = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  height = NULL,
  item_size = NULL,
  virtual_scroll = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Panel ID. Auto-generated if `NULL`.

- options:

  Nested options, each `list(value =, label =, children =)`, as for
  [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md).
  [`df_to_cascader_options()`](https://kaipingyang.github.io/shiny.element/reference/df_to_cascader_options.md)
  builds them from a data.frame.

- value:

  Initially selected path, as a vector of values from the top level down
  – or a list of paths with `props = list(multiple = TRUE)`.

- props:

  Element's `props`, as a named list: `multiple`, `checkStrictly`,
  `expandTrigger` (`"click"` or `"hover"`), `lazy`, `lazyLoad`, and the
  field names `value`, `label`, `children`, `disabled`, `leaf`. With
  `lazy = TRUE` and no `lazyLoad` of your own, the server loads each
  column.

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

- height:

  Menu height for virtual scrolling (px). Element Plus's `height`
  (number).

- item_size:

  Node height for virtual scrolling (px). Element Plus's `item-size`
  (number).

- virtual_scroll:

  Whether to enable virtual scrolling for large data. Element Plus's
  `virtual-scroll` (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. The default slot, scoped with
  `{node, data}`, renders one option; write it with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the selected path, on load and on change.

- `input$<id>_expand_change` – the path of the column just opened.

- `input$<id>_lazy_load` – with `props = list(lazy = TRUE)`, a column to
  load; answer with
  [`el_load_children()`](https://kaipingyang.github.io/shiny.element/reference/el_load_children.md).
  See
  [`el_cascader()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader.md).

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `getCheckedNodes()` – the selected options

- `clearCheckedNodes()` – clear the selection

## Examples

``` r
regions <- list(
  list(
    value = "asia",
    label = "Asia",
    children = list(
      list(value = "cn", label = "China"),
      list(value = "jp", label = "Japan")
    )
  ),
  list(
    value = "europe",
    label = "Europe",
    children = list(
      list(value = "fr", label = "France")
    )
  )
)
el_cascader_panel("where", options = regions, value = c("asia", "jp"))
#> <div id="where" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="where_container" style="display: contents">
#>   <el-cascader-panel v-model="value" :options="options" :props="elProps" @change="handleChange" @expand-change="elEmitExpandChange" @close="elEmitClose" :height="height === null ? undefined : height" :item-size="itemSize === null ? undefined : itemSize" :virtual-scroll="virtualScroll === null ? undefined : virtualScroll"></el-cascader-panel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":["asia","jp"],"options":[{"value":"asia","label":"Asia","children":[{"value":"cn","label":"China"},{"value":"jp","label":"Japan"}]},{"value":"europe","label":"Europe","children":[{"value":"fr","label":"France"}]}],"props":null,"height":null,"itemSize":null,"virtualScroll":null},"methods":{"elEmitExpandChange":"function() { window.shinyVue.emit('where', 'expand_change', arguments); }","elEmitClose":"function() { window.shinyVue.emit('where', 'close', arguments); }","handleChange":"function(v) { }"},"computed":{"elProps":"function() {\n  var p = this.props;\n  if (p === null) return undefined;\n  if (!p.lazy || p.lazyLoad) return p;\n  var vm = this;\n  return Object.assign({}, p, {lazyLoad: function(node, resolve) {\n    window.shinyVue.ask('where_lazy_load', {level: node.level,\n      value: node.level ? node.value : null, path: node.level ? node.pathValues : []}, vm)\n      .then(function(children) { resolve(children || []); },\n            function() { resolve([]); });\n  }});\n}"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitExpandChange","options.methods.elEmitClose","options.methods.handleChange","options.computed.elProps"]}</script>
#> </div>

# Several at once
el_cascader_panel("where", options = regions, props = list(multiple = TRUE))
#> <div id="where" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="where_container" style="display: contents">
#>   <el-cascader-panel v-model="value" :options="options" :props="elProps" @change="handleChange" @expand-change="elEmitExpandChange" @close="elEmitClose" :height="height === null ? undefined : height" :item-size="itemSize === null ? undefined : itemSize" :virtual-scroll="virtualScroll === null ? undefined : virtualScroll"></el-cascader-panel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":[],"options":[{"value":"asia","label":"Asia","children":[{"value":"cn","label":"China"},{"value":"jp","label":"Japan"}]},{"value":"europe","label":"Europe","children":[{"value":"fr","label":"France"}]}],"props":{"multiple":true},"height":null,"itemSize":null,"virtualScroll":null},"methods":{"elEmitExpandChange":"function() { window.shinyVue.emit('where', 'expand_change', arguments); }","elEmitClose":"function() { window.shinyVue.emit('where', 'close', arguments); }","handleChange":"function(v) { }"},"computed":{"elProps":"function() {\n  var p = this.props;\n  if (p === null) return undefined;\n  if (!p.lazy || p.lazyLoad) return p;\n  var vm = this;\n  return Object.assign({}, p, {lazyLoad: function(node, resolve) {\n    window.shinyVue.ask('where_lazy_load', {level: node.level,\n      value: node.level ? node.value : null, path: node.level ? node.pathValues : []}, vm)\n      .then(function(children) { resolve(children || []); },\n            function() { resolve([]); });\n  }});\n}"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitExpandChange","options.methods.elEmitClose","options.methods.handleChange","options.computed.elProps"]}</script>
#> </div>
```
