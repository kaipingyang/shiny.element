# Components following state in the browser (vue_bind()), with a server
# that reads what the page did and changes it.

bind_ui <- function() {
  shiny::tagList(
    vue_store(
      "ui",
      state = list(on = TRUE, open = FALSE, tab = "a", drawer = FALSE)
    ),
    el_radio_group(
      "sz",
      choices = c("large", "default", "small"),
      selected = "default"
    ),
    el_space(
      id = "sp",
      size = vue_bind("$inputs.sz"),
      el_card("A"),
      el_card("B")
    ),
    el_switch("sw", value = vue_bind("$store.ui.on")),
    el_switch("sw2", value = vue_bind("$store.ui.on")),
    el_button(
      "open",
      "Open",
      # Vue's inline statement, as @click="..."
      on = list(click = "$store.ui.open = true")
    ),
    el_dialog(
      "dlg",
      title = "Tips",
      visible = vue_bind("$store.ui.open"),
      content = shiny::tags$span("Hello")
    ),
    # a container's prop following another component
    el_radio_group("edge", choices = c("rtl", "btt"), selected = "rtl"),
    el_drawer(
      "drw",
      visible = vue_bind("$store.ui.drawer"),
      direction = vue_bind("$inputs.edge"),
      content = "Inside"
    ),
    el_tabs(
      "tabs",
      tabs = list(
        list(name = "a", label = "A", content = "A!"),
        list(name = "b", label = "B", content = "B!")
      ),
      selected = vue_bind("$store.ui.tab")
    ),
    el_button(
      "msg",
      "Message",
      on = list(click = JS("function() { this.$message('Hi from the page'); }"))
    ),
    vue_app(
      "state",
      shiny::tags$span(
        "on={{ $store.ui.on }} open={{ $store.ui.open }} tab={{ $store.ui.tab }}"
      )
    )
  )
}

ui <- el_page(
  bind_ui(),
  el_button("srv_on", "Server: on"),
  el_button("srv_tab", "Server: tab b"),
  shiny::verbatimTextOutput("seen")
)

server <- function(input, output, session) {
  output$seen <- shiny::renderText(paste0(
    "sz=",
    input$sz,
    " sw=",
    input$sw,
    " sw2=",
    input$sw2,
    " dlg=",
    input$dlg,
    " tabs=",
    input$tabs
  ))
  shiny::observeEvent(
    input$srv_on,
    update_el_switch(session, "sw", value = TRUE)
  )
  shiny::observeEvent(
    input$srv_tab,
    update_el_tabs(session, "tabs", selected = "b")
  )
}

shiny::shinyApp(ui, server)
