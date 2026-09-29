# Element UI Footer

Element UI Footer

## Usage

``` r
el_footer(..., height = "60px", style = NULL, class = NULL)
```

## Arguments

- ...:

  Content.

- height:

  Footer height. Defaults to `"60px"`, as in Element UI, which sets it
  inline rather than through the stylesheet.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

## Value

A Shiny UI element.

## Examples

``` r
el_footer("(c) 2026")
#> <div class="el-footer" style="height:60px">(c) 2026</div>
el_footer(height = "40px", "Compact footer")
#> <div class="el-footer" style="height:40px">Compact footer</div>
```
