# Fixture for test-browser-combos.R: components put together the way an app
# does -- folded into one another, inside a config provider, drawn later by
# renderUI(), hidden in a dialog -- where each bug here was found.
library(shiny)

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
    el_radio_group(
      "size_pick",
      choices = c("small", "default", "large"),
      selected = "small",
      button = TRUE
    ),
    # a tooltip's button and a select, folded in at different depths
    el_space(
      id = "sp",
      el_tooltip("tip", el_button("tip_btn", "In a tooltip"), content = "c"),
      el_select("sel", choices = c("a", "b", "c"), selected = "a")
    ),
    el_button("upd", "Update the folded ones"),
    # drawn later, inside the provider
    uiOutput("dyn"),
    # a select in an input's slot, inside the provider
    el_input(
      "q",
      slots = list(
        prepend = el_select(
          "kind",
          choices = c(Name = "n", Id = "i"),
          selected = "n"
        )
      )
    ),
    # two trees in one instance, each with its methods
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
    el_button("check_a", "Check Pear in A"),
    el_button("check_b", "Check Leek in B")
  ),
  el_button("open", "Open the dialog"),
  el_dialog(
    "dlg",
    title = "Tabs drawn while hidden",
    content = el_tabs(
      "dlg_tabs",
      tabs = list(
        list(name = "a", label = "First", content = "first"),
        list(name = "b", label = "Second, longer", content = "second")
      )
    )
  )
)

server <- function(input, output, session) {
  output$dyn <- renderUI(el_button("dyn_btn", "Drawn later"))
  observeEvent(input$size_pick, ignoreInit = TRUE, {
    update_el_config_provider(session, "cfg", size = input$size_pick)
  })
  observeEvent(input$upd, {
    update_el_button(session, "tip_btn", label = "Updated")
    update_el_select(session, "sel", selected = "c")
    update_el_select(session, "kind", selected = "i")
  })
  observeEvent(
    input$check_a,
    call_el(session, "tree_a", "setChecked", list(12, TRUE, FALSE))
  )
  observeEvent(
    input$check_b,
    call_el(session, "tree_b", "setChecked", list(21, TRUE, FALSE))
  )
  observeEvent(input$open, update_el_dialog(session, "dlg", visible = TRUE))
}

shinyApp(ui, server)
