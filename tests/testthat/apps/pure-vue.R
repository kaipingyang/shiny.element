# Fixture for test-browser-pure-vue.R: the Vue layer with no Element Plus
# on the page -- a plain fluidPage, components written with vue_app(), a
# plugin of the page's own, a store, and render_vue().
library(shiny)

ui <- fluidPage(
  # a Vue plugin, as a library would ship one: registers <hello-x>
  tags$script(HTML(
    "window.HelloPlugin = { install: function(app) {
       var greeting = (arguments[1] && arguments[1].greeting) || 'hi';
       app.component('hello-x', { props: ['name'], template: '<b class=\"hello\">' + greeting + ' {{ name }}</b>' });
     } };"
  )),
  # the store first or last: stores mount before the components reading them
  vue_app(
    "sa",
    tags$button(class = "sa", `@click` = "$store.cart.count++", "add")
  ),
  vue_app(
    "sb",
    tags$span(class = "sb", "{{ $store.cart.count }}|{{ $store.cart.note }}")
  ),
  vue_store("cart", data = list(count = 0, note = ""), model = "count"),
  # model is input$<id>; $emit() sends input$<id>_<event>
  vue_app(
    "counter",
    tags$div(
      tags$button(class = "inc", `@click` = "n++", "+"),
      tags$span(class = "n", "{{ n }}"),
      tags$span(
        class = "rows",
        `v-for` = "r in rows",
        `@click` = "$emit('picked', r)",
        "{{ r.name }};"
      )
    ),
    data = list(n = 1, rows = data.frame(name = c("a", "b"))),
    emits = "picked",
    model = "n"
  ),
  # one value of two fields, as dateRangeInput() gives
  vue_app(
    "range",
    tags$div(
      tags$input(class = "from", `v-model.number` = "from"),
      tags$input(class = "to", `v-model.number` = "to")
    ),
    data = list(from = 1, to = 9),
    model = c("from", "to")
  ),
  vue_app(
    "greet",
    tags$div(htmltools::tag("hello-x", list(`:name` = "who"))),
    data = list(who = "Ada"),
    plugins = "HelloPlugin"
  ),
  vue_app(
    "greet2",
    tags$div(htmltools::tag("hello-x", list(`:name` = "who"))),
    data = list(who = "Alan"),
    plugins = list(HelloPlugin = list(greeting = "hello"))
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
  observeEvent(input$counter, {
    if (input$counter >= 3) {
      update_vue_data(session, "cart", list(note = "from R"))
    }
  })
  output$vals <- renderText(paste("counter =", input$counter))
}

shinyApp(ui, server)
