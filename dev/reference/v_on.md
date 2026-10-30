# Vue's `v-on`: handlers in a template, or in a module

In a template – a
[`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md)'s,
`el$` tags, a slot, a cell –
`v_on(click = "n++", "keyup.enter" = "send()")` gives the tag its
handlers, as `@click="n++"` does: Vue's inline statements, `$event` the
event's first argument, modifiers in the name as Vue writes them.

## Usage

``` r
v_on(..., ns = NULL)
```

## Arguments

- ...:

  In a template, handlers by event: `click = "n++"`. As a value of `on`,
  one statement, unnamed.

- ns:

  In a module, its namespace: the function
  [`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) gives,
  `session$ns`, or the module's id.

## Value

Attributes for a tag, or a handler for `on`.

## Details

As a value of a component's `on`, `v_on("statement", ns = ns)` is a
statement run with a module's names, as
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
evaluates an expression: `$vueStore.ui` is `vue_store(ns("ui"))`,
`$inputs.size` the module's input. Outside a module a plain string does
the same: `on = list(click = "$vueStore.ui.open = true")`.

## See also

Other directives:
[`directives`](https://kaipingyang.github.io/shiny.element/dev/reference/directives.md)

## Examples

``` r
vue_app(
  "counter",
  htmltools::tags$button(v_on(click = "n++"), "Clicked {{ n }} times"),
  data = list(n = 0)
)
#> <div id="counter" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><button @click="n++">Clicked {{ n }} times</button></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"n":0}},"evals":[]}</script>
#> </div>

panel_ui <- function(id) {
  ns <- shiny::NS(id)
  htmltools::tagList(
    vue_store(ns("ui"), state = list(n = 0)),
    vue_app(
      ns("add"),
      htmltools::tags$button("Add"),
      on = list(click = v_on("$vueStore.ui.n++", ns = ns))
    )
  )
}
```
