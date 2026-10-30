#' Vue's `v-bind` and `v-model` for a component's arguments
#'
#' A component's argument given `v_bind()` or `v_model()` in place of a
#' value follows state on the page, in the browser, with no round trip to
#' the server -- as `:size="size"` and `v-model="open"` do in a Vue
#' template. The page's UI state stays in the browser; the server keeps
#' the data and the decisions.
#'
#' * `v_bind(expr)` is one way, as `v-bind` (`:prop="expr"`): the argument
#'   follows the expression, any JavaScript expression --
#'   `v_bind("$inputs.fold === 'collapse'")`.
#' * `v_model(path)` is both ways, as `v-model`: the argument follows a
#'   store's field, and when the component's user changes it -- a dialog
#'   closed, a value picked -- the field is set, so everything bound to it
#'   follows. The path is one a value can be assigned to:
#'   `v_model("$vueStore.ui.open")`.
#'
#' Each component is a Vue application of its own, so an expression sees
#' the page, not another component's variables: the names it can use are
#'
#' * `$vueStore.<id>`: a [vue_store()], its state and getters;
#' * `$inputs.<id>`: the value a component reports as `input$<id>`, as its
#'   component reports it (before any debounce, before an input handler
#'   converts it);
#' * `$route`: the route of the page's [vue_router()] -- `$route.path`,
#'   `$route.params.id`.
#'
#' Given a bound argument, `update_*()` sets the field; with `v_model()`
#' that sets the store too, so everything bound to it follows; with
#' `v_bind()` the field keeps the update until the expression changes.
#' `v_bind()` on a component's value makes it controlled: it starts from
#' and follows the expression, and its user's change stays the
#' component's until the expression changes. With Shiny on the page the
#' component reports `input$<id>` as ever, so the server sees what the
#' page did.
#'
#' What can be bound: any of a component's props and its value, and what a
#' dialog's, drawer's, tabs' or collapse's `update_*()` can set. An
#' argument R reads to draw the component -- a label, the choices, a class
#' -- says it cannot be bound.
#'
#' @section Modules: Give `ns`, the module's [shiny::NS()] or its id, and
#'   the expression is left as written while its names are the module's:
#'   `$inputs.size` is `input$size` of the module, `$vueStore.ui` the store
#'   made with `vue_store(ns("ui"))` -- as `input$size` is inside
#'   [shiny::moduleServer()]. Without `ns`, the names are the page's, and a
#'   store named the same in two instances of a module is one store.
#'
#' @param expr A JavaScript expression over `$vueStore`, `$inputs` and
#'   `$route`, a string.
#' @param path A store's field, `$vueStore.<id>.<field>`, going on with
#'   `.<name>`, `['<name>']` or `[<index>]`.
#' @param ns In a module, its namespace: the function [shiny::NS()] gives,
#'   `session$ns`, or the module's id.
#' @return The binding, to give as an argument's value.
#' @seealso [v_on()] for acting in the browser; [vue_store()] for state
#'   shared by components.
#' @examples
#' # A size picked in one component, followed by another
#' htmltools::tagList(
#'   vue_app(
#'     "size",
#'     htmltools::tags$select(
#'       `v-model` = "size",
#'       htmltools::tags$option("small"),
#'       htmltools::tags$option("large")
#'     ),
#'     data = list(size = "small"),
#'     input = "size"
#'   ),
#'   vue_app(
#'     "shown",
#'     htmltools::tags$span("Large: {{ large }}"),
#'     data = list(large = v_bind("$inputs.size === 'large'"))
#'   )
#' )
#'
#' # A store, set by one and followed by another
#' htmltools::tagList(
#'   vue_store("ui", state = list(open = FALSE)),
#'   vue_app(
#'     "toggle",
#'     htmltools::tags$button(`@click` = "open = !open", "Toggle"),
#'     data = list(open = v_model("$vueStore.ui.open"))
#'   ),
#'   vue_app("state", htmltools::tags$span("{{ $vueStore.ui.open }}"))
#' )
#'
#' # In a module: the module's input and store
#' panel_ui <- function(id) {
#'   ns <- shiny::NS(id)
#'   htmltools::tagList(
#'     vue_store(ns("ui"), state = list(open = FALSE)),
#'     vue_app(
#'       ns("shown"),
#'       htmltools::tags$span("{{ open }}"),
#'       data = list(open = v_bind("$vueStore.ui.open", ns = ns))
#'     )
#'   )
#' }
#' @export
v_bind <- function(expr, ns = NULL) {
  if (
    !is.character(expr) || length(expr) != 1L || is.na(expr) || !nzchar(expr)
  ) {
    stop("`expr` must be one JavaScript expression, a string.", call. = FALSE)
  }
  .vue_binding(expr, "v_bind", ns)
}

