## basic
#' A data.frame, its columns made from its variables.
df <- as.data.frame(setNames(lapply(1:10, function(j) paste0("Row ", 1:1000, " - Col ", j)),
                             paste0("column-", 1:10)))
el_table_v2("tv_basic", data = df, table_v2_width = 700, height = 400)

## auto-resizer
#' Element Plus's table needs a width and height in pixels; give the size
#' the space has.
df <- data.frame(id = 1:1000, name = paste("Name", 1:1000), value = round(runif(1000) * 100))
el_table_v2("tv_auto", data = df, table_v2_width = 700, height = 400)

## cell-templating
#' A cell drawn with a template: the `cell` slot, its scope the row and column.
df <- data.frame(name = paste("User", 1:200), state = sample(c("active", "inactive"), 200, TRUE))
el_table_v2("tv_cell", data = df, table_v2_width = 700, height = 300, slots = list(
  cell = template(htmltools::HTML(paste0(
    "<el-tag v-if=\"column.dataKey === 'state'\" :type=\"rowData.state === 'active' ? 'success' : 'info'\">",
    "{{ rowData.state }}</el-tag><span v-else>{{ rowData[column.dataKey] }}</span>")),
    slot = "cell", scope = "{ rowData, column }")))

## selection !skip
Selection columns are drawn with a JSX cell renderer in Element Plus's demo;
in R, use `el_table(selection = TRUE)`, or a `cell` slot with a checkbox.

## inline-editing !skip
Editing in place is a JSX cell renderer upstream; in R, edit with a `cell`
slot that holds an input, as `el_table()`'s cell templates do.

## row-class
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
tagList(
  tags$style(".tv-odd { background: var(--el-color-primary-light-9); }"),
  el_table_v2("tv_rowclass", data = df, table_v2_width = 700, height = 300,
              row_class = JS("function({ rowIndex }) { return rowIndex % 2 ? 'tv-odd' : ''; }")))

## sticky-rows
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2("tv_sticky", data = df, table_v2_width = 700, height = 300,
            fixed_data = list(list(id = "Pinned", name = "Stays on top")))

## fixed-columns
cols <- lapply(1:10, function(j) list(key = paste0("c", j), dataKey = paste0("c", j),
  title = paste("Column", j), width = 150, fixed = if (j == 1) "left" else if (j == 10) "right"))
df <- as.data.frame(setNames(lapply(1:10, function(j) paste0("Row ", 1:200, " - Col ", j)), paste0("c", 1:10)))
el_table_v2("tv_fixed", data = df, columns = cols, table_v2_width = 700, height = 300, fixed = TRUE)

## grouping-header !skip
Grouped headers are drawn with a JSX header renderer upstream; `el_table()`
groups its headers with a column's `children`.

## filter !skip
Filtering in the header is a JSX header renderer upstream; filter the data
in R and `update_el_table_v2()` it, or use `el_table()`'s column filters.

## sort
#' Sorting is the server's: `input$<id>_column_sort` says which column and
#' which way.
df <- data.frame(id = 1:200, value = round(runif(200) * 100))
cols <- list(list(key = "id", dataKey = "id", title = "Id", width = 150, sortable = TRUE),
             list(key = "value", dataKey = "value", title = "Value", width = 150, sortable = TRUE))
el_table_v2("tv_sort", data = df, columns = cols, table_v2_width = 700, height = 300,
            sort_by = list(key = "id", order = "asc"))

## controlled-sort
df <- data.frame(id = 1:200, value = round(runif(200) * 100))
cols <- list(list(key = "id", dataKey = "id", title = "Id", width = 150, sortable = TRUE),
             list(key = "value", dataKey = "value", title = "Value", width = 150, sortable = TRUE))
el_table_v2("tv_csort", data = df, columns = cols, table_v2_width = 700, height = 300,
            sort_state = list(id = "desc", value = "asc"))

## cross-hovering !skip
Hovering across rows and columns is a JSX cell renderer upstream.

## colspan !skip
Spanning cells is a JSX row renderer upstream; `el_table(span_method =)` spans
cells.

## rowspan !skip
Spanning cells is a JSX row renderer upstream; `el_table(span_method =)` spans
cells.

## spans !skip
Spanning cells is a JSX row renderer upstream; `el_table(span_method =)` spans
cells.

## tree-data
rows <- lapply(1:50, function(i) list(id = paste0("r", i), name = paste("Parent", i),
  children = lapply(1:3, function(j) list(id = paste0("r", i, "-", j), name = paste("Child", i, j)))))
el_table_v2("tv_tree", data = rows, expand_column_key = "name", table_v2_width = 700, height = 300,
            columns = list(list(key = "name", dataKey = "name", title = "Name", width = 300),
                           list(key = "id", dataKey = "id", title = "Id", width = 150)))

## dynamic-height
#' `estimated_row_height` lets each row take the height of its content.
df <- data.frame(id = 1:100, text = vapply(1:100, function(i) strrep("text ", (i %% 7 + 1) * 8), ""))
el_table_v2("tv_dyn", data = df, estimated_row_height = 50, table_v2_width = 700, height = 300,
            columns = list(list(key = "id", dataKey = "id", title = "Id", width = 80),
                           list(key = "text", dataKey = "text", title = "Text", width = 600)))

## detailed-view !skip
A row's detail is a JSX row renderer upstream; `el_table()`'s expandable
rows show one.

## footer
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2("tv_footer", data = df, table_v2_width = 700, height = 300, footer_height = 50,
            slots = list(footer = tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%",
                                           "Display a message in the footer")))

## empty
el_table_v2("tv_empty", data = list(), table_v2_width = 700, height = 300,
            columns = list(list(key = "a", dataKey = "a", title = "A", width = 150)),
            slots = list(empty = tags$div(style = "display: flex; justify-content: center", el_empty())))

## overlay
df <- data.frame(id = 1:200, name = paste("Name", 1:200))
el_table_v2("tv_overlay", data = df, table_v2_width = 700, height = 300,
            slots = list(overlay = tags$div(class = "el-loading-mask",
              style = "display: flex; align-items: center; justify-content: center",
              el_icon("Loading", class = "is-loading", size = "26px"))))

## manual-scroll
#' `el_call(session, "tv_scroll", "scrollToRow", list(100))` scrolls it from
#' the server.
df <- data.frame(id = 1:1000, name = paste("Name", 1:1000))
el_table_v2("tv_scroll", data = df, table_v2_width = 700, height = 300)
