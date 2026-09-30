# Merge what several absorbed components contribute

Merge what several absorbed components contribute

## Usage

``` r
.el_absorb_merge(...)
```

## Arguments

- ...:

  Results of
  [`.el_absorb()`](https://kaipingyang.github.io/shiny.element/reference/dot-el_absorb.md).

## Value

One set of Vue options, the dependencies to attach, and each part's
markup as it now stands – renaming rewrites it, so the caller must
render `markups` rather than what it passed in.
