# Build one of the Element Plus container parts

Build one of the Element Plus container parts

## Usage

``` r
.el_container_part(
  class,
  children,
  size = NULL,
  size_prop = NULL,
  style = NULL,
  extra_class = NULL
)
```

## Arguments

- class:

  The Element Plus class name, e.g. `"el-header"`.

- children:

  Child elements.

- size:

  The `height` or `width`, or `NULL`: Element's CSS variable,
  `--el-header-height`.

- size_prop:

  Which size it is.

- style:

  Extra inline style.

- extra_class:

  Extra CSS classes.

## Value

A Shiny UI element.
