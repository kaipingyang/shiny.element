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
#' @param routes `NULL`, or a named list of [vue_component()]s, by path --
#'   `list("/" = home, "/orders/:id" = order)` -- which a `<router-view>` in
#'   any [vue_app()] renders for the route, as vue-router's routes do;
#'   `$route.params.id` reaches the path's parts. Any other path is still a
#'   route, rendering nothing.
#' @param guard `NULL`; `"server"`, for every navigation to ask the server
#'   first (see "Shiny inputs"); or a [JS()] function of `(to, from)`, as
#'   vue-router's `beforeEach`: `true` lets it through, `false` stays, a
#'   path goes there instead.
#' @return A Shiny UI element: put it anywhere on the page, once.
#' @section Shiny inputs:
#' `input$<id>` is the route's full path -- `"/orders"`,
#' `"/orders?page=2"` -- on load and after every navigation that succeeds,
#' whether by a link, the browser's back and forward, a component or
#' [update_vue_router()]; `input$<id>_params` its params, `list(id = "42")`
#' for `/orders/:id` (`NULL` when it has none). A bookmark restores the
#' route.
#'
#' With `guard = "server"`, `input$<id>_guard` is each navigation's
#' question, `list(to =, from =, params =, request =)`, and it waits for the
#' answer, `vue_answer(session, "<id>", input$<id>_guard, value)`: `TRUE`
#' lets it through, `FALSE` stays where it is, a path goes there instead.
#' Unanswered within 30 seconds, it goes through. A guard in the browser is a
#' convenience, not security: the server checks what it serves for a route
#' as it would without one.
#' @seealso [update_vue_router()]
#' @examples
#' library(shiny)
#' home <- vue_component("<h3>Home</h3>")
#' order <- vue_component("<h3>Order {{ $route.params.id }}</h3>")
#' ui <- fluidPage(
#'   vue_router(
#'     "route",
#'     routes = list("/" = home, "/orders/:id" = order),
#'     guard = "server"
#'   ),
#'   vue_app(
#'     "nav",
#'     htmltools::tags$nav(
#'       htmltools::tag("router-link", list(to = "/", "Home")),
#'       " | ",
#'       htmltools::tag("router-link", list(to = "/orders/42", "Order 42"))
#'     )
#'   ),
#'   vue_app("view", htmltools::tag("router-view", list()))
#' )
#' server <- function(input, output, session) {
#'   # order 13 is not shown
#'   observeEvent(input$route_guard, {
#'     q <- input$route_guard
#'     vue_answer(session, "route", q, !identical(q$params$id, "13"))
#'   })
#' }
#' if (interactive()) {
#'   shinyApp(ui, server)
#' }
#' @export
vue_router <- function(
  id,
  history = c("hash", "memory"),
  routes = NULL,
  guard = NULL
) {
  history <- match.arg(history)
  id <- .vue_ui_id(id)
  if (length(routes)) {
    if (
      is.null(names(routes)) ||
        !all(startsWith(names(routes), "/")) ||
        !all(vapply(routes, inherits, logical(1), "vue_component"))
    ) {
      stop(
        "`routes` must be a list of vue_component()s named by their paths: ",
        "`list(\"/\" = home)`.",
        call. = FALSE
      )
    }
  }
  if (
    !is.null(guard) &&
      !identical(guard, "server") &&
      !inherits(guard, "JS_EVAL")
  ) {
    stop("`guard` must be \"server\" or a JS() function.", call. = FALSE)
  }
  config <- list(
    id = id,
    history = history,
    # the route a bookmark brings back, taken when the URL has none
    initial = shiny::restoreInput(id = id, default = NULL),
    routes = if (length(routes)) {
      I(unname(Map(
        function(path, comp) {
          list(path = path, component = unclass(comp))
        },
        names(routes),
        routes
      )))
    },
    guard = guard
  )
  deps <- unlist(
    lapply(routes, function(r) attr(r, "dependencies")),
    recursive = FALSE
  )
  htmltools::attachDependencies(
    htmltools::tags$script(htmltools::HTML(sprintf(
      "shinyVue.createRouter(%s);",
      gsub("</", "<\\/", .vue_json(config), fixed = TRUE)
    ))),
    c(.vue_host_dependencies(), list(.vue_router_dependency()), deps)
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
