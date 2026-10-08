# Components drawn by renderUI() inside a config provider; two trees in
# one space, each reached by its own call_el(); a drawer holding tabs with a
# table and a calendar output; components in a carousel; steps driven by a
# button group.
#
#   shiny::runApp(system.file("examples/combinations/drawn-later", package = "shiny.element"))
#
# tools/combinations.R drives it in a browser and checks each step
# (tools/combinations/drawn-later.R).

library(shiny)
library(shiny.element)

# what the server holds, one input per line
inputs_text <- function(x) {
  paste(
    sprintf(
      "%s: %s",
      names(x),
      vapply(
        x,
        function(v) {
          if (is.null(v)) "NULL" else paste(format(unclass(v)), collapse = ", ")
        },
        character(1)
      )
    ),
    collapse = "\n"
  )
}

tree_data <- list(
  list(
    id = 1,
    label = "Fruit",
    children = list(
      list(id = 11, label = "Apple"),
      list(id = 12, label = "Pear")
    )
  ),
  list(id = 2, label = "Veg", children = list(list(id = 21, label = "Leek")))
)

ui <- el_page(
  el_config_provider(
    id = "cfg",
    size = "small",
    tags$h4("renderUI inside a config provider"),
    el_button("regen", "Draw again"),
    uiOutput("dyn"),
    verbatimTextOutput("dump_dyn"),
    tags$h4("two trees in one space"),
    el_space(
      id = "trees",
      el_tree(
        "tree_a",
        data = tree_data,
        node_key = "id",
        show_checkbox = TRUE,
        default_expand_all = TRUE
      ),
      el_tree(
        "tree_b",
        data = tree_data,
        node_key = "id",
        show_checkbox = TRUE,
        default_expand_all = TRUE
      )
    ),
    el_button("check_b", "Check Leek in tree B"),
    el_tree_select(
      "tsel",
      data = list(),
      props = list(value = "id", label = "label", children = "children"),
      width = "200px"
    ),
    verbatimTextOutput("dump_tree")
  ),
  tags$h4("a drawer with tabs and a table"),
  el_button("open_drawer", "Open drawer"),
  el_drawer(
    "drw",
    title = "Details",
    size = "60%",
    content = el_tabs(
      "dtabs",
      tabs = list(
        list(name = "t", label = "Table", content = el_table_output("dtbl")),
        list(
          name = "c",
          label = "Calendar",
          content = el_calendar_output("dcal")
        )
      )
    )
  ),
  tags$h4("carousel with components"),
  el_carousel(
    "car",
    height = "160px",
    autoplay = FALSE,
    items = list(
      el_carousel_item(
        name = "s1",
        el_card(header = "Slide 1", el_button("car_btn", "Inside slide"))
      ),
      el_carousel_item(
        name = "s2",
        el_card(header = "Slide 2", el_rate("car_rate", value = 2))
      )
    )
  ),
  tags$h4("steps driven by a button group"),
  el_steps(
    "stp",
    active = 0,
    steps = list(el_step("One"), el_step("Two"), el_step("Three"))
  ),
  el_button_group(el_button("prev", "Prev"), el_button("nxt", "Next")),
  verbatimTextOutput("dump_misc")
)

server <- function(input, output, session) {
  n <- reactiveVal(1)
  observeEvent(input$regen, n(n() + 1))
  output$dyn <- renderUI({
    el_space(
      id = "dyn_space",
      el_button("dyn_btn", paste("Dynamic", n())),
      el_select(
        "dyn_sel",
        choices = c("a", "b", "c"),
        selected = "a",
        width = "100px"
      ),
      el_switch("dyn_sw", value = n() %% 2 == 0)
    )
  })
  output$dump_dyn <- renderText(inputs_text(list(
    btn = input$dyn_btn,
    sel = input$dyn_sel,
    sw = input$dyn_sw
  )))
  observeEvent(
    input$dyn_btn,
    update_el_select(session, "dyn_sel", selected = "c")
  )

  observeEvent(
    input$check_b,
    call_el(session, "tree_b", "setChecked", list(21, TRUE, FALSE))
  )
  observe({
    ticked <- input$tree_a_checked
    keys <- unlist(input$tree_a_checked)
    update_el_tree_select(session, "tsel", data = tree_data)
  }) |>
    bindEvent(input$tree_a_checked, ignoreInit = TRUE)
  output$dump_tree <- renderText(inputs_text(list(
    a = input$tree_a,
    a_check = input$tree_a_checked,
    b_check = input$tree_b_checked
  )))

  observeEvent(
    input$open_drawer,
    update_el_drawer(session, "drw", visible = TRUE)
  )
  output$dtbl <- render_el_table(el_table(
    data = mtcars[1:5, 1:6],
    selection = TRUE
  ))
  output$dcal <- render_el_calendar(el_calendar(
    events = data.frame(date = Sys.Date(), title = "Today's event")
  ))

  active <- reactiveVal(0)
  observeEvent(input$nxt, {
    active(min(3, active() + 1))
    update_el_steps(session, "stp", active = active())
  })
  observeEvent(input$prev, {
    active(max(0, active() - 1))
    update_el_steps(session, "stp", active = active())
  })
  output$dump_misc <- renderText(inputs_text(list(
    car_btn = input$car_btn,
    car_rate = input$car_rate,
    car = input$car,
    nxt = input$nxt,
    prev = input$prev
  )))
}

shinyApp(ui, server)
