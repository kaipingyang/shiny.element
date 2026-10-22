# Handlers of one event, run in turn

Handlers of one event, run in turn

## Usage

``` r
.vue_join_handlers(key, handlers)
```

## Arguments

- key:

  The attribute, `"@change"`.

- handlers:

  What each is given: a method's name or an arrow function, as
  [`.vue_on_attach()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_on_attach.md)
  writes.

## Value

One arrow function calling each, in order.
