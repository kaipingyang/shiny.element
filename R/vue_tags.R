#' Vue's built-in components, as tags
#'
#' A tag generator for each component Vue -- and the page's [vue_router()]
#' -- registers in every app, as `tags$p` is for HTML and a component
#' library's tag set for its components: `vtags$transition(name = "fade",
#' ...)` writes `<transition name="fade">`. They belong in a Vue template --
#' a [vue_app()]'s, a component's markup, a slot -- where a Vue app
#' compiles them;
#' Vue's own names, snake_case for kebab-case (`keep_alive` is
#' `<keep-alive>`). Directives go on them as on any tag:
#' `vtags$component(is = v_bind("view"))`.
#'
#' * `transition`, `transition_group`: Vue's enter and leave animations;
#' * `keep_alive`: keeps the components it switches between alive;
#' * `teleport`: draws its content elsewhere, `to = "body"`;
#' * `suspense`: waits for async components;
#' * `component`: a component chosen by `is`;
#' * `slot`: a slot of a [vue_component()]'s own template;
#' * `router_view`, `router_link`: the route's component, a link to a route
#'   ([vue_router()]).
#'
#' @examples
#' names(vtags)
#'
#' vue_app(
#'   "fade",
#'   htmltools::tags$div(
#'     htmltools::tags$button(v_on(click = "show = !show"), "Toggle"),
#'     vtags$transition(
#'       name = "fade",
#'       htmltools::tags$p(v_if("show"), "Hello")
#'     )
#'   ),
#'   data = list(show = TRUE)
#' )
#' @return A named list of tag-generating functions.
#' @seealso [directives] for `v_if()` and the rest.
#' @export
vtags <- local({
  names <- c(
    "transition",
    "transition-group",
    "keep-alive",
    "teleport",
    "suspense",
    "component",
    "slot",
    "router-view",
    "router-link"
  )
  out <- list()
  for (n in names) {
    out[[gsub("-", "_", n)]] <- eval(bquote(
      function(...) htmltools::tag(.(n), list(...))
    ))
  }
  out
})
