# Keep only the fields an entry actually sets

A `v-for` binding reading a missing property gets `undefined`, which is
what makes Element fall back to a prop's default. Filling the gaps with
NA would send JSON null instead, and null is a value: an entry without
`placement` then matched neither `placement === 'top'` nor `'bottom'`,
so its timestamp rendered nowhere at all.

## Usage

``` r
.el_timeline_items(items)
```

## Arguments

- items:

  A list of entries.

## Value

The entries with unknown and empty fields dropped.
