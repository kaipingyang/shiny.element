## basic
el_tabs("basic", selected = "first", tabs = list(
  list(name = "first", label = "User", content = "User"),
  list(name = "second", label = "Config", content = "Config"),
  list(name = "third", label = "Role", content = "Role"),
  list(name = "fourth", label = "Task", content = "Task")))

## card-style
el_tabs("card", type = "card", tabs = list(
  list(name = "first", label = "User", content = "User"),
  list(name = "second", label = "Config", content = "Config"),
  list(name = "third", label = "Role", content = "Role"),
  list(name = "fourth", label = "Task", content = "Task")))

## border-card
el_tabs("bc", type = "border-card", tabs = list(
  list(name = "first", label = "User", content = "User"),
  list(name = "second", label = "Config", content = "Config"),
  list(name = "third", label = "Role", content = "Role"),
  list(name = "fourth", label = "Task", content = "Task")))

## tab-position
el_tabs("pos", tab_position = "left", tabs = list(
  list(name = "first", label = "User", content = "User"),
  list(name = "second", label = "Config", content = "Config"),
  list(name = "third", label = "Role", content = "Role"),
  list(name = "fourth", label = "Task", content = "Task")))

## custom-tab
#' A `label` may be markup.
el_tabs("cus", type = "border-card", tabs = list(
  list(name = "route", label = tagList(el_icon("Calendar"), " Route"), content = "Route"),
  list(name = "config", label = "Config", content = "Config"),
  list(name = "role", label = "Role", content = "Role"),
  list(name = "task", label = "Task", content = "Task")))

## dynamic-tabs
#' `editable = TRUE` adds the close buttons and the new-tab button; the
#' tabs close themselves, and a new one is the server's to make, with
#' `insert_el_tab()`.
#| shot_js = "var b = document.querySelector('#shot .el-tabs__new-tab'); b.click(); setTimeout(function(){ b.click(); }, 600)", shot_wait = 2.5
ui <- el_page(el_tabs("docs", type = "card", editable = TRUE, tabs = list(
  list(name = "1", label = "Tab 1", content = "Tab 1 content"),
  list(name = "2", label = "Tab 2", content = "Tab 2 content"))))

server <- function(input, output, session) {
  n <- 2
  observeEvent(input$docs_tab_add, {
    n <<- n + 1
    insert_el_tab(id = "docs", name = as.character(n), label = "New Tab",
                  content = "New Tab content")
  })
}

shinyApp(ui, server)

## customized-add-button-icon
el_tabs("icon", type = "card", editable = TRUE, add_icon = "CirclePlus", tabs = list(
  list(name = "1", label = "Tab 1", content = "Tab 1 content"),
  list(name = "2", label = "Tab 2", content = "Tab 2 content")))

## customized-trigger
#| shot_js = "document.querySelector('#add_container button').click()", shot_wait = 1.5
ui <- el_page(
  el_button("add", "add tab", size = "small"),
  el_tabs("docs", type = "card", closable = TRUE, tabs = list(
    list(name = "1", label = "Tab 1", content = "Tab 1 content"),
    list(name = "2", label = "Tab 2", content = "Tab 2 content"))))

server <- function(input, output, session) {
  n <- 2
  observeEvent(input$add, {
    n <<- n + 1
    insert_el_tab(id = "docs", name = as.character(n), label = "New Tab", content = "New Tab content")
  })
}

shinyApp(ui, server)

## default-value
#' `selected` opens a tab other than the first.
el_tabs("dv", selected = "third", type = "card", tabs = list(
  list(name = "first", label = "User", content = "User"),
  list(name = "second", label = "Config", content = "Config"),
  list(name = "third", label = "Role", content = "Role"),
  list(name = "fourth", label = "Task", content = "Task")))
