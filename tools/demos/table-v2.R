## basic
#' A data.frame, its columns made from its variables.
df <- data.frame(
  check.names = FALSE,
  setNames(
    lapply(1:10, function(j) paste0("Row ", 1:1000, " - Col ", j)),
    paste0("column-", 1:10)
  )
)
el_table_v2("tv_basic", data = df, table_v2_width = 700, height = 400)

## auto-resizer
#' `auto_resize = TRUE` sizes the table to its container, which needs a
#' height of its own.
df <- data.frame(
  id = 1:1000,
  name = paste("Name", 1:1000),
  value = round(runif(1000) * 100)
)
tags$div(
  style = "height: 400px",
  el_table_v2("tv_auto", data = df, auto_resize = TRUE)
)

## cell-templating
#' A cell drawn with a template: the `cell` slot, its scope the row and column.
df <- data.frame(
  name = paste("User", 1:200),
  state = sample(c("active", "inactive"), 200, TRUE)
)
el_table_v2(
  "tv_cell",
  data = df,
  table_v2_width = 700,
  height = 300,
  slots = list(
    cell = template(
      htmltools::HTML(paste0(
        "<el-tag v-if=\"column.dataKey === 'state'\" :type=\"rowData.state === 'active' ? 'success' : 'info'\">",
        "{{ rowData.state }}</el-tag><span v-else>{{ rowData[column.dataKey] }}</span>"
      )),
      slot = "cell",
      scope = "{ rowData, column }"
    )
  )
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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
  })
}
df <- grid()
df$checked <- FALSE
report <- "$setInput('tv_sel_checked', data.filter(r => r.checked).map(r => r.id))"
el_table_v2(
  "tv_sel",
  data = df,
  columns = c(list(list(key = "selection", width = 50)), grid_columns()),
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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
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
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
tagList(
  tags$style(".tv-odd { background: var(--el-color-primary-light-9); }"),
  el_table_v2(
    "tv_rowclass",
    data = df,
    table_v2_width = 700,
    height = 300,
    row_class = JS(
      "function({ rowIndex }) { return rowIndex % 2 ? 'tv-odd' : ''; }"
    )
  )
)

## sticky-rows
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2(
  "tv_sticky",
  data = df,
  table_v2_width = 700,
  height = 300,
  fixed_data = list(list(id = "Pinned", name = "Stays on top"))
)

## fixed-columns
cols <- lapply(1:10, function(j) {
  list(
    key = paste0("c", j),
    dataKey = paste0("c", j),
    title = paste("Column", j),
    width = 150,
    fixed = if (j == 1) {
      "left"
    } else if (j == 10) {
      "right"
    }
  )
})
df <- data.frame(
  check.names = FALSE,
  setNames(
    lapply(1:10, function(j) paste0("Row ", 1:200, " - Col ", j)),
    paste0("c", 1:10)
  )
)
el_table_v2(
  "tv_fixed",
  data = df,
  columns = cols,
  table_v2_width = 700,
  height = 300,
  fixed = TRUE
)

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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
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
#' Sorting is the server's: `input$<id>_column_sort` says which column and
#' which way.
df <- data.frame(id = 1:200, value = round(runif(200) * 100))
cols <- list(
  list(key = "id", dataKey = "id", title = "Id", width = 150, sortable = TRUE),
  list(
    key = "value",
    dataKey = "value",
    title = "Value",
    width = 150,
    sortable = TRUE
  )
)
el_table_v2(
  "tv_sort",
  data = df,
  columns = cols,
  table_v2_width = 700,
  height = 300,
  sort_by = list(key = "id", order = "asc")
)

## controlled-sort
df <- data.frame(id = 1:200, value = round(runif(200) * 100))
cols <- list(
  list(key = "id", dataKey = "id", title = "Id", width = 150, sortable = TRUE),
  list(
    key = "value",
    dataKey = "value",
    title = "Value",
    width = 150,
    sortable = TRUE
  )
)
el_table_v2(
  "tv_csort",
  data = df,
  columns = cols,
  table_v2_width = 700,
  height = 300,
  sort_state = list(id = "desc", value = "asc")
)

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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
  })
}
cols <- c(
  list(list(
    key = "column-n-1",
    width = 50,
    title = "Row No.",
    align = "center",
    cellRenderer = JS("function({ rowIndex }) { return String(rowIndex + 1); }")
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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
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
rows <- lapply(1:50, function(i) {
  list(
    id = paste0("r", i),
    name = paste("Parent", i),
    children = lapply(1:3, function(j) {
      list(id = paste0("r", i, "-", j), name = paste("Child", i, j))
    })
  )
})
el_table_v2(
  "tv_tree",
  data = rows,
  expand_column_key = "name",
  table_v2_width = 700,
  height = 300,
  columns = list(
    list(key = "name", dataKey = "name", title = "Name", width = 300),
    list(key = "id", dataKey = "id", title = "Id", width = 150)
  )
)

## dynamic-height
#' `estimated_row_height` lets each row take the height of its content.
df <- data.frame(
  id = 1:100,
  text = vapply(1:100, function(i) strrep("text ", (i %% 7 + 1) * 8), "")
)
el_table_v2(
  "tv_dyn",
  data = df,
  estimated_row_height = 50,
  table_v2_width = 700,
  height = 300,
  columns = list(
    list(key = "id", dataKey = "id", title = "Id", width = 80),
    list(key = "text", dataKey = "text", title = "Text", width = 600)
  )
)

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
    list(key = k, dataKey = k, title = paste("Column", j), width = width)
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
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2(
  "tv_footer",
  data = df,
  table_v2_width = 700,
  height = 300,
  footer_height = 50,
  slots = list(
    footer = tags$div(
      style = "display: flex; align-items: center; justify-content: center; height: 100%",
      "Display a message in the footer"
    )
  )
)

## empty
el_table_v2(
  "tv_empty",
  data = list(),
  table_v2_width = 700,
  height = 300,
  columns = list(list(key = "a", dataKey = "a", title = "A", width = 150)),
  slots = list(
    empty = tags$div(
      style = "display: flex; justify-content: center",
      el_empty()
    )
  )
)

## overlay
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2(
  "tv_overlay",
  data = df,
  table_v2_width = 700,
  height = 300,
  slots = list(
    overlay = tags$div(
      class = "el-loading-mask",
      style = "display: flex; align-items: center; justify-content: center",
      el_icon("Loading", class = "is-loading", size = "26px")
    )
  )
)

## manual-scroll
#' `el_call(session, "tv_scroll", "scrollToRow", list(100))` scrolls it from
#' the server.
df <- data.frame(id = 1:1000, name = paste("Name", 1:1000))
el_table_v2("tv_scroll", data = df, table_v2_width = 700, height = 300)
