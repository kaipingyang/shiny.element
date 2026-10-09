## basic
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  data = tableData,
  columns = list(
    el_table_column("date", "Date", width = 180),
    el_table_column("name", "Name", width = 180),
    el_table_column("address", "Address")
  )
)

## striped
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  data = tableData,
  stripe = TRUE,
  columns = list(
    el_table_column("date", "Date", width = 180),
    el_table_column("name", "Name", width = 180),
    el_table_column("address", "Address")
  )
)

## with-border
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  data = tableData,
  border = TRUE,
  columns = list(
    el_table_column("date", "Date", width = 180),
    el_table_column("name", "Name", width = 180),
    el_table_column("address", "Address")
  )
)

## with-status
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
tagList(
  tags$style(
    ".el-table .warning-row {
  --el-table-tr-bg-color: var(--el-color-warning-light-9);
}
.el-table .success-row {
  --el-table-tr-bg-color: var(--el-color-success-light-9);
}"
  ),
  el_table(
    data = tableData,
    row_class_name = JS(
      "function({ row, rowIndex }) {",
      "  if (rowIndex === 1) return 'warning-row';",
      "  if (rowIndex === 3) return 'success-row';",
      "  return '';",
      "}"
    ),
    columns = list(
      el_table_column("date", "Date", width = 180),
      el_table_column("name", "Name", width = 180),
      el_table_column("address", "Address")
    )
  )
)

## fixed-header
tableData <- data.frame(
  date = c(
    "2016-05-03",
    "2016-05-02",
    "2016-05-04",
    "2016-05-01",
    "2016-05-08",
    "2016-05-06",
    "2016-05-07"
  ),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  data = tableData,
  height = 250,
  columns = list(
    el_table_column("date", "Date", width = 180),
    el_table_column("name", "Name", width = 180),
    el_table_column("address", "Address")
  )
)

## fixed-column
#' The buttons report to the server with `rowAction()`: in an app, Detail
#' sets `input$<id>_detail` to the row.
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  state = "California",
  city = "Los Angeles",
  address = "No. 189, Grove St, Los Angeles",
  zip = "CA 90036",
  tag = c("Home", "Office", "Home", "Office")
)
el_table(
  data = tableData,
  columns = list(
    el_table_column("date", "Date", width = 150, fixed = TRUE),
    el_table_column("name", "Name", width = 120),
    el_table_column("state", "State", width = 120),
    el_table_column("city", "City", width = 120),
    el_table_column("address", "Address", width = 600),
    el_table_column("zip", "Zip", width = 120),
    el_table_column(
      label = "Operations",
      fixed = "right",
      min_width = 120,
      cell = tagList(
        el$button(
          link = NA,
          type = "primary",
          size = "small",
          "@click" = "rowAction('detail', scope)",
          "Detail"
        ),
        el$button(link = NA, type = "primary", size = "small", "Edit")
      )
    )
  )
)

## fixed-column-and-header
tableData <- data.frame(
  date = c(
    "2016-05-03",
    "2016-05-02",
    "2016-05-04",
    "2016-05-01",
    "2016-05-08",
    "2016-05-06",
    "2016-05-07"
  ),
  name = "Tom",
  state = "California",
  city = "Los Angeles",
  address = "No. 189, Grove St, Los Angeles",
  zip = "CA 90036"
)
el_table(
  data = tableData,
  height = 250,
  columns = list(
    el_table_column("date", "Date", width = 150, fixed = TRUE),
    el_table_column("name", "Name", width = 120),
    el_table_column("state", "State", width = 120),
    el_table_column("city", "City", width = 320),
    el_table_column("address", "Address", width = 600),
    el_table_column("zip", "Zip")
  )
)

## fixed-header-with-fluid-header
#| shot_js = "document.querySelector('#add_item_container button').click()"
#| shot_wait = 2
#' The rows are the server's, rendered from a reactive value: Remove
#' reports its row as `input$fluid_remove`, Add Item asks for one more, and
#' the table is rendered again with the rows that are left.
row <- function(date) {
  data.frame(
    date = format(date),
    name = "Tom",
    state = "California",
    city = "Los Angeles",
    address = "No. 189, Grove St, Los Angeles",
    zip = "CA 90036"
  )
}
tableData <- do.call(rbind, lapply(as.Date("2016-05-01") + 0:2, row))

ui <- el_page(
  el_table_output("fluid"),
  tags$div(
    style = "margin-top: 12px",
    el_button("add_item", "Add Item", width = "100%")
  )
)

