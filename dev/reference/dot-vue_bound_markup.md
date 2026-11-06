# Arguments of a component drawn as markup, given v_bind() or v_model()

A component drawn as markup with a binding of its own (a dialog, tabs)
is no Vue app: the binding follows the expressions itself, from
`data-shiny-vue-bind`, `{"<field>": {expr, model, scope}}`, applying
each value as an update of that field would. Each bound argument is
drawn with its default meanwhile: the caller takes `values` back.

## Usage

``` r
.vue_bound_markup(values, defaults)
```

## Arguments

- values:

  The arguments an update can set, by name: those that may be bound.

- defaults:

  The component function's formals, for the defaults.

## Value

A list: `values`, the bound ones replaced by their defaults, and `json`,
the attribute's value, or `NULL` when none is bound.
