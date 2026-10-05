## basic
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  "basic",
  data = tableData,
  columns = list(
    list(prop = "date", label = "Date", width = 180),
    list(prop = "name", label = "Name", width = 180),
    list(prop = "address", label = "Address")
  )
)

## striped
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  "striped",
  data = tableData,
  stripe = TRUE,
  columns = list(
    list(prop = "date", label = "Date", width = 180),
    list(prop = "name", label = "Name", width = 180),
    list(prop = "address", label = "Address")
  )
)

## with-border
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = "Tom",
  address = "No. 189, Grove St, Los Angeles"
)
el_table(
  "bordered",
  data = tableData,
  border = TRUE,
  columns = list(
    list(prop = "date", label = "Date", width = 180),
    list(prop = "name", label = "Name", width = 180),
    list(prop = "address", label = "Address")
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
    "status",
    data = tableData,
    row_class_name = JS(
      "function({ row, rowIndex }) {",
      "  if (rowIndex === 1) return 'warning-row';",
      "  if (rowIndex === 3) return 'success-row';",
      "  return '';",
      "}"
    ),
    columns = list(
      list(prop = "date", label = "Date", width = 180),
      list(prop = "name", label = "Name", width = 180),
      list(prop = "address", label = "Address")
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
  "fixedhead",
  data = tableData,
  height = 250,
  columns = list(
    list(prop = "date", label = "Date", width = 180),
    list(prop = "name", label = "Name", width = 180),
    list(prop = "address", label = "Address")
  )
)

## fixed-column
#' The buttons report to the server with `rowAction()`: Detail sets
#' `input$fixedcol_detail` to the row.
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
  "fixedcol",
  data = tableData,
  columns = list(
    list(prop = "date", label = "Date", width = 150, fixed = TRUE),
    list(prop = "name", label = "Name", width = 120),
    list(prop = "state", label = "State", width = 120),
    list(prop = "city", label = "City", width = 120),
    list(prop = "address", label = "Address", width = 600),
    list(prop = "zip", label = "Zip", width = 120),
    list(
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
  "fixedboth",
  data = tableData,
  height = 250,
  columns = list(
    list(prop = "date", label = "Date", width = 150, fixed = TRUE),
    list(prop = "name", label = "Name", width = 120),
    list(prop = "state", label = "State", width = 120),
    list(prop = "city", label = "City", width = 320),
    list(prop = "address", label = "Address", width = 600),
    list(prop = "zip", label = "Zip")
  )
)

## fixed-header-with-fluid-header
#| shot_js = "document.querySelector('#add_item_container button').click()"
#| shot_wait = 2
#' The rows are the server's: Remove reports its row as
#' `input$fluid_remove`, Add Item asks for one more, and the server sends
#' the rows back with `update_el_table()`.
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
  el_table(
    "fluid",
    data = tableData,
    max_height = 250,
    columns = list(
      list(prop = "date", label = "Date", width = 150, fixed = TRUE),
      list(prop = "name", label = "Name", width = 120),
      list(prop = "state", label = "State", width = 120),
      list(prop = "city", label = "City", width = 120),
      list(prop = "address", label = "Address", width = 600),
      list(prop = "zip", label = "Zip", width = 120),
      list(
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
  ),
  tags$div(
    style = "margin-top: 12px",
    el_button("add_item", "Add Item", width = "100%")
  )
)

server <- function(input, output, session) {
  rows <- reactiveVal(tableData)
  day <- reactiveVal(Sys.Date())
  observeEvent(rows(), update_el_table(session, "fluid", data = rows()))
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
  "grouped",
  data = tableData,
  columns = list(
    list(prop = "date", label = "Date", width = 150),
    list(
      label = "Delivery Info",
      children = list(
        list(prop = "name", label = "Name", width = 120),
        list(
          label = "Address Info",
          children = list(
            list(prop = "state", label = "State", width = 120),
            list(prop = "city", label = "City", width = 120),
            list(prop = "address", label = "Address"),
            list(prop = "zip", label = "Zip", width = 120)
          )
        )
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
  el_table(
    "single",
    data = tableData,
    highlight_current_row = TRUE,
    columns = list(
      list(type = "index", width = 50),
      list(prop = "date", label = "Date", width = 120),
      list(prop = "name", label = "Name", width = 120),
      list(prop = "address", label = "Address")
    )
  ),
  tags$div(
    style = "margin-top: 20px",
    el_button("second", "Select second row"),
    el_button("clear", "Clear selection")
  )
)

server <- function(input, output, session) {
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
#' the rows ticked arrive as `input$multi_selected_rows`.
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
  el_table(
    "multi",
    data = tableData,
    row_key = "id",
    columns = list(
      list(
        type = "selection",
        width = 55,
        selectable = JS("function(row) { return ![1, 2].includes(row.id); }")
      ),
      list(label = "Date", width = 120, cell = "{{ scope.row.date }}"),
      list(prop = "name", label = "Name", width = 120),
      list(prop = "address", label = "Address")
    )
  ),
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
  "sorted",
  data = tableData,
  default_sort = list(prop = "date", order = "descending"),
  columns = list(
    list(prop = "date", label = "Date", sortable = TRUE, width = 180),
    list(prop = "name", label = "Name", width = 180),
    list(
      prop = "address",
      label = "Address",
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
  el_table(
    "filtered",
    data = tableData,
    row_key = "date",
    columns = list(
      list(
        prop = "date",
        label = "Date",
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
      list(prop = "name", label = "Name", width = 180),
      list(
        prop = "address",
        label = "Address",
        formatter = JS("function(row, column) { return row.address; }")
      ),
      list(
        prop = "tag",
        label = "Tag",
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
  )
)

server <- function(input, output, session) {
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
  el_table(
    "custom",
    data = tableData,
    columns = list(
      list(
        label = "Date",
        width = 180,
        cell = tags$div(
          style = "display: flex; align-items: center",
          htmltools::tag("el-icon", list(htmltools::tag("timer", list()))),
          tags$span(style = "margin-left: 10px", "{{ scope.row.date }}")
        )
      ),
      list(
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
    edit = input$custom_edit$row_index,
    delete = input$custom_delete$row_index
  ))
}

shinyApp(ui, server)

## custom-header
#| shot_js = "var i = document.querySelector('#shot .el-table__header input'); i.value = 'jo'; i.dispatchEvent(new Event('input'))"
#| shot_wait = 2
#' The search box is the column's `header` template. What is typed lives in
#' a store, `$store.search.text`, reported as `input$search`; the server
#' filters the rows and sends them with `update_el_table()`.
tableData <- data.frame(
  date = c("2016-05-03", "2016-05-02", "2016-05-04", "2016-05-01"),
  name = c("Tom", "John", "Morgan", "Jessy"),
  address = "No. 189, Grove St, Los Angeles"
)

ui <- el_page(
  vue_store("search", data = list(text = ""), input = "text"),
  el_table(
    "searchable",
    data = tableData,
    columns = list(
      list(prop = "date", label = "Date"),
      list(prop = "name", label = "Name"),
      list(
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
  )
)

server <- function(input, output, session) {
  observeEvent(input$search, {
    keep <- !nzchar(input$search) |
      grepl(tolower(input$search), tolower(tableData$name), fixed = TRUE)
    update_el_table(session, "searchable", data = tableData[keep, ])
  })
}

shinyApp(ui, server)

## expandable-row
#| shot_js = "document.querySelector('#shot .el-table__expand-icon').click()"
#| shot_wait = 2
#' Each row opens to its details and a table of its own, the family. The
#' switches are the server's: the parent's border and
#' `preserve_expanded_content` with `update_el_table()`, the child tables'
#' border through a store their template reads, `$store.expand.child`.
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
  el_table(
    "expandable",
    data = tableData,
    columns = list(
      list(
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
      list(label = "Date", prop = "date"),
      list(label = "Name", prop = "name")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$parent_border, {
    update_el_table(session, "expandable", border = input$parent_border)
  })
  observeEvent(input$preserve, {
    update_el_table(
      session,
      "expandable",
      preserve_expanded_content = input$preserve
    )
  })
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
    "tree",
    data = tableData,
    row_key = "id",
    border = TRUE,
    default_expand_all = TRUE,
    columns = list(
      list(prop = "date", label = "Date", sortable = TRUE),
      list(prop = "name", label = "Name", sortable = TRUE),
      list(prop = "address", label = "Address", sortable = TRUE)
    )
  ),
  tags$div(style = "height: 20px"),
  el_table(
    "lazy",
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
      list(prop = "date", label = "Date"),
      list(prop = "name", label = "Name"),
      list(prop = "address", label = "Address")
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
    "sums",
    data = tableData,
    border = TRUE,
    show_summary = TRUE,
    columns = list(
      list(prop = "id", label = "ID", width = 180),
      list(prop = "name", label = "Name"),
      list(prop = "amount1", label = "Amount 1", sortable = TRUE),
      list(prop = "amount2", label = "Amount 2", sortable = TRUE),
      list(prop = "amount3", label = "Amount 3", sortable = TRUE)
    )
  ),
  tags$div(style = "height: 20px"),
  el_table(
    "costs",
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
      list(prop = "id", label = "ID", width = 180),
      list(prop = "name", label = "Name"),
      list(prop = "amount1", label = "Cost 1 ($)"),
      list(prop = "amount2", label = "Cost 2 ($)"),
      list(prop = "amount3", label = "Cost 3 ($)")
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
    "colspans",
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
      list(prop = "id", label = "ID", width = 180),
      list(prop = "name", label = "Name"),
      list(prop = "amount1", label = "Amount 1", sortable = TRUE),
      list(prop = "amount2", label = "Amount 2", sortable = TRUE),
      list(prop = "amount3", label = "Amount 3", sortable = TRUE)
    )
  ),
  tags$div(style = "height: 20px"),
  el_table(
    "rowspans",
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
      list(prop = "id", label = "ID", width = 180),
      list(prop = "name", label = "Name"),
      list(prop = "amount1", label = "Amount 1"),
      list(prop = "amount2", label = "Amount 2"),
      list(prop = "amount3", label = "Amount 3")
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
  "idx",
  data = tableData,
  columns = list(
    list(type = "index", index = JS("function(index) { return index * 2; }")),
    list(prop = "date", label = "Date", width = 180),
    list(prop = "name", label = "Name", width = 180),
    list(prop = "address", label = "Address")
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
  "tt",
  data = tableData,
  columns = list(
    list(type = "selection", width = 55),
    list(label = "Date", width = 120, cell = "{{ scope.row.date }}"),
    list(prop = "name", label = "Name", width = 120),
    list(
      prop = "address",
      label = "use show-overflow-tooltip",
      width = 240,
      show_overflow_tooltip = TRUE
    ),
    list(prop = "address", label = "address")
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
  "fg",
  data = tableData,
  height = 250,
  columns = list(
    list(prop = "date", label = "Date"),
    list(prop = "name", label = "Name"),
    list(prop = "zip", label = "Zip"),
    list(
      label = "Address Info",
      fixed = "right",
      children = list(
        list(prop = "state", label = "State"),
        list(prop = "city", label = "City"),
        list(prop = "address", label = "Address", min_width = 200)
      )
    )
  )
)

## check-strictly
#| shot_js = "document.querySelectorAll('#strict_mode_container .el-radio-button')[0].click()"
#| shot_wait = 2
#' The radio buttons set `tree_props = list(checkStrictly =)` from the
#' server: ticked strictly, a row ticks on its own, not with its children.
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
  el_table(
    "strict",
    data = tableData,
    row_key = "id",
    default_expand_all = TRUE,
    tree_props = list(checkStrictly = FALSE),
    columns = list(
      list(
        type = "selection",
        width = 55,
        selectable = JS("function(row) { return ![1, 31].includes(row.id); }")
      ),
      list(prop = "date", label = "Date"),
      list(prop = "name", label = "Name"),
      list(prop = "address", label = "Address")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$strict_mode, {
    update_el_table(
      session,
      "strict",
      tree_props = list(checkStrictly = input$strict_mode == "true")
    )
  })
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
  el_table(
    "layout_table",
    data = tableData,
    table_layout = "fixed",
    columns = list(
      list(prop = "date", label = "Date"),
      list(prop = "name", label = "Name"),
      list(prop = "address", label = "Address")
    )
  )
)

server <- function(input, output, session) {
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
    "tt_fmt",
    data = tableData,
    show_overflow_tooltip = TRUE,
    tooltip_formatter = JS(
      "function(data) { return data.cellValue + ': table formatter'; }"
    ),
    columns = list(
      list(prop = "address", label = "extends table formatter", width = 240),
      list(
        prop = "tags",
        label = "formatter object",
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
      list(
        prop = "url",
        label = "with vnode",
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
