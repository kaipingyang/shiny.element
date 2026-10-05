## basic
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 1000)
el_table_v2(
  "tv_basic",
  columns = columns,
  data = data,
  table_v2_width = 700,
  height = 400,
  fixed = TRUE
)

## auto-resizer
#' `auto_resize = TRUE` sizes the table to its container, which needs a
#' height of its own.
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)
tags$div(
  style = "height: 400px",
  el_table_v2(
    "tv_auto",
    columns = columns,
    data = data,
    fixed = TRUE,
    auto_resize = TRUE
  )
)

## cell-templating
#' The cells are drawn by each column's `cellRenderer`, a [JS()] function
#' returning Vue's `h()`, as upstream's JSX does.
columns <- list(
  el_table_v2_column(
    "date",
    "Date",
    width = 150,
    fixed = "left",
    cell_renderer = JS(
      "function({ cellData: date }) {",
      "  var p = date.split('-').map(function(n) { return n.padStart(2, '0'); });",
      "  var text = p.join('/');",
      "  return Vue.h(ElementPlus.ElTooltip, { content: text }, function() {",
      "    return Vue.h('span', { style: 'display: flex; align-items: center' }, [",
      "      Vue.h(ElementPlus.ElIcon, { style: 'margin-right: 12px' },",
      "        function() { return Vue.h(ElementPlusIconsVue.Timer); }),",
      "      text",
      "    ]);",
      "  });",
      "}"
    )
  ),
  el_table_v2_column(
    "name",
    "Name",
    width = 150,
    align = "center",
    cell_renderer = JS(
      "function({ cellData: name }) {",
      "  return Vue.h(ElementPlus.ElTag, null, function() { return name; });",
      "}"
    )
  ),
  el_table_v2_column(
    "operations",
    "Operations",
    cell_renderer = JS(
      "function() {",
      "  return [",
      "    Vue.h(ElementPlus.ElButton, { size: 'small' }, function() { return 'Edit'; }),",
      "    Vue.h(ElementPlus.ElButton, { size: 'small', type: 'danger' },",
      "      function() { return 'Delete'; })",
      "  ];",
      "}"
    ),
    width = 150,
    align = "center"
  )
)
data <- data.frame(
  id = paste0("random-id-", 1:200),
  name = "Tom",
  date = "2020-10-1"
)
el_table_v2(
  "tv_cell",
  columns = columns,
  data = data,
  table_v2_width = 700,
  height = 400,
  fixed = TRUE
)

## selection
#' A checkbox column, drawn by the `cell` and `header-cell` slots: a field
#' of each row, `checked`, holds the tick. `$setInput()` reports the rows
#' ticked to the server as `input$tv_sel_checked`; it is Shiny's
#' `setInputValue()`, which a template cannot otherwise reach.
#| shot_js = "document.querySelectorAll('#shot .el-table-v2__row .el-checkbox')[1].click()"
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
df <- grid()
df$checked <- FALSE
report <- "$setInput('tv_sel_checked', data.filter(r => r.checked).map(r => r.id))"
el_table_v2(
  "tv_sel",
  data = df,
  columns = c(
    list(el_table_v2_column("selection", width = 50)),
    grid_columns()
  ),
  table_v2_width = 700,
  height = 400,
  fixed = TRUE,
  slots = list(
    cell = template(
      HTML(paste0(
        "<el-checkbox v-if=\"column.key === 'selection'\" ",
        "v-model=\"rowData.checked\" @change=\"",
        report,
        "\" />",
        "<div v-else class=\"el-table-v2__cell-text\">",
        "{{ rowData[column.dataKey] }}</div>"
      )),
      slot = "cell",
      scope = "{ rowData, column }"
    ),
    "header-cell" = template(
      HTML(paste0(
        "<el-checkbox v-if=\"column.key === 'selection'\" ",
        ":model-value=\"data.every(r => r.checked)\" ",
        ":indeterminate=\"data.some(r => r.checked) && !data.every(r => r.checked)\" ",
        "@change=\"v => { data.forEach(r => r.checked = v); ",
        report,
        " }\" />",
        "<div v-else class=\"el-table-v2__header-cell-text\">",
        "{{ column.title }}</div>"
      )),
      slot = "header-cell",
      scope = "{ column }"
    )
  )
)

