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
  locale = getOption("shiny.element.locale", "en")
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
