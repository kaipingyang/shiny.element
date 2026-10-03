# Add gutter padding to a column

Element Plus's Col reads `gutter` off its parent Row and emits the
padding inline, so the same has to happen here rather than through a CSS
class.

## Usage

``` r
.el_col_gutter(child, half)
```

## Arguments

- child:

  A column tag, or any other child (returned untouched).

- half:

  Half the gutter width, in pixels.

## Value

The child with padding merged into its `style`.
