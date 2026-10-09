# Forward Element Plus events to Shiny inputs

The component's entry in
[`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md)
– the events on by default, and those the user asked for with `events` –
forwarded by the Vue layer
([`.vue_event_bindings()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_event_bindings.md)),
with the user's own handlers, `on`.

## Usage

``` r
.el_event_bindings(
  ns_id,
  fn,
  asked = NULL,
  on = NULL,
  shapes = list(),
  throttle = character(),
  bound = character()
)
```

## Arguments

- ns_id:

  The namespaced element id.

- fn:

  The component's function name, its entry in the registry.

- asked:

  The user's `events`.

- on, shapes, throttle, bound:

  As for
  [`.vue_event_bindings()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_event_bindings.md).

## Value

A list with `attrs` (to merge into the tag) and `methods` (to merge into
the Vue options).
