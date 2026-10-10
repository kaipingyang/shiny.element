# Element Plus for a page of your own

What
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
gives a page, for other page functions –
[`bslib::page_sidebar()`](https://rstudio.github.io/bslib/reference/page_sidebar.html),
[`shiny::navbarPage()`](https://rdrr.io/pkg/shiny/man/navbarPage.html):
the theme Element follows, its locale and global config, the handlers of
[`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md)
and the other feedback services, and Element served from the CDN when
`offline = FALSE`. Components need none of it to work: each carries Vue
and Element Plus, so on a page without `use_element()` they show in
English, Element's own colours and sizes. Place it before the
components, so its copy of Element is the one kept.

## Usage

``` r
use_element(
  theme = NULL,
  offline = TRUE,
  dev = .vue_dev(),
  locale = getOption("shiny.element.locale", "en"),
  size = NULL,
  z_index = NULL,
  layout_css = el_layout_css_dependency()
)
```

## Arguments

- theme:

  The page's theme – an
  [`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md)
  or any
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
  – for Element's components to follow: its colours, and any Element
  variable given to
  [`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md)'s
  `element`. It styles Element only; the page function that owns the
  page applies it to Bootstrap. `NULL` leaves Element as it ships.

- offline:

  Serve Element Plus from the copy bundled with this package rather than
  the unpkg CDN. See
  [`element_plus_dependency()`](https://kaipingyang.github.io/shiny.element/reference/element_plus_dependency.md).

- dev:

  Load Vue's development build (`vue.global.js`) instead of the
  production one, so Vue's warnings are not stripped. Defaults to
  `getOption("shiny.vue.dev")` (or `shiny.element.dev`), `FALSE` unless
  set. Installed from CRAN, the development build is loaded from the
  unpkg CDN.

- locale:

  Language for Element Plus's built-in text. English by default, or
  `getOption("shiny.element.locale")` when set. See
  [`el_locale_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_locale_dependency.md).

- size, z_index:

  Element Plus's global config, as `app.use()` gives it: the size of
  every component not given one of its own (`"large"`, `"default"` or
  `"small"`), and the z-index its popups start from (2000 by default).
  `NULL` leaves Element's default.

- layout_css:

  Element's layout CSS,
  [`el_layout_css_dependency()`](https://kaipingyang.github.io/shiny.element/reference/el_layout_css_dependency.md);
  `NULL` leaves it out.

## Value

A list of htmlDependency objects

## Examples

``` r
if (FALSE) { # \dontrun{
  library(bslib)
  theme <- el_theme(primary = "#7c3aed")
  ui <- page_sidebar(
    theme = theme,
    use_element(theme = theme),
    el_button("btn1", "Click me")
  )
} # }
```
