## basic
el_tabs(
  "basic",
  selected = "first",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)

## card-style
el_tabs(
  "card",
  type = "card",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)

## border-card
el_tabs(
  "bc",
  type = "border-card",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)

## tab-position
el_tabs(
  "pos",
  tab_position = "left",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)

## custom-tab
#' A `label` may be markup.
el_tabs(
  "cus",
  type = "border-card",
  tabs = list(
    el_tab_pane(
      tagList(el_icon("Calendar"), " Route"),
      "Route",
      name = "route"
    ),
    el_tab_pane("Config", "Config", name = "config"),
    el_tab_pane("Role", "Role", name = "role"),
    el_tab_pane("Task", "Task", name = "task")
  )
)

## dynamic-tabs
#' `editable = TRUE` adds the close buttons and the new-tab button; the
#' tabs close themselves, and a new one is the server's to make, with
#' `insert_el_tab()`.
#| shot_js = "var b = document.querySelector('#shot .el-tabs__new-tab'); b.click(); setTimeout(function(){ b.click(); }, 600)", shot_wait = 2.5
ui <- el_page(el_tabs(
  "docs",
  type = "card",
  editable = TRUE,
  tabs = list(
    el_tab_pane("Tab 1", "Tab 1 content", name = "1"),
    el_tab_pane("Tab 2", "Tab 2 content", name = "2")
  )
))

server <- function(input, output, session) {
  n <- 2
  observeEvent(input$docs_tab_add, {
    n <<- n + 1
    insert_el_tab(
      id = "docs",
      tab = el_tab_pane("New Tab", "New Tab content", name = as.character(n))
    )
  })
}

shinyApp(ui, server)

## customized-add-button-icon
el_tabs(
  "icon",
  type = "card",
  editable = TRUE,
  add_icon = "CirclePlus",
  tabs = list(
    el_tab_pane("Tab 1", "Tab 1 content", name = "1"),
    el_tab_pane("Tab 2", "Tab 2 content", name = "2")
  )
)

## customized-trigger
#| shot_js = "document.querySelector('#add_container button').click()", shot_wait = 1.5
ui <- el_page(
  el_button("add", "add tab", size = "small"),
  el_tabs(
    "docs",
    type = "card",
    closable = TRUE,
    tabs = list(
      el_tab_pane("Tab 1", "Tab 1 content", name = "1"),
      el_tab_pane("Tab 2", "Tab 2 content", name = "2")
    )
  )
)

server <- function(input, output, session) {
  n <- 2
  observeEvent(input$add, {
    n <<- n + 1
    insert_el_tab(
      id = "docs",
      tab = el_tab_pane("New Tab", "New Tab content", name = as.character(n))
    )
  })
}

shinyApp(ui, server)

## default-value
#' `selected` opens a tab other than the first.
el_tabs(
  "dv",
  selected = "third",
  type = "card",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)
