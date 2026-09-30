# Rename an absorbed component's Vue fields

Two components folded into the same instance share one set of field
names, and most of them declare a `label`, a `type` or a `disabled`.
Prefixing one side's fields keeps them apart – but the markup and the
methods refer to those fields by name, so they have to be rewritten to
match.

## Usage

``` r
.el_prefix_absorbed(absorbed, prefix)
```

## Arguments

- absorbed:

  Output of
  [`.el_absorb()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_absorb.md).

- prefix:

  Prefix to apply, already a valid JS identifier fragment.

## Value

The same list, with every field renamed.

## Details

Only whole identifiers are renamed, and never inside a string literal:
`:class="data.isSelected ? 'is-selected' : ''"` names a CSS class, not a
field.