server <- function(input, output, session) {
  rows <- reactiveVal(tableData)
  day <- reactiveVal(Sys.Date())
  output$fluid <- render_el_table(el_table(
    data = rows(),
    max_height = 250,
    columns = list(
      el_table_column("date", "Date", width = 150, fixed = TRUE),
      el_table_column("name", "Name", width = 120),
      el_table_column("state", "State", width = 120),
      el_table_column("city", "City", width = 120),
      el_table_column("address", "Address", width = 600),
      el_table_column("zip", "Zip", width = 120),
      el_table_column(
        label = "Operations",
        fixed = "right",
        min_width = 120,
        cell = el$button(
          link = NA,
          type = "primary",
          size = "small",
          "@click.prevent" = "rowAction('remove', scope)",
          "Remove"
        )
      )
    )
  ))
  observeEvent(input$fluid_remove, {
    rows(rows()[-input$fluid_remove$row_index, ])
  })
  observeEvent(input$add_item, {
    day(day() + 1)
    rows(rbind(rows(), row(day())))
  })
}

shinyApp(ui, server)

## grouping-header
tableData <- data.frame(
  date = c(
    "2016-05-03",
    "2016-05-02",
    "2016-05-04",
    "2016-05-01",
    "2016-05-08",
    "2016-05-06",
    "2016-05-07"
  ),
  name = "Tom",
  state = "California",
  city = "Los Angeles",
  address = "No. 189, Grove St, Los Angeles",
  zip = "CA 90036"
)
el_table(
  data = tableData,
  columns = list(
    el_table_column("date", "Date", width = 150),
    el_table_column(
      label = "Delivery Info",
      el_table_column("name", "Name", width = 120),
      el_table_column(
        label = "Address Info",
        el_table_column("state", "State", width = 120),
        el_table_column("city", "City", width = 120),
        el_table_column("address", "Address"),
        el_table_column("zip", "Zip", width = 120)
      )
    )
  )
)

## single-select
#| shot_js = "document.querySelector('#second_container button').click()"
#| shot_wait = 2
#' The buttons call the table's `setCurrentRow()` from the server; the row
#' clicked or set arrives as `input$single_current_change`.
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)

ui <- el_page(
  el_table_output("single"),
  tags$div(
    style = "margin-top: 20px",
    el_button("second", "Select second row"),
    el_button("clear", "Clear selection")
  )
)

server <- function(input, output, session) {
  output$single <- render_el_table(el_table(
    data = tableData,
    highlight_current_row = TRUE,
    columns = list(
      el_table_column(type = "index", width = 50),
      el_table_column("date", "Date", width = 120),
      el_table_column("name", "Name", width = 120),
      el_table_column("address", "Address")
    )
  ))
  observeEvent(input$second, {
    call_el(session, "single", "setCurrentRow", list(el_table_row(2)))
  })
  observeEvent(input$clear, call_el(session, "single", "setCurrentRow"))
}

shinyApp(ui, server)

## multi-select
#| shot_js = "document.querySelector('#toggle_container button').click()"
#| shot_wait = 2
#' Rows 1 and 2 cannot be ticked (`selectable`). The first button toggles
#' rows 2 and 3 whatever `selectable` says, the second only where it allows;
#' the rows ticked arrive as `input$multi_selection_rows` (their numbers)
#' and `input$multi_selection_change` (the rows).
tableData <- data.frame(
  id = 1:7,
  date = c(
    "2016-05-03",
    "2016-05-02",
    "2016-05-04",
    "2016-05-01",
    "2016-05-08",
    "2016-05-06",
    "2016-05-07"
  ),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)

ui <- el_page(
  el_table_output("multi"),
  tags$div(
    style = "margin-top: 20px",
    el_button("toggle", "Toggle selection status of second and third rows"),
    el_button(
      "toggle_selectable",
      "Toggle selection status based on selectable"
    ),
    el_button("clear", "Clear selection")
  )
)

