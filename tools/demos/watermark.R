## basic
el_watermark(
  content = "Element Plus",
  font = list(color = "rgba(0, 0, 0, .15)"),
  tags$div(style = "height: 500px")
)

## multi-line
#' Several lines: `content` is a vector.
el_watermark(
  content = c("Element+", "Element Plus"),
  font = list(color = "rgba(0, 0, 0, .15)"),
  tags$div(style = "height: 500px")
)

## image
#' `image` draws a picture instead of text; `watermark_width` and `height`
#' size it (`width` is the box's).
el_watermark(
  watermark_width = 130,
  height = 30,
  image = "https://element-plus.org/images/element-plus-logo.svg",
  tags$div(style = "height: 500px")
)

## custom
#' Its settings from inputs: the server redraws it as they change.
ui <- el_page(
  el_row(
    el_col(span = 14, uiOutput("marked")),
    el_col(
      span = 10,
      el_input("content", label = "Content", value = "Element Plus"),
      el_color_picker(
        "color",
        label = "Color",
        value = "rgba(0, 0, 0, 0.15)",
        show_alpha = TRUE
      ),
      el_slider("size", label = "FontSize", value = 16, min = 8, max = 40),
      el_slider("rotate", label = "Rotate", value = -22, min = -180, max = 180),
      el_input_number("gap", label = "Gap", value = 100)
    )
  )
)

server <- function(input, output, session) {
  output$marked <- renderUI(el_watermark(
    content = input$content,
    rotate = input$rotate,
    gap = rep(input$gap %||% 100, 2),
    font = list(fontSize = input$size, color = input$color),
    tags$div(
      style = "padding: 40px 20px; height: 360px",
      tags$h1("Element Plus"),
      tags$h2("A Vue 3 based component library for designers and developers")
    )
  ))
}

shinyApp(ui, server)