## inline-editing
#' The first column edits in place: a click turns the cell into an input,
#' Enter or leaving it turns it back. Each edit is reported as
#' `input$tv_edit_edited`.
#| shot_js = "document.querySelector('#shot .table-v2-inline-editing-trigger').click()", shot_wait = 1
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
df <- grid()
df$editing <- FALSE
cols <- grid_columns()
cols[[1]]$title <- "Editable Column"
el_table_v2(
  "tv_edit",
  data = df,
  columns = cols,
  table_v2_width = 700,
  height = 400,
  fixed = TRUE,
  slots = list(
    cell = template(
      HTML(paste0(
        "<template v-if=\"column.key === 'column-0'\">",
        "<el-input v-if=\"rowData.editing\" v-model=\"rowData[column.dataKey]\" ",
        ":ref=\"el => el && el.focus()\" ",
        "@blur=\"rowData.editing = false\" ",
        "@keydown.enter=\"rowData.editing = false\" ",
        "@change=\"v => $setInput('tv_edit_edited', {id: rowData.id, value: v})\" />",
        "<div v-else class=\"table-v2-inline-editing-trigger\" ",
        "@click=\"rowData.editing = true\">{{ rowData[column.dataKey] }}</div>",
        "</template>",
        "<div v-else class=\"el-table-v2__cell-text\">",
        "{{ rowData[column.dataKey] }}</div>"
      )),
      slot = "cell",
      scope = "{ rowData, column }"
    )
  )
)
tags$style(
  ".table-v2-inline-editing-trigger {
    border: 1px transparent dotted;
    padding: 4px;
  }
  .table-v2-inline-editing-trigger:hover {
    border-color: var(--el-color-primary);
  }"
)

## row-class
columns <- list(
  el_table_v2_column(
    "date",
    "Date",
    width = 150,
    fixed = "left",
    cell_renderer = JS(
      "function({ cellData: date }) {",
      "  var p = date.split('-').map(function(n) { return n.padStart(2, '0'); });",
      "  var text = p.join('/');",
      "  return Vue.h(ElementPlus.ElTooltip, { content: text }, function() {",
      "    return Vue.h('span', { style: 'display: flex; align-items: center' }, [",
      "      Vue.h(ElementPlus.ElIcon, { style: 'margin-right: 12px' },",
      "        function() { return Vue.h(ElementPlusIconsVue.Timer); }),",
      "      text",
      "    ]);",
      "  });",
      "}"
    )
  ),
  el_table_v2_column(
    "name",
    "Name",
    width = 150,
    align = "center",
    cell_renderer = JS(
      "function({ cellData: name }) {",
      "  return Vue.h(ElementPlus.ElTag, null, function() { return name; });",
      "}"
    )
  ),
  el_table_v2_column(
    "operations",
    "Operations",
    cell_renderer = JS(
      "function() {",
      "  return [",
      "    Vue.h(ElementPlus.ElButton, { size: 'small' }, function() { return 'Edit'; }),",
      "    Vue.h(ElementPlus.ElButton, { size: 'small', type: 'danger' },",
      "      function() { return 'Delete'; })",
      "  ];",
      "}"
    ),
    width = 150,
    align = "center",
    flex_grow = 1
  )
)
data <- data.frame(
  id = paste0("random-id-", 1:200),
  name = "Tom",
  date = "2020-10-1"
)
tagList(
  tags$style(
    ".bg-red-100 { background-color: #fee2e2; }
.bg-blue-200 { background-color: #bfdbfe; }"
  ),
  el_table_v2(
    "tv_rowclass",
    columns = columns,
    data = data,
    row_class = JS(
      "function({ rowIndex }) {",
      "  if (rowIndex % 10 === 5) return 'bg-red-100';",
      "  if (rowIndex % 10 === 0) return 'bg-blue-200';",
      "  return '';",
      "}"
    ),
    table_v2_width = 700,
    height = 400
  )
)

## sticky-rows
#| shot_js = "shinyVue.call({id: 'tv_sticky', method: 'scrollToTop', args: [600]})"
#| shot_wait = 2
#' The first row stays at the top while the rest scroll. As the table
#' scrolls, the server hears `input$tv_sticky_scroll` and pins the next
#' fifth row with `update_el_table_v2(fixed_data =)`.
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)