server <- function(input, output, session) {
  output$multi <- render_el_table(el_table(
    data = tableData,
    row_key = "id",
    columns = list(
      el_table_column(
        type = "selection",
        width = 55,
        selectable = JS("function(row) { return ![1, 2].includes(row.id); }")
      ),
      el_table_column(
        label = "Date",
        width = 120,
        cell = "{{ scope.row.date }}"
      ),
      el_table_column("name", "Name", width = 120),
      el_table_column("address", "Address")
    )
  ))
  toggle <- function(ignore_selectable) {
    for (i in 2:3) {
      call_el(
        session,
        "multi",
        "toggleRowSelection",
        list(el_table_row(i), NULL, ignore_selectable)
      )
    }
  }
  observeEvent(input$toggle, toggle(TRUE))
  observeEvent(input$toggle_selectable, toggle(FALSE))
  observeEvent(input$clear, call_el(session, "multi", "clearSelection"))
}

shinyApp(ui, server)

## sort
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  data = tableData,
  default_sort = list(prop = "date", order = "descending"),
  columns = list(
    el_table_column("date", "Date", sortable = TRUE, width = 180),
    el_table_column("name", "Name", width = 180),
    el_table_column(
      "address",
      "Address",
      formatter = JS("function(row, column) { return row.address; }")
    )
  )
)

## filter
#' The buttons call the table's `clearFilter()` from the server: with the
#' date column's `column_key`, or with nothing for every column.
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles",
  tag = c("Home", "Office", "Home", "Office")
)

ui <- el_page(
  el_button("reset_date", "reset date filter"),
  el_button("reset_all", "reset all filters"),
  el_table_output("filtered")
)

server <- function(input, output, session) {
  output$filtered <- render_el_table(el_table(
    data = tableData,
    row_key = "date",
    columns = list(
      el_table_column(
        "date",
        "Date",
        sortable = TRUE,
        width = 180,
        column_key = "date",
        filters = lapply(
          c("2016-05-01", "2016-05-02", "2016-05-03", "2016-05-04"),
          function(d) list(text = d, value = d)
        ),
        filter_method = JS(
          "function(value, row, column) {",
          "  return row[column['property']] === value;",
          "}"
        )
      ),
      el_table_column("name", "Name", width = 180),
      el_table_column(
        "address",
        "Address",
        formatter = JS("function(row, column) { return row.address; }")
      ),
      el_table_column(
        "tag",
        "Tag",
        width = 100,
        filters = list(
          list(text = "Home", value = "Home"),
          list(text = "Office", value = "Office")
        ),
        filter_method = JS(
          "function(value, row) { return row.tag === value; }"
        ),
        filter_placement = "bottom-end",
        cell = el$tag(
          ":type" = "scope.row.tag === 'Home' ? 'primary' : 'success'",
          "disable-transitions" = NA,
          "{{ scope.row.tag }}"
        )
      )
    )
  ))
  observeEvent(input$reset_date, {
    call_el(session, "filtered", "clearFilter", list(list("date")))
  })
  observeEvent(input$reset_all, call_el(session, "filtered", "clearFilter"))
}

shinyApp(ui, server)

## custom-column
#| shot_js = "document.querySelectorAll('#shot .el-table__body .el-button')[1].click()"
#| shot_wait = 2
#' Edit and Delete report to the server with `rowAction()`, as
#' `input$custom_edit` and `input$custom_delete`: the row's number and the
#' row.
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)

ui <- el_page(
  el_table_output("custom"),
  verbatimTextOutput("which")
)

