# Rename the fields of record options, as Element Plus's `props` does

Rename the fields of record options, as Element Plus's `props` does

## Usage

``` r
.el_rename_option_fields(choices, props)
```

## Arguments

- choices:

  The choices as given.

- props:

  `list(value =, label =, disabled =, options =)`: the fields holding
  each, or `NULL`.

## Value

The choices, with the fields
[`.el_select_choices()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_select_choices.md)
reads.
