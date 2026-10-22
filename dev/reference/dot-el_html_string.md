# Markup as a string, for a `v-html` field

A field read by `v-html` travels as JSON, where a tag would arrive as
its serialised object and show as text. Tags and tag lists are rendered
to their HTML first; a character value is taken as markup already.

## Usage

``` r
.el_html_string(x, arg = "html")
```

## Arguments

- x:

  A character string, tag, tag list or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html),
  or `NULL`.

- arg:

  The argument's name, for the error.

## Value

A single string, or `NULL`.
