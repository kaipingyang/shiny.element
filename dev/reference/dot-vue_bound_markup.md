# Arguments of a component drawn as markup, given v_bind() or v_model()

A component drawn as markup with a binding of its own (a dialog, tabs)
is no Vue app: the binding follows the expressions itself, from
`data-shiny-vue-bind`, `{"<field>": {expr, model, scope}}`, applying
each value as an update of that field would. Each bound argument is
drawn with its default meanwhile.

## Usage

``` r
.vue_bound_markup(env, defaults, args)
```

## Arguments

- env:

  The component function's environment.

- defaults:

  The function's formals, for the defaults.

- args:

  The arguments an update can set: those that may be bound.

## Value

The attribute's JSON, or `NULL` when none is bound.
