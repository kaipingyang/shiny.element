# Refuse a value Element does not accept

Called first thing by every component with an enumerated argument: a
typo – `type = "primry"` – is an error naming the values that work,
rather than a component Element quietly draws in its default style.
Exact matching, unlike
[`match.arg()`](https://rdrr.io/r/base/match.arg.html): `"prim"` is not
`"primary"` to Element either.

## Usage

``` r
.el_check_choices(fn, env)
```

## Arguments

- fn:

  The function's name, a key of
  [.el_choices](https://kaipingyang.github.io/shiny.element/reference/dot-el_choices.md).

- env:

  Its evaluation environment.

## Value

`NULL`, invisibly; or an error.
