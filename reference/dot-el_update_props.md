# Props an update function was given, as the component's fields

`update_el_<name>()` takes `el_<name>()`'s arguments under the same
names. Each sets the component's field of that name in camelCase
(`table_layout` -\> `tableLayout`) – the field the prop is bound to,
`NA` standing for Element's default – or the field `rename` names. An
argument the UI function does not have, or one that cannot change once
drawn (`skip`), is an error; enumerated ones are checked as the UI
function checks them.

## Usage

``` r
.el_update_props(fn, dots, skip = character(), rename = character())
```

## Arguments

- fn:

  The UI function's name, `"el_table"`.

- dots:

  The props given, named by their R names; leave out those the caller
  left `NULL`.

- skip:

  Arguments of `fn` an update cannot set this way.

- rename:

  `c(<argument> = "<field>")` for a field named otherwise.

## Value

A named list: field -\> value.
