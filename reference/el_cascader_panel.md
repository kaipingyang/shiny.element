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
#> <div id="where_container" style="display: contents">
#>   <el-cascader-panel v-model="value" :options="options" :props="props === null ? undefined : props" @change="handleChange" @expand-change="elEmitExpandChange"></el-cascader-panel>
#> </div>
#> <div id="where" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="where">{"x":{"el":"#where_container","data":{"value":["asia","jp"],"options":[{"value":"asia","label":"Asia","children":[{"value":"cn","label":"China"},{"value":"jp","label":"Japan"}]},{"value":"europe","label":"Europe","children":[{"value":"fr","label":"France"}]}],"props":null},"methods":{"elEmitExpandChange":"function() { window.shinyElement.emit('where', 'expand_change', arguments); }","handleChange":"function(v) { window.Shiny && Shiny.setInputValue('where', v); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"where\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitExpandChange","methods.handleChange","mounted"],"jsHooks":[]}</script>

# Several at once
el_cascader_panel("where", options = regions, props = list(multiple = TRUE))
#> <div id="where_container" style="display: contents">
#>   <el-cascader-panel v-model="value" :options="options" :props="props === null ? undefined : props" @change="handleChange" @expand-change="elEmitExpandChange"></el-cascader-panel>
#> </div>
#> <div id="where" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="where">{"x":{"el":"#where_container","data":{"value":[],"options":[{"value":"asia","label":"Asia","children":[{"value":"cn","label":"China"},{"value":"jp","label":"Japan"}]},{"value":"europe","label":"Europe","children":[{"value":"fr","label":"France"}]}],"props":{"multiple":true}},"methods":{"elEmitExpandChange":"function() { window.shinyElement.emit('where', 'expand_change', arguments); }","handleChange":"function(v) { window.Shiny && Shiny.setInputValue('where', v); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue(\"where\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitExpandChange","methods.handleChange","mounted"],"jsHooks":[]}</script>
```
