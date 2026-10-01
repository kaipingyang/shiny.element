# Element UI's own "Container" example, rebuilt in R: a side menu, a header
# with a dropdown, and a table in the main area.
#
#   shiny::runApp(system.file("examples/dashboards/admin-layout", package = "shiny.element"))

library(shiny)
library(shiny.element)

rows <- data.frame(
  date    = rep("2016-05-02", 20),
  name    = rep("Tom", 20),
  address = rep("No. 189, Grove St, Los Angeles", 20)
)

# One navigator: two titled groups and a nested submenu, as upstream has it
navigator <- function(i, icon, label) {
  sub <- function(n) paste0(i, "-", n)
  list(index = as.character(i), label = label, icon = icon, children = list(
    list(group = TRUE, title = "Group 1", children = list(
      list(index = sub(1), label = "Option 1"),
      list(index = sub(2), label = "Option 2"))),
    list(group = TRUE, title = "Group 2", children = list(
      list(index = sub(3), label = "Option 3"))),
    list(index = sub(4), label = "Option 4", children = list(
      list(index = sub("4-1"), label = "Option 4-1")))
  ))
}

ui <- el_page(
  el_container(
    style = "height: 500px; border: 1px solid #eee",
    el_aside(
      width = "200px", style = "background-color: rgb(238, 241, 246)",
      el_menu("nav", default_openeds = c("1", "3"), items = list(
        navigator(1, "el-icon-message", "Navigator One"),
        navigator(2, "el-icon-menu", "Navigator Two"),
        navigator(3, "el-icon-setting", "Navigator Three")
      ))
    ),
    el_container(
      el_header(
        style = "text-align: right; font-size: 12px; background-color: #B3C0D1;
                 color: #333; line-height: 60px",
        el_dropdown("account",
          trigger_label = tags$i(class = "el-icon-setting",
                                 style = "margin-right: 15px"),
          items = list(list(command = "view", label = "View"),
                       list(command = "add", label = "Add"),
                       list(command = "delete", label = "Delete"))),
        tags$span("Tom")
      ),
      el_main(
        el_table("people", data = rows, columns = list(
          list(prop = "date", label = "Date", width = "140"),
          list(prop = "name", label = "Name", width = "120"),
          list(prop = "address", label = "Address")
        ))
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$nav, {
    el_message(session, paste("Navigated to", input$nav))
  })
  observeEvent(input$account, {
    el_message(session, paste("Account:", input$account), type = "info")
  })
}

shinyApp(ui, server)
