# Data for a component, from the server

An output that sends a value rather than markup: a component's field
follows it. The component names the output in its `outputs`
(`vue_app(outputs = c(stats = "stats"))`); the server renders the value,
which arrives as JSON and is assigned to the field – the template
redraws what depends on it, and nothing else is touched. As shinyreact's
`reactive_output()` does for React.

## Usage

``` r
render_vue_data(expr, env = parent.frame(), quoted = FALSE)

vue_data_output(outputId)
```

## Arguments

- expr:

  An expression returning the value.

- env, quoted:

  As for
  [`shiny::renderText()`](https://rdrr.io/pkg/shiny/man/renderPrint.html).

- outputId:

  The output's id. Only needed to place the output by hand: a component
  listing it in `outputs` places it itself.

## Value

`render_vue_data()`, a render function; `vue_data_output()`, a tag.

## Details

It is an output like any other: rendered again when what it reads
changes, held back while its component is hidden, an error shown as
Shiny shows one. While it recalculates, `$recalculating.<id>` is `true`
in the component's templates.

Values travel as
[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md)'s
`data` does: a list an object, a data.frame its rows,
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md) a
function; [`I()`](https://rdrr.io/r/base/AsIs.html) keeps a vector of
one an array.

## See also

[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md),
[`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md).

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- fluidPage(
    sliderInput("n", "Draws", 10, 1000, 100),
    vue_app(
      "summary",
      template = htmltools::tags$p(
        `:style` = "{opacity: $recalculating.stats ? 0.5 : 1}",
        "Mean {{ stats.mean }}, sd {{ stats.sd }}"
      ),
      data = list(stats = list(mean = NA, sd = NA)),
      outputs = "stats"
    )
  )
  server <- function(input, output, session) {
    output$stats <- render_vue_data({
      x <- rnorm(input$n)
      list(mean = round(mean(x), 3), sd = round(sd(x), 3))
    })
  }
  shinyApp(ui, server)
}
```
