# Border

Element standardises the borders, radii and shadows its components use.

## Border

``` r

tagList(
  tags$div(style = "display: inline-block; width: 200px; height: 60px; margin-right: 20px; border: 1px solid #DCDFE6; padding: 8px", "Solid, 1px"),
  tags$div(style = "display: inline-block; width: 200px; height: 60px; border: 2px dashed #DCDFE6; padding: 8px", "Dashed, 2px"))
```

Solid, 1px

Dashed, 2px

## Radius

``` r

box <- function(r, label) tags$div(style = sprintf(
  "display: inline-block; width: 160px; height: 60px; margin-right: 20px; border: 1px solid #DCDFE6; border-radius: %s; padding: 8px", r), label)
tagList(box("0", "No radius"), box("2px", "Small, 2px"), box("4px", "Large, 4px"), box("20px", "Round, 20px"))
```

No radius

Small, 2px

Large, 4px

Round, 20px

## Shadow

``` r

tagList(
  tags$div(style = "display: inline-block; width: 200px; height: 60px; margin-right: 20px; padding: 8px; box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04)", "Basic shadow"),
  tags$div(style = "display: inline-block; width: 200px; height: 60px; padding: 8px; box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1)", "Light shadow"))
```

Basic shadow

Light shadow

## Changing them

``` r

el_page(theme = el_theme(element = list("border-radius-base" = "8px",
                                        "border-color-base" = "#cbd5e1")))
```