ui <- el_page(
  tags$style(
    ".el-el-table-v2__fixed-header-row {
  background-color: var(--el-color-primary-light-5);
  font-weight: bold;
}"
  ),
  el_table_v2(
    "tv_sticky",
    columns = columns,
    data = data[-1, ],
    fixed_data = data[1, ],
    row_class = JS(
      "function({ rowIndex }) {",
      "  if (rowIndex < 0 || (rowIndex + 1) % 5 === 0) return 'sticky-row';",
      "}"
    ),
    table_v2_width = 700,
    height = 400,
    fixed = TRUE
  )
)

server <- function(input, output, session) {
  sticky <- reactiveVal(0)
  observeEvent(input$tv_sticky_scroll, {
    sticky(floor(input$tv_sticky_scroll$scrollTop / 250) * 5)
  })
  observeEvent(sticky(), ignoreInit = TRUE, {
    update_el_table_v2(id = "tv_sticky", fixed_data = data[sticky() + 1, ])
  })
}

shinyApp(ui, server)

## fixed-columns
#' Sorting is the server's: a click on a sortable header arrives as
#' `input$tv_fixed_column_sort`, and the server sends the rows back reversed
#' and the new sort with `update_el_table_v2()`.
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)
columns[[1]]$fixed <- TRUE
columns[[2]]$fixed <- "left"
columns[[10]]$fixed <- "right"
for (i in 1:3) {
  columns[[i]]$sortable <- TRUE
}

ui <- el_page(
  el_table_v2(
    "tv_fixed",
    columns = columns,
    data = data,
    sort_by = list(key = "column-0", order = "asc"),
    table_v2_width = 700,
    height = 400,
    fixed = TRUE
  )
)

server <- function(input, output, session) {
  rows <- reactiveVal(data)
  observeEvent(input$tv_fixed_column_sort, {
    rows(rows()[rev(seq_len(nrow(rows()))), ])
    sort <- input$tv_fixed_column_sort
    update_el_table_v2(
      id = "tv_fixed",
      data = rows(),
      sort_by = list(key = sort$key, order = sort$order)
    )
  })
}

shinyApp(ui, server)

## grouping-header
#' Three header rows, `header_height = c(50, 40, 50)`. The `header` slot
#' redraws the first two as groups of four and two columns; the grouping is
#' upstream's own function, given as `methods` and drawing with `Vue.h()`.
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
cols <- grid_columns(15, width = 100)
for (j in 1:3) {
  cols[[j]]$fixed <- "left"
}
for (j in 14:15) {
  cols[[j]]$fixed <- "right"
}
el_table_v2(
  "tv_group",
  data = grid(15),
  columns = cols,
  header_height = c(50, 40, 50),
  header_class = JS(
    "function({ headerIndex }) { return headerIndex === 1 ? 'el-primary-color' : ''; }"
  ),
  table_v2_width = 700,
  height = 400,
  fixed = TRUE,
  methods = list(
    groupCells = JS(
      "function({ cells, columns, headerIndex }) {
        if (headerIndex === 2) return cells;
        var out = [], width = 0, idx = 0;
        columns.forEach(function(column, i) {
          if (column.placeholderSign === ElementPlus.TableV2Placeholder) {
            out.push(cells[i]);
            return;
          }
          width += cells[i].props.column.width;
          idx++;
          var next = columns[i + 1];
          if (i === columns.length - 1 ||
              next.placeholderSign === ElementPlus.TableV2Placeholder ||
              idx === (headerIndex === 0 ? 4 : 2)) {
            out.push(Vue.h('div', {
              class: 'custom-header-cell',
              role: 'columnheader',
              style: Object.assign({}, cells[i].props.style, {
                width: width + 'px', display: 'flex',
                alignItems: 'center', justifyContent: 'center'
              })
            }, 'Group width ' + width));
            width = 0;
            idx = 0;
          }
        });
        return out;
      }"
    )
  ),
  slots = list(
    header = template(
      HTML('<component v-for="c in groupCells(props)" :is="c" />'),
      slot = "header",
      scope = "props"
    )
  )
)

