# Color

Element uses a specific set of palettes to specify colors, to provide a
consistent look and feel. They are its Sass variables –
`$--color-primary` and the rest – and
[`el_theme()`](https://kaipingyang.github.io/shiny.element/reference/el_theme.md)
changes them: the brand colours by name (`primary`, `success`,
`warning`, `danger`, `info`), any other through `element =`.

## Main color

The main color of Element is a bright and friendly blue.

``` r

swatch <- function(name, hex, fg = "white") tags$div(
  style = sprintf("display: inline-block; width: 180px; height: 90px; margin: 0 10px 10px 0;
                   padding: 12px; border-radius: 4px; background: %s; color: %s", hex, fg),
  tags$b(name), tags$br(), hex)
swatch("Brand color", "#409EFF")
```

**Brand color**  
\#409EFF

## Secondary colors

Besides the main color, scenes call for others: success, warning, danger
and info.

``` r

swatch <- function(name, hex, fg = "white") tags$div(
  style = sprintf("display: inline-block; width: 140px; height: 80px; margin: 0 10px 10px 0;
                   padding: 12px; border-radius: 4px; background: %s; color: %s", hex, fg),
  tags$b(name), tags$br(), hex)
tagList(swatch("Success", "#67C23A"), swatch("Warning", "#E6A23C"),
        swatch("Danger", "#F56C6C"), swatch("Info", "#909399"))
```

**Success**  
\#67C23A

**Warning**  
\#E6A23C

**Danger**  
\#F56C6C

**Info**  
\#909399

## Neutral colors

For text, borders and backgrounds.

``` r

swatch <- function(name, hex, fg) tags$div(
  style = sprintf("display: inline-block; width: 140px; height: 70px; margin: 0 10px 10px 0;
                   padding: 10px; border-radius: 4px; background: %s; color: %s", hex, fg),
  tags$b(name), tags$br(), hex)
tagList(
  swatch("Primary text", "#303133", "white"), swatch("Regular text", "#606266", "white"),
  swatch("Secondary text", "#909399", "white"), swatch("Placeholder", "#C0C4CC", "white"),
  tags$br(),
  swatch("Base border", "#DCDFE6", "#303133"), swatch("Light border", "#E4E7ED", "#303133"),
  swatch("Lighter border", "#EBEEF5", "#303133"), swatch("Extra light", "#F2F6FC", "#303133"))
```

**Primary text**  
\#303133

**Regular text**  
\#606266

**Secondary text**  
\#909399

**Placeholder**  
\#C0C4CC

  

**Base border**  
\#DCDFE6

**Light border**  
\#E4E7ED

**Lighter border**  
\#EBEEF5

**Extra light**  
\#F2F6FC

## Changing them

``` r

el_page(theme = el_theme(primary = "#7c3aed",
                         element = list("color-text-regular" = "#4b5563")))
```
