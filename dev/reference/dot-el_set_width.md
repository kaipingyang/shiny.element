# Set a width on a tag, replacing any width it already declares

`htmltools` joins repeated attributes with a space, so appending a
second `style` turns `width: 100%` and `width: 200px` into
`style="width: 100% width: 200px"` – neither of which a browser reads.
The existing declarations are parsed instead, the width among them
dropped, and the new one appended.

## Usage

``` r
.el_set_width(tag, width)
```

## Arguments

- tag:

  A tag, or something else (returned unchanged).

- width:

  A CSS unit, as accepted by
  [`shiny::validateCssUnit()`](https://rstudio.github.io/htmltools/reference/validateCssUnit.html).

## Value

The tag, with the width set.
