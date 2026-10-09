# Handlers of the user's own, as `on`

Each becomes a method the component's tag listens with: `@<event>`. The
handler is called with `report` first – `report(name, value)` sets
`input$<id>_<name>` – then the event's own arguments, and `this` the Vue
instance.

## Usage

``` r
.vue_on_bindings(ns_id, on)
```

## Arguments

- ns_id:

  The namespaced id.

- on:

  A named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions.

## Value

A list with `attrs` and `methods`.
