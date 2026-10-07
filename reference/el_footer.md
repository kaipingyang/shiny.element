# Element Plus Footer

Element Plus Footer

## Usage

``` r
el_footer(..., height = "60px", style = NULL, class = NULL)
```

## Arguments

- ...:

  Content.

- height:

  Footer height. Defaults to `"60px"`, as in Element Plus, which sets it
  as the CSS variable `--el-<part>-<size>`.

- style:

  Extra inline style.

- class:

  Extra CSS classes.

## Value

A Shiny UI element.

## Examples

``` r
el_footer("(c) 2026")
#> <footer class="el-footer" style="--el-footer-height:60px">(c) 2026</footer>
el_footer(height = "40px", "Compact footer")
#> <footer class="el-footer" style="--el-footer-height:40px">Compact footer</footer>
```
