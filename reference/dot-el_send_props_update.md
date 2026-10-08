# Send an update of a component's props

For the components whose props are all bound through
[`.el_props()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_props.md):
the fields are named as the component's own, prefix and renames
included, so an update reaches what the UI declared.

## Usage

``` r
.el_send_props_update(session, id, fn, values, prefix = NULL, rename = NULL)
```

## Arguments

- session:

  The Shiny session.

- id:

  The component's id.

- fn:

  The UI function, whose arguments the values are checked against.

- values:

  Named list of the arguments given; `NULL` ones are left out.

- prefix, rename:

  As for
  [`.el_props()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_props.md).

## Value

`NULL`, invisibly.
