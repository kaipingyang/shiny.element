# Fixture for test-browser-islands.R: Shiny UI in a vue_app() template,
# under v-if -- an input, outputs, htmlwidgets, a component function, a
# container -- moved in while shown and back out, its state kept.

library(shiny)
ui <- el_page(
  vue_app(
    "va1",
    tags$div(
      tags$button(id = "tog", `@click` = "show = !show", "toggle"),
      tags$div(
        `v-if` = "show",
        textInput("txt", "Shiny text", "a"),
        tags$div(style = "width: 400px", plotOutput("plt", height = "250px")),
        DT::DTOutput("dt"),
        tags$div(
          id = "staticwidget",
          DT::datatable(head(mtcars, 2), options = list(dom = "t"))
        ),
        el_input("elin", value = "el"),
        el_tabs(
          "tb",
          tabs = list(
            list(name = "a", label = "A", content = "tab a"),
            list(name = "b", label = "B", content = "tab b")
          )
        )
      )
    ),
    data = list(show = TRUE)
  ),
  textOutput("echo")
)
server <- function(input, output, session) {
  output$plt <- renderPlot(plot(1:3))
  output$dt <- DT::renderDT(head(iris, 3), options = list(dom = "t"))
  output$echo <- renderText(paste(
    "txt:",
    input$txt,
    "elin:",
    input$elin,
    "tb:",
    input$tb
  ))
}
shinyApp(ui, server)
