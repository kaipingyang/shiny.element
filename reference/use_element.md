# Load All Element-UI Dependencies

Convenience function to load Vue, Element-UI, and layout CSS
dependencies. Use this when you want to use Element-UI components in
non-el_page layouts (e.g., bslib::page_sidebar, shiny::navbarPage).

## Usage

``` r
use_element(
  theme = el_layout_css_dependency(),
  offline = TRUE,
  dev = getOption("shiny.element.dev", FALSE),
  locale = getOption("shiny.element.locale", "en"),
  size = NULL,
  z_index = NULL,
  colors = NULL
)
```

## Arguments

- theme:

  CSS dependency function or list (optional, default is
  el_layout_css_dependency())

- offline:

  Serve Element UI from the copy bundled with this package rather than
  the unpkg CDN. See
  [`element_ui_dependency()`](https://kaipingyang.github.io/shiny.element/reference/element_ui_dependency.md).

- dev:

  Load the development build of Vue instead of `vue.min.js`, so Vue's
  warnings are not stripped. Defaults to
  `getOption("shiny.element.dev", FALSE)`.

- locale:

  Language for Element UI's built-in text. English by default, or
  `getOption("shiny.element.locale")` when set. See
  [`el_locale_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_locale_dependency.md).

- size, z_index:

  Element's global config, as `Vue.use(Element, {size, zIndex})` sets
  it: the size of every component not given one of its own (`"medium"`,
  `"small"` or `"mini"`), and the z-index its popups start from (2000 by
  default). `NULL` leaves Element's default.

- colors:

  Element's `primary`, `success`, `warning` and `danger`, as a named
  list – or a
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
  to take them from, such as the page's own. Element's components are
  recoloured with them, tints and shades included, as Element's theme
  picker does.
  [`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
  takes them from its `theme`.

## Value

A list of htmlDependency objects

## Examples

``` r
if (FALSE) { # \dontrun{
library(bslib)
ui <- page_sidebar(
  use_element(),
  el_button("btn1", "Click me")
)
} # }
```
