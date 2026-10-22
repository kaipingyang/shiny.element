# The page's theme function, drawn with the cache

`shiny::fluidPage(theme =)` puts the theme on the page as a tag function
calling
[`bslib::bs_theme_dependencies()`](https://rstudio.github.io/bslib/reference/bs_theme_dependencies.html);
it reads sass's cache from the `sass.cache` option, set here while it
runs.

## Usage

``` r
.el_page_theme_cached(page, theme)
```

## Arguments

- page:

  A page from
  [`shiny::fluidPage()`](https://rdrr.io/pkg/shiny/man/fluidPage.html).

- theme:

  The theme it was given.

## Value

The page.
