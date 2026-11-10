# Refuse a binding of an argument R draws with

Run first in a component, over its own environment: an argument whose
kind is `markup` and which was given
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
or
[`v_model()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
is an error naming the function, the argument and the reason.

## Usage

``` r
.vue_check_bindings(
  fn,
  env,
  kinds,
  frame = c("id", "session", "events", "on", "slots")
)
```

## Arguments

- fn:

  The component function's name, for the message.

- env:

  Its environment.

- kinds:

  Its arguments' kinds
  ([`.vue_arg_kind()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_arg_kind.md)).

- frame:

  Arguments every component reads in R – its id, session, events,
  handlers and slots – refused whatever `kinds` says.

## Value

`NULL`, invisibly.
