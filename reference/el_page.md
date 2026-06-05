# Element UI Page Wrapper with Theme Support

Top-level page constructor that loads Element-UI, Vue, and layout CSS
dependencies, and supports both bslib/shiny themes and Element-UI layout
CSS.

## Usage

``` r
el_page(
  ...,
  title = NULL,
  theme = bslib::bs_theme(version = 5, bootswatch = "minty"),
  theme_css = el_layout_css_dependency()
)
```

## Arguments

- ...:

  UI elements to include in the page body.

- title:

  Optional page title.

- theme:

  Optional bslib or shiny theme object (e.g.,
  [`bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html))
  for Bootstrap styling. If provided, Bootstrap dependencies will be
  included.

- theme_css:

  Optional Element-UI layout CSS dependency (default:
  [`el_layout_css_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_layout_css_dependency.md)).
  Set to `NULL` to disable Element-UI layout CSS.

## Details

Use this as the root UI function for your Shiny app. You can combine
bslib layouts (such as `page_sidebar`, `layout_columns`) and Element-UI
widgets (such as `el_button`).

The `el_page` function is designed to work with both bslib layouts and
Element-UI widgets. Do not mix Element-UI layout functions
(`el_container`, `el_row`, `el_col`) with bslib layouts, as they are not
compatible. The Element-UI layout functions are experimental and may be
deprecated in the future.
