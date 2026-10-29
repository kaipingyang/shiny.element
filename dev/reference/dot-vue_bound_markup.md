# Arguments of a component drawn as markup, given vue_bind()

A component drawn as markup with a binding of its own (a dialog, tabs)
is no Vue app: the binding follows the paths itself, from
`data-shiny-vue-bind`, `{"<field>": "<path>"}`, applying each value as
an update of that field would. Each bound argument is drawn with its
default meanwhile. Its state – its value – can be bound to a store
alone.

## Usage

``` r
.vue_bound_markup(env, defaults, args, state)
```

## Arguments

- env:

  The component function's environment.

- defaults:

  The function's formals, for the defaults.

- args:

  The arguments an update can set: those that may be bound.

- state:

  The one that is the component's value.

## Value

The attribute's JSON, or `NULL` when none is bound.
