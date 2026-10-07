# Data for a component, from the server

An output that sends a component's `data` – some of its fields, by name
– rather than markup: the server renders `list(mean = 1, sd = 2)` and
the fields `mean` and `sd` of every component following the output take
those values; the template redraws what depends on them, and nothing
else is touched. It is the declarative twin of
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md),
with the same rule: a field must be declared in the component's `data`
(or returned by `setup()`), as Vue tracks only the fields a component
starts with; one it does not have is left alone, with a warning in the
browser's console. Fields not in a render keep their values.

## Usage

``` r
render_vue_data(expr, env = parent.frame(), quoted = FALSE)

vue_data_output(outputId)
```

## Arguments

- expr:

  An expression returning the fields: a named list.

- env, quoted:

  As for
  [`shiny::renderText()`](https://rdrr.io/pkg/shiny/man/renderPrint.html).

- outputId:

  The output's id. Only needed to place the output by hand: a component
  listing it in `outputs` places it itself.

## Value

`render_vue_data()`, a render function; `vue_data_output()`, a tag.

## Details

The component names the output in its `outputs`
(`vue_app(outputs = "stats")`, inside a module `ns("stats")`). It is an
output like any other: rendered again when what it reads changes, held
back while its component is hidden, an error shown as Shiny shows one, a
promise – an `ExtendedTask`'s result – waited for. While it
recalculates, `$recalculating.<id>` is `true` in the component's
templates. It can be cached with
[`shiny::bindCache()`](https://rdrr.io/pkg/shiny/man/bindCache.html).

Values travel as
[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md)'s
`data` does: a list an object, a data.frame its rows,
[`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md) a
function; [`I()`](https://rdrr.io/r/base/AsIs.html) keeps a vector of
one an array.

Where
[`render_vue()`](https://kaipingyang.github.io/shiny.element/reference/vue_output.md)
draws a component the server writes, this fills one the UI writes: the
template stays where it is, the data comes from the server. One output
can feed several components, or a
[`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md)
they all read – shared state, as Vue's guide recommends, with the server
as its source. As shinyreact's `reactive_output()` does for React.

## See also

[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md),
[`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md),
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md).

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
        "Mean {{ mean }}, sd {{ sd }}"
      ),
      data = list(mean = NA, sd = NA),
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
