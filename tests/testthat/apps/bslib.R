# Fixture for test-browser-bslib.R: components inside bslib's and Shiny's
# containers -- a sidebar, cards, a closed accordion, a hidden nav panel, a
# tabsetPanel, a conditionalPanel, a modal -- with bslib's dark mode switch
# and shinyjs's show, hide, toggle, enable and disable.
library(shiny)
library(bslib)

theme <- el_theme()

ui <- page_sidebar(
  title = "bslib",
  theme = theme,
  use_element(theme = theme),
  shinyjs::useShinyjs(),
  sidebar = sidebar(
    el_select("sb_sel", choices = c("a", "b"), value = "a"),
    input_dark_mode(id = "dm", mode = "light")
  ),
  layout_columns(
    card(
      card_header("table"),
      el_table("tbl", data = head(mtcars[, 1:3], 3))
    ),
    card(
      card_header("accordion"),
      accordion(
        open = FALSE,
        accordion_panel("closed", el_input("acc_in", value = "in accordion"))
      )
    )
  ),
  navset_card_tab(
    id = "nav",
    nav_panel("one", el_button("nav_btn", "visible")),
    nav_panel(
      "two",
      el_slider("nav_sl", value = 30),
      el_tabs(
        "nav_tabs",
        tabs = list(
          list(name = "a", label = "Alpha", content = "a"),
          list(name = "b", label = "Beta", content = "b")
        )
      )
    )
  ),
  tabsetPanel(
    id = "tsp",
    tabPanel("A", "a"),
    tabPanel("B", el_rate("tsp_rate", value = 2))
  ),
  checkboxInput("show_cp", "show", FALSE),
  conditionalPanel("input.show_cp", el_switch("cp_sw", value = TRUE)),
  el_input("js_in", value = "shinyjs target"),
  actionButton("modal", "modal"),
  # bslib's tooltip and popover around a component
  tooltip(el_button("tip_btn", "tip"), "tip text"),
  popover(el_input("pop_in", value = "pop"), "pop body", title = "pop"),
  # shinyjs::reset() over components and a Shiny input
  tags$div(
    id = "reset_area",
    el_input("rs_in", value = "start"),
    el_select(
      "rs_sel",
      choices = c("a", "b", "c"),
      value = "a",
      multiple = TRUE
    ),
    textInput("rs_txt", "text", "orig")
  )
)

server <- function(input, output, session) {
  observeEvent(input$modal, {
    showModal(modalDialog(
      el_select("md_sel", choices = c("x", "y"), value = "x"),
      easyClose = TRUE
    ))
  })
  observeEvent(input$do_hide, shinyjs::hide("js_in"))
  observeEvent(input$do_show, shinyjs::show("js_in"))
  observeEvent(input$do_toggle, shinyjs::toggle("js_in"))
  observeEvent(input$do_disable, shinyjs::disable("js_in"))
  observeEvent(input$do_enable, shinyjs::enable("js_in"))
  observeEvent(input$do_change, {
    update_el_input(session, "rs_in", value = "changed")
    update_el_select(session, "rs_sel", value = c("b", "c"))
    updateTextInput(session, "rs_txt", value = "changed")
  })
  observeEvent(input$do_reset, shinyjs::reset("reset_area"))
}

shinyApp(ui, server)
