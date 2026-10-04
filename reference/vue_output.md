# A Vue output that keeps the user's state across renders

`vue_output()` and `render_vue()` are the Vue layer's pair, as
[`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) and
[`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) are
Shiny's, with one difference.
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) replaces
what it drew on every render, and with it whatever the user had done: a
table's sort, a tree's open nodes, the tab they were on. `render_vue()`
applies a render as a change, comparing the server's last render, its
new one and the page:

## Usage

``` r
vue_output(id)

render_vue(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- id:

  Output id.

- expr:

  An expression returning UI: one component or several, with any markup
  around them.

- env, quoted:

  As for
  [`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html).

## Value

`vue_output()`, a tag; `render_vue()`, a render function.

## Details

- markup the server did not change stays as the page has it;

- text and attributes the server changed are set;

- each component whose template and options are unchanged gets only the
  `data` fields the server changed since its last render – so a field
  the user changed and the server did not keeps the user's value.

Anything structural – an element added or removed, a component's
template or options changed – renders afresh, as
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) does. To
keep a component, put what changes from render to render in its `data`
and keep its template the same.

A field the server sends with the same value as last time is not sent
again, so it does not undo what the user did; to set a value whatever
the user did, use
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md).

## See also

[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md),
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md).

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- fluidPage(
    sliderInput("n", "Rows", 1, 10, 5),
    vue_output("list")
  )
  server <- function(input, output, session) {
    output$list <- render_vue(vue_app(
      "items",
      template = htmltools::tags$ul(htmltools::tags$li(
        `v-for` = "i in items",
        "{{ i }}"
      )),
      data = list(items = as.list(seq_len(input$n)))
    ))
  }
  shinyApp(ui, server)
}
```
