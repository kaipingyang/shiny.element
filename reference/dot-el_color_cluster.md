# A colour and the ten Element derives from it

As Element's theme picker computes them, and Sass's `mix()` with them:
rounding half up, which R's
[`round()`](https://rdrr.io/r/base/Round.html) does not.

## Usage

``` r
.el_color_cluster(hex)
```

## Arguments

- hex:

  A colour, `"#RRGGBB"`.

## Value

Eleven lowercase hex colours: the colour, its tints at 10% to 90%
towards white, and its 10% shade towards black.
