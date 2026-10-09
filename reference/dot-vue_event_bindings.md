# Forward a component's events to Shiny inputs

Events carry different arguments each, some of them DOM nodes or native
events that cannot be serialised. Rather than write a handler per event,
each one is bound to a generated method that hands its arguments to
`shinyVue.emit()` (see `inst/js/shiny-vue.js`), which drops what cannot
travel and sets `input$<id>_<event>`.

## Usage

``` r
.vue_event_bindings(
  ns_id,
  events,
  on = NULL,
  shapes = list(),
  throttle = character(),
  bound = character()
)
```

## Arguments

- ns_id:

  The namespaced element id.

- events:

  The events forwarded, by their Vue names (kebab-case).

- on:

  The user's own handlers: see
  [`.vue_on_bindings()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_on_bindings.md).

- shapes:

  Named list of JavaScript functions, one per event that carries more
  than one argument, turning the arguments into a single object. `this`
  is the Vue instance. Returning `undefined` skips that emission.
  Without a shape, several arguments are sent as `arg1`, `arg2`, ...

- throttle:

  Events that fire on every frame – a scroll, a drag – sent at most
  every 200 ms, the last one always: the server hears where the scroll
  or the drag ended.

- bound:

  Events the component listens to whether or not they are reported,
  through the method of the same name, which it wraps: a tree's
  `check-change` keeps its checked keys.

## Value

A list with `attrs` (to merge into the tag) and `methods` (to merge into
the Vue options).
