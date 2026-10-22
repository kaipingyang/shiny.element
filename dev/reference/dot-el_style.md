# Merge inline style fragments

[`htmltools::tagAppendAttributes()`](https://rstudio.github.io/htmltools/reference/tagAppendAttributes.html)
joins repeated `style` attributes with a space, producing invalid CSS
(`"color:red padding-left:10px"`), so style fragments are assembled here
instead.

## Usage

``` r
.el_style(...)
```

## Arguments

- ...:

  Style fragments; `NULL` entries are dropped.

## Value

A single `;`-separated style string, or `NULL` if nothing was given.
