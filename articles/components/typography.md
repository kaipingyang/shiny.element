# Typography

Element unifies the font family, size and line height across its
components.
[`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md)
carries its font stack and 14px base size to the page, so Shiny’s own
inputs and text match.

## Font

``` r

tags$div(style = "font-size: 18px; color: #303133",
  tags$p(style = "font-family: 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', Arial, sans-serif",
         "Helvetica Neue, Helvetica, PingFang SC, Hiragino Sans GB, Microsoft YaHei, Arial, sans-serif"))
```

Helvetica Neue, Helvetica, PingFang SC, Hiragino Sans GB, Microsoft
YaHei, Arial, sans-serif

## Font convention

``` r

row <- function(level, size, text) tags$tr(tags$td(style = "padding: 6px 24px 6px 0", level),
  tags$td(style = sprintf("font-size: %s; padding: 6px 24px 6px 0", size), text), tags$td(size))
tags$table(style = "color: #303133",
  row("Supplementary text", "12px", "Build with Element"),
  row("Body (small)", "13px", "Build with Element"),
  row("Body", "14px", "Build with Element"),
  row("Small title", "16px", "Build with Element"),
  row("Title", "18px", "Build with Element"),
  row("Main title", "20px", "Build with Element"))
```

|                    |                    |      |
|--------------------|--------------------|------|
| Supplementary text | Build with Element | 12px |
| Body (small)       | Build with Element | 13px |
| Body               | Build with Element | 14px |
| Small title        | Build with Element | 16px |
| Title              | Build with Element | 18px |
| Main title         | Build with Element | 20px |

## Changing it

The base size and every derived size are Element variables:

``` r

el_page(theme = el_theme(element = list("font-size-base" = "13px",
                                        "font-size-small" = "12px")))
```
