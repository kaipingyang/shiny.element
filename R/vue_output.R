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

# ── outputs that send data, not markup ────────────────────────────────────────
#
# An output that draws one component sends its markup
# once. Rendered again with the same template and the same options but its
# data, it sends only the data fields that changed since its last render,
# as JSON -- Shiny's own outputs send values, not HTML, wherever they can.
# The browser assigns them, which is what it would do with the markup (see
# applyRender() in shiny-vue.js), without the markup crossing the wire.

#' What an output sends: its markup, or the data that changed
#'
#' @param session The session.
#' @param name The output's id.
#' @param tags The component's tags, its host carrying `vue_host`.
#' @return `list(html =, deps =)`, or `list(patch = list(host =, fields =))`
#'   with each changed field as JSON text.
#' @keywords internal
.vue_output_value <- function(session, name, tags) {
  host <- .vue_find_host(tags)
  sent <- if (!is.null(host)) .vue_output_parts(host)
  outputs <- .vue_outputs(session)
  last <- outputs[[name]]
  if (!is.null(sent) && !is.null(last) && identical(last$shape, sent$shape)) {
    changed <- names(sent$fields)[
      !vapply(
        names(sent$fields),
        function(k) identical(sent$fields[[k]], last$fields[[k]]),
        logical(1)
      )
    ]
    outputs[[name]] <- sent
    return(list(
      patch = list(
        host = host$attribs$id,
        fields = as.list(sent$fields[changed])
      )
    ))
  }
  outputs[[name]] <- sent
  rendered <- htmltools::renderTags(tags)
  list(
    html = rendered$html,
    deps = lapply(
      htmltools::resolveDependencies(rendered$dependencies),
      shiny::createWebDependency
    )
  )
}

#' A host's shape -- template and options but data -- and its data fields,
#' each as the JSON the page would read
#' @noRd
.vue_output_parts <- function(host) {
  parts <- attr(host, "vue_host")
  spec <- parts$spec
  data <- spec$options$data
  spec$options$data <- NULL
  fields <- vapply(
    names(data),
    function(k) .vue_json(list(value = data[[k]])),
    character(1)
  )
  list(
    shape = paste(parts$template, .vue_json(spec), sep = "\u0001"),
    fields = fields
  )
}

#' The first host in some tags
#' @noRd
.vue_find_host <- function(x) {
  if (inherits(x, "shiny.tag")) {
    if (!is.null(attr(x, "vue_host"))) {
      return(x)
    }
    x <- x$children
  }
  if (is.list(x)) {
    for (child in x) {
      found <- .vue_find_host(child)
      if (!is.null(found)) {
        return(found)
      }
    }
  }
  NULL
}

#' The outputs' last renders, per session
#' @noRd
.vue_outputs <- function(session) {
  outputs <- session$userData$.vue_outputs
  if (is.null(outputs)) {
    outputs <- new.env(parent = emptyenv())
    session$userData$.vue_outputs <- outputs
  }
  outputs
}

#' Draw an output whole next time
#' @noRd
.vue_output_forget <- function(session, name) {
  outputs <- .vue_outputs(session)
  if (exists(name, envir = outputs, inherits = FALSE)) {
    rm(list = name, envir = outputs)
  }
  invisible(NULL)
}

#' The browser's request for an output's markup: input$<name>__vue_redraw,
#' read so that a request renders the output again, whole
#' @noRd
.vue_output_redraw <- function(session, name) {
  asked <- session$input[[paste0(name, "__vue_redraw")]]
  outputs <- .vue_outputs(session)
  seen <- paste0(name, "\u0001redraw")
  if (!is.null(asked) && !identical(asked, outputs[[seen]])) {
    outputs[[seen]] <- asked
    .vue_output_forget(session, name)
  }
  invisible(NULL)
}