## filter
#' The `header-cell` slot puts a filter in the first column's header. The
#' filtering is the server's: Confirm sends the choice as
#' `input$tv_filter_on`, and the server answers with
#' `update_el_table_v2(data =)`.
#| shot_js = "document.querySelector('#shot .el-table-v2__demo-filter-btn').click()", shot_sel = ".el-popper", shot_wait = 1
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
cols <- grid_columns(width = 100)
for (j in 1:2) {
  cols[[j]]$fixed <- "left"
}
ui <- el_page(
  el_table_v2(
    "tv_filter",
    data = grid(),
    columns = cols,
    table_v2_width = 700,
    height = 400,
    fixed = TRUE,
    slots = list(
      "header-cell" = template(
        HTML(paste0(
          "<div v-if=\"column.key === 'column-0'\" ",
          "style=\"display: flex; align-items: center; gap: 8px\">",
          "<span>{{ column.title }}</span>",
          "<el-popover ref=\"filterPop\" trigger=\"click\" :width=\"200\">",
          "<template #reference><button type=\"button\" ",
          "class=\"el-table-v2__demo-filter-btn\" aria-label=\"Filter\">",
          "<el-icon :size=\"14\"><Filter /></el-icon></button></template>",
          "<el-checkbox v-model=\"column.filterOn\">Filter Text</el-checkbox>",
          "<div class=\"el-table-v2__demo-filter\">",
          "<el-button text @click=\"$refs.filterPop.hide(); ",
          "$setInput('tv_filter_on', !!column.filterOn)\">Confirm</el-button>",
          "<el-button text @click=\"column.filterOn = false; ",
          "$refs.filterPop.hide(); $setInput('tv_filter_on', false)\">",
          "Reset</el-button></div></el-popover></div>",
          "<div v-else class=\"el-table-v2__header-cell-text\">",
          "{{ column.title }}</div>"
        )),
        slot = "header-cell",
        scope = "{ column }"
      )
    )
  ),
  tags$style(
    ".el-table-v2__demo-filter {
      border-top: var(--el-border);
      margin: 12px -12px -12px;
      padding: 0 12px;
      display: flex;
      justify-content: space-between;
    }
    .el-table-v2__demo-filter-btn {
      display: flex;
      cursor: pointer;
      padding: 0;
      background: transparent;
      border: none;
    }"
  )
)
server <- function(input, output, session) {
  observeEvent(input$tv_filter_on, {
    rows <- if (input$tv_filter_on) 100 else 200
    update_el_table_v2(id = "tv_filter", data = grid(rows = rows))
  })
}
shinyApp(ui, server)

## sort
#' Sorting is the server's: `input$tv_sort_column_sort` says which column
#' and which way, and the server sends the rows back reversed with the new
#' `sort_by`.
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)
columns[[1]]$sortable <- TRUE

ui <- el_page(
  el_table_v2(
    "tv_sort",
    columns = columns,
    data = data,
    sort_by = list(key = "column-0", order = "asc"),
    table_v2_width = 700,
    height = 400,
    fixed = TRUE
  )
)

