## basic
el_table("cars", data = head(mtcars[, 1:5], 4))

## striped
el_table("striped", data = head(mtcars[, 1:5], 4), stripe = TRUE)

## with-border
el_table("bordered", data = head(mtcars[, 1:5], 4), border = TRUE)

## with-status
tagList(
  tags$style(
    ".el-table .warning-row { background: oldlace; }
              .el-table .success-row { background: #f0f9eb; }"
  ),
  el_table(
    "status",
    data = head(mtcars[, 1:4], 4),
    row_class_name = JS(
      "function({row, rowIndex}) {",
      "  return rowIndex === 1 ? 'warning-row' : rowIndex === 3 ? 'success-row' : '';",
      "}"
    )
  )
)

## fixed-header
el_table("fixedhead", data = iris, height = "250px")

## fixed-column
el_table(
  "fixedcol",
  data = head(mtcars, 4),
  border = TRUE,
  columns = c(
    list(list(prop = "mpg", label = "MPG", width = "120", fixed = TRUE)),
    lapply(names(mtcars)[-1], function(n) {
      list(prop = n, label = n, width = "120")
    }),
    list(list(
      label = "Operations",
      width = "120",
      fixed = "right",
      cell = el$button(link = TRUE, size = "small", "Detail")
    ))
  )
)

## fixed-column-and-header
el_table(
  "fixedboth",
  data = head(mtcars, 12),
  height = "250px",
  columns = c(
    list(list(prop = "mpg", label = "MPG", width = "120", fixed = TRUE)),
    lapply(names(mtcars)[-1], function(n) {
      list(prop = n, label = n, width = "120")
    })
  )
)

## fixed-header-with-fluid-header
el_table("fluid", data = head(mtcars[, 1:5], 10), max_height = "250px")

## grouping-header
people <- data.frame(
  date = "2016-05-03",
  name = "Tom",
  state = "California",
  city = "Los Angeles",
  address = "No. 189, Grove St",
  zip = "CA 90036"
)
el_table(
  "grouped",
  data = people[rep(1, 3), ],
  border = TRUE,
  columns = list(
    list(prop = "date", label = "Date", width = "150"),
    list(
      label = "Delivery Info",
      children = list(
        list(prop = "name", label = "Name", width = "120"),
        list(
          label = "Address Info",
          children = list(
            list(prop = "state", label = "State", width = "120"),
            list(prop = "city", label = "City", width = "120"),
            list(prop = "address", label = "Address"),
            list(prop = "zip", label = "Zip", width = "120")
          )
        )
      )
    )
  )
)

## single-select
#| shot_js = "document.querySelector('#second_container button').click()"
#| shot_wait = 2
ui <- el_page(
  el_table("single", data = head(iris, 4), highlight_current_row = TRUE),
  el_button("second", "Select second row"),
  el_button("clear", "Clear selection"),
  verbatimTextOutput("current")
)

server <- function(input, output, session) {
  observeEvent(
    input$second,
    call_el(session, "single", "setCurrentRow", list(el_table_row(2)))
  )
  observeEvent(input$clear, call_el(session, "single", "setCurrentRow"))
  output$current <- renderPrint(input$single_current_change$row_index)
}

shinyApp(ui, server)

## multi-select
#| shot_js = "document.querySelector('#toggle_container button').click()"
#| shot_wait = 2
cars <- head(mtcars[, 1:4], 5)

ui <- el_page(
  el_table("cars", data = cars, selection = TRUE),
  el_button("toggle", "Toggle rows 2 and 3"),
  el_button("none", "Clear selection"),
  verbatimTextOutput("picked")
)

server <- function(input, output, session) {
  observeEvent(
    input$toggle,
    for (i in 2:3) {
      call_el(session, "cars", "toggleRowSelection", list(el_table_row(i)))
    }
  )
  observeEvent(input$none, call_el(session, "cars", "clearSelection"))
  output$picked <- renderPrint(cars[input$cars_selected_rows, ])
}

shinyApp(ui, server)

## sort
el_table(
  "sorted",
  data = head(mtcars[, 1:4], 6),
  default_sort = list(prop = "mpg", order = "descending"),
  columns = list(
    list(prop = "mpg", label = "MPG", sortable = TRUE),
    list(prop = "cyl", label = "Cylinders", sortable = TRUE),
    list(prop = "disp", label = "Displacement")
  )
)

## filter
staff <- data.frame(
  name = c("Tom", "Ada", "Linus", "Grace"),
  tag = c("Home", "Office", "Home", "Office")
)
el_table(
  "filtered",
  data = staff,
  columns = list(
    list(prop = "name", label = "Name"),
    list(
      prop = "tag",
      label = "Tag",
      filters = list(
        list(text = "Home", value = "Home"),
        list(text = "Office", value = "Office")
      ),
      filter_method = JS("function(value, row) { return row.tag === value; }"),
      cell = el$tag(
        ":type" = "scope.row.tag === 'Home' ? 'primary' : 'success'",
        "disable-transitions" = NA,
        "{{ scope.row.tag }}"
      )
    )
  )
)

## custom-column
#| shot_js = "document.querySelectorAll('#shot .el-table__body .el-button')[1].click()"
#| shot_wait = 2
tasks <- data.frame(
  task = c("Draft", "Review", "Publish"),
  done = c(100, 60, 0)
)

ui <- el_page(
  el_table(
    "tasks",
    data = tasks,
    columns = list(
      list(prop = "task", label = "Task"),
      list(
        prop = "done",
        label = "Progress",
        cell = el$progress(":percentage" = "scope.row.done")
      ),
      list(
        label = "Operations",
        cell = tagList(
          el$button(
            size = "small",
            "@click" = "rowAction('edit', scope)",
            "Edit"
          ),
          el$button(
            size = "small",
            type = "danger",
            "@click" = "rowAction('delete', scope)",
            "Delete"
          )
        )
      )
    )
  ),
  verbatimTextOutput("which")
)

server <- function(input, output, session) {
  output$which <- renderPrint(list(
    edit = input$tasks_edit$row_index,
    delete = input$tasks_delete$row_index
  ))
}

shinyApp(ui, server)

## custom-header
el_table(
  "hdr",
  data = head(mtcars[, 1:3], 3),
  columns = list(
    list(
      prop = "mpg",
      label = "MPG",
      header_html = "<b>MPG</b> <small>(miles/gallon)</small>"
    ),
    list(prop = "cyl", label = "Cylinders"),
    list(prop = "disp", label = "Displacement")
  )
)

## expandable-row
el_table(
  "exp",
  data = data.frame(
    name = c("Tom", "Ada"),
    city = c("Los Angeles", "London"),
    shop = c("No. 189, Grove St", "1 Baker St")
  ),
  default_expand_all = TRUE,
  columns = list(
    list(
      type = "expand",
      cell = tags$p("City: {{ scope.row.city }} -- Shop: {{ scope.row.shop }}")
    ),
    list(prop = "name", label = "Name")
  )
)

## tree-and-lazy
#| shot_js = "document.querySelector('#shot .el-table__expand-icon').click()"
#| shot_wait = 2
teams <- data.frame(
  id = c(1, 2),
  name = c("Engineering", "Design"),
  size = c(42, 9),
  hasChildren = c(TRUE, FALSE)
)

ui <- el_page(el_table(
  "teams",
  data = teams,
  row_key = "id",
  lazy = TRUE,
  columns = list(
    list(prop = "name", label = "Team"),
    list(prop = "size", label = "People")
  )
))

server <- function(input, output, session) {
  observeEvent(input$teams_load, {
    el_load_children(
      id = "teams",
      request = input$teams_load,
      children = data.frame(
        id = c(11, 12),
        name = c("Platform", "Product"),
        size = c(18, 24)
      )
    )
  })
}

shinyApp(ui, server)

## summary
el_table(
  "sums",
  data = head(mtcars[, c("mpg", "hp", "wt")], 5),
  show_summary = TRUE,
  sum_text = "Total",
  border = TRUE
)

## rowspan-and-colspan
el_table(
  "spans",
  data = head(mtcars[, 1:4], 6),
  border = TRUE,
  span_method = JS(
    "function({row, column, rowIndex, columnIndex}) {",
    "  if (columnIndex === 0) return rowIndex % 2 === 0 ? [2, 1] : [0, 0];",
    "}"
  )
)

## custom-index
el_table(
  "idx",
  data = head(iris[, c(1, 5)], 4),
  columns = list(
    list(type = "index", index = JS("function(i) { return i * 2; }")),
    list(prop = "Sepal_Length", label = "Sepal length"),
    list(prop = "Species", label = "Species")
  )
)

## show-overflow-tooltip
el_table(
  "tt",
  show_overflow_tooltip = TRUE,
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  ),
  columns = list(
    list(prop = "date", label = "Date", width = 120),
    list(prop = "name", label = "Name", width = 120),
    list(prop = "address", label = "Address", width = 200)
  )
)

