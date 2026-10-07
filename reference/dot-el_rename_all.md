# Rename identifiers all at once

One pass over every name: renamed one after another, a field renamed to
`el3_label` would be renamed again by a rule for `el3_label` – two
buttons in one popover, absorbed twice over, then showed the second
one's label on both.

## Usage

``` r
.el_rename_all(x, rename, before)
```

## Arguments

- x:

  Character vector.

- rename:

  Named character vector, old name to new.

- before:

  A lookbehind that must precede a name.

## Value

`x`, renamed.