server <- function(input, output, session) {
  rows <- reactiveVal(data)
  observeEvent(input$tv_sort_column_sort, {
    rows(rows()[rev(seq_len(nrow(rows()))), ])
    sort <- input$tv_sort_column_sort
    update_el_table_v2(
      id = "tv_sort",
      data = rows(),
      sort_by = list(key = sort$key, order = sort$order)
    )
  })
}

shinyApp(ui, server)

## controlled-sort
#' Two columns sorted at once: `sort_state` holds each column's order. A
#' click sets that column's order on the server, which sends the state back
#' with `update_el_table_v2(sort_state =)`.
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)
columns[[1]]$sortable <- TRUE
columns[[2]]$sortable <- TRUE

ui <- el_page(
  el_table_v2(
    "tv_csort",
    columns = columns,
    data = data,
    sort_state = list(`column-0` = "desc", `column-1` = "asc"),
    table_v2_width = 700,
    height = 400,
    fixed = TRUE
  )
)

server <- function(input, output, session) {
  state <- list(`column-0` = "desc", `column-1` = "asc")
  rows <- data
  observeEvent(input$tv_csort_column_sort, {
    sort <- input$tv_csort_column_sort
    state[[sort$key]] <<- sort$order
    rows <<- rows[rev(seq_len(nrow(rows))), ]
    update_el_table_v2(id = "tv_csort", data = rows, sort_state = state)
  })
}

shinyApp(ui, server)

## cross-hovering
#' Hovering a cell lights its row and its column. `cell_props` gives every
#' cell a `data-key` naming its column and marks the table with the column
#' the pointer is over; the stylesheet does the rest.
#| shot_js = "var c = document.querySelectorAll('#shot .el-table-v2__row')[2].querySelectorAll('.el-table-v2__row-cell')[3]; c.dispatchEvent(new MouseEvent('mouseenter')); c.closest('.el-table-v2__row').classList.add('is-hovered');"
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
cols <- c(
  list(el_table_v2_column(
    "column-n-1",
    "Row No.",
    width = 50,
    align = "center",
    cell_renderer = JS(
      "function({ rowIndex }) { return String(rowIndex + 1); }"
    )
  )),
  grid_columns()
)
tagList(
  tags$style(HTML(paste0(
    sprintf(
      "[data-hover-col='%d'] [data-key='hovering-col-%d']",
      0:10,
      0:10
    ),
    " { background: var(--el-table-row-hover-bg-color); }",
    collapse = "\n"
  ))),
  el_table_v2(
    "tv_cross",
    data = grid(),
    columns = cols,
    table_v2_width = 700,
    height = 400,
    cell_props = JS(
      "function({ columnIndex }) {
        var table = function(e) { return e.currentTarget.closest('.el-table-v2'); };
        return {
          'data-key': 'hovering-col-' + columnIndex,
          onMouseenter: function(e) { table(e).setAttribute('data-hover-col', columnIndex); },
          onMouseleave: function(e) { table(e).removeAttribute('data-hover-col'); }
        };
      }"
    )
  )
)

## colspan
#' The `row` slot draws each row's cells; `methods` holds upstream's own
#' function, which widens the second cell over the next ones with
#' `Vue.cloneVNode()`.
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
el_table_v2(
  "tv_colspan",
  data = grid(),
  columns = grid_columns(),
  table_v2_width = 700,
  height = 400,
  fixed = TRUE,
  methods = list(
    rowCells = JS(
      "function({ rowIndex, cells }) {
        cells = cells.slice();
        var span = (rowIndex % 4) + 1;
        if (span > 1) {
          var width = parseInt(cells[1].props.style.width);
          for (var i = 1; i < span; i++) {
            width += parseInt(cells[1 + i].props.style.width);
            cells[1 + i] = null;
          }
          cells[1] = Vue.cloneVNode(cells[1], { style: Object.assign({},
            cells[1].props.style, { width: width + 'px',
              backgroundColor: 'var(--el-color-primary-light-3)' }) });
        }
        return cells.filter(Boolean);
      }"
    )
  ),
  slots = list(
    row = template(
      HTML('<component v-for="c in rowCells(props)" :is="c" />'),
      slot = "row",
      scope = "props"
    )
  )
)

