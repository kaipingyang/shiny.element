# Normalise `choices` into option configs

Accepts a named vector (`c(Label = value)`), an unnamed vector, or a
list already shaped as `list(value = , label = )` items, and returns the
list form that `el-option` / `el-radio` / `el-checkbox` iterate over.

## Usage

``` r
.el_normalize_choices(choices)
```

## Arguments

- choices:

  A named vector, an unnamed vector, or a list of configs.

## Value

An unnamed list of `list(value = , label = )` items.

## Details

The named branch deliberately does not require a character vector. It
used to, so `c(Beijing = 1, Shanghai = 2)` fell through to the unnamed
branch: the labels were lost (rendered as "1" and "2") and the surviving
names turned the serialised JSON into an object rather than the array
`v-for` expects.
