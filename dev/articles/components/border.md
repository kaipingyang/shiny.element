# Border

We standardize the borders that can be used in buttons, cards, pop-ups
and other components.

## Border style

There are few border styles to choose.

``` r

row <- function(name, width, style) {
  tags$tr(
    tags$td(name),
    tags$td(width),
    tags$td(tags$div(
      style = sprintf(
        "width: 200px; height: 0; border-top: %s %s var(--el-border-color)",
        width,
        style
      )
    ))
  )
}
tags$table(
  class = "demo-border",
  style = "border-spacing: 30px 10px",
  tags$tr(tags$td("Name"), tags$td("Thickness"), tags$td("Demo")),
  row("Solid", "1px", "solid"),
  row("Dashed", "2px", "dashed")
)
```

[TABLE]

## Radius

There are few radius styles to choose.

Each radius is read from the theme’s variable, with VueUse’s
`useCssVar()`, as upstream’s does.

``` r

vue_app(
  "radius_demo",
  el$row(
    `:gutter` = "12",
    el$col(
      `v-for` = "(r, i) in radii",
      `:key` = "i",
      `:span` = "6",
      `:xs` = "{ span: 12 }",
      tags$div("{{ r.name }}"),
      tags$code("border-radius: {{ r.type ? r.value : '0px' }}"),
      tags$div(
        style = paste(
          "height: 40px; margin-top: 10px;",
          "border: 1px solid var(--el-border-color)"
        ),
        `:style` = "{ borderRadius: r.type ? 'var(--el-border-radius-' + r.type + ')' : '' }"
      )
    )
  ),
  setup = JS(
    "function() {",
    "  var group = [['No Radius', ''], ['Small Radius', 'small'],",
    "    ['Large Radius', 'base'], ['Round Radius', 'round']];",
    "  return { radii: Vue.reactive(group.map(function(g) {",
    "    return { name: g[0], type: g[1],",
    "      value: g[1] ? VueUse.useCssVar('--el-border-radius-' + g[1]) : '' };",
    "  })) };",
    "}"
  ),
  use = "shinyElement.plugin",
  dependencies = vueuse_dependency()
)
```

## Shadow

There are few shadow styles to choose.

``` r

shadow <- function(name, var) {
  tags$div(
    style = "text-align: center; margin: 0 20px",
    tags$div(
      style = sprintf("width: 120px; height: 120px; box-shadow: var(%s)", var)
    ),
    tags$p(name),
    tags$code(var)
  )
}
tags$div(
  style = "display: flex; flex-wrap: wrap",
  shadow("Basic Shadow", "--el-box-shadow"),
  shadow("Light Shadow", "--el-box-shadow-light"),
  shadow("Lighter Shadow", "--el-box-shadow-lighter"),
  shadow("Dark Shadow", "--el-box-shadow-dark")
)
```

Basic Shadow

`--el-box-shadow`

Light Shadow

`--el-box-shadow-light`

Lighter Shadow

`--el-box-shadow-lighter`

Dark Shadow

`--el-box-shadow-dark`

## API

Element Plus’s tables, and beside each entry where it is in R.