## rowspan
#' The `row` slot draws each row's cells; `methods` holds upstream's own
#' function, which makes every other first cell two rows tall.
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
el_table_v2(
  "tv_rowspan",
  data = grid(),
  columns = grid_columns(),
  table_v2_width = 700,
  height = 400,
  fixed = TRUE,
  methods = list(
    rowCells = JS(
      "function({ rowIndex, cells }) {
        cells = cells.slice();
        if (rowIndex % 2 === 0 && rowIndex <= 198) {
          cells[0] = Vue.cloneVNode(cells[0], { style: Object.assign({},
            cells[0].props.style, { height: (2 * 50 - 1) + 'px',
              alignSelf: 'flex-start', zIndex: 1,
              backgroundColor: 'var(--el-color-primary-light-3)' }) });
        }
        return cells;
      }"
    )
  ),
  slots = list(
    row = template(
      HTML('<component v-for="c in rowCells(props)" :is="c" />'),
      slot = "row",
      scope = "props"
    )
  )
)

## spans
#' Column and row spans together, from one `row` function in `methods`.
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
el_table_v2(
  "tv_spans",
  data = grid(),
  columns = grid_columns(),
  table_v2_width = 700,
  height = 400,
  fixed = TRUE,
  methods = list(
    rowCells = JS(
      "function({ rowIndex, cells }) {
        cells = cells.slice();
        var span = (rowIndex % 4) + 1;
        if (span > 1) {
          var width = parseInt(cells[1].props.style.width);
          for (var i = 1; i < span; i++) {
            width += parseInt(cells[1 + i].props.style.width);
            cells[1 + i] = null;
          }
          cells[1] = Vue.cloneVNode(cells[1], { style: Object.assign({},
            cells[1].props.style, { width: width + 'px',
              backgroundColor: 'var(--el-color-primary-light-3)' }) });
        }
        var style = cells[0].props.style;
        if (rowIndex % 2 === 0 && rowIndex <= 198) {
          cells[0] = Vue.cloneVNode(cells[0], { style: Object.assign({}, style,
            { height: '100px', alignSelf: 'flex-start', zIndex: 1,
              backgroundColor: 'var(--el-color-danger-light-3)' }) });
        } else {
          // the cell above covers this one: an empty box keeps the width
          cells[0] = Vue.h('div', { style: Object.assign({}, style,
            { width: parseInt(style.width) + 'px' }) });
        }
        return cells.filter(Boolean);
      }"
    )
  ),
  slots = list(
    row = template(
      HTML('<component v-for="c in rowCells(props)" :is="c" />'),
      slot = "row",
      scope = "props"
    )
  )
)

## tree-data
#' The rows nest through `children`; the arrow sits in the column named by
#' `expand_column_key`. Opening a row reports `input$tv_tree_row_expand`,
#' and the open rows `input$tv_tree_expanded_rows_change`.
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
for (i in 1:2) {
  columns[[i]]$fixed <- "left"
}
columns[[10]]$fixed <- "right"

expand_column_key <- "column-0"
rows <- generate_data(columns, 200)
rows <- lapply(seq_len(nrow(rows)), function(i) as.list(rows[i, ]))
copy <- function(row, id, label) {
  row$id <- id
  row[[expand_column_key]] <- label
  row
}
rows[[1]]$children <- lapply(0:49, function(i) {
  copy(rows[[1]], paste0(rows[[1]]$id, "-sub-", i), paste("Sub", i))
})
rows[[3]]$children <- lapply(0:49, function(i) {
  sub <- copy(rows[[3]], paste0(rows[[3]]$id, "-sub-", i), paste("Sub", i))
  sub$children <- list(copy(
    rows[[3]],
    paste0(rows[[3]]$id, "-sub-sub-", i),
    paste("Sub-Sub", i)
  ))
  sub
})

