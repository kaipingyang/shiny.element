# Typography

We create a font convention to ensure the best presentation across
different platforms.

## Font

Element Plus’s font stack, as the page draws it.

``` r

tags$div(style = "display: grid; gap: 12px",
  lapply(c("Helvetica Neue", "Helvetica", "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Arial"),
         function(f) tags$div(style = sprintf("font-family: '%s'; font-size: 18px", f), f)))
```

Helvetica Neue

Helvetica

PingFang SC

Hiragino Sans GB

Microsoft YaHei

Arial

## Font Convention

``` r

row <- function(level, size, var) tags$tr(tags$td(level), tags$td(size),
  tags$td(style = sprintf("font-size: var(%s)", var), "Build with Element"))
tags$table(style = "border-spacing: 20px 10px",
  tags$tr(tags$th("Level"), tags$th("Font Size"), tags$th("Demo")),
  row("Supplementary text", "12px Extra Small", "--el-font-size-extra-small"),
  row("Body (small)", "13px Small", "--el-font-size-small"),
  row("Body", "14px Base", "--el-font-size-base"),
  row("Small Title", "16px Medium", "--el-font-size-medium"),
  row("Title", "18px Large", "--el-font-size-large"),
  row("Main Title", "20px Extra Large", "--el-font-size-extra-large"))
```

| Level              | Font Size        | Demo               |
|--------------------|------------------|--------------------|
| Supplementary text | 12px Extra Small | Build with Element |
| Body (small)       | 13px Small       | Build with Element |
| Body               | 14px Base        | Build with Element |
| Small Title        | 16px Medium      | Build with Element |
| Title              | 18px Large       | Build with Element |
| Main Title         | 20px Extra Large | Build with Element |

## Font Line Height

``` r

lines <- c("line-height: 1" = "1", "line-height: 1.3" = "1.3", "line-height: 1.5" = "1.5",
           "line-height: 1.7" = "1.7")
tags$div(style = "display: flex; gap: 24px",
  Map(function(lab, lh) tags$div(style = sprintf("line-height: %s; width: 160px", lh),
    tags$b(lab), tags$p("Build with Element Plus, a component library for developers.")),
    names(lines), lines))
```

**line-height: 1**

Build with Element Plus, a component library for developers.

**line-height: 1.3**

Build with Element Plus, a component library for developers.

**line-height: 1.5**

Build with Element Plus, a component library for developers.

**line-height: 1.7**

Build with Element Plus, a component library for developers.

## Font-family

## API

Element Plus’s tables, and beside each entry where it is in R.
