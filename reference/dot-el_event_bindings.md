# Forward Element UI events to Shiny inputs

Element's events carry different arguments each, some of them DOM nodes
or native events that cannot be serialised. Rather than write a handler
per event, each one is bound to a generated method that hands its
arguments to `shinyVue.emit()` (see `inst/js/shiny-vue.js`), which drops
what cannot travel and sets `input$<id>_<event>`.

## Usage

``` r
.el_event_bindings(ns_id, events, shapes = list())
```

## Arguments

- ns_id:

  The namespaced element id.

- events:

  Character vector of Element event names, in kebab-case.

- shapes:

  Named list of JavaScript functions, one per event that carries more
  than one argument, turning the arguments into a single object. `this`
  is the Vue instance. Returning `undefined` skips that emission.
  Without a shape, several arguments are sent as `arg1`, `arg2`, ...

## Value

A list with `attrs` (to merge into the tag) and `methods` (to merge into
the Vue options).
