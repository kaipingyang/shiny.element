# Optional props, bound and given their data

Element Plus's props that keep its own default unless given: each is
bound as `:kebab-name` to a field of the same camelCase name, through
[`.el_optional_bind()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_optional_bind.md),
and the field holds the value or `NA` (read back as `undefined`,
Element's default).

## Usage

``` r
.el_props(values, prefix = NULL, rename = NULL)
```

## Arguments

- values:

  A named list, names in snake_case as the R arguments are.

- prefix:

  A prefix for the fields' names, or `NULL`.

- rename:

  Named character vector: an argument's name, and the prop it stands
  for, where the two differ.

## Value

A list of `attrs` (for the tag) and `data` (for the Vue data).
