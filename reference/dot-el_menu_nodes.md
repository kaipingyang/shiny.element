# Build the nested tags inside an `el-menu`

Menus nest arbitrarily deep, so the tree is generated in R rather than
with `v-for`: a template can only repeat one level, and a menu's shape
is fixed at render time anyway.

## Usage

``` r
.el_menu_nodes(items)
```

## Arguments

- items:

  A list of item descriptions, see
  [`el_menu()`](https://kaipingyang.github.io/shiny.element/reference/el_menu.md).

## Value

A list of tags.
