# Fixture for test-browser-router.R: the page's router with route
# components and a server guard, the Element components that navigate it, a
# Vue app of the user's reading it, and the server navigating.
library(shiny)

page <- function(text) {
  vue_component(sprintf("<h4 class=\"page\">%s</h4>", text))
}

ui <- el_page(
  loading = FALSE,
  vue_router(
    "route",
    routes = list(
      "/" = page("Home"),
      "/orders" = page("Orders"),
      "/orders/:id" = page("Order {{ $route.params.id }}"),
      "/admin" = page("Admin")
    ),
    guard = "server"
  ),
  el_menu(
    "menu",
    router = TRUE,
    mode = "horizontal",
    items = list(
      el_menu_item("Home", "/"),
      el_menu_item("Orders", "/orders"),
      el_menu_item("Admin", "/admin"),
      # an index that is not the path: the item's route goes
      el_menu_item("Reports", "reports", route = "/reports")
    )
  ),
  el_breadcrumb(
    "crumb",
    items = list(
      el_breadcrumb_item("Home", to = "/"),
      el_breadcrumb_item("Orders", to = "/orders", replace = TRUE),
      el_breadcrumb_item("Here")
    )
  ),
  # Vue's own: $route in a template, <router-link>, <router-view>
  vue_app(
    "own",
    tags$div(
      tags$span(class = "path", "{{ $route.path }}"),
      tag("router-link", list(class = "to-admin", to = "/admin", "Admin"))
    )
  ),
  vue_app("view", tag("router-view", list())),
  actionButton("go_orders", "Server: to /orders"),
  verbatimTextOutput("seen"),
  verbatimTextOutput("params")
)

server <- function(input, output, session) {
  output$seen <- renderText(paste0("route=", input$route, " menu=", input$menu))
  output$params <- renderText(paste0("id=", input$route_params$id))
  observeEvent(input$go_orders, update_vue_router(session, "route", "/orders"))
  # the server's guard: /secret stays where it is, /old goes to /orders
  observeEvent(input$route_guard, {
    q <- input$route_guard
    answer <- switch(q$to, "/secret" = FALSE, "/old" = "/orders", TRUE)
    vue_answer(session, "route", q, answer)
  })
}

shinyApp(ui, server)
