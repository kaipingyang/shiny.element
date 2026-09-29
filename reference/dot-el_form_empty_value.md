# Empty value for a field type

Picked so the initial model round-trips as the right JSON type, and so
`resetFields()` has something sensible to reset to.

## Usage

``` r
.el_form_empty_value(type)
```

## Arguments

- type:

  A field type from
  [.el_form_tags](https://kaipingyang.github.io/shiny.element/reference/dot-el_form_tags.md).

## Value

The type's empty value.
