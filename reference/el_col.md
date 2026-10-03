# Element Plus Layout Column

Emits `<div class="el-col el-col-N">` directly; see
[`el_row()`](https://kaipingyang.github.io/shiny.element/reference/el_row.md)
for why.

## Usage

``` r
el_col(
  ...,
  span = 24,
  offset = NULL,
  push = NULL,
  pull = NULL,
  xs = NULL,
  sm = NULL,
  md = NULL,
  lg = NULL,
  xl = NULL,
  tag = "div",
  class = NULL,
  style = NULL
)
```

## Arguments

- ...:

  Column content.

- span:

  Column span out of 24. Defaults to 24, as in Element Plus.

- offset:

  Columns to offset by.

- push:

  Columns to push right.

- pull:

  Columns to pull left.

- xs, sm, md, lg, xl:

  Responsive spans. Either a number (the span) or a list such as
  `list(span = 12, offset = 6)`.

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
el_col(span = 12, "half width")
#> <div class="el-col el-col-12">half width</div>
el_col(span = 6, offset = 6, "quarter, pushed right")
#> <div class="el-col el-col-6 el-col-offset-6">quarter, pushed right</div>
el_col(xs = 24, sm = 12, md = 8, "responsive")
#> <div class="el-col el-col-24 el-col-xs-24 el-col-sm-12 el-col-md-8">responsive</div>
el_col(md = list(span = 12, offset = 6), "responsive with offset")
#> <div class="el-col el-col-24 el-col-md-12 el-col-md-offset-6">responsive with offset</div>
```
