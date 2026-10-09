# Add `on` handlers to a tag, beside any it already listens with

A tag carries one `@<event>`: where the component already listens to
that event – one it forwards – both run, its own first.

## Usage

``` r
.vue_on_attach(tag, on)
```

## Arguments

- tag:

  The component's tag.

- on:

  Output of
  [`.vue_on_bindings()`](https://kaipingyang.github.io/shiny.element/reference/dot-vue_on_bindings.md).

## Value

The tag.