server <- function(input, output, session) {
  output$custom <- render_el_table(el_table(
    data = tableData,
    columns = list(
      el_table_column(
        label = "Date",
        width = 180,
        cell = tags$div(
          style = "display: flex; align-items: center",
          htmltools::tag("el-icon", list(htmltools::tag("timer", list()))),
          tags$span(style = "margin-left: 10px", "{{ scope.row.date }}")
        )
      ),
      el_table_column(
        label = "Name",
        width = 180,
        cell = el$popover(
          effect = "light",
          trigger = "hover",
          placement = "top",
          width = "auto",
          tags$template(
            `v-slot:default` = NA,
            tags$div("name: {{ scope.row.name }}"),
            tags$div("address: {{ scope.row.address }}")
          ),
          tags$template(
            `v-slot:reference` = NA,
            el$tag("{{ scope.row.name }}")
          )
        )
      ),
      el_table_column(
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
  ))
  output$which <- renderPrint(list(
    edit = input$custom_edit$row_index,
    delete = input$custom_delete$row_index
  ))
}

shinyApp(ui, server)

## custom-header
#| shot_js = "var i = document.querySelector('#shot .el-table__header input'); i.value = 'jo'; i.dispatchEvent(new Event('input'))"
#| shot_wait = 2
#' The search box is the column's `header` template. What is typed lives in
#' a store, `$store.search.text`, reported as `input$search`; the table is
#' rendered again with the rows that match.
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = c("Tom", "John", "Morgan", "Jessy"),
  address = "No. 189, Grove St, Los Angeles"
)

ui <- el_page(
  vue_store("search", data = list(text = ""), input = "text"),
  el_table_output("searchable")
)

server <- function(input, output, session) {
  matches <- reactive({
    text <- input$search %||% ""
    !nzchar(text) | grepl(tolower(text), tolower(tableData$name), fixed = TRUE)
  })
  output$searchable <- render_el_table(el_table(
    data = tableData[matches(), ],
    columns = list(
      el_table_column("date", "Date"),
      el_table_column("name", "Name"),
      el_table_column(
        align = "right",
        header = el$input(
          "v-model" = "$store.search.text",
          size = "small",
          placeholder = "Type to search"
        ),
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
  ))
}

shinyApp(ui, server)

## expandable-row
#| shot_js = "document.querySelector('#shot .el-table__expand-icon').click()"
#| shot_wait = 2
#' Each row opens to its details and a table of its own, the family. The
#' switches are the server's: the parent's border and
#' `preserve_expanded_content` render the table again -- patched in place,
#' the open rows stay open -- the child tables' border goes through a store
#' their template reads, `$store.expand.child`.
family <- data.frame(
  name = c("Jerry", "Spike", "Tyke"),
  state = "California",
  city = "San Francisco",
  address = "3650 21st St, San Francisco",
  zip = "CA 94114"
)
tableData <- lapply(
  c(
    "2016-05-03",
    "2016-05-02",
    "2016-05-04",
    "2016-05-01",
    "2016-05-08",
    "2016-05-06",
    "2016-05-07"
  ),
  function(date) {
    list(
      date = date,
      name = "Tom",
      state = "California",
      city = "San Francisco",
      address = "3650 21st St, San Francisco",
      zip = "CA 94114",
      family = family
    )
  }
)

ui <- el_page(
  vue_store("expand", data = list(child = FALSE)),
  tags$div(
    style = "display: flex; gap: 8px; align-items: center",
    "switch parent border:",
    el_switch("parent_border"),
    "switch child border:",
    el_switch("child_border"),
    "preserve expanded:",
    el_switch("preserve")
  ),
  el_table_output("expandable")
)

server <- function(input, output, session) {
  output$expandable <- render_el_table(el_table(
    data = tableData,
    border = isTRUE(input$parent_border),
    preserve_expanded_content = isTRUE(input$preserve),
    columns = list(
      el_table_column(
        type = "expand",
        cell = tags$div(
          style = "margin: 16px",
          tags$p("State: {{ scope.row.state }}"),
          tags$p("City: {{ scope.row.city }}"),
          tags$p("Address: {{ scope.row.address }}"),
          tags$p("Zip: {{ scope.row.zip }}"),
          tags$h3("Family"),
          el$table(
            ":data" = "scope.row.family",
            ":border" = "$store.expand.child",
            el$table_column(label = "Name", prop = "name"),
            el$table_column(label = "State", prop = "state"),
            el$table_column(label = "City", prop = "city"),
            el$table_column(label = "Address", prop = "address"),
            el$table_column(label = "Zip", prop = "zip")
          )
        )
      ),
      el_table_column("date", "Date"),
      el_table_column("name", "Name")
    )
  ))
  observeEvent(input$child_border, {
    update_vue(session, "expand", child = input$child_border)
  })
}

shinyApp(ui, server)

## tree-and-lazy
#| shot_js = "document.querySelectorAll('#shot .el-table')[1].querySelector('.el-table__expand-icon').click()"
#| shot_wait = 2.5
#' The second table loads a row's children when it is opened, with `load`,
#' in the browser. Without `load` the server loads them: see
#' `el_load_children()`.
tableData <- list(
  list(
    id = 1,
    date = "2016-05-02",
    name = "wangxiaohu",
    address = "No. 189, Grove St, Los Angeles"
  ),
  list(
    id = 2,
    date = "2016-05-04",
    name = "wangxiaohu",
    address = "No. 189, Grove St, Los Angeles"
  ),
  list(
    id = 3,
    date = "2016-05-01",
    name = "wangxiaohu",
    address = "No. 189, Grove St, Los Angeles",
    children = list(
      list(
        id = 31,
        date = "2016-05-01",
        name = "wangxiaohu",
        address = "No. 189, Grove St, Los Angeles"
      ),
      list(
        id = 32,
        date = "2016-05-01",
        name = "wangxiaohu",
        address = "No. 189, Grove St, Los Angeles"
      )
    )
  ),
  list(
    id = 4,
    date = "2016-05-03",
    name = "wangxiaohu",
    address = "No. 189, Grove St, Los Angeles"
  )
)
tableData1 <- data.frame(
  id = 1:4,
  date = c("2016-05-02", "2016-05-04", "2016-05-01", "2016-05-03"),
  name = "wangxiaohu",
  hasChildren = c(FALSE, FALSE, TRUE, FALSE),
  address = "No. 189, Grove St, Los Angeles"
)
tags$div(
  el_table(
    data = tableData,
    row_key = "id",
    border = TRUE,
    default_expand_all = TRUE,
    columns = list(
      el_table_column("date", "Date", sortable = TRUE),
      el_table_column("name", "Name", sortable = TRUE),
      el_table_column("address", "Address", sortable = TRUE)
    )
  ),
  tags$div(style = "height: 20px"),
  el_table(
    data = tableData1,
    row_key = "id",
    border = TRUE,
    lazy = TRUE,
    tree_props = list(children = "children", hasChildren = "hasChildren"),
    load = JS(
      "function(row, treeNode, resolve) {",
      "  setTimeout(function() {",
      "    resolve([",
      "      { id: 31, date: '2016-05-01', name: 'wangxiaohu',",
      "        address: 'No. 189, Grove St, Los Angeles' },",
      "      { id: 32, date: '2016-05-01', name: 'wangxiaohu',",
      "        address: 'No. 189, Grove St, Los Angeles' }",
      "    ]);",
      "  }, 1000);",
      "}"
    ),
    columns = list(
      el_table_column("date", "Date"),
      el_table_column("name", "Name"),
      el_table_column("address", "Address")
    )
  )
)

## summary
tableData <- data.frame(
  id = c("12987122", "12987123", "12987124", "12987125", "12987126"),
  name = "Tom",
  amount1 = c("234", "165", "324", "621", "539"),
  amount2 = c("3.2", "4.43", "1.9", "2.2", "4.1"),
  amount3 = c(10, 12, 9, 17, 15)
)
tags$div(
  el_table(
    data = tableData,
    border = TRUE,
    show_summary = TRUE,
    columns = list(
      el_table_column("id", "ID", width = 180),
      el_table_column("name", "Name"),
      el_table_column("amount1", "Amount 1", sortable = TRUE),
      el_table_column("amount2", "Amount 2", sortable = TRUE),
      el_table_column("amount3", "Amount 3", sortable = TRUE)
    )
  ),
  tags$div(style = "height: 20px"),
  el_table(
    data = tableData,
    border = TRUE,
    height = 200,
    show_summary = TRUE,
    summary_method = JS(
      "function({ columns, data }) {",
      "  return columns.map(function(column, index) {",
      "    if (index === 0) {",
      "      return Vue.h('div', { style: { textDecoration: 'underline' } }, ['Total Cost']);",
      "    }",
      "    var values = data.map(function(item) { return Number(item[column.property]); });",
      "    if (values.every(function(value) { return Number.isNaN(value); })) return 'N/A';",
      "    return '$ ' + values.reduce(function(prev, curr) {",
      "      return Number.isNaN(curr) ? prev : prev + curr;",
      "    }, 0);",
      "  });",
      "}"
    ),
    columns = list(
      el_table_column("id", "ID", width = 180),
      el_table_column("name", "Name"),
      el_table_column("amount1", "Cost 1 ($)"),
      el_table_column("amount2", "Cost 2 ($)"),
      el_table_column("amount3", "Cost 3 ($)")
    )
  )
)

## rowspan-and-colspan
tableData <- data.frame(
  id = c("12987122", "12987123", "12987124", "12987125", "12987126"),
  name = "Tom",
  amount1 = c("234", "165", "324", "621", "539"),
  amount2 = c("3.2", "4.43", "1.9", "2.2", "4.1"),
  amount3 = c(10, 12, 9, 17, 15)
)
tags$div(
  el_table(
    data = tableData,
    border = TRUE,
    span_method = JS(
      "function({ row, column, rowIndex, columnIndex }) {",
      "  if (rowIndex % 2 === 0) {",
      "    if (columnIndex === 0) return [1, 2];",
      "    if (columnIndex === 1) return [0, 0];",
      "  }",
      "}"
    ),
    columns = list(
      el_table_column("id", "ID", width = 180),
      el_table_column("name", "Name"),
      el_table_column("amount1", "Amount 1", sortable = TRUE),
      el_table_column("amount2", "Amount 2", sortable = TRUE),
      el_table_column("amount3", "Amount 3", sortable = TRUE)
    )
  ),
  tags$div(style = "height: 20px"),
  el_table(
    data = tableData,
    border = TRUE,
    span_method = JS(
      "function({ row, column, rowIndex, columnIndex }) {",
      "  if (columnIndex === 0) {",
      "    return rowIndex % 2 === 0",
      "      ? { rowspan: 2, colspan: 1 }",
      "      : { rowspan: 0, colspan: 0 };",
      "  }",
      "}"
    ),
    columns = list(
      el_table_column("id", "ID", width = 180),
      el_table_column("name", "Name"),
      el_table_column("amount1", "Amount 1"),
      el_table_column("amount2", "Amount 2"),
      el_table_column("amount3", "Amount 3")
    )
  )
)

## custom-index
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  state = "California",
  city = "Los Angeles",
  address = "No. 189, Grove St, Los Angeles",
  zip = "CA 90036",
  tag = c("Home", "Office", "Home", "Office")
)
el_table(
  data = tableData,
  columns = list(
    el_table_column(
      type = "index",
      index = JS("function(index) { return index * 2; }")
    ),
    el_table_column("date", "Date", width = 180),
    el_table_column("name", "Name", width = 180),
    el_table_column("address", "Address")
  )
)

## show-overflow-tooltip
tableData <- data.frame(
  date = c("2016-05-04", "2016-05-03", "2016-05-02", "2016-05-01"),
  name = c("Aleyna Kutzner", "Helen Jacobi", "Brandon Deckert", "Margie Smith"),
  address = c(
    "Lohrbergstr. 86c, Süd Lilli, Saarland",
    "760 A Street, South Frankfield, Illinois",
    "Arnold-Ohletz-Str. 41a, Alt Malinascheid, Thüringen",
    "23618 Windsor Drive, West Ricardoview, Idaho"
  )
)
el_table(
  data = tableData,
  columns = list(
    el_table_column(type = "selection", width = 55),
    el_table_column(label = "Date", width = 120, cell = "{{ scope.row.date }}"),
    el_table_column("name", "Name", width = 120),
    el_table_column(
      "address",
      "use show-overflow-tooltip",
      width = 240,
      show_overflow_tooltip = TRUE
    ),
    el_table_column("address", "address")
  )
)

## fixed-column-and-group-header
tableData <- data.frame(
  date = c(
    "2016-05-03",
    "2016-05-02",
    "2016-05-04",
    "2016-05-01",
    "2016-05-08",
    "2016-05-06",
    "2016-05-07"
  ),
  name = "Tom",
  state = "California",
  city = "Los Angeles",
  address = "No. 189, Grove St, Los Angeles",
  zip = "CA 90036"
)
el_table(
  data = tableData,
  height = 250,
  columns = list(
    el_table_column("date", "Date"),
    el_table_column("name", "Name"),
    el_table_column("zip", "Zip"),
    el_table_column(
      label = "Address Info",
      fixed = "right",
      el_table_column("state", "State"),
      el_table_column("city", "City"),
      el_table_column("address", "Address", min_width = 200)
    )
  )
)

## check-strictly
#| shot_js = "document.querySelectorAll('#strict_mode_container .el-radio-button')[0].click()"
#| shot_wait = 2
#' The radio buttons set `tree_props = list(checkStrictly =)`, rendering
#' the table again: ticked strictly, a row ticks on its own, not with its
#' children.
#' Rows 1 and 31 cannot be ticked.
row <- function(id, date, children = NULL) {
  r <- list(
    id = id,
    date = date,
    name = "wangxiaohu",
    address = "No. 189, Grove St, Los Angeles"
  )
  if (length(children)) {
    r$children <- children
  }
  r
}
tableData <- list(
  row(1, "2016-05-02"),
  row(2, "2016-05-04"),
  row(
    3,
    "2016-05-01",
    list(row(31, "2016-05-01"), row(32, "2016-05-01"), row(33, "2016-05-01"))
  ),
  row(4, "2016-05-03")
)

ui <- el_page(
  el_radio_group(
    "strict_mode",
    choices = c("true", "false"),
    value = "false",
    button = TRUE
  ),
  el_table_output("strict")
)

server <- function(input, output, session) {
  output$strict <- render_el_table(el_table(
    data = tableData,
    row_key = "id",
    default_expand_all = TRUE,
    tree_props = list(checkStrictly = identical(input$strict_mode, "true")),
    columns = list(
      el_table_column(
        type = "selection",
        width = 55,
        selectable = JS("function(row) { return ![1, 31].includes(row.id); }")
      ),
      el_table_column("date", "Date"),
      el_table_column("name", "Name"),
      el_table_column("address", "Address")
    )
  ))
}

shinyApp(ui, server)

## table-layout
#| shot_js = "document.querySelectorAll('#layout_container .el-radio-button')[1].click()"
#| shot_wait = 2
#' The radio buttons set `table_layout` from the server.
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)

ui <- el_page(
  el_radio_group(
    "layout",
    choices = c("fixed", "auto"),
    value = "fixed",
    button = TRUE
  ),
  el_table_output("layout_table")
)

server <- function(input, output, session) {
  output$layout_table <- render_el_table(el_table(
    data = tableData,
    table_layout = "fixed",
    columns = list(
      el_table_column("date", "Date"),
      el_table_column("name", "Name"),
      el_table_column("address", "Address")
    )
  ))
  observeEvent(input$layout, {
    update_el_table(session, "layout_table", table_layout = input$layout)
  })
}

shinyApp(ui, server)

## tooltip-formatter
tableData <- list(
  list(
    address = "Lohrbergstr. 86c, Süd Lilli, Saarland",
    tags = list("Office", "Home", "Park", "Garden"),
    url = "https://github.com/element-plus/element-plus/issues"
  ),
  list(
    address = "760 A Street, South Frankfield, Illinois",
    tags = list("error", "warning", "success", "info"),
    url = "https://github.com/element-plus/element-plus/pulls"
  ),
  list(
    address = "Arnold-Ohletz-Str. 41a, Alt Malinascheid, Thüringen",
    tags = list("one", "two", "three", "four", "five"),
    url = "https://github.com/element-plus/element-plus/discussions"
  ),
  list(
    address = "23618 Windsor Drive, West Ricardoview, Idaho",
    tags = list("blue", "white", "dark", "gray", "red", "bright"),
    url = "https://github.com/element-plus/element-plus/actions"
  )
)
tagList(
  tags$style(".tag-item + .tag-item { margin-left: 5px; }"),
  el_table(
    data = tableData,
    show_overflow_tooltip = TRUE,
    tooltip_formatter = JS(
      "function(data) { return data.cellValue + ': table formatter'; }"
    ),
    columns = list(
      el_table_column("address", "extends table formatter", width = 240),
      el_table_column(
        "tags",
        "formatter object",
        width = 240,
        tooltip_formatter = JS(
          "function({ row }) { return row.tags.join(', '); }"
        ),
        cell = el$tag(
          "v-for" = "tag in scope.row.tags",
          ":key" = "tag",
          class = "tag-item",
          type = "primary",
          "{{ tag }}"
        )
      ),
      el_table_column(
        "url",
        "with vnode",
        width = 240,
        tooltip_formatter = JS(
          "function(data) {",
          "  return Vue.h(ElementPlus.ElLink, { type: 'primary', href: data.cellValue },",
          "    function() { return Vue.h('span', null, data.cellValue); });",
          "}"
        )
      )
    )
  )
)

## in-shiny
#| shot_js = "var c = document.querySelectorAll('#cars .el-table__body .el-checkbox'); c[1].click(); c[3].click();"
#| shot_wait = 2
#' In an app a table is an output, as DT's and reactable's are: the page
#' holds `el_table_output("cars")`, the server renders `el_table()` into it
#' with `render_el_table()`, and the output's id names the table's inputs.
#' The table above every example on this page is `el_table()` alone, which
#' is how it goes in R Markdown, Quarto or a static page.
#'
#' | Input | Value |
#' |---|---|
#' | `input$cars_selection_rows` | the selected row numbers, integers; `NULL` with none |
#' | `input$cars_selection_change` | the selected rows, `data[rows, , drop = FALSE]`: the columns, types and row names as R holds them |
#' | `input$cars_current_change`, `_sort_change`, `_filter_change`, `_expand_change` | reported by every table |
#' | `input$cars_<event>` | any other of Element's events, asked for with `el_table(events =)`: see `el_events("el_table")` |
#'
#' Rendering again with the same rows keeps the user's ticks, sort and open
#' rows; other rows clear the selection, as Element does, unless the rows
#' carry a `row_key` and the selection column `reserve_selection = TRUE`.
#' `update_el_table()` and `call_el()` reach the table by the output's id:
#' `update_el_table(insert =, replace =, delete =)` changes a few rows and
#' sends only those, and `el_table_data()` reads the data the table shows.
cars <- head(mtcars[, 1:4], 6)
cars$made <- as.Date("2024-01-01") + 0:5

ui <- el_page(
  el_input_number("n", value = 6, min = 1, max = 6),
  el_table_output("cars"),
  verbatimTextOutput("picked")
)

server <- function(input, output, session) {
  output$cars <- render_el_table(
    el_table(
      data = head(cars, input$n),
      selection = TRUE,
      events = "row_dblclick"
    )
  )
  # the ticked rows, as R subsets them: Dates stay Dates
  output$picked <- renderPrint(input$cars_selection_change)
  observeEvent(input$cars_row_dblclick, {
    el_message(message = paste("Row", input$cars_row_dblclick$row_index))
  })
}

shinyApp(ui, server)

## in-shiny-edit
#| shot_js = "var v = document.querySelectorAll('#cars .el-table-edit-cell__value')[1]; v.dispatchEvent(new MouseEvent('dblclick', {bubbles: true}));"
#| shot_wait = 1.5
#' ### Editing cells
#'
#' A column with `editable` is edited in place, in Element's own input,
#' input-number, select or date picker: double-click a cell, then Enter or
#' leave it to commit, Escape to abandon, Tab to commit and go on to the
#' next editable cell. The edit is shown at once, applied to the server's
#' copy of the data -- `el_table_data()` -- and reported as
#' `input$cars_cell_edit`, `list(row, column, value, old)` with the
#' column's type: a Date stays a Date, a factor a factor. An observer saves
#' it, or puts the old value back with `update_el_table(replace =)`.
cars <- head(mtcars[, 1:2], 4)
cars$made <- as.Date("2024-01-01") + 0:3
cars$grade <- factor(c("A", "B", "A", "C"))

ui <- el_page(
  el_table_output("cars"),
  verbatimTextOutput("edited")
)

server <- function(input, output, session) {
  output$cars <- render_el_table(el_table(
    data = cars,
    columns = list(
      el_table_column(
        "mpg",
        "MPG",
        editable = "number",
        editor = list(min = 0)
      ),
      el_table_column("cyl", "Cylinders"),
      el_table_column("made", "Made", editable = "date"),
      el_table_column(
        "grade",
        "Grade",
        editable = "select",
        editor = list(choices = c("A", "B", "C"))
      )
    )
  ))
  output$edited <- renderPrint(input$cars_cell_edit)
}

shinyApp(ui, server)

## in-shiny-rows
#| shot_js = "document.querySelector('#add_container button').click()"
#| shot_wait = 2
#' ### Rows from the server
#'
#' `update_el_table()` changes a few rows and sends only those: `insert`
#' (before row `at`, or at the end), `replace` (rows `at`) and `delete`.
#' The server's copy changes as R would change the data, and the rows not
#' touched keep their ticks. `el_table_data()` is that copy, a reactive
#' read; `data` replaces every row, as rendering again does.
todo <- data.frame(
  task = c("Write the docs", "Run the tests"),
  done = c(FALSE, TRUE)
)

ui <- el_page(
  el_button("add", "Add a task"),
  el_button("remove", "Remove the ticked"),
  el_table_output("todo"),
  textOutput("count")
)

server <- function(input, output, session) {
  output$todo <- render_el_table(el_table(
    data = todo,
    selection = TRUE,
    columns = list(
      el_table_column("task", "Task", editable = TRUE),
      el_table_column("done", "Done")
    )
  ))
  observeEvent(input$add, {
    update_el_table(
      session,
      "todo",
      insert = data.frame(task = paste("Task", input$add), done = FALSE),
      at = 1
    )
  })
  observeEvent(input$remove, {
    req(input$todo_selection_rows)
    update_el_table(session, "todo", delete = input$todo_selection_rows)
  })
  output$count <- renderText(
    paste(nrow(el_table_data(id = "todo")), "tasks")
  )
}

shinyApp(ui, server)
