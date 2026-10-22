# One mounted hook running several in turn

When every hook is only reporting – what .vue_mounted_report() writes –
the result says so, with every field each reports: el_widget() then
binds the component's own value to Shiny, as it does for any other, and
reports the folded components' under their ids.

## Usage

``` r
.el_join_mounted(mounts)
```

## Arguments

- mounts:

  A list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  hooks, `NULL`s dropped.

## Value

One hook, or `NULL`.
