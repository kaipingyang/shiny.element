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

#' The data a table shows, kept on the server
#'
#' One entry per table and session: `shown`, a reactive value holding the
#' data the browser has, and `rendered`, the data the table's last render
#' gave. The browser patches a render in -- a field changes only when the
#' render's value of it does -- so the two sides stay alike by the same
#' rule: a render writes `shown` only when its data differs from its last;
#' an update always does.
#' @noRd
.el_table_entry <- function(session, id, create = FALSE) {
  tables <- session$userData$.el_tables
  if (is.null(tables)) {
    if (!create) {
      return(NULL)
    }
    tables <- new.env(parent = emptyenv())
    session$userData$.el_tables <- tables
  }
  entry <- tables[[id]]
  if (is.null(entry) && create) {
    entry <- new.env(parent = emptyenv())
    entry$shown <- shiny::reactiveVal(NULL)
    entry$rendered <- NULL
    entry$rownames <- NULL
    tables[[id]] <- entry
  }
  entry
}

#' The data a table shows, outside a reactive read
#' @noRd
.el_table_data <- function(session, id) {
  entry <- .el_table_entry(session, id)
  if (is.null(entry)) NULL else shiny::isolate(entry$shown())
}

#' A table rendered: its data is what the browser shows if it changed
#' @noRd
.el_table_rendered <- function(session, id, data, rownames = NULL) {
  entry <- .el_table_entry(session, id, create = TRUE)
  entry$rownames <- rownames
  if (is.null(entry$rendered) || !identical(entry$rendered, data)) {
    entry$rendered <- data
    entry$shown(data)
  }
  invisible(NULL)
}

#' A table's data replaced or edited by an update
#' @noRd
.el_table_data_set <- function(session, id, data) {
  entry <- .el_table_entry(session, id, create = TRUE)
  entry$shown(data)
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
  entry <- .el_table_entry(session, session$ns(id))
  if (is.null(entry)) NULL else entry$shown()
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
#' @param outputId The output's id.
#' @param width The table's width, as a CSS unit.
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
el_table_output <- function(outputId, width = "100%") {
  htmltools::attachDependencies(
    htmltools::tags$div(
      id = outputId,
      class = "shiny-vue-output",
      style = if (!is.null(width)) paste0("width: ", width)
    ),
    .el_vue_dependencies()
  )
}

#' @rdname el_table_output
#' @export
render_el_table <- function(expr, env = parent.frame(), quoted = FALSE) {
  func <- shiny::exprToFunction(expr, env, quoted)
  shiny::markRenderFunction(
    el_table_output,
    function(shinysession, name, ...) {
      table <- func()
      if (is.null(table)) {
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
      rendered <- htmltools::renderTags(.el_output_host(table, name))
      list(
        html = rendered$html,
        deps = lapply(
          htmltools::resolveDependencies(rendered$dependencies),
          shiny::createWebDependency
        )
      )
    }
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
