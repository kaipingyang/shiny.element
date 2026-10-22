# Element Plus icon

An icon from Element Plus's set, Font Awesome, or a plain tag. Follows
the same dispatch pattern as
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
  lib = c("element-plus", "font-awesome", "none"),
  ...,
  color = NULL
)
```

## Arguments

- name:

  Icon name, as Element Plus spells it – `"Search"`, `"ArrowRight"` – or
  in any of the forms that reach the same name: `"search"`,
  `"arrow-right"`, `"arrow right"`, and Element UI's
  `"el-icon-arrow-right"`.

- size:

  CSS size string (e.g. `"1.5em"`, `"20px"`), as Element Plus's
  `<el-icon size>`. `NULL` (default) follows the surrounding text.

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

  `"element-plus"` (default)

  :   Element Plus's icon set.

  `"font-awesome"`

  :   Delegates to
      [`fontawesome::fa_i()`](https://rstudio.github.io/fontawesome/reference/fa_i.html).
      Requires the `fontawesome` package.

  `"none"`

  :   Renders a plain `<i>` tag with no icon class.

- ...:

  Additional HTML attributes passed to the `<i>` tag.

- color:

  Icon colour, as Element Plus's `<el-icon color>`. `NULL` follows the
  surrounding text.

## Value

An `htmltools` tag object.

## Details

Element Plus's icons are SVG components (`@element-plus/icons-vue`,
bundled): the tag is an `<i class="el-icon">` naming its icon, drawn by
the page wherever it lands – inside a component or not.

## Examples

``` r
el_icon("Search")
#> <i class="el-icon" data-el-icon="Search" aria-hidden="true" role="img"></i>
el_icon("edit", size = "1.5em")
#> <i class="el-icon" data-el-icon="Edit" style="font-size:1.5em;" aria-hidden="true" role="img"></i>
el_icon("Delete", title = "Delete item", color = "#f56c6c")
#> <i class="el-icon" data-el-icon="Delete" style="--color:#f56c6c;" title="Delete item" aria-label="Delete item" role="img"></i>
el_icon("close", a11y = "deco")
#> <i class="el-icon" data-el-icon="Close" aria-hidden="true" role="img"></i>
```
