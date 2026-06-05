# Element UI icon tag

Creates an icon tag supporting Element UI icons, Font Awesome, or plain
tags. Follows the same dispatch pattern as
[`shiny::icon()`](https://rdrr.io/pkg/shiny/man/icon.html), with
accessibility attributes inspired by `bsicons::bs_icon()`.

## Usage

``` r
el_icon(
  name,
  size = NULL,
  class = NULL,
  title = NULL,
  a11y = c("auto", "deco", "sem", "none"),
  lib = c("element-ui", "font-awesome", "none"),
  ...
)
```

## Arguments

- name:

  Icon name. For `lib = "element-ui"`, the `el-icon-` prefix is optional
  and will not be doubled (e.g. `"search"` and `"el-icon-search"` both
  work). Names are lowercased and spaces replaced with `-`.

- size:

  CSS size string (e.g. `"1.5em"`, `"20px"`). Applied as `font-size` on
  the `<i>` tag. `NULL` (default) leaves the size unset.

- class:

  Additional CSS class(es) to append.

- title:

  Accessible title string. When provided, it also drives `a11y` (see
  below).

- a11y:

  Accessibility mode. One of:

  `"auto"` (default)

  :   `"deco"` when `title` is `NULL`, `"sem"` otherwise.

  `"deco"`

  :   Decorative icon: adds `aria-hidden="true"` and `role="img"`.

  `"sem"`

  :   Semantic icon: adds `aria-label` (using `title` or `name`) and
      `role="img"`.

  `"none"`

  :   No accessibility attributes added.

- lib:

  Icon library. One of:

  `"element-ui"` (default)

  :   Renders `<i class="el-icon-{name}">`.

  `"font-awesome"`

  :   Delegates to
      [`fontawesome::fa_i()`](https://rstudio.github.io/fontawesome/reference/fa_i.html).
      Requires the `fontawesome` package.

  `"none"`

  :   Renders a plain `<i>` tag with no icon class.

- ...:

  Additional HTML attributes passed to the `<i>` tag.

## Value

An `htmltools` tag object.

## Examples

``` r
el_icon("search")
#> <i class="el-icon-search" aria-hidden="true" role="img"></i>
el_icon("edit", size = "1.5em")
#> <i class="el-icon-edit" style="font-size:1.5em;" aria-hidden="true" role="img"></i>
el_icon("delete", title = "Delete item")
#> <i class="el-icon-delete" title="Delete item" aria-label="Delete item" role="img"></i>
el_icon("close", a11y = "deco")
#> <i class="el-icon-close" aria-hidden="true" role="img"></i>
```
