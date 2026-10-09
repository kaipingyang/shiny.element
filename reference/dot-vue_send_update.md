# Send fields to a component: the shinyVueUpdate message

Send fields to a component: the shinyVueUpdate message

## Usage

``` r
.vue_send_update(session, msg, immediate = FALSE)
```

## Arguments

- session:

  A Shiny session.

- msg:

  `list(id =, <field> = <value>, ...)`; dot-keys are the bridge's.

- immediate:

  Send now rather than with the flush: see
  [`.vue_send()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_send.md).

## Value

`NULL`, invisibly.
