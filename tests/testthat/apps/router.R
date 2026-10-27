# Fixture for test-browser-router.R: the page's router, the Element
# components that navigate it, a Vue app of the user's reading it, and the
# server navigating.
library(shiny)

ui <- el_page(
  loading = FALSE,
  vue_router("route"),
  el_menu(
    "menu",
    router = TRUE,
    mode = "horizontal",
    items = list(
      el_menu_item("Home", "/"),
      el_menu_item("Orders", "/orders"),
      el_menu_item("Admin", "/admin")
    )
  ),
  el_breadcrumb(
    "crumb",
    items = list(
      el_breadcrumb_item("Home", to = "/"),
      el_breadcrumb_item("Orders", to = "/orders"),
      el_breadcrumb_item("Here")
    )
  ),
  # Vue's own: $route in a template, <router-link>
  vue_app(
    "own",
    tags$div(
      tags$span(class = "path", "{{ $route.path }}"),
      tag("router-link", list(class = "to-admin", to = "/admin", "Admin"))
    )
  ),
  actionButton("go_orders", "Server: to /orders"),
  verbatimTextOutput("seen")
)

server <- function(input, output, session) {
  output$seen <- renderText(paste0("route=", input$route, " menu=", input$menu))
  observeEvent(input$go_orders, update_vue_router(session, "route", "/orders"))
}

shinyApp(ui, server)