#' @rdname v_bind
#' @export
v_model <- function(path, ns = NULL) {
  if (
    !is.character(path) ||
      length(path) != 1L ||
      is.na(path) ||
      !grepl(.vue_model_pattern, path, perl = TRUE)
  ) {
    stop(
      "`path` must be a store's field: \"$vueStore.<id>.<field>\", going ",
      "on with .<name>, ['<name>'] or [<index>].",
      call. = FALSE
    )
  }
  .vue_binding(path, "v_model", ns)
}

#' Vue's `v-on` for a component's event, in a module
#'
#' `on = list(click = "$vueStore.ui.open = true")` runs Vue's inline
#' statement when the event fires, as `@click="..."` in a template, with
#' `$event` the event's first argument. In a module, `v_on(statement, ns)`
#' runs it with the module's names, as [v_bind()] evaluates an expression:
#' `$vueStore.ui` is `vue_store(ns("ui"))`, `$inputs.size` the module's
#' input. Outside a module a plain string does the same.
#'
#' @param statement Vue's inline statement, a string.
#' @inheritParams v_bind
#' @return The handler, to give as a value of `on`.
#' @examples
#' panel_ui <- function(id) {
#'   ns <- shiny::NS(id)
#'   htmltools::tagList(
#'     vue_store(ns("ui"), state = list(n = 0)),
#'     vue_app(
#'       ns("add"),
#'       htmltools::tags$button("Add"),
#'       on = list(click = v_on("$vueStore.ui.n++", ns = ns))
#'     )
#'   )
#' }
#' @export
v_on <- function(statement, ns = NULL) {
  if (
    !is.character(statement) ||
      length(statement) != 1L ||
      is.na(statement) ||
      !nzchar(statement)
  ) {
    stop("`statement` must be one inline statement, a string.", call. = FALSE)
  }
  .vue_binding(statement, "v_on", ns)
}

#' @export
print.vue_binding <- function(x, ...) {
  cat("<", class(x)[1], "> ", unclass(x)[1], "\n", sep = "")
  scope <- attr(x, "scope")
  if (length(scope)) {
    cat(
      "  in ",
      paste(names(scope), unlist(scope), sep = ": ", collapse = ", "),
      "\n",
      sep = ""
    )
  }
  invisible(x)
}

# A store's field: $vueStore, then at least two segments (the store, a field)
.vue_model_pattern <- paste0(
  "^\\$vueStore",
  "(\\.[A-Za-z_$][A-Za-z0-9_$]*|\\['([^'\\\\]|\\\\.)*'\\]|",
  "\\[\"([^\"\\\\]|\\\\.)*\"\\]|\\[[0-9]+\\]){2,}$"
)

#' A binding: an expression, its kind and the names it is evaluated with
#'
#' `scope` holds the prefixes the bridge resolves `$inputs` and `$vueStore`
#' under: a module's namespace for both; the prefix the package's articles
#' give components' ids (`.vue_ui_id()`) for `$inputs` too.
#'
#' @param code The expression, path or statement.
#' @param kind `"v_bind"`, `"v_model"` or `"v_on"`.
#' @param ns `NULL`, a namespace function or a module's id.
#' @return The code, classed `c(kind, "vue_binding")`, with `scope`.
#' @keywords internal
.vue_binding <- function(code, kind, ns) {
  module <- if (is.null(ns)) {
    ""
  } else if (is.function(ns)) {
    ns("")
  } else if (is.character(ns) && length(ns) == 1L && !is.na(ns)) {
    paste0(ns, "-")
  } else {
    stop("`ns` must be a module's NS() function or its id.", call. = FALSE)
  }
  page <- getOption("shiny.vue.id_prefix", getOption("shiny.element.id_prefix"))
  scope <- Filter(nzchar, list(inputs = paste0(page, module), store = module))
  structure(
    code,
    scope = if (length(scope)) scope,
    class = c(kind, "vue_binding")
  )
}

