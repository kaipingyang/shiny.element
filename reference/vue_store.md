# State shared by Vue components: a store

Each
[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md)
is an application of its own, so Vue's `provide` and `inject` cannot
reach from one to another. Vue's guide answers shared state with a
store, one [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)
object every component refers to, and this is that: every template reads
and writes it as `$store.<id>.<field>`, at once and in the browser. It
is also a component of the bridge, so the server reaches it the way it
reaches any other: `input` makes fields `input$<id>`,
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
sets them – and every template showing them follows – and a bookmark
restores them.

## Usage

``` r
vue_store(id, data = list(), input = NULL)
```

## Arguments

- id:

  The store's id: `$store.<id>` in templates.

- data:

  Named list: the initial state.

- input:

  Fields reported as `input$<id>`, as for
  [`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md).

## Value

A tag: a hidden host that holds the store.

## Details

A store can be anywhere on the page; stores are set up before the
components that read them.

## Examples

``` r
vue_store("cart", data = list(count = 0), input = "count")
#> <div id="cart" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span hidden></span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"count":0}},"input":"count","store":true,"evals":[]}</script>
#> </div>
vue_app("add", htmltools::tags$button(`@click` = "$store.cart.count++", "Add"))
#> <div id="add" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><button @click="$store.cart.count++">Add</button></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"evals":[]}</script>
#> </div>
vue_app("show", htmltools::tags$span("{{ $store.cart.count }} in the cart"))
#> <div id="show" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><span>{{ $store.cart.count }} in the cart</span></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":[]},"evals":[]}</script>
#> </div>
```
