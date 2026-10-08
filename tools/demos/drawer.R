## basic-usage
#' The radios set the edge it slides from, with `update_el_drawer(direction
#' =)`; closing the first asks first, through `before_close`.
#| shot_js = c("Array.from(document.querySelectorAll('#direction .el-radio')).find(function(r){ return r.innerText.indexOf('top to bottom') >= 0; }).click()", "document.querySelector('#open_container button').click()")
#| shot_sel = ".el-drawer"
#| shot_wait = 1.5
#| shot_expect = "document.querySelector('#drw .el-drawer.ttb')"
ui <- el_page(
  el_radio_group(
    "direction",
    choices = c(
      "left to right" = "ltr",
      "right to left" = "rtl",
      "top to bottom" = "ttb",
      "bottom to top" = "btt"
    ),
    value = "rtl"
  ),
  el_button("open", "open", type = "primary"),
  el_button("open2", "with footer", type = "primary"),
  el_drawer(
    "drw",
    title = "I am the title",
    direction = "rtl",
    before_close = JS(
      "function(done) { if (confirm('Are you sure you want to close this?')) done(); }"
    ),
    content = tags$span("Hi, there!")
  ),
  el_drawer(
    "drw2",
    title = tags$h4("set title by slot"),
    direction = "rtl",
    content = el_radio_group(
      "radio1",
      choices = c("Option 1", "Option 2"),
      value = "Option 1",
      size = "large"
    ),
    footer = tags$div(
      style = "flex: auto",
      el_button("cancel", "cancel"),
      el_button("confirm", "confirm", type = "primary")
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$direction, ignoreInit = TRUE, {
    update_el_drawer(id = "drw", direction = input$direction)
    update_el_drawer(id = "drw2", direction = input$direction)
  })
  observeEvent(input$open, update_el_drawer(id = "drw", visible = TRUE))
  observeEvent(input$open2, update_el_drawer(id = "drw2", visible = TRUE))
  observeEvent(input$cancel, update_el_drawer(id = "drw2", visible = FALSE))
  observeEvent(input$confirm, {
    update_el_drawer(id = "drw2", visible = FALSE)
    el_message(paste("You chose", input$radio1))
  })
}
shinyApp(ui, server)

## no-title
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
ui <- el_page(
  el_button("open", "open", type = "primary"),
  el_drawer(
    "drw",
    title = "I am the title",
    with_header = FALSE,
    content = tags$span("Hi there!")
  )
)
server <- function(input, output, session) {
  observeEvent(input$open, update_el_drawer(id = "drw", visible = TRUE))
}
shinyApp(ui, server)

## customization-content
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open Drawer with nested form", text = TRUE),
  el_drawer(
    "drw",
    title = "I have a nested form inside!",
    direction = "ltr",
    size = "40%",
    content = tagList(
      el_input(
        "name",
        label = "Name",
        label_position = "left",
        label_width = "80px"
      ),
      el_select(
        "area",
        choices = c("Area1" = "shanghai", "Area2" = "beijing"),
        label = "Area",
        label_position = "left",
        label_width = "80px"
      )
    ),
    footer = tagList(
      el_button("cancel", "Cancel"),
      el_button("submit", "Submit", type = "primary")
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$open, update_el_drawer(id = "drw", visible = TRUE))
}
shinyApp(ui, server)

## customization-header
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open Drawer with customized header"),
  el_drawer(
    "drw",
    show_close = FALSE,
    content = "This is drawer content.",
    title = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$h4("This is a custom header!"),
      el_button("close", "Close", type = "danger", icon = "CircleCloseFilled")
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$open, update_el_drawer(id = "drw", visible = TRUE))
  observeEvent(input$close, update_el_drawer(id = "drw", visible = FALSE))
}
shinyApp(ui, server)

## resizable
#' Picking an edge opens it there; dragging its inner edge resizes it,
#' reported as `input$<id>_resize`.
#| shot_js = "Array.from(document.querySelectorAll('#direction .el-radio-button')).find(function(r){ return r.innerText.trim() === 'bottom'; }).click()"
#| shot_sel = ".el-drawer"
#| shot_wait = 1.5
#| shot_expect = c("document.querySelector('#drw .el-drawer.btt')", "getComputedStyle(document.getElementById('drw')).display !== 'none'")
ui <- el_page(
  el_radio_group(
    "direction",
    choices = c(top = "ttb", right = "rtl", bottom = "btt", left = "ltr"),
    value = "rtl",
    button = TRUE
  ),
  el_drawer(
    "drw",
    direction = "rtl",
    resizable = TRUE,
    content = "This is drawer content."
  )
)
server <- function(input, output, session) {
  observeEvent(input$direction, ignoreInit = TRUE, {
    update_el_drawer(id = "drw", direction = input$direction, visible = TRUE)
  })
}
shinyApp(ui, server)

## nested-drawer
#| shot_js = "document.querySelector('#open_container button').click(); setTimeout(function(){ document.querySelector('#inner_open_container button').click(); }, 800);", shot_sel = ".el-drawer", shot_wait = 2
ui <- el_page(
  el_button("open", "open", type = "primary"),
  el_drawer(
    "outer",
    title = "I'm outer Drawer",
    size = "50%",
    content = tagList(
      el_button("inner_open", "Click me!"),
      el_drawer(
        "inner",
        title = "I'm inner Drawer",
        append_to_body = TRUE,
        content = tags$p("_(:з)∠)_")
      )
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$open, update_el_drawer(id = "outer", visible = TRUE))
  observeEvent(input$inner_open, update_el_drawer(id = "inner", visible = TRUE))
}
shinyApp(ui, server)

## modal
#| shot_js = "document.querySelector('#open_container button').click()", shot_sel = ".el-drawer", shot_wait = 1.5
ui <- el_page(
  el_button("open", "Open the modal Drawer", plain = TRUE),
  el_drawer(
    "drw",
    modal = FALSE,
    modal_penetrable = TRUE,
    content = tags$span("It's a modal Drawer"),
    footer = tagList(
      el_button("cancel", "Cancel"),
      el_button("confirm", "Confirm", type = "primary")
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$open, update_el_drawer(id = "drw", visible = TRUE))
}
shinyApp(ui, server)