# What travels to the browser for a binding: its code, whether it writes
# back, and its scope
.vue_binding_spec <- function(x) {
  Filter(
    Negate(is.null),
    list(
      expr = unclass(x)[1],
      model = if (inherits(x, "v_model")) TRUE,
      scope = attr(x, "scope")
    )
  )
}

#' The fields of a component's data given v_bind() or v_model()
#'
#' A bound field keeps a placeholder (`NA`) in the data and its binding in
#' the spec's `bound`, which the bridge follows. Only whole fields are
#' bound.
#'
#' @param spec A host's spec, as [.vue_host()] receives it.
#' @return The spec, with `bound` when a field is.
#' @keywords internal
.vue_bound <- function(spec) {
  data <- spec$options$data
  if (!length(data) || !is.list(data)) {
    return(spec)
  }
  is_bound <- vapply(data, inherits, logical(1), c("v_bind", "v_model"))
  inner <- vapply(
    data[!is_bound],
    function(v) is.list(v) && .vue_has_binding(v),
    logical(1)
  )
  if (any(inner)) {
    stop(
      "v_bind() and v_model() bind a whole field; ",
      paste(sQuote(names(data)[!is_bound][inner], FALSE), collapse = ", "),
      " holds one inside.",
      call. = FALSE
    )
  }
  if (!any(is_bound)) {
    return(spec)
  }
  spec$bound <- lapply(data[is_bound], .vue_binding_spec)
  spec$options$data[is_bound] <- list(NA)
  spec
}

#' Arguments R reads to draw a component, which cannot follow state
#'
#' Called with the arguments by name; an error names those given
#' [v_bind()] or [v_model()].
#'
#' @param ... The arguments, named.
#' @return `NULL`, invisibly.
#' @keywords internal
.vue_unbound <- function(...) {
  args <- list(...)
  hit <- names(args)[vapply(args, inherits, logical(1), "vue_binding")]
  if (length(hit)) {
    stop(
      paste(sQuote(hit, FALSE), collapse = ", "),
      " cannot follow v_bind() or v_model(): R reads ",
      if (length(hit) == 1L) "it" else "them",
      " to draw the component.",
      call. = FALSE
    )
  }
  invisible(NULL)
}

#' Arguments of a component drawn as markup, given v_bind() or v_model()
#'
#' A component drawn as markup with a binding of its own (a dialog, tabs)
#' is no Vue app: the binding follows the expressions itself, from
#' `data-shiny-vue-bind`, `{"<field>": {expr, model, scope}}`, applying
#' each value as an update of that field would. Each bound argument is
#' drawn with its default meanwhile.
#'
#' @param env The component function's environment.
#' @param defaults The function's formals, for the defaults.
#' @param args The arguments an update can set: those that may be bound.
#' @return The attribute's JSON, or `NULL` when none is bound.
#' @keywords internal
.vue_bound_markup <- function(env, defaults, args) {
  values <- mget(args, envir = env)
  bound <- vapply(values, inherits, logical(1), c("v_bind", "v_model"))
  if (!any(bound)) {
    return(NULL)
  }
  for (a in names(values)[bound]) {
    assign(a, eval(defaults[[a]], env), envir = env)
  }
  specs <- lapply(values[bound], .vue_binding_spec)
  names(specs) <- vapply(names(specs), .vue_camel, "")
  as.character(jsonlite::toJSON(specs, auto_unbox = TRUE))
}

# Whether a list holds a binding anywhere
.vue_has_binding <- function(x) {
  if (inherits(x, "vue_binding")) {
    return(TRUE)
  }
  is.list(x) && any(vapply(x, .vue_has_binding, logical(1)))
}
