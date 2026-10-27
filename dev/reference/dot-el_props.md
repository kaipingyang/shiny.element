# Optional props, given their data

Element Plus's props that keep its own default unless given: each has a
field of its camelCase name holding the value, `NA` when unset
(Element's default, `undefined` in the browser; `JS("null")` is a
deliberate `null`), and an entry naming that field for the prop.
[`.el_bind_props()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-el_bind_props.md)
binds the entries on their tag as one group,
`v-bind="$optional('<group>')"`
([`.vue_optional_props()`](https://kaipingyang.github.io/shiny.element/dev/reference/dot-vue_optional_props.md));
[`el_widget()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_widget.md)
does it for its root tag.

## Usage

``` r
.el_props(values, prefix = NULL, rename = NULL, fields = NULL)
```

## Arguments

- values:

  A named list, names in snake_case as the R arguments are.

- prefix:

  A prefix for the fields' names, or `NULL`.

- rename:

  Named character vector: an argument's name, and the prop it stands
  for, where the two differ.

- fields:

  `c(<argument> = "<field>")`: a field named otherwise than the prop, as
  an update function already sets it.

## Value

A list of `data` (for the Vue data) and `entries`
(`<prop-kebab> = <field>`, or `list(field =, wrap =)`), not yet bound to
a tag.
