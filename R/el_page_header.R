#' Element UI Page Header
#'
#' A page title with a back link.
#'
#' @param id Header ID. Auto-generated if `NULL`.
#' @param title Text of the back link. Default `"Back"`.
#' @param content The page's own title, shown after the separator.
#' @param width Component width, as a CSS unit.
#' @param icon Icon component of page header. Element Plus's `icon` (string /
#'   Component). An icon's name, such as `"Search"`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>_back` -- fires when the back link is clicked. Observe it to
#'   decide what going back means in your app; the component navigates nowhere
#'   on its own.
#'
#' @return A Shiny UI element.
#' @examples
#' el_page_header("hdr", content = "Sales for March")
#' el_page_header("hdr", title = "All reports", content = "Sales for March")
#'
#' if (interactive()) {
#'   library(shiny)
#'   ui <- el_page(
#'     el_page_header("hdr", content = "Detail"),
#'     verbatimTextOutput("where")
#'   )
#'   server <- function(input, output, session) {
#'     output$where <- renderPrint(input$hdr_back)
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
el_page_header <- function(id = NULL,
                           title = NULL,
                           content = NULL,
                           icon = NULL,
                           width = NULL,
                           slots   = NULL,
                           session = NULL) {
  if (is.null(id)) id <- paste0("el_page_header_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    ":title"   = .el_optional_bind("title"),
    ":content" = .el_optional_bind("content")
  )
  events <- .el_event_bindings(ns_id, "back")
  attrs <- c(attrs, events$attrs)

  el_widget(
    props = .el_props(list(
      icon = .el_icon_name(icon))),
    id     = ns_id,
    markup = htmltools::tag("el-page-header", attrs),
    data   = list(title = .el_or_na(title), content = .el_or_na(content)),
    methods    = events$methods,
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Page Header
#'
#' Server-side update for [el_page_header()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Header ID (un-namespaced).
#' @param title,content New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$row_click, {
#'     update_el_page_header(session, "hdr", content = selected_name())
#'   })
#' }
#' @export
update_el_page_header <- function(session = shiny::getDefaultReactiveDomain(), id, title = NULL, content = NULL) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(title))   msg$title   <- title
  if (!is.null(content)) msg$content <- content
  .el_send_update(session, msg)
  invisible(NULL)
}