el_table_v2(
  "tv_tree",
  columns = columns,
  data = rows,
  expand_column_key = expand_column_key,
  table_v2_width = 700,
  height = 400,
  fixed = TRUE
)

## dynamic-height
#' `estimated_row_height` lets each row take the height of its content.
#' Sorting is the server's: it sorts the rows and sends them back with the
#' new `sort_by`.
long_text <- "Quaerat ipsam necessitatibus eum quibusdam est id voluptatem cumque mollitia."
mid_text <- "Corrupti doloremque a quos vero delectus consequatur."
short_text <- "Eius optio fugiat."

set.seed(1)
data <- data.frame(
  id = paste0("random-", 1:200),
  name = "Tom",
  date = "2016-05-03",
  description = sample(c(short_text, mid_text, long_text), 200, TRUE)
)

columns <- list(
  el_table_v2_column("id", "Id", width = 150, sortable = TRUE, fixed = "left"),
  el_table_v2_column(
    "name",
    "Name",
    width = 150,
    align = "center",
    cell_renderer = JS(
      "function({ cellData: name }) {",
      "  return Vue.h(ElementPlus.ElTag, null, function() { return name; });",
      "}"
    )
  ),
  el_table_v2_column(
    "description",
    "Description",
    width = 150,
    cell_renderer = JS(
      "function({ cellData: description }) {",
      "  return Vue.h('div', { style: 'padding: 10px 0;' }, description);",
      "}"
    )
  ),
  el_table_v2_column(
    "operations",
    "Operations",
    cell_renderer = JS(
      "function() {",
      "  return [",
      "    Vue.h(ElementPlus.ElButton, { size: 'small' }, function() { return 'Edit'; }),",
      "    Vue.h(ElementPlus.ElButton, { size: 'small', type: 'danger' },",
      "      function() { return 'Delete'; })",
      "  ];",
      "}"
    ),
    width = 150,
    align = "center"
  )
)

ui <- el_page(
  el_table_v2(
    "tv_dyn",
    columns = columns,
    data = data,
    sort_by = list(key = "name", order = "asc"),
    estimated_row_height = 40,
    table_v2_width = 700,
    height = 400,
    fixed = TRUE
  )
)

server <- function(input, output, session) {
  observeEvent(input$tv_dyn_column_sort, {
    sort <- input$tv_dyn_column_sort
    rows <- data[order(data[[sort$key]], decreasing = sort$order == "desc"), ]
    update_el_table_v2(
      id = "tv_dyn",
      data = rows,
      sort_by = list(key = sort$key, order = sort$order)
    )
  })
}

shinyApp(ui, server)

## detailed-view
#' Each row has a child holding its detail; expanded, the `row` slot draws
#' the child as a block of text rather than cells.
#| shot_js = "document.querySelector('#shot .el-table-v2__expand-icon').click()", shot_wait = 1
# the grid upstream's examples use: Row i - Col j
grid <- function(cols = 10, rows = 200) {
  df <- data.frame(
    check.names = FALSE,
    setNames(
      lapply(seq_len(cols) - 1, function(j) {
        paste0("Row ", seq_len(rows) - 1, " - Col ", j)
      }),
      paste0("column-", seq_len(cols) - 1)
    )
  )
  cbind(id = paste0("row-", seq_len(rows) - 1), df)
}
grid_columns <- function(cols = 10, width = 150) {
  lapply(seq_len(cols) - 1, function(j) {
    k <- paste0("column-", j)
    el_table_v2_column(k, paste("Column", j), width = width)
  })
}
detail <- paste(
  "Velit sed aspernatur tempora. Natus consequatur officiis dicta vel",
  "assumenda. Itaque est temporibus minus quis. Ipsum commodiab porro vel",
  "voluptas illum. Qui quam nulla et dolore autem itaque est."
)
df <- grid()
rows <- lapply(seq_len(nrow(df)), function(i) {
  row <- as.list(df[i, ])
  row$children <- list(list(id = paste0(row$id, "-detail"), detail = detail))
  row
})
el_table_v2(
  "tv_detail",
  data = rows,
  columns = grid_columns(),
  expand_column_key = "column-0",
  estimated_row_height = 50,
  table_v2_width = 700,
  height = 400,
  slots = list(
    row = template(
      HTML(paste0(
        "<div v-if=\"props.rowData.detail\" style=\"padding: 24px\">",
        "{{ props.rowData.detail }}</div>",
        "<component v-else v-for=\"c in props.cells\" :is=\"c\" />"
      )),
      slot = "row",
      scope = "props"
    )
  )
)

