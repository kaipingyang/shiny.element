#' Call a method of an Element component
#'
#' [update_el_table()] and the other `update_el_*()` functions assign into the
#' Vue instance's data, which reaches a component's props. Element also
#' documents *methods* -- `clearSelection()`, `setCheckedKeys()`,
#' `validate()` -- which are functions on the component and cannot be reached
#' that way. `call_el()` invokes one: it is [call_vue()] with Element's
#' references to table rows, upload files and tree nodes.
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
#'   `actionButton("car_next")` beside `call_el(session, "car", "next")` --
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
#'       call_el(session, "tree", "setCheckedKeys", list(list()))
#'     })
#'
#'     # A method with a return value answers asynchronously
#'     observeEvent(input$ask, {
#'       call_el(session, "tree", "getCheckedKeys")
#'     })
#'     output$answer <- renderPrint(input$tree_get_checked_keys)
#'   }
#'
#'   shinyApp(ui, server)
#' }
#' @export
call_el <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  method,
  args = list(),
  result = TRUE,
  component = NULL
) {
  .el_check_session(session)
  # Element's references -- el_table_row(), el_upload_file(), el_tree_node()
  # -- are lists the bridge resolves in the browser (sv.refs); the call
  # itself is the Vue layer's
  call_vue(
    session,
    id,
    method,
    args = args,
    result = result,
    component = component
  )
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
#' @param index A row's number, 1-based, as a table's `input$<id>_selection_rows`
#'   reports them.
#' @param name A file's name, as it shows in the upload's list.
#' @param key A node's key: the field `node_key` names, or the tree's
#'   `props$value`.
#' @return A reference, for [call_el()]'s `args`.
#' @examples
#' if (interactive()) {
#'   # inside a server function: select the third row, then make it current
#'   call_el(session, "tbl", "toggleRowSelection", list(el_table_row(3), TRUE))
#'   call_el(session, "tbl", "setCurrentRow", list(el_table_row(3)))
#'   # stop one file
#'   call_el(session, "docs", "abort", list(el_upload_file("big.csv")))
#'   # open a node of a virtualized tree
#'   call_el(session, "files", "expandNode", list(el_tree_node("src")))
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
