# State shared by Vue components: a store

Each
[`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md)
is an application of its own, so Vue's `provide` and `inject` cannot
reach from one to another. Vue's answer is a store, and its store is
Pinia's: this is one, defined from R with Pinia's own parts – `state`,
`getters`, `actions`, or a `setup` function – and reached in every
template as `$store.<id>`: `$store.cart.count`, a getter
`$store.cart.total`, an action `$store.cart.add(1)`, at once and in the
browser. In a component's `setup()`, `shinyVue.useStore("<id>")` gives
the Pinia store itself (`Pinia.storeToRefs()` works on it).

## Usage

``` r
vue_store(
  id,
  state = list(),
  getters = NULL,
  actions = NULL,
  setup = NULL,
  input = NULL,
  outputs = NULL,
  data = NULL
)
```

## Arguments

- id:

  The store's id: `$store.<id>` in templates, Pinia's store id.

- state:

  Named list: the initial state.

- getters:

  Named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  functions of `state`, as Pinia's getters: values computed from the
  state, cached.

- actions:

  Named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  functions, as Pinia's actions: `this` is the store.

- setup:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  function returning the store's refs, computed and functions: Pinia's
  setup store, instead of `state`, `getters` and `actions`.

- input:

  Fields reported as `input$<id>`, as for
  [`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md):
  state or getters.

- outputs:

  Outputs the store's state follows, as for
  [`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md).

- data:

  Deprecated: `state`, under Vue's name for a component's state.

## Value

A tag: a hidden host that holds the store.

## Details

It is also a component of the bridge, so the server reaches it the way
it reaches any other: `input` makes fields or getters `input$<id>`,
[`update_vue()`](https://kaipingyang.github.io/shiny.element/dev/reference/update_vue.md)
sets its state – and every template showing it follows –,
[`call_vue()`](https://kaipingyang.github.io/shiny.element/dev/reference/call_vue.md)
runs an action, its value coming back as `input$<id>_<action>`,
`outputs` fill its state from the server, and a bookmark restores it.

A store can be anywhere on the page; stores are set up before the
components that read them.

## Examples

``` r
vue_store(
  "cart",
  state = list(count = 0, price = 3),
  getters = list(
    total = JS("function(state) { return state.count * state.price; }")
  ),
  actions = list(add = JS("function(n) { this.count += n; }")),
  input = "total"
)
#> <div id="cart" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span hidden></span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"count":0,"price":3}},"input":"total","store":true,"storeDef":{"getters":{"total":"function(state) { return state.count * state.price; }"},"actions":{"add":"function(n) { this.count += n; }"}},"evals":["storeDef.getters.total","storeDef.actions.add"]}</script>
#> </div>
vue_app("add", htmltools::tags$button(`@click` = "$store.cart.add(1)", "Add"))
#> <div id="add" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><button @click="$store.cart.add(1)">Add</button></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"evals":[]}</script>
#> </div>
vue_app(
  "show",
  htmltools::tags$span("{{ $store.cart.count }} for {{ $store.cart.total }}")
)
#> <div id="show" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span>{{ $store.cart.count }} for {{ $store.cart.total }}</span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"evals":[]}</script>
#> </div>
```
