# sass's cache, placing what it holds where sass's file output goes

sass's cache, placing what it holds where sass's file output goes

## Usage

``` r
.el_theme_cache(theme)
```

## Arguments

- theme:

  The page's theme.

## Value

An object sass takes for its cache (class `FileCache`), or `NULL` when
sass's caching is off (`options(sass.cache = FALSE)`, Shiny's developer
mode).
