# The page's router: vue-router, with the route as a Shiny input

One router for the page, installed in every Vue app on it – each
component's own – as vue-router allows: `$router` and `$route` in their
templates, `<router-link>`, and what component libraries do with them (a
menu or a breadcrumb that navigates).

## Usage

``` r
vue_router(id, history = c("hash", "memory"))
```

## Arguments

- id:

  The router's id: the route arrives as `input$<id>`.

- history:

  `"hash"` (the default) or `"memory"`.

## Value

A Shiny UI element: put it anywhere on the page, once.

## Details

The route lives in the URL's hash (`#/orders`), which leaves the query
string to Shiny's bookmarks; `history = "memory"` keeps the URL as it
is. Any path is a route: what the page shows for it is the server's
choice, with `input$<id>` –
[`shiny::conditionalPanel()`](https://rdrr.io/pkg/shiny/man/conditionalPanel.html),
[`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html), a
navset driven by it.

## Shiny inputs

`input$<id>` is the route's full path – `"/orders"`, `"/orders?page=2"`
– on load and after every navigation that succeeds, whether by a link,
the browser's back and forward, a component or
[`update_vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/update_vue_router.md).
A bookmark restores it.

## See also

[`update_vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/update_vue_router.md)

## Examples

``` r
library(shiny)
ui <- fluidPage(
  vue_router("route"),
  vue_app(
    "nav",
    htmltools::tags$nav(
      htmltools::tag("router-link", list(to = "/", "Home")), " | ",
      htmltools::tag("router-link", list(to = "/about", "About"))
    )
  ),
  conditionalPanel("input.route == '/about'", "About this app")
)
server <- function(input, output, session) {}
if (interactive()) shinyApp(ui, server)
```
