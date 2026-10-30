# Components following state in the browser (v_bind(), v_model()), with a server
# that reads what the page did and changes it.

# A module drawn twice: its store, its input and its handler are its own
panel_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    vue_store(ns("ui"), state = list(n = 0)),
    el_radio_group(
      ns("size"),
      choices = c("large", "default"),
      selected = "default"
    ),
    el_space(
      id = ns("sp"),
      size = v_bind("$inputs.size", ns = ns),
      el_card("M")
    ),
    el_button(
      ns("add"),
      "Add",
      on = list(click = v_on("$vueStore.ui.n++", ns = ns))
    ),
    vue_app(
      ns("count"),
      shiny::tags$span("n={{ n }}"),
      data = list(n = v_bind("$vueStore.ui.n", ns = ns))
    )
  )
}

# What 0.3.1 wrote: $store, said once
legacy_ui <- function() {
  vue_app("legacy", shiny::tags$span("{{ $store.ui.on }}"))
}

bind_ui <- function() {
  shiny::tagList(
    panel_ui("m1"),
    panel_ui("m2"),
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
      size = v_bind("$inputs.sz"),
      el_card("A"),
      el_card("B")
    ),
    el_switch("sw", value = v_model("$vueStore.ui.on")),
    # an expression, one way
    el_switch("big", disabled = v_bind("$inputs.sz !== 'large'")),
    el_switch("sw2", value = v_model("$vueStore.ui.on")),
    el_button(
      "open",
      "Open",
      # Vue's inline statement, as @click="..."
      on = list(click = "$vueStore.ui.open = true")
    ),
    el_dialog(
      "dlg",
      title = "Tips",
      visible = v_model("$vueStore.ui.open"),
      content = shiny::tags$span("Hello")
    ),
    # a container's prop following another component
    el_radio_group("edge", choices = c("rtl", "btt"), selected = "rtl"),
    el_drawer(
      "drw",
      visible = v_model("$vueStore.ui.drawer"),
      direction = v_bind("$inputs.edge"),
      content = "Inside"
    ),
    el_tabs(
      "tabs",
      tabs = list(
        list(name = "a", label = "A", content = "A!"),
        list(name = "b", label = "B", content = "B!")
      ),
      selected = v_model("$vueStore.ui.tab")
    ),
    # a component's method, called in the browser
    el_tree(
      "tr",
      data = list(list(label = "apple"), list(label = "pear")),
      filter_node_method = JS(
        "function(v, d) { return !v || d.label.indexOf(v) >= 0; }"
      )
    ),
    el_button("flt", "Filter", on = list(click = "$find('tr').filter('pe')")),
    el_button(
      "msg",
      "Message",
      on = list(click = JS("function() { this.$message('Hi from the page'); }"))
    ),
    vue_app(
      "state",
      shiny::tags$span(
        "on={{ $vueStore.ui.on }} open={{ $vueStore.ui.open }} tab={{ $vueStore.ui.tab }}"
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
