# A component as an object: its arguments, drawn when placed.
#
# The way htmlwidgets work -- datatable(df) is the table's specification,
# rendered by htmltools::as.tags() when it lands in a UI, a tagList or a
# document -- so it can be changed on the way, piped to el_on() before it
# is drawn.

#' A component's specification
#'
#' @param fn The function that draws it, by name: `".el_table_tags"`.
#' @param args Its arguments.
#' @param class The component's class, `"el_table"`.
#' @return An object of class `class` and `el_component`.
#' @keywords internal
.el_component <- function(fn, args, class) {
  structure(list(fn = fn, args = args), class = c(class, "el_component"))
}

#' @export
#' @importFrom htmltools as.tags
as.tags.el_component <- function(x, ...) {
  htmltools::as.tags(do.call(x$fn, x$args))
}

#' @export
as.character.el_component <- function(x, ...) {
  as.character(htmltools::as.tags(x), ...)
}

#' @export
format.el_component <- function(x, ...) {
  format(htmltools::as.tags(x), ...)
}

#' @export
print.el_component <- function(x, ...) {
  print(htmltools::as.tags(x), ...)
  invisible(x)
}

#' @exportS3Method knitr::knit_print
knit_print.el_component <- function(x, ...) {
  knitr::knit_print(htmltools::as.tags(x), ...)
}

#' Components inside UI, drawn: what code that reads tags expects
#'
#' @param x UI: tags, lists of them, components.
#' @return `x`, every component in it replaced by its tags.
#' @keywords internal
.el_resolve <- function(x) {
  if (inherits(x, "el_component")) {
    return(htmltools::as.tags(x))
  }
  if (inherits(x, "shiny.tag")) {
    x$children <- lapply(x$children, .el_resolve)
    return(x)
  }
  if (
    is.list(x) &&
      !inherits(x, c("html_dependency", "htmlwidget", "json", "JS_EVAL"))
  ) {
    x[] <- lapply(x, .el_resolve)
  }
  x
}

#' Report a component's event to the server
#'
#' Each component reports a few events by default -- a table its
#' `selection-change`, `current-change`, `sort-change`, `filter-change` and
#' `expand-change` -- and any other of Element Plus's events when asked:
#' here, piped, or with the component's `events` argument. The event arrives
#' as `input$<id>_<event>`, Element's name in snake_case
#' (`row-dblclick` -> `input$tbl_row_dblclick`), or under `input` if given.
#'
#' @param x A component: `el_table(...)`.
#' @param event Element Plus's name for the event, `"row-dblclick"`; several
#'   at once are fine.
#' @param input The input it reports as, instead of `<id>_<event>`; inside
#'   a module, namespaced as the component's own id is. One event only.
#' @return `x`, reporting the event too.
#' @seealso [el_table()].
#' @examples
#' el_table(data = head(mtcars)) |>
#'   el_on("row-dblclick") |>
#'   el_on("cell-click", input = "picked")
#' @export
el_on <- function(x, event, input = NULL) {
  if (!inherits(x, "el_component")) {
    stop("`x` must be a component, such as `el_table(...)`.", call. = FALSE)
  }
  if (!is.character(event) || !length(event)) {
    stop("`event` must name Element Plus events.", call. = FALSE)
  }
  if (!is.null(input) && length(event) != 1L) {
    stop("`input` names the input of one event.", call. = FALSE)
  }
  if (inherits(x, "el_table")) {
    .el_check_events(event, "el-table", .el_table_events)
  }
  given <- if (is.null(input)) event else stats::setNames(event, input)
  x$args$events <- c(x$args$events, given)
  x
}

#' Events a component can report: an error naming the others
#' @noRd
.el_check_events <- function(events, tag, known) {
  unknown <- setdiff(unname(events), known)
  if (length(unknown)) {
    stop(
      "Not an event of ",
      tag,
      ": ",
      paste(sQuote(unknown), collapse = ", "),
      ". Its events: ",
      toString(known),
      ".",
      call. = FALSE
    )
  }
  invisible(events)
}

#' The data tables show, kept on the server
#'
#' One set per session: `shown`, a `reactiveValues()` holding, under each
#' table's id, the data the browser has; `rendered`, the data each table's
#' last render gave; `rownames`, each render's `rownames`. The browser
#' patches a render in -- a field changes only when the render's value of
#' it does -- so the two sides stay alike by the same rule: a render writes
#' `shown` only when its data differs from its last; an update always does.
#' @noRd
.el_tables <- function(session, create = FALSE) {
  tables <- session$userData$.el_tables
  if (is.null(tables) && create) {
    tables <- list(
      shown = shiny::reactiveValues(),
      rendered = new.env(parent = emptyenv()),
      rownames = new.env(parent = emptyenv()),
      known = new.env(parent = emptyenv())
    )
    session$userData$.el_tables <- tables
  }
  tables
}

#' Whether the server holds a table's data
#' @noRd
.el_table_known <- function(session, id) {
  tables <- .el_tables(session)
  !is.null(tables) && exists(id, envir = tables$known, inherits = FALSE)
}

