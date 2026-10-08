# A config provider resized from the server; a select in an input's
# slot; tabs, a nested dialog and a message box over a dialog; a popconfirm
# in a table cell; components added and removed with insertUI().
#
#   shiny::runApp(system.file("examples/combinations/overlays-and-cells", package = "shiny.element"))
#
# tools/combinations.R drives it in a browser and checks each step
# (tools/combinations/overlays-and-cells.R).

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
rows <- data.frame(id = 1:3, name = c("Ada", "Grace", "Linus"))

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
    el_button("static_btn", "Static"),
    uiOutput("dyn"),
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
    el_button("check_a", "Check Pear in tree A"),
    el_input(
      "q",
      placeholder = "search",
      slots = list(
        prepend = el_select(
          "kind",
          choices = c(Name = "n", Id = "i"),
          selected = "n",
          width = "90px"
        )
      )
    ),
    el_button("set_kind", "Set kind to Id")
  ),
  el_button("open_dlg", "Open dialog"),
  el_dialog(
    "dlg",
    title = "Outer",
    width = "600px",
    content = tagList(
      el_tabs(
        "dlg_tabs",
        tabs = list(
          list(name = "a", label = "First tab", content = "first"),
          list(
            name = "b",
            label = "A much longer second tab",
            content = el_table(data = rows)
          )
        )
      ),
      el_button("open_inner", "Open inner dialog"),
      el_button("ask", "Ask a question")
    )
  ),
  el_dialog(
    "inner",
    title = "Inner",
    width = "300px",
    content = "inner content"
  ),
  el_table_output("acts"),
  el_button("add", "insertUI a switch"),
  el_button("remove", "removeUI it"),
  tags$div(id = "slot"),
  verbatimTextOutput("dump")
)

server <- function(input, output, session) {
  output$dyn <- renderUI(el_button("dyn_btn", "Dynamic"))
  observeEvent(
    input$size_pick,
    ignoreInit = TRUE,
    update_el_config_provider(session, "cfg", size = input$size_pick)
  )
  observeEvent(
    input$check_a,
    call_el(session, "tree_a", "setChecked", list(12, TRUE, FALSE))
  )
  observeEvent(
    input$set_kind,
    update_el_select(session, "kind", selected = "i")
  )
  observeEvent(input$open_dlg, update_el_dialog(session, "dlg", visible = TRUE))
  observeEvent(
    input$open_inner,
    update_el_dialog(session, "inner", visible = TRUE)
  )
  observeEvent(
    input$ask,
    el_message_box(session, "q1", "Sure?", title = "Question")
  )
  output$acts <- render_el_table(el_table(
    data = rows,
    columns = list(
      el_table_column("name", "Name"),
      el_table_column(
        label = "Ops",
        cell = tagList(
          htmltools::HTML(paste0(
            "<el-popconfirm title=\"Delete?\" @confirm=\"rowAction('del', scope)\">",
            "<template #reference><el-button type=\"danger\" link>Delete</el-button></template>",
            "</el-popconfirm>"
          )),
          el$button(
            link = NA,
            type = "primary",
            `@click` = "rowAction('edit', scope)",
            "Edit"
          )
        )
      )
    )
  ))
  n <- 0
  observeEvent(input$add, {
    n <<- n + 1
    insertUI(
      "#slot",
      ui = tags$div(
        id = paste0("w", n),
        el_switch(paste0("ins_sw", n), value = TRUE)
      )
    )
  })
  observeEvent(input$remove, removeUI(paste0("#w", n)))
  output$dump <- renderText(inputs_text(list(
    kind = input$kind,
    q1 = input$q1,
    edit = input$acts_edit,
    del = input$acts_del,
    a = input$tree_a_checked,
    b = input$tree_b_checked,
    sw1 = input$ins_sw1
  )))
}

shinyApp(ui, server)
