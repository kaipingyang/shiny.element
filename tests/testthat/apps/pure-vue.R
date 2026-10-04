# Fixture for test-browser-pure-vue.R: the Vue layer with no Element Plus
# on the page -- a plain fluidPage, components written with vue_app(), a
# plugin of the page's own, shared state, and render_vue().
library(shiny)

ui <- fluidPage(
  # a Vue plugin, as a library would ship one: registers <hello-x>
  tags$script(HTML(
    "window.HelloPlugin = { install: function(app) {
       app.component('hello-x', { props: ['name'], template: '<b class=\"hello\">hi {{ name }}</b>' });
     } };"
  )),
  vue_app(
    "counter",
    tags$div(
      tags$button(class = "inc", `@click` = "n++", "+"),
      tags$span(class = "n", "{{ n }}"),
      tags$span(class = "rows", `v-for` = "r in rows", "{{ r.name }};")
    ),
    data = list(n = 1, rows = data.frame(name = c("a", "b"))),
    model = "n",
    inputs = c(rows = "counter_rows")
  ),
  vue_app(
    "greet",
    tags$div(htmltools::tag("hello-x", list(`:name` = "who"))),
    data = list(who = "Ada"),
    plugins = "HelloPlugin"
  ),
  # two apps, one shared state
  vue_app(
    "sa",
    tags$button(
      class = "sa",
      `@click` = "$shared.count = ($shared.count || 0) + 1",
      "share"
    )
  ),
  vue_app(
    "sb",
    tags$span(class = "sb", "{{ $shared.count || 0 }}|{{ $shared.note }}")
  ),
  shiny.element:::vue_output("rv"),
  verbatimTextOutput("vals")
)

server <- function(input, output, session) {
  output$rv <- shiny.element:::render_vue(
    vue_app(
      "rv_app",
      tags$i(class = "rv", "{{ label }}"),
      data = list(label = paste("n is", input$counter))
    )
  )
  observeEvent(
    input$counter,
    if (input$counter >= 3) update_vue_shared(note = "from R")
  )
  output$vals <- renderText(paste("counter =", input$counter))
}

shinyApp(ui, server)