#' The data a table shows, outside a reactive read
#' @noRd
.el_table_data <- function(session, id) {
  if (!.el_table_known(session, id)) {
    return(NULL)
  }
  shiny::isolate(.el_tables(session)$shown[[id]])
}

#' The `rownames` a table was rendered with
#' @noRd
.el_table_rownames_of <- function(session, id) {
  tables <- .el_tables(session)
  if (is.null(tables)) NULL else tables$rownames[[id]]
}

#' A table rendered: its data is what the browser shows if it changed
#' @noRd
.el_table_rendered <- function(session, id, data, rownames = NULL) {
  tables <- .el_tables(session, create = TRUE)
  tables$rownames[[id]] <- rownames
  last <- tables$rendered[[id]]
  if (!.el_table_known(session, id) || !identical(last, data)) {
    tables$rendered[[id]] <- data
    .el_table_data_set(session, id, data)
  }
  invisible(NULL)
}

#' A table's data replaced or edited by an update
#' @noRd
.el_table_data_set <- function(session, id, data) {
  tables <- .el_tables(session, create = TRUE)
  assign(id, TRUE, envir = tables$known)
  tables$shown[[id]] <- data
  invisible(NULL)
}

#' The data a table shows
#'
#' What the browser holds, as R: the data last rendered with
#' [render_el_table()] or sent with [update_el_table()], with every row
#' [update_el_table()] has since inserted, replaced or deleted. A reactive
#' read: an observer or output reading it runs again when the data changes.
#' Row numbers in the table's inputs -- `input$<id>_selection_rows`, a row
#' event's `row_index` -- index it.
#'
#' @param session The Shiny session, the current one by default.
#' @param id The table's id, the output's.
#' @return The data, as given (a data.frame or a list of rows); `NULL` for
#'   a table the server has not rendered or updated.
#' @seealso [render_el_table()], [update_el_table()].
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   ui <- el_page(el_table_output("cars"), verbatimTextOutput("n"))
#'   server <- function(input, output, session) {
#'     output$cars <- render_el_table(el_table(data = head(mtcars)))
#'     output$n <- renderText(nrow(el_table_data(id = "cars")))
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_table_data <- function(session = shiny::getDefaultReactiveDomain(), id) {
  .el_check_session(session)
  # created here if need be, so a read before the first render still
  # depends on the data that render brings
  .el_tables(session, create = TRUE)$shown[[session$ns(id)]]
}

#' A cell edit from the browser, applied to the server's data
#'
#' @param x What the browser sent: `table`, `row`, `column` (the prop),
#'   `value`, `old`.
#' @param session The session.
#' @return `list(row, column, value, old)`: the column under its R name and
#'   the values with its type.
#' @noRd
.el_table_cell_edit <- function(x, session) {
  row <- as.integer(x$row %||% NA)
  data <- .el_table_data(session, x$table %||% "")
  column <- x$column
  plain <- list(row = row, column = column, value = x$value, old = x$old)
  if (is.null(data) || is.na(row)) {
    return(plain)
  }
  if (!is.data.frame(data)) {
    if (row > length(data)) {
      return(plain)
    }
    old <- data[[row]][[column]]
    data[[row]][[column]] <- x$value
    .el_table_data_set(session, x$table, data)
    return(list(row = row, column = column, value = x$value, old = old))
  }
  # the prop is the column's name with dots made underscores
  name <- names(data)[gsub(".", "_", names(data), fixed = TRUE) == column]
  if (!length(name) || row > nrow(data)) {
    return(plain)
  }
  name <- name[[1]]
  old <- data[[name]][row]
  value <- .el_cell_value(x$value, data[[name]])
  if (is.factor(value) && !is.na(value) && !value %in% levels(data[[name]])) {
    levels(data[[name]]) <- c(levels(data[[name]]), as.character(value))
  }
  data[[name]][row] <- value
  .el_table_data_set(session, x$table, data)
  list(row = row, column = name, value = data[[name]][row], old = old)
}

#' A value from an editor, as the column it goes into holds values
#' @noRd
.el_cell_value <- function(value, column) {
  if (is.null(value) || !length(value)) {
    return(column[NA_integer_])
  }
  value <- unlist(value)[[1]]
  if (inherits(column, "Date")) {
    return(as.Date(value))
  }
  if (inherits(column, "POSIXct")) {
    return(as.POSIXct(value, tz = attr(column, "tzone") %||% ""))
  }
  if (is.factor(column)) {
    return(factor(as.character(value), levels = union(levels(column), value)))
  }
  if (is.integer(column)) {
    return(as.integer(value))
  }
  if (is.numeric(column)) {
    return(as.numeric(value))
  }
  if (is.logical(column)) {
    return(as.logical(value))
  }
  if (is.character(column)) {
    return(as.character(value))
  }
  value
}

#' Rows as the browser holds them, as a data.frame
#' @noRd
.el_rows_frame <- function(rows) {
  if (!length(rows)) {
    return(NULL)
  }
  jsonlite::fromJSON(
    jsonlite::toJSON(rows, auto_unbox = TRUE, null = "null", na = "null"),
    simplifyDataFrame = TRUE
  )
}

