# The rest of a component's arguments, set from its update function

`update_el_<name>(...)` takes any other argument of `el_<name>()` by its
name. Each sets the component's field of that name in camelCase
(`table_layout` -\> `tableLayout`) – the field the prop is bound to,
with `NA` standing for Element's default – or the field `rename` names.
`NULL` sends the prop back to Element's default. An argument the UI
function does not have, or one that cannot change once drawn (`skip`),
is an error; enumerated ones are checked as the UI function checks them.

## Usage

``` r
.el_update_props(fn, dots, skip = character(), rename = character())
```

## Arguments

- fn:

  The UI function's name, `"el_table"`.

- dots:

  The update's `list(...)`.

- skip:

  Arguments of `fn` an update cannot set this way.

- rename:

  `c(<argument> = "<field>")` for a field named otherwise.

## Value

A named list: field -\> value.
