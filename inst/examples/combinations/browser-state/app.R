# State in the browser, put together: bindings on folded components, inside
# overlays and cells, drawn later by renderUI(), redrawn, in two instances
# of a module, set by the server, following the route; Vue's ref, computed
# and watch; $find().
library(shiny)
library(shiny.element)

panel_ui <- function(id) {
  ns <- NS(id)
  tagList(
    vue_store(ns("ui"), state = list(n = 0)),
    el_button(
      ns("add"),
      "Add",
      on = list(click = v_on("$vueStore.ui.n++", ns = ns))
    ),
    el_badge(
      el_button(ns("mail"), "Mail"),
      id = ns("badge"),
      value = v_bind("$vueStore.ui.n", ns = ns)
    )
  )
}

ui <- el_page(
  vue_router("route"),
  vue_store("app", state = list(on = FALSE, open = FALSE, label = "start")),
  vue_ref("count", 0, input = TRUE),
  vue_computed("twice", "$vueRef.count * 2", input = TRUE),
  vue_watch("$vueRef.count", "$vueStore.app.label = 'count ' + $value"),
  # folded: a button inside a badge, the badge's value bound
  el_badge(
    el_button("inc", "+1", on = list(click = "$vueRef.count++")),
    id = "bdg",
    value = v_bind("$vueComputed.twice")
  ),
  # in an overlay: a switch in a dialog, both bound to one store
  el_button("open", "Open", on = list(click = "$vueStore.app.open = true")),
  el_dialog(
    "dlg",
    title = "Settings",
    visible = v_model("$vueStore.app.open"),
    content = el_switch("dlg_sw", value = v_model("$vueStore.app.on"))
  ),
  el_switch("main_sw", value = v_model("$vueStore.app.on")),
  # in a cell: a tag reading the store
  el_table(
    "tbl",
    data = data.frame(x = 1:2),
    columns = list(
      el_table_column("x", "X"),
      el_table_column(
        label = "On",
        cell = el$tag(v_if("$vueStore.app.on"), class = "cell-on", "on")
      )
    )
  ),
  # drawn later, and redrawn
  uiOutput("later"),
  actionButton("redraw", "Redraw"),
  # the route
  vue_app(
    "routed",
    tags$span(class = "route", "{{ path }}"),
    data = list(path = v_bind("$route.path"))
  ),
  # two instances of a module
  panel_ui("m1"),
  panel_ui("m2"),
  # $find()
  el_tree("tr", data = list(list(label = "apple"), list(label = "pear"))),
  el_button("flt", "Filter", on = list(click = "$find('tr').filter('pe')")),
  actionButton("srv", "Server sets"),
  verbatimTextOutput("seen")
)

server <- function(input, output, session) {
  output$later <- renderUI({
    input$redraw
    tagList(
      el_tag(
        id = "later_tag",
        label = "later",
        type = v_bind("$vueStore.app.on ? 'success' : 'info'")
      ),
      # a store drawn after the components that read it
      vue_store("late", state = list(word = "late store")),
      vue_app(
        "late_read",
        tags$span(class = "late", "{{ $vueStore.late.word }}")
      )
    )
  })
  observeEvent(input$srv, {
    update_el_switch(session, "main_sw", value = FALSE)
    update_vue(session, "count", value = 10)
  })
  output$seen <- renderText(paste0(
    "count=",
    input$count,
    " twice=",
    input$twice,
    " main=",
    input$main_sw,
    " dlg=",
    input$dlg_sw
  ))
}

shinyApp(ui, server)
