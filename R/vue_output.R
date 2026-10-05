#' A Vue output that keeps the user's state across renders
#'
#' `vue_output()` and `render_vue()` are the Vue layer's pair, as
#' [shiny::uiOutput()] and [shiny::renderUI()] are Shiny's, with one
#' difference. `renderUI()` replaces what it drew on every render, and with it
#' whatever the user had done: a table's sort, a tree's open nodes, the tab
#' they were on. `render_vue()` applies a render as a change, comparing the
#' server's last render, its new one and the page:
#'
#' * markup the server did not change stays as the page has it;
#' * text and attributes the server changed are set;
#' * each component whose template and options are unchanged gets only the
#'   `data` fields the server changed since its last render -- so a field
#'   the user changed and the server did not keeps the user's value.
#'
#' Anything structural -- an element added or removed, a component's
#' template or options changed, a component given another id -- renders
#' afresh, as `renderUI()` does. (A component given no id draws a random one
#' each render; that is not a change.) To
#' keep a component, put what changes from render to render in its `data`
#' and keep its template the same.
#'
#' A field the server sends with the same value as last time is not sent
#' again, so it does not undo what the user did; to set a value whatever the
#' user did, use [update_vue()].
#'
#' @param id Output id.
#' @param expr An expression returning UI: one component or several, with
#'   any markup around them.
#' @param env,quoted As for [shiny::renderUI()].
#' @return `vue_output()`, a tag; `render_vue()`, a render function.
#' @seealso [vue_app()], [update_vue()].
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   ui <- fluidPage(
#'     sliderInput("n", "Rows", 1, 10, 5),
#'     vue_output("list")
#'   )
#'   server <- function(input, output, session) {
#'     output$list <- render_vue(vue_app(
#'       "items",
#'       template = htmltools::tags$ul(htmltools::tags$li(
#'         `v-for` = "i in items",
#'         "{{ i }}"
#'       )),
#'       data = list(items = as.list(seq_len(input$n)))
#'     ))
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
vue_output <- function(id) {
  htmltools::attachDependencies(
    htmltools::tags$div(id = id, class = "shiny-vue-output"),
    .vue_dependencies()
  )
}

#' @rdname vue_output
#' @export
render_vue <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  inner <- shiny::renderUI(expr, env = env, quoted = TRUE)
  shiny::markRenderFunction(
    vue_output,
    function(shinysession, name, ...) inner(shinysession, name, ...)
  )
}
