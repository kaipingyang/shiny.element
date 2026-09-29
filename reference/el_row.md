# Element UI Layout Row

Emits `<div class="el-row">` directly rather than an `<el-row>` custom
tag. Nothing mounts a Vue instance over page-level markup, so a custom
tag would never be compiled and would render as an unstyled inline
element; the Element UI stylesheet is already loaded, so the class name
is all that is needed.

## Usage

``` r
el_row(
  ...,
  gutter = NULL,
  type = NULL,
  justify = NULL,
  align = NULL,
  class = NULL,
  style = NULL
)
```

## Arguments

- ...:

  Child columns
  ([`el_col()`](https://kaipingyang.github.io/shiny.element/reference/el_col.md))
  or other content.

- gutter:

  Spacing between columns, in pixels.

- type:

  Set to `"flex"` for the flex layout, which `justify` and `align`
  require.

- justify:

  Flex horizontal alignment: `"start"` (default), `"center"`, `"end"`,
  `"space-between"` or `"space-around"`.

- align:

  Flex vertical alignment: `"top"` (default), `"middle"` or `"bottom"`.

- class:

  Extra CSS classes.

- style:

  Extra inline style.

## Value

A Shiny UI element.

## Examples

``` r
# Two equal columns with a 20px gutter
el_row(
  gutter = 20,
  el_col(span = 12, "left"),
  el_col(span = 12, "right")
)
#> <div class="el-row" style="margin-left:-10px; margin-right:-10px">
#>   <div class="el-col el-col-12" style="padding-left:10px; padding-right:10px">left</div>
#>   <div class="el-col el-col-12" style="padding-left:10px; padding-right:10px">right</div>
#> </div>

# Centred flex row
el_row(
  type = "flex", justify = "center", align = "middle",
  el_col(span = 8, "centred")
)
#> <div class="el-row el-row--flex is-justify-center is-align-middle">
#>   <div class="el-col el-col-8">centred</div>
#> </div>
```
