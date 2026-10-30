# Vue's reactivity for the page: `ref()`, `reactive()`, `computed()`, `watch()`

State the page's components share, in the browser, made with Vue's own
functions – the shapes Shiny's server has, on the other side:

## Usage

``` r
vue_ref(id, value = NULL, input = FALSE)

vue_reactive(id, value = list(), input = FALSE)

vue_computed(id, expr, ns = NULL, input = FALSE)

vue_watch(
  source,
  handler,
  immediate = FALSE,
  deep = FALSE,
  ns = NULL,
  use = NULL
)
```

## Arguments

- id:

  The state's name: `$vueRef.<id>`, and `input$<id>`.

- value:

  The initial value: for `vue_reactive()`, a named list.

- input:

  Whether to report it as `input$<id>`.

- expr, source:

  A JavaScript expression over the page's state, a string:
  `"$vueRef.count * 2"`.

- ns:

  In a module, its namespace: the function
  [`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) gives,
  `session$ns`, or the module's id.

- handler:

  What `vue_watch()` runs: Vue's inline statement, a string, or a
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  function `function(value, oldValue)`.

- immediate, deep:

  As Vue's `watch()`: run once at the start; follow changes inside
  objects.

- use:

  For `vue_watch()`, the Vue plugins its statement uses, as
  [`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md)'s:
  a component library's message service, for one.

## Value

A tag to put on the page; it draws nothing.

## Details

|  |  |  |  |
|----|----|----|----|
| Shiny (server) | Vue | Here (browser) | Read as |
| [`reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html) | `ref()` | `vue_ref(id, value)` | `$vueRef.<id>` |
| [`reactiveValues()`](https://rdrr.io/pkg/shiny/man/reactiveValues.html) | [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) | `vue_reactive(id, list())` | `$vueReactive.<id>.<field>` |
| [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) | `computed()` | `vue_computed(id, expr)` | `$vueComputed.<id>` |
| [`observe()`](https://rdrr.io/pkg/shiny/man/observe.html) | `watch()` | `vue_watch(source, handler)` | – |

Each component is a Vue app of its own, and a template compiled in the
browser cannot import: what upstream shares through a module of refs,
these share through the names every app sees – in templates, in
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
and
[`v_model()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
expressions, in `on` statements, and in a component's `setup()` as
`shinyVue.useRef(id)`, `useReactive(id)`, `useComputed(id)`. A
[`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md)
is the same with Pinia's getters and actions, for a whole piece of
logic.

Each is a component of the page with no markup, so the server reaches it
as any: `input = TRUE` reports it as `input$<id>` (a ref's and a
computed's value, a reactive's object), and
`update_vue(session, id, value = )` sets a ref,
`update_vue(session, id, <field> = )` a reactive's field.

`vue_watch()` runs `handler` whenever `source` changes: Vue's inline
statement, with `$value` and `$oldValue`, or a
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
function of the two. It acts in the browser – a store set, a message
from a component library it is given with `use` – and stops when it
leaves the page.

In a module, give the id as `ns("count")` and `ns` to the expressions
that read it, as for
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md).

## See also

[`vue_store()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_store.md);
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md),
[`v_model()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
to bind arguments to them.

## Examples

``` r
htmltools::tagList(
  vue_ref("count", 0),
  vue_computed("twice", "$vueRef.count * 2"),
  vue_watch(
    "$vueRef.count",
    "console.log('count is', $value)"
  ),
  vue_app(
    "counter",
    htmltools::tags$button(
      v_on(click = "$vueRef.count++"),
      "{{ $vueRef.count }} -> {{ $vueComputed.twice }}"
    )
  )
)
#> <div id="count" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span hidden></span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":0}},"state":{"kind":"ref"},"evals":[]}</script>
#> </div>
#> <div id="twice" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span hidden></span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"state":{"kind":"computed","expr":{"expr":"$vueRef.count * 2"}},"evals":[]}</script>
#> </div>
#> <div id="vue_watch_9ca8955a-782e-4974-a50e-5ced4c423a09" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span hidden></span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"state":{"kind":"watch","source":{"expr":"$vueRef.count"},"handler":"console.log('count is', $value)","statement":true,"immediate":false,"deep":false},"evals":[]}</script>
#> </div>
#> <div id="counter" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><button @click="$vueRef.count++">{{ $vueRef.count }} -&gt; {{ $vueComputed.twice }}</button></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"evals":[]}</script>
#> </div>
```
