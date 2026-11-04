# Vue's `v-bind` and `v-model` for a component's arguments

A component's argument given `v_bind()` or `v_model()` in place of a
value follows state on the page, in the browser, with no round trip to
the server – as `:size="size"` and `v-model="open"` do in a Vue
template. The page's UI state stays in the browser; the server keeps the
data and the decisions.

## Usage

``` r
v_bind(expr, ns = NULL)

v_model(path, arg = NULL, modifiers = NULL, ns = NULL)
```

## Arguments

- expr:

  A JavaScript expression over `$vueStore`, `$inputs` and `$route`, a
  string.

- ns:

  In a module, its namespace: the function
  [`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) gives,
  `session$ns`, or the module's id.

- path:

  A store's field, `$vueStore.<id>.<field>`, going on with `.<name>`,
  `['<name>']` or `[<index>]`.

## Value

The binding, to give as an argument's value.

## Details

- `v_bind(expr)` is one way, as `v-bind` (`:prop="expr"`): the argument
  follows the expression, any JavaScript expression –
  `v_bind("$inputs.fold === 'collapse'")`.

- `v_model(path)` is both ways, as `v-model`: the argument follows a
  store's field, and when the component's user changes it – a dialog
  closed, a value picked – the field is set, so everything bound to it
  follows. The path is one a value can be assigned to:
  `v_model("$vueStore.ui.open")`.

Each component is a Vue application of its own, so an expression sees
the page, not another component's variables: the names it can use are

- `$vueStore.<id>`: a
  [`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md),
  its state and getters;

- `$inputs.<id>`: the value a component reports as `input$<id>`, as its
  component reports it (before any debounce, before an input handler
  converts it);

- `$route`: the route of the page's
  [`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md)
  – `$route.path`, `$route.params.id`.

Given a bound argument, `update_*()` sets the field; with `v_model()`
that sets the store too, so everything bound to it follows; with
`v_bind()` the field keeps the update until the expression changes.
`v_bind()` on a component's value makes it controlled: it starts from
and follows the expression, and its user's change stays the component's
until the expression changes. With Shiny on the page the component
reports `input$<id>` as ever, so the server sees what the page did.

What can be bound: any of a component's props and its value, and what a
dialog's, drawer's, tabs' or collapse's `update_*()` can set. An
argument R reads to draw the component – a label, a class, whether
options are buttons – says it cannot be bound.

A bound value reaches the component as it is, as upstream's
`:prop="value"`: functions, `Date`s and components (an icon) included.
Data R converts – a select's `choices`, a mention's `options` – has two
rules, as DT's
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md):
an R value is given in R's terms (a named vector) and converted; a
`v_bind()` gives the library's own form, `[{ value, label }]`, as its
docs write it, and is not converted. Vue's development build (the page's
`dev = TRUE`) says when a bound list is not records.

A binding the page cannot read – a store it does not have, `$route` with
no
[`vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_router.md),
a path that runs through nothing – leaves its field unset and says so
once in the browser's console, naming what is missing. A field a store
simply does not have reads as `undefined`, as JavaScript does: that one
is not said.

## What `expr` becomes

A string – and a
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
– is JavaScript, as Vue's `:size="..."` is: `v_bind("large")` reads a
name `large`, and the text is `v_bind("'large'")`, quoted, as
`:size="'large'"`. Any other R value is a constant, its JSON:

|  |  |
|----|----|
| Given | In the browser |
| `"$vueStore.ui.size"` | the store's field, followed |
| `"1 + 1"` | `2` |
| `"'large'"` | the text `large` |
| `"large"` | the name `large` – an error where there is none |
| `1`, `TRUE` | `1`, `true` |
| `c(1, 2)` | `[1, 2]` (a vector of one is a scalar: `list(1)` for `[1]`) |
| `list("a", "b")` | `["a", "b"]` |
| `list(a = 1)` | `{a: 1}` |
| a data.frame | its rows, `[{...}, ...]` |
| `JS("() => 1")` | the function |

A constant needs no binding: an argument takes the R value itself,
`size = "large"`; `v_bind()` of a constant is for a raw template, whose
attributes are text (`el$input_number(min = v_bind(1))`). `NULL` and
`NA` are errors – leaving an argument unset is not giving it – as are
[`I()`](https://rdrr.io/r/base/AsIs.html), which Shiny gives opposite
meanings, and a vector of strings, which is data: `list("a", "b")`.

## Modules

Give `ns`, the module's
[`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) or its id, and
the expression is left as written while its names are the module's:
`$inputs.size` is `input$size` of the module, `$vueStore.ui` the store
made with `vue_store(ns("ui"))` – as `input$size` is inside
[`shiny::moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).
Without `ns`, the names are the page's, and a store named the same in
two instances of a module is one store.

## See also

[`v_on()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_on.md)
for acting in the browser;
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
    htmltools::tags$span("Large: {{ large }}"),
    data = list(large = v_bind("$inputs.size === 'large'"))
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
#>   <script type="text/x-template" data-shiny-vue-template><span>Large: {{ large }}</span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"large":null}},"bound":{"large":{"expr":"$inputs.size === 'large'"}},"evals":[]}</script>
#> </div>

# A store, set by one and followed by another
htmltools::tagList(
  vue_store("ui", state = list(open = FALSE)),
  vue_app(
    "toggle",
    htmltools::tags$button(`@click` = "open = !open", "Toggle"),
    data = list(open = v_model("$vueStore.ui.open"))
  ),
  vue_app("state", htmltools::tags$span("{{ $vueStore.ui.open }}"))
)
#> <div id="ui" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span hidden></span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"open":false}},"store":true,"evals":[]}</script>
#> </div>
#> <div id="toggle" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><button @click="open = !open">Toggle</button></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"open":null}},"bound":{"open":{"expr":"$vueStore.ui.open","model":true}},"evals":[]}</script>
#> </div>
#> <div id="state" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span>{{ $vueStore.ui.open }}</span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"evals":[]}</script>
#> </div>

# In a module: the module's input and store
panel_ui <- function(id) {
  ns <- shiny::NS(id)
  htmltools::tagList(
    vue_store(ns("ui"), state = list(open = FALSE)),
    vue_app(
      ns("shown"),
      htmltools::tags$span("{{ open }}"),
      data = list(open = v_bind("$vueStore.ui.open", ns = ns))
    )
  )
}
```
