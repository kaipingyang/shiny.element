# The page's router: vue-router, with the route as a Shiny input

One router for the page, installed in every Vue app on it – each
component's own – as vue-router allows: `$router` and `$route` in their
templates, `<router-link>`, and what component libraries do with them (a
menu or a breadcrumb that navigates).

## Usage

``` r
vue_router(id, history = c("hash", "memory"), routes = NULL, guard = NULL)
```

## Arguments

- id:

  The router's id: the route arrives as `input$<id>`.

- history:

  `"hash"` (the default) or `"memory"`.

- routes:

  `NULL`, or a named list of
  [`vue_component()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_component.md)s,
  by path – `list("/" = home, "/orders/:id" = order)` – which a
  `<router-view>` in any
  [`vue_app()`](https://kaipingyang.github.io/shiny.element/dev/reference/vue_app.md)
  renders for the route, as vue-router's routes do; `$route.params.id`
  reaches the path's parts. Any other path is still a route, rendering
  nothing.

- guard:

  `NULL`; `"server"`, for every navigation to ask the server first (see
  "Shiny inputs"); or a
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  function of `(to, from)`, as vue-router's `beforeEach`: `true` lets it
  through, `false` stays, a path goes there instead.

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
[`update_vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/update_vue_router.md);
`input$<id>_params` its params, `list(id = "42")` for `/orders/:id`
(`NULL` when it has none). A bookmark restores the route.

With `guard = "server"`, `input$<id>_guard` is each navigation's
question, `list(to =, from =, params =, request =)`, and it waits for
the answer, `vue_answer(session, "<id>", input$<id>_guard, value)`:
`TRUE` lets it through, `FALSE` stays where it is, a path goes there
instead. Unanswered within 30 seconds, it goes through. A guard in the
browser is a convenience, not security: the server checks what it serves
for a route as it would without one.

## See also

[`update_vue_router()`](https://kaipingyang.github.io/shiny.element/dev/reference/update_vue_router.md)

## Examples

``` r
library(shiny)
home <- vue_component("<h3>Home</h3>")
order <- vue_component("<h3>Order {{ $route.params.id }}</h3>")
ui <- fluidPage(
  vue_router(
    "route",
    routes = list("/" = home, "/orders/:id" = order),
    guard = "server"
  ),
  vue_app(
    "nav",
    htmltools::tags$nav(
      htmltools::tag("router-link", list(to = "/", "Home")),
      " | ",
      htmltools::tag("router-link", list(to = "/orders/42", "Order 42"))
    )
  ),
  vue_app("view", htmltools::tag("router-view", list()))
)
server <- function(input, output, session) {
  # order 13 is not shown
  observeEvent(input$route_guard, {
    q <- input$route_guard
    vue_answer(session, "route", q, !identical(q$params$id, "13"))
  })
}
if (interactive()) {
  shinyApp(ui, server)
}
```
