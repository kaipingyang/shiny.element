#' The page's router: vue-router, with the route as a Shiny input
#'
#' One router for the page, installed in every Vue app on it -- each
#' component's own -- as vue-router allows: `$router` and `$route` in their
#' templates, `<router-link>`, and what component libraries do with them (a
#' menu or a breadcrumb that navigates).
#'
#' The route lives in the URL's hash (`#/orders`), which leaves the query
#' string to Shiny's bookmarks; `history = "memory"` keeps the URL as it is.
#' Any path is a route: what the page shows for it is the server's choice,
#' with `input$<id>` -- [shiny::conditionalPanel()], [shiny::renderUI()], a
#' navset driven by it.
#'
#' @param id The router's id: the route arrives as `input$<id>`.
#' @param history `"hash"` (the default) or `"memory"`.
#' @return A Shiny UI element: put it anywhere on the page, once.
#' @section Shiny inputs:
#' `input$<id>` is the route's full path -- `"/orders"`,
#' `"/orders?page=2"` -- on load and after every navigation that succeeds,
#' whether by a link, the browser's back and forward, a component or
#' [update_vue_router()]. A bookmark restores it.
#' @seealso [update_vue_router()]
#' @examples
#' library(shiny)
#' ui <- fluidPage(
#'   vue_router("route"),
#'   vue_app(
#'     "nav",
#'     htmltools::tags$nav(
#'       htmltools::tag("router-link", list(to = "/", "Home")),
#'       " | ",
#'       htmltools::tag("router-link", list(to = "/about", "About"))
#'     )
#'   ),
#'   conditionalPanel("input.route == '/about'", "About this app")
#' )
#' server <- function(input, output, session) {}
#' if (interactive()) {
#'   shinyApp(ui, server)
#' }
#' @export
vue_router <- function(id, history = c("hash", "memory")) {
  history <- match.arg(history)
  id <- .vue_ui_id(id)
  config <- list(
    id = id,
    history = history,
    # the route a bookmark brings back, taken when the URL has none
    initial = shiny::restoreInput(id = id, default = NULL)
  )
  htmltools::attachDependencies(
    htmltools::tags$script(htmltools::HTML(sprintf(
      "shinyVue.createRouter(%s);",
      gsub("</", "<\\/", .vue_json(config), fixed = TRUE)
    ))),
    c(.vue_host_dependencies(), list(.vue_router_dependency()))
  )
}

#' Navigate the page's router from the server
#'
#' @param session The Shiny session, the current one by default.
#' @param id The router's id, as given to [vue_router()].
#' @param path The route to go to: `"/orders"`, `"/orders?page=2"`.
#' @param replace Replace the current entry of the browser's history
#'   rather than adding one, so that "back" skips it.
#' @return `NULL`, invisibly.
#' @seealso [vue_router()]
#' @export
update_vue_router <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  path,
  replace = FALSE
) {
  .vue_check_session(session)
  if (!is.character(path) || length(path) != 1L || is.na(path)) {
    stop("`path` must be a single string, such as \"/orders\".", call. = FALSE)
  }
  .vue_send(
    session,
    "shinyVueRouter",
    list(id = session$ns(id), path = path, replace = isTRUE(replace))
  )
  invisible(NULL)
}
