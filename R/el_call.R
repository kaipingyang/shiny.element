#' Call a method on the Element UI component behind a widget
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
#' @param session Shiny session object.
#' @param id Component ID (un-namespaced).
#' @param method Name of the Element method to call.
#' @param args A list of arguments, passed positionally.
#' @param result Whether to report the return value as an input. Default
#'   `TRUE`.
#' @param component Optional Element component name (`"ElTable"`) to look for
#'   under the widget. Only needed when a component nests another of its own.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'
#'   ui <- el_page(
#'     el_tree("tree", show_checkbox = TRUE, node_key = "id", checked = "apple",
#'             default_expand_all = TRUE,
#'             data = list(list(id = "fruit", label = "Fruit", children = list(
#'               list(id = "apple", label = "Apple"),
#'               list(id = "pear", label = "Pear"))))),
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
el_call <- function(session, id, method, args = list(), result = TRUE,
                    component = NULL) {
  if (!is.character(method) || length(method) != 1L || !nzchar(method)) {
    stop("`method` must be a single method name.", call. = FALSE)
  }
  if (!grepl("^[A-Za-z][A-Za-z0-9_]*$", method)) {
    stop("`method` must be a plain method name, not ", sQuote(method), ".",
         call. = FALSE)
  }
  if (!is.list(args)) args <- list(args)

  ns_id <- session$ns(id)
  session$sendCustomMessage("elInvoke", list(
    id        = ns_id,
    method    = method,
    # Unnamed, so jsonlite writes an array and the arguments stay positional
    args      = unname(args),
    component = component,
    input     = if (isTRUE(result)) paste0(ns_id, "_", .el_snake_case(method))
  ))
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
