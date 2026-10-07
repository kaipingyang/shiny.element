.onLoad <- function(libname, pkgname) {
  # Dates arrive as Date, as from shiny::dateInput(): "YYYY-MM-DD" text from
  # the picker, one value or several. An empty picker is NULL.
  shiny::registerInputHandler(
    "shiny.element.date",
    function(x, ...) {
      if (is.null(x) || !length(x)) {
        return(NULL)
      }
      x <- unlist(x)
      if (all(is.na(x) | x == "")) {
        return(NULL)
      }
      x[x == ""] <- NA
      as.Date(x)
    },
    force = TRUE
  )
  # Row numbers, as integers; none selected is NULL, as Shiny reports an
  # empty checkboxGroupInput()
  shiny::registerInputHandler(
    "shiny.element.rows",
    function(x, ...) {
      if (is.null(x) || !length(x)) {
        return(NULL)
      }
      as.integer(unlist(x))
    },
    force = TRUE
  )
  # A table's selection-change: the selected rows of the data the table was
  # rendered with, as R subsets them -- `data[rows, , drop = FALSE]`, the
  # columns and their types untouched. A table outside render_el_table()
  # has no data on the server, and gets the rows as the browser holds them.
  shiny::registerInputHandler(
    "shiny.element.selection",
    function(x, session, name) {
      rows <- as.integer(unlist(x$rows))
      if (!length(rows)) {
        return(NULL)
      }
      data <- .el_table_data(session, x$table %||% "")
      if (is.data.frame(data)) {
        return(data[rows, , drop = FALSE])
      }
      .el_rows_frame(x$data)
    },
    force = TRUE
  )
  # A calendar's events and the days it shows, their dates as Dates:
  # `date`, `end`, `start` and `current`, at any depth
  shiny::registerInputHandler(
    "shiny.element.cal_event",
    function(x, ...) .el_calendar_dates(x),
    force = TRUE
  )
  # A cell edited in an editable column: applied to the server's copy of
  # the data, as the browser shows it already, and reported with R's types
  # -- the value as the column holds it, and the value it replaced
  shiny::registerInputHandler(
    "shiny.element.cell_edit",
    function(x, session, name) .el_table_cell_edit(x, session),
    force = TRUE
  )
  # An upload job a failed or aborted file left behind, to be let go of
  shiny::registerInputHandler(
    "shiny.element.upload_abandon",
    function(x, session, name) {
      .el_upload_abandon(x, session)
      NULL
    },
    force = TRUE
  )
}
