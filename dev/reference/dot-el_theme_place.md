# A theme's CSS and files, written where its compiled output goes

bslib compiles a theme to `bootstrap.min.css` in
`tempdir()/bslib-<key>`, the key being sass's; sass takes that file as
already compiled when its key is in `.sass_cache_keys` beside it.

## Usage

``` r
.el_theme_place(base, key, theme)
```

## Arguments

- base:

  sass's cache.

- key:

  The theme's key in it.

- theme:

  The theme, whose files (fonts) go beside the CSS, as
  [`sass::as_sass_layer()`](https://rstudio.github.io/sass/reference/as_sass_layer.html)
  lists them: destination = source.

## Value

The output's directory, invisibly.