## footer
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)
el_table_v2(
  "tv_footer",
  columns = columns,
  data = data,
  row_height = 40,
  table_v2_width = 700,
  height = 400,
  footer_height = 50,
  fixed = TRUE,
  slots = list(
    footer = tags$div(
      style = paste(
        "display: flex; align-items: center; justify-content: center;",
        "height: 100%; background-color: var(--el-color-primary-light-7);"
      ),
      "Display a message in the footer"
    )
  )
)

## empty
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
columns <- generate_columns(10)
el_table_v2(
  "tv_empty",
  columns = columns,
  data = list(),
  row_height = 40,
  table_v2_width = 700,
  height = 400,
  footer_height = 50,
  slots = list(
    empty = tags$div(
      style = "display: flex; align-items: center; justify-content: center; height: 100%",
      el_empty()
    )
  )
)

## overlay
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)
el_table_v2(
  "tv_overlay",
  columns = columns,
  data = data,
  row_height = 40,
  table_v2_width = 700,
  height = 400,
  slots = list(
    overlay = tags$div(
      class = "el-loading-mask",
      style = "display: flex; align-items: center; justify-content: center",
      el_icon(
        "Loading",
        class = "is-loading",
        color = "var(--el-color-primary)",
        size = 26
      )
    )
  )
)

## manual-scroll
#| shot_js = "document.querySelector('#rows_btn_container button').click()"
#| shot_wait = 2
#' The buttons call the table's `scrollToTop()` and `scrollToRow()` from the
#' server. `scrollToRow()` is given the strategy `"start"`: with the default,
#' Element Plus 2.14.7 also scrolls the table to its last column (see
#' "Limitations").
generate_columns <- function(length = 10, prefix = "column-") {
  lapply(seq_len(length) - 1, function(i) {
    el_table_v2_column(paste0(prefix, i), paste("Column", i), width = 150)
  })
}
generate_data <- function(columns, length = 200, prefix = "row-") {
  rows <- data.frame(id = paste0(prefix, seq_len(length) - 1))
  for (j in seq_along(columns)) {
    rows[[columns[[j]]$dataKey]] <- paste0(
      "Row ",
      seq_len(length) - 1,
      " - Col ",
      j - 1
    )
  }
  rows
}
columns <- generate_columns(10)
data <- generate_data(columns, 200)

ui <- el_page(
  tags$div(
    style = "display: flex; gap: 16px; margin-bottom: 16px",
    el_input("delta", value = "200", label = "Scroll pixels"),
    el_input("rows", value = "10", label = "Scroll rows")
  ),
  tags$div(
    style = "margin-bottom: 16px",
    el_button("pixels_btn", "Scroll by pixels"),
    el_button("rows_btn", "Scroll by rows")
  ),
  tags$div(
    style = "height: 400px",
    el_table_v2(
      "tv_scroll",
      columns = columns,
      data = data,
      fixed = TRUE,
      auto_resize = TRUE
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$pixels_btn, {
    call_el(session, "tv_scroll", "scrollToTop", list(as.numeric(input$delta)))
  })
  observeEvent(input$rows_btn, {
    call_el(
      session,
      "tv_scroll",
      "scrollToRow",
      list(as.numeric(input$rows), "start")
    )
  })
}

shinyApp(ui, server)
