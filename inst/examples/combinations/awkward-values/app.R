# Ids and values an app does not choose with a component in mind: ids with
# dots and hyphens, as Shiny allows them, inside a module and in tabs a tab
# is inserted into; labels holding markup, quotes, template braces and
# non-ASCII text, shown as text; numeric choices, an empty checkbox group,
# an empty date, a negative fraction, a range, a select of 3000 options --
# reported, and updated. A select in a space is given a width, as in
# Element's demos: it has none of its own there, and would shrink to its
# arrow.
#
#   shiny::runApp(system.file("examples/combinations/awkward-values", package = "shiny.element"))
#
# tools/combinations.R drives it in a browser and checks each step
# (tools/combinations/awkward-values.R).

library(shiny)
library(shiny.element)

mod_ui <- function(id) {
  ns <- NS(id)
  tagList(
    el_select(
      ns("pick.one"),
      choices = c("α" = "a", "β & γ" = "b"),
      selected = "a",
      width = "120px"
    ),
    el_button(ns("go"), "Go <b>bold?</b>")
  )
}
mod_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    observeEvent(
      input$go,
      update_el_select(session, "pick.one", selected = "b")
    )
  })
}

ui <- el_page(
  h4("Ids with dots and hyphens"),
  el_space(
    el_input("in.dot", value = "dotted"),
    el_switch("sw-dash", value = TRUE),
    mod_ui("m.1")
  ),
  el_tabs(
    "tabs.dot",
    tabs = list(list(name = "a", label = "A", content = "a"))
  ),
  el_button("add_tab", "Add a tab"),
  h4("Text that looks like markup"),
  el_space(
    el_button("lbl", "<script>alert(1)</script> & \"quotes\" 'single'"),
    el_select(
      "weird",
      choices = c("<b>x</b>" = "x", "naïve café" = "c", "{{ 1 + 1 }}" = "t"),
      selected = "x",
      width = "160px"
    ),
    el_tag(id = "tag1", label = "{{ 7 * 6 }}")
  ),
  h4("Awkward values"),
  el_space(
    wrap = TRUE,
    el_select(
      "nums",
      choices = c(One = 1, Two = 2, Ten = 10),
      selected = 10,
      width = "120px"
    ),
    el_checkbox_group("empty_cg", choices = c("a", "b")),
    el_date_picker("date_na", value = NULL),
    el_input_number("num_neg", value = -0.5, step = 0.25),
    el_select(
      "many",
      choices = paste("Option", 1:3000),
      filterable = TRUE,
      width = "200px"
    )
  ),
  el_slider("sl_range", value = c(10, 40), range = TRUE),
  el_button("set_values", "Set awkward values", type = "primary"),
  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  mod_server("m.1")
  observeEvent(input$add_tab, {
    insert_el_tab(session, "tabs.dot", "b", label = "B", content = "b")
  })
  observeEvent(input$set_values, {
    update_el_input(session, "in.dot", value = "a \"quoted\" <tag> & é")
    update_el_select(session, "nums", selected = 2)
    update_el_checkbox_group(session, "empty_cg", selected = character())
    update_el_slider(session, "sl_range", value = c(0, 100))
    update_el_select(session, "many", selected = "Option 2999")
  })
  output$dump <- renderPrint(str(list(
    in.dot = input$in.dot,
    `sw-dash` = input$`sw-dash`,
    tabs.dot = input$tabs.dot,
    `m.1-pick.one` = input$`m.1-pick.one`,
    weird = input$weird,
    nums = input$nums,
    empty_cg = input$empty_cg,
    date_na = input$date_na,
    num_neg = input$num_neg,
    sl_range = input$sl_range,
    many = input$many
  )))
}

shinyApp(ui, server)
