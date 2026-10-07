# Element's variables for a theme, decided when the page is drawn

When `theme` is the page's own Bootstrap theme –
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
gives it to the page, a bslib page function was given the same one –
Element's colours follow Bootstrap's CSS variables, so a theme changed
while the app runs reaches them. Any other theme, or one drawn outside a
page that has it, is written out as it stands.

## Usage

``` r
.el_theme_tag(theme)
```

## Arguments

- theme:

  A theme, or `NULL`.

## Value

A tag function giving the dependency, or `NULL`.