#' An Element Plus table as a Shiny output
#'
#' The table of a Shiny app, as DT's `DTOutput()` and `renderDT()`: the page
#' holds `el_table_output()`, the server renders [el_table()] into it with
#' its data. Rendering again with new data updates the table in place -- the
#' user's sort, ticks and open rows stay (see [render_vue()]).
#'
#' The output id names the table's inputs:
#'
#' - `input$<id>_selection_rows` -- the selected row numbers, integers;
#'   `NULL` with none.
#' - `input$<id>_selection_change` -- the selected rows, `data[rows, , drop =
#'   FALSE]` of the data shown: its columns, types and row names.
#' - `input$<id>_current_change`, `_sort_change`, `_filter_change`,
#'   `_expand_change` -- reported by every table; any other of Element's
#'   events with `el_table(events =)` or [el_on()].
#'
#' [update_el_table()] and [call_el()] reach the table by the output id;
#' [el_table_data()] reads the data it shows.
#'
#' The first render sends the table; a render after it whose columns,
#' templates and options are unchanged sends only the data that changed, as
#' JSON -- as Shiny's own outputs send values rather than markup. Because a
#' render depends on the last one in the session, `render_el_table()` is not
#' cached with [shiny::bindCache()] (as DT's server-side table is not); cache
#' the data it shows instead, in a [shiny::reactive()] upstream.
#'
#' @param outputId The output's id.
#' @param width The table's width, as a CSS unit.
#' @param loading Whether Element's loading mask covers the table while
#'   Shiny recalculates it, in place of Shiny fading the output.
#' @param expr An expression returning [el_table()], given no `id`.
#' @param env,quoted As for [shiny::renderUI()].
#' @return `el_table_output()`, a tag; `render_el_table()`, a render
#'   function.
#' @seealso [el_table()], [el_on()].
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   ui <- el_page(el_table_output("cars"), verbatimTextOutput("picked"))
#'   server <- function(input, output, session) {
#'     output$cars <- render_el_table(
#'       el_table(data = head(mtcars), selection = TRUE)
#'     )
#'     output$picked <- renderPrint(input$cars_selection_change)
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_table_output <- function(outputId, width = "100%", loading = TRUE) {
  style <- c(
    if (!is.null(width)) paste0("width: ", width),
    # Shiny fades a recalculating output; the mask says it instead
    if (isTRUE(loading)) "--shiny-fade-opacity: 1"
  )
  htmltools::attachDependencies(
    htmltools::tags$div(
      id = outputId,
      class = "shiny-vue-output",
      style = if (length(style)) paste(style, collapse = "; "),
      `data-shiny-vue-loading` = if (isTRUE(loading)) NA
    ),
    .el_vue_dependencies()
  )
}

#' @rdname el_table_output
#' @export
render_el_table <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  render <- shiny::markRenderFunction(
    el_table_output,
    function(shinysession, name, ...) {
      # the browser asks for the whole table when it cannot apply a patch
      .vue_output_redraw(shinysession, name)
      table <- tryCatch(func(), error = function(e) {
        # an error, req() included, empties the output: draw it whole next
        .vue_output_forget(shinysession, name)
        stop(e)
      })
      if (is.null(table)) {
        .vue_output_forget(shinysession, name)
        return(NULL)
      }
      if (!inherits(table, "el_table")) {
        stop("render_el_table() renders an el_table().", call. = FALSE)
      }
      table$args$id <- name
      .el_table_rendered(
        shinysession,
        name,
        table$args$data,
        table$args$rownames
      )
      tags <- .el_output_host(table, name)
      .vue_output_value(shinysession, name, tags)
    },
    # it sends what changed since its last render in this session, so a
    # cached value would be wrong: not cacheable, as DT's server-side table
    cacheHint = FALSE
  )
  class(render) <- c("el_render_table", class(render))
  render
}

#' A table output is not cached: cache what it shows
#' @exportS3Method shiny::bindCache
#' @noRd
bindCache.el_render_table <- function(x, ..., cache = "app") {
  stop(
    "render_el_table() cannot be cached: a render sends only what changed ",
    "since the last one in the session. Cache the data instead, upstream:\n",
    "  rows <- bindCache(reactive(query(input$year)), input$year)\n",
    "  output$tbl <- render_el_table(el_table(data = rows()))",
    call. = FALSE
  )
}

#' A component drawn inside the output of the same id
#'
#' The output element carries the id, so the component's host takes
#' another (`<id>-el`) and names its inputs after the output's
#' (`data-shiny-vue-id`), where the bridge finds it by that id too.
#' @noRd
.el_output_host <- function(component, id) {
  tags <- htmltools::as.tags(component)
  rename <- function(x) {
    if (inherits(x, "shiny.tag") && !is.null(attr(x, "el_spec"))) {
      x$attribs$id <- paste0(id, "-el")
      x$attribs[["data-shiny-vue-id"]] <- id
      return(x)
    }
    if (
      inherits(x, "shiny.tag.list") || (is.list(x) && !inherits(x, "shiny.tag"))
    ) {
      x[] <- lapply(x, rename)
    }
    x
  }
  rename(tags)
}
