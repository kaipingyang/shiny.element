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
template or options changed, a component given another id – renders
afresh, as [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)
does. (A component given no id draws a random one each render; that is
not a change.) To keep a component, put what changes from render to
render in its `data` and keep its template the same.

A field the server sends with the same value as last time is not sent
again, so it does not undo what the user did; to set a value whatever
the user did, use
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md).

## render_vue(), render_vue_data(), update_vue()

Three ways the server shapes a component, by who owns it:

- `render_vue()` – the server writes the component: template, options,
  methods, data, dependencies. Rendered again, it keeps what the user
  did; a new template or new methods mount it afresh. As shiny.react's
  `renderReact()` is for React.

- [`render_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/render_vue_data.md)
  – the component is written in the UI and one of its fields follows a
  value the server renders: a value, not markup, for components whose
  structure is fixed. One output can feed several components, or a
  [`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md)
  they share.

- [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
  – an observer sets fields when it decides to: an imperative change,
  sent whether or not the component is shown.

`render_vue()` can be cached with
[`shiny::bindCache()`](https://rdrr.io/pkg/shiny/man/bindCache.html), as
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) can.

## See also

[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md),
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md),
[`render_vue_data()`](https://kaipingyang.github.io/shiny.element/reference/render_vue_data.md).

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