## fixed-column-and-group-header
el_table(
  "fg",
  height = "250px",
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  ),
  columns = list(
    list(prop = "date", label = "Date", width = 150, fixed = "left"),
    list(
      label = "Delivery Info",
      children = list(
        list(prop = "name", label = "Name", width = 120),
        list(
          label = "Address Info",
          children = list(list(
            prop = "address",
            label = "Address",
            width = 300
          ))
        )
      )
    )
  )
)

## check-strictly
#' A tree table's rows tick on their own, not with their children.
el_table(
  "strict",
  row_key = "id",
  selection = TRUE,
  default_expand_all = TRUE,
  data = list(
    list(id = 1, date = "2016-05-02", name = "Tom"),
    list(
      id = 3,
      date = "2016-05-01",
      name = "Tom",
      children = list(
        list(id = 31, date = "2016-05-01", name = "Tom"),
        list(id = 32, date = "2016-05-01", name = "Tom")
      )
    )
  ),
  columns = list(
    list(prop = "date", label = "Date"),
    list(prop = "name", label = "Name")
  )
)

## table-layout
el_table(
  "layout_auto",
  table_layout = "auto",
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  )
)

## tooltip-formatter
el_table(
  "tt_fmt",
  show_overflow_tooltip = TRUE,
  data = data.frame(
    date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
    name = "Tom",
    address = "No. 189, Grove St, Los Angeles, a long address that runs on"
  ),
  tooltip_formatter = JS("function(d) { return 'Address: ' + d.row.address; }"),
  columns = list(
    list(prop = "date", label = "Date", width = 120),
    list(prop = "address", label = "Address", width = 200)
  )
)
