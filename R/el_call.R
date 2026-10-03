#' Call a method of an Element component
#'
#' [update_el_table()] and the other `update_el_*()` functions assign into the
#' Vue instance's data, which reaches a component's props. Element also
#' documents *methods* -- `clearSelection()`, `setCheckedKeys()`,
#' `validate()` -- which are functions on the component and cannot be reached
#' that way. `el_call()` invokes one.
#'
#' A method that returns something reports it as `input$<id>_<method>`, with
#' the method name in snake_case, matching how events are reported:
#' `getCheckedKeys` arrives as `input$<id>_get_checked_keys`. The input is set
#' with event priority, so asking twice and getting the same answer still
#' fires an `observeEvent()` the second time.
#'
#' A method that returns nothing reports `TRUE`, so an `observeEvent()` can
#' still tell that it ran. Pass `result = FALSE` to send nothing back.
#'
#' Each component's methods are listed in its own help page, under
#' "Element methods".
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Component ID (un-namespaced).
#' @param method Name of the Element method to call.
#' @param args A list of arguments, passed positionally. A row of a table
#'   or a file of an upload is given by [el_table_row()] or
#'   [el_upload_file()]: the method needs the object itself.
#' @param result Whether to report the return value as an input. Default
#'   `TRUE`.
#'   The input is `<id>_<method>`; an input of your own with that name -- an
#'   `actionButton("car_next")` beside `el_call(session, "car", "next")` --
#'   would hear it too. Give `result = FALSE`, or another name, then.
#' @param component Optional Element component name (`"ElTable"`) to look for
#'   under the component's id. Only needed when a component nests another of
#'   its own.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'
#'   ui <- el_page(
#'     el_tree(
#'       "tree",
#'       show_checkbox = TRUE,
#'       node_key = "id",
#'       checked = "apple",
#'       default_expand_all = TRUE,
#'       data = list(list(
#'         id = "fruit",
#'         label = "Fruit",
#'         children = list(
#'           list(id = "apple", label = "Apple"),
#'           list(id = "pear", label = "Pear")
#'         )
#'       ))
#'     ),
#'     el_button("clear", "Clear the ticks"),
#'     el_button("ask", "Which are ticked?"),
#'     verbatimTextOutput("answer")
#'   )
#'
#'   server <- function(input, output, session) {
#'     # A command: setCheckedKeys() with an empty set
#'     observeEvent(input$clear, {
#'       el_call(session, "tree", "setCheckedKeys", list(list()))
#'     })
#'
#'     # A method with a return value answers asynchronously
#'     observeEvent(input$ask, {
#'       el_call(session, "tree", "getCheckedKeys")
#'     })
#'     output$answer <- renderPrint(input$tree_get_checked_keys)
#'   }
#'
#'   shinyApp(ui, server)
#' }
#' @export
el_call <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  method,
  args = list(),
  result = TRUE,
  component = NULL
) {
  .el_check_session(session)
  if (!is.character(method) || length(method) != 1L || !nzchar(method)) {
    stop("`method` must be a single method name.", call. = FALSE)
  }
  if (!grepl("^[A-Za-z][A-Za-z0-9_]*$", method)) {
    stop(
      "`method` must be a plain method name, not ",
      sQuote(method),
      ".",
      call. = FALSE
    )
  }
  if (!is.list(args)) {
    args <- list(args)
  }

  ns_id <- session$ns(id)
  session$sendCustomMessage(
    "shinyVueCall",
    list(
      id = ns_id,
      method = method,
      # Unnamed, so jsonlite writes an array and the arguments stay positional
      args = unname(args),
      component = component,
      input = if (isTRUE(result)) paste0(ns_id, "_", .el_snake_case(method))
    )
  )
  invisible(NULL)
}


#' Turn a camelCase method name into the snake_case input it reports to
#'
#' @param x A method name.
#' @return The same name in snake_case.
#' @keywords internal
.el_snake_case <- function(x) {
  tolower(gsub("([a-z0-9])([A-Z])", "\\1_\\2", x))
}


#' Name a table row, an uploaded file or a tree node for a method
#'
#' Element's table methods take the row object itself --
#' `toggleRowSelection(row)`, `setCurrentRow(row)`,
#' `toggleRowExpansion(row)` -- and compare it by identity, so a copy sent
#' from R would match nothing. Likewise the upload's `abort(file)` and
#' `handleRemove(file)`, and a virtualized tree's `expandNode(node)` and
#' `collapseNode(node)`. These stand for the object instead, and the page
#' puts the real one in its place before the method runs.
#'
#' @param index A row's number, 1-based, as `input$<id>_selected_rows`
#'   reports them.
#' @param name A file's name, as it shows in the upload's list.
#' @param key A node's key: the field `node_key` names, or the tree's
#'   `props$value`.
#' @return A reference, for [el_call()]'s `args`.
#' @examples
#' if (interactive()) {
#'   # inside a server function: select the third row, then make it current
#'   el_call(session, "tbl", "toggleRowSelection", list(el_table_row(3), TRUE))
#'   el_call(session, "tbl", "setCurrentRow", list(el_table_row(3)))
#'   # stop one file
#'   el_call(session, "docs", "abort", list(el_upload_file("big.csv")))
#'   # open a node of a virtualized tree
#'   el_call(session, "files", "expandNode", list(el_tree_node("src")))
#' }
#' @export
el_table_row <- function(index) {
  stopifnot(is.numeric(index), length(index) == 1)
  list(.ref = "row", value = index)
}

#' @rdname el_table_row
#' @export
el_upload_file <- function(name) {
  stopifnot(is.character(name), length(name) == 1)
  list(.ref = "file", value = name)
}

#' @rdname el_table_row
#' @export
el_tree_node <- function(key) {
  stopifnot(length(key) == 1)
  list(.ref = "node", value = key)
}
