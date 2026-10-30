# A binding: an expression, its kind and the names it is evaluated with

`scope` holds the prefixes the bridge resolves `$inputs` and `$vueStore`
under: a module's namespace for both; the prefix the package's articles
give components' ids
([`.vue_ui_id()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_ui_id.md))
for `$inputs` too.

## Usage

``` r
.vue_binding(code, kind, ns)
```

## Arguments

- code:

  The expression, path or statement.

- kind:

  `"v_bind"`, `"v_model"` or `"v_on"`.

- ns:

  `NULL`, a namespace function or a module's id.

## Value

The code, classed `c(kind, "vue_binding")`, with `scope`.
