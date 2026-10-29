# Bind an argument to state in the browser

A component's argument given `vue_bind()` in place of a value follows
state on the page, with no round trip to the server: a store's field,
another component's value, the route. It is how a Vue application's
components share a `ref`, for components that are each an application of
their own – the page's UI state stays in the browser, and the server
keeps the data and the decisions.

## Usage

``` r
vue_bind(path)
```

## Arguments

- path:

  The state to follow: a string starting with `$store`, `$inputs` or
  `$route`.

## Value

The path, classed `"vue_bind"`, to give as an argument's value.

## Details

Three kinds of state can be bound:

- `$store.<id>.<field>`: a
  [`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md)'s
  state, both ways. The component follows the field, and when its user
  changes it – a dialog closed, a value picked – the field is set, so
  everything bound to it follows.

- `$inputs.<id>`: the value another component reports as `input$<id>`,
  one way. In a module, the id is the namespaced one, in brackets:
  `vue_bind(sprintf("$inputs['%s']", ns("size")))`.

- `$route.<...>`: the route of the page's
  [`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md),
  one way: `$route.path`, `$route.params.id`.

A path goes on with `.<name>`, `['<name>']` or `[<index>]`. A
component's value – what it reports as `input$<id>` – can be bound to a
store alone: bound to something read-only, its user's change would be
lost. A component drawn as markup (a dialog, a drawer, tabs, a collapse)
can bind what its `update_*()` can set. An argument R reads to draw a
component – a label, the choices – is an error.

The binding holds the argument from then on: `update_*()` of the field
sets it, and through it the store; bound to `$inputs` or `$route`, the
field keeps the update until what it follows changes again. With Shiny
on the page, the component reports `input$<id>` as ever, so the server
sees what the page did.

Acting in the browser needs nothing more: an `on` handler may be Vue's
inline statement, as `@click="..."` in a template, which reaches the
stores and whatever the component library installs on every component,
as a message service – `on = list(click = "$store.ui.open = true")`,
`"$message('Saved')"`. A
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
handler runs with the component as `this`: `this.$store.ui.open = true`.

## See also

[`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md)
for state shared by components.

## Examples

``` r
# A size picked in one component, followed by another
htmltools::tagList(
  vue_app(
    "size",
    htmltools::tags$select(
      `v-model` = "size",
      htmltools::tags$option("small"),
      htmltools::tags$option("large")
    ),
    data = list(size = "small"),
    input = "size"
  ),
  vue_app(
    "shown",
    htmltools::tags$span("Size: {{ size }}"),
    data = list(size = vue_bind("$inputs.size"))
  )
)
#> <div id="size" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><select v-model="size">
#>   <option>small</option>
#>   <option>large</option>
#> </select></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"size":"small"}},"input":"size","evals":[]}</script>
#> </div>
#> <div id="shown" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span>Size: {{ size }}</span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"size":null}},"bound":{"size":"$inputs.size"},"evals":[]}</script>
#> </div>

# A store both follow: the second sets it
htmltools::tagList(
  vue_store("ui", state = list(open = FALSE)),
  vue_app(
    "toggle",
    htmltools::tags$button(`@click` = "open = !open", "Toggle"),
    data = list(open = vue_bind("$store.ui.open"))
  ),
  vue_app("state", htmltools::tags$span("{{ $store.ui.open }}"))
)
#> <div id="ui" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span hidden></span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"open":false}},"store":true,"evals":[]}</script>
#> </div>
#> <div id="toggle" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><button @click="open = !open">Toggle</button></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"open":null}},"bound":{"open":"$store.ui.open"},"evals":[]}</script>
#> </div>
#> <div id="state" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span>{{ $store.ui.open }}</span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"evals":[]}</script>
#> </div>
```
