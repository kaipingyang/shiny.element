# Element Plus Layout Row

Emits `<div class="el-row">` directly rather than an `<el-row>` custom
tag. Nothing mounts a Vue instance over page-level markup, so a custom
tag would never be compiled and would render as an unstyled inline
element; the Element Plus stylesheet is already loaded, so the class
name is all that is needed.

## Usage

``` r
el_row(
  ...,
  gutter = NULL,
  type = NULL,
  justify = NULL,
  align = NULL,
  tag = "div",
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

  Element UI's `"flex"`, kept so old code runs: Element Plus's row is
  always a flex row, and `justify` and `align` apply without it.

- justify:

  Flex horizontal alignment: `"start"` (default), `"center"`, `"end"`,
  `"space-between"` or `"space-around"`.

- align:

  Flex vertical alignment: `"top"` (default), `"middle"` or `"bottom"`.

- tag:

  HTML element to render, as Element's `tag`. Default `"div"`; `"ul"`
  and `"li"` suit a grid of list items.

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
#>   <div class="el-col el-col-12 is-guttered" style="padding-left:10px; padding-right:10px">left</div>
#>   <div class="el-col el-col-12 is-guttered" style="padding-left:10px; padding-right:10px">right</div>
#> </div>

# Centred row
el_row(
  justify = "center",
  align = "middle",
  el_col(span = 8, "centred")
)
#> <div class="el-row is-justify-center is-align-middle">
#>   <div class="el-col el-col-8">centred</div>
#> </div>
```
