#' An output that keeps its Vue component across renders (prototype)
#'
#' `vue_output()` and `render_vue()` are the Vue layer's pair, as
#' [shiny::uiOutput()] and [shiny::renderUI()] are Shiny's -- with one
#' difference. `renderUI()` replaces what it drew on every render, and with
#' it whatever the user had done: a table's sort, a tree's open nodes, a
#' scroll position. `render_vue()` keeps the component when a new render has
#' the same shape -- the same template and options, only its `data` changed
#' -- and sends the fields of `data` that changed since the last render. A
#' field the server did not change keeps what the user made of it. A render
#' of another shape replaces the component.
#'
#' Prototype: not exported yet (see `.claude/plans/vue-layer-2026-10-04.md`).
#'
#' @param id Output id.
#' @param expr An expression returning one component.
#' @param env,quoted As for [shiny::renderUI()].
#' @return `vue_output()`, a tag; `render_vue()`, a render function.
#' @keywords internal
#' @noRd
vue_output <- function(id) {
  htmltools::attachDependencies(
    htmltools::tags$div(id = id, class = "shiny-vue-output"),
    .vue_dependencies()
  )
}

#' @noRd
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
