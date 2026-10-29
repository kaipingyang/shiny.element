# Handlers of the user's own, as `on`

A
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
function becomes a method the component's tag listens with: `@<event>`.
It is called with `report` first – `report(name, value)` sets
`input$<id>_<name>` – then the event's own arguments, and `this` the Vue
instance. A string is Vue's inline statement, as `@click="..."` takes it
– `"$store.ui.open = true"`, `$event` the event's first argument –
written into the template as it is, inside the arrow function the tag's
handlers are joined in.

## Usage

``` r
.vue_on_bindings(ns_id, on)
```

## Arguments

- ns_id:

  The namespaced id.

- on:

  A named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  functions or strings.

## Value

A list with `attrs` and `methods`.
