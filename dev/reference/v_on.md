# Vue's `v-on` for a component's event, in a module

`on = list(click = "$vueStore.ui.open = true")` runs Vue's inline
statement when the event fires, as `@click="..."` in a template, with
`$event` the event's first argument. In a module, `v_on(statement, ns)`
runs it with the module's names, as
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
evaluates an expression: `$vueStore.ui` is `vue_store(ns("ui"))`,
`$inputs.size` the module's input. Outside a module a plain string does
the same.

## Usage

``` r
v_on(statement, ns = NULL)
```

## Arguments

- statement:

  Vue's inline statement, a string.

- ns:

  In a module, its namespace: the function
  [`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) gives,
  `session$ns`, or the module's id.

## Value

The handler, to give as a value of `on`.

## Examples

``` r
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
