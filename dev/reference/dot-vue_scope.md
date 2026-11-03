# The names a module's code is evaluated with

As Shiny's `conditionalPanel(ns =)` narrows `input` to a module's: the
prefixes the bridge resolves `$inputs`, `$find()` and `$vueStore` (and
the other page state) under – the module's namespace for both, and the
prefix the package's articles give components' ids
([`.vue_ui_id()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_ui_id.md))
for the components' too.

## Usage

``` r
.vue_scope(ns)
```

## Arguments

- ns:

  `NULL`, a namespace function or a module's id.

## Value

`NULL`, or a list of `inputs` and `store` prefixes.
