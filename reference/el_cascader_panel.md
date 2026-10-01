# Element UI Cascader Panel

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
  field names `value`, `label`, `children`, `disabled`, `leaf`.

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

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `getCheckedNodes()` – the selected options

- `clearCheckedNodes()` – clear the selection

## Examples

``` r
regions <- list(
  list(value = "asia", label = "Asia", children = list(
    list(value = "cn", label = "China"), list(value = "jp", label = "Japan"))),
  list(value = "europe", label = "Europe", children = list(
    list(value = "fr", label = "France")))
)
el_cascader_panel("where", options = regions, value = c("asia", "jp"))
#> <div id="where" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="where_container" style="display: contents">
#>   <el-cascader-panel v-model="value" :options="options" :props="props === null ? undefined : props" @change="handleChange" @expand-change="elEmitExpandChange"></el-cascader-panel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":["asia","jp"],"options":[{"value":"asia","label":"Asia","children":[{"value":"cn","label":"China"},{"value":"jp","label":"Japan"}]},{"value":"europe","label":"Europe","children":[{"value":"fr","label":"France"}]}],"props":null},"methods":{"elEmitExpandChange":"function() { window.shinyElement.emit('where', 'expand_change', arguments); }","handleChange":"function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('where', v); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitExpandChange","options.methods.handleChange"]}</script>
#> </div>

# Several at once
el_cascader_panel("where", options = regions, props = list(multiple = TRUE))
#> <div id="where" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="where_container" style="display: contents">
#>   <el-cascader-panel v-model="value" :options="options" :props="props === null ? undefined : props" @change="handleChange" @expand-change="elEmitExpandChange"></el-cascader-panel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":[],"options":[{"value":"asia","label":"Asia","children":[{"value":"cn","label":"China"},{"value":"jp","label":"Japan"}]},{"value":"europe","label":"Europe","children":[{"value":"fr","label":"France"}]}],"props":{"multiple":true}},"methods":{"elEmitExpandChange":"function() { window.shinyElement.emit('where', 'expand_change', arguments); }","handleChange":"function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('where', v); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitExpandChange","options.methods.handleChange"]}</script>
#> </div>
```
