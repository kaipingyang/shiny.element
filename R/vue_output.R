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
#'
#' @section render_vue(), render_vue_data(), update_vue():
#' Three ways the server shapes a component, by who owns it:
#'
#' - `render_vue()` -- the server writes the component: template, options,
#'   methods, data, dependencies. Rendered again, it keeps what the user did;
#'   a new template or new methods mount it afresh. As shiny.react's
#'   `renderReact()` is for React.
#' - [render_vue_data()] -- the component is written in the UI and one of
#'   its fields follows a value the server renders: a value, not markup, for
#'   components whose structure is fixed. One output can feed several
#'   components, or a [vue_store()] they share.
#' - [update_vue()] -- an observer sets fields when it decides to: an
#'   imperative change, sent whether or not the component is shown.
#'
#' `render_vue()` can be cached with [shiny::bindCache()], as `renderUI()`
#' can.
#' @seealso [vue_app()], [update_vue()], [render_vue_data()].
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
    function(shinysession, name, ...) inner(shinysession, name, ...),
    # what it sends depends on the expression alone, as renderUI()'s does
    cacheHint = list(label = "render_vue", userExpr = expr)
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
#' A render is made in two steps. `.vue_output_whole()` is the output as
#' it stands, the same for every session -- what `bindCache()` keeps;
#' `.vue_output_send()` compares it with what this session's page last got
#' and sends the markup or the changed fields. A cached render runs only the
#' second step (`cacheReadHook`), so caching and sending only what changed
#' go together.
#'
#' @param session The session.
#' @param name The output's id.
#' @param tags The component's tags, its host carrying `vue_host`.
#' @return `list(html =, deps =)`, or `list(patch = list(host =, fields =))`
#'   with each changed field as JSON text; carrying the whole as attribute
#'   `vue_whole`, for the cache.
#' @keywords internal
.vue_output_value <- function(session, name, tags) {
  whole <- .vue_output_whole(tags)
  value <- .vue_output_send(session, name, whole)
  attr(value, "vue_whole") <- whole
  value
}

#' The output as it stands: markup, dependencies, shape and fields
#' @noRd
.vue_output_whole <- function(tags) {
  host <- .vue_find_host(tags)
  rendered <- htmltools::renderTags(tags)
  list(
    html = rendered$html,
    deps = lapply(
      htmltools::resolveDependencies(rendered$dependencies),
      shiny::createWebDependency
    ),
    host = if (!is.null(host)) host$attribs$id,
    parts = if (!is.null(host)) .vue_output_parts(host)
  )
}

#' What this session's page needs of the output: the markup, or the fields
#' that changed since it last got it
#' @noRd
.vue_output_send <- function(session, name, whole) {
  sent <- whole$parts
  outputs <- .vue_outputs(session)
  last <- outputs[[name]]
  outputs[[name]] <- sent
  if (!is.null(sent) && !is.null(last) && identical(last$shape, sent$shape)) {
    changed <- names(sent$fields)[
      !vapply(
        names(sent$fields),
        function(k) identical(sent$fields[[k]], last$fields[[k]]),
        logical(1)
      )
    ]
    return(list(
      patch = list(host = whole$host, fields = as.list(sent$fields[changed]))
    ))
  }
  list(html = whole$html, deps = whole$deps)
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

# ── data outputs ──────────────────────────────────────────────────────────────

#' Data for a component, from the server
#'
#' An output that sends a component's `data` -- some of its fields, by name
#' -- rather than markup: the server renders `list(mean = 1, sd = 2)` and the
#' fields `mean` and `sd` of every component following the output take those
#' values; the template redraws what depends on them, and nothing else is
#' touched. It is the declarative twin of [update_vue()], with the same
#' rule: a field must be declared in the component's `data` (or returned by
#' `setup()`), as Vue tracks only the fields a component starts with; one it
#' does not have is left alone, with a warning in the browser's console.
#' Fields not in a render keep their values.
#'
#' The component names the output in its `outputs` (`vue_app(outputs =
#' "stats")`, inside a module `ns("stats")`). It is an output like any
#' other: rendered again when what it reads changes, held back while its
#' component is hidden, an error shown as Shiny shows one, a promise -- an
#' `ExtendedTask`'s result -- waited for. While it recalculates,
#' `$recalculating.<id>` is `true` in the component's templates. It can be
#' cached with [shiny::bindCache()].
#'
#' Values travel as [vue_app()]'s `data` does: a list an object, a
#' data.frame its rows, [JS()] a function; `I()` keeps a vector of one an
#' array.
#'
#' Where [render_vue()] draws a component the server writes, this fills one
#' the UI writes: the template stays where it is, the data comes from the
#' server. One output can feed several components, or a [vue_store()] they
#' all read -- shared state, as Vue's guide recommends, with the server as
#' its source. As shinyreact's `reactive_output()` does for React.
#'
#' @param expr An expression returning the fields: a named list.
#' @param env,quoted As for [shiny::renderText()].
#' @param outputId The output's id. Only needed to place the output by
#'   hand: a component listing it in `outputs` places it itself.
#' @return `render_vue_data()`, a render function; `vue_data_output()`, a
#'   tag.
#' @seealso [vue_app()], [vue_store()], [update_vue()].
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   ui <- fluidPage(
#'     sliderInput("n", "Draws", 10, 1000, 100),
#'     vue_app(
#'       "summary",
#'       template = htmltools::tags$p(
#'         `:style` = "{opacity: $recalculating.stats ? 0.5 : 1}",
#'         "Mean {{ mean }}, sd {{ sd }}"
#'       ),
#'       data = list(mean = NA, sd = NA),
#'       outputs = "stats"
#'     )
#'   )
#'   server <- function(input, output, session) {
#'     output$stats <- render_vue_data({
#'       x <- rnorm(input$n)
#'       list(mean = round(mean(x), 3), sd = round(sd(x), 3))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
render_vue_data <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  func <- shiny::exprToFunction(expr, env, quoted = TRUE)
  # createRenderFunction(): a promise is waited for before it is sent
  shiny::createRenderFunction(
    func,
    function(fields, shinysession, name, ...) {
      if (is.null(fields)) {
        fields <- list()
      }
      if (
        !is.list(fields) ||
          is.data.frame(fields) ||
          (length(fields) && !.vue_all_named(fields))
      ) {
        stop(
          "render_vue_data() renders fields of a component's data, by ",
          "name: list(mean = 1, sd = 2). For one value, name its field: ",
          "list(rows = df).",
          call. = FALSE
        )
      }
      # as `data` travels: rows for a data.frame, functions revived
      .vue_json(list(fields = lapply(fields, .vue_rows)))
    },
    vue_data_output,
    NULL,
    cacheHint = list(label = "render_vue_data", userExpr = expr)
  )
}

#' @rdname render_vue_data
#' @export
vue_data_output <- function(outputId) {
  htmltools::attachDependencies(
    htmltools::tags$span(id = outputId, class = "shiny-vue-data-output"),
    .vue_dependencies()
  )
}

#' Every element named
#' @noRd
.vue_all_named <- function(x) {
  nms <- names(x)
  !is.null(nms) && all(nzchar(nms))
}

#' `outputs`: the ids of the outputs a component's data follows
#' @noRd
.vue_outputs_arg <- function(outputs) {
  if (!length(outputs)) {
    return(NULL)
  }
  if (!is.character(outputs) || !is.null(names(outputs))) {
    stop(
      "`outputs` names the outputs a component's data follows: ",
      "\"stats\", or c(\"stats\", \"trend\").",
      call. = FALSE
    )
  }
  unique(outputs)
}
