#' Bind an argument to state in the browser
#'
#' A component's argument given `vue_bind()` in place of a value follows
#' state on the page, with no round trip to the server: a store's field,
#' another component's value, the route. It is how a Vue application's
#' components share a `ref`, for components that are each an application
#' of their own -- the page's UI state stays in the browser, and the server
#' keeps the data and the decisions.
#'
#' Three kinds of state can be bound:
#'
#' * `$store.<id>.<field>`: a [vue_store()]'s state, both ways. The
#'   component follows the field, and when its user changes it -- a dialog
#'   closed, a value picked -- the field is set, so everything bound to it
#'   follows.
#' * `$inputs.<id>`: the value another component reports as `input$<id>`,
#'   one way. In a module, the id is the namespaced one, in brackets:
#'   `vue_bind(sprintf("$inputs['%s']", ns("size")))`.
#' * `$route.<...>`: the route of the page's [vue_router()], one way:
#'   `$route.path`, `$route.params.id`.
#'
#' A path goes on with `.<name>`, `['<name>']` or `[<index>]`. A component's
#' value -- what it reports as `input$<id>` -- can be bound to a store
#' alone: bound to something read-only, its user's change would be lost. A
#' component drawn as markup (a dialog, a drawer, tabs, a collapse) can
#' bind what its `update_*()` can set. An argument R reads to draw a
#' component -- a label, the choices -- is an error.
#'
#' The binding holds the argument from then on: `update_*()` of the field
#' sets it, and through it the store; bound to `$inputs` or `$route`, the
#' field keeps the update until what it follows changes again. With Shiny
#' on the page, the component reports `input$<id>` as ever, so the server
#' sees what the page did.
#'
#' Acting in the browser needs nothing more: an `on` handler may be Vue's
#' inline statement, as `@click="..."` in a template, which reaches the
#' stores and whatever the component library installs on every component,
#' as a message service -- `on = list(click = "$store.ui.open = true")`,
#' `"$message('Saved')"`. A [JS()] handler runs with the component as
#' `this`: `this.$store.ui.open = true`.
#'
#' @param path The state to follow: a string starting with `$store`,
#'   `$inputs` or `$route`.
#' @return The path, classed `"vue_bind"`, to give as an argument's value.
#' @seealso [vue_store()] for state shared by components.
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
#'     htmltools::tags$span("Size: {{ size }}"),
#'     data = list(size = vue_bind("$inputs.size"))
#'   )
#' )
#'
#' # A store both follow: the second sets it
#' htmltools::tagList(
#'   vue_store("ui", state = list(open = FALSE)),
#'   vue_app(
#'     "toggle",
#'     htmltools::tags$button(`@click` = "open = !open", "Toggle"),
#'     data = list(open = vue_bind("$store.ui.open"))
#'   ),
#'   vue_app("state", htmltools::tags$span("{{ $store.ui.open }}"))
#' )
#' @export
vue_bind <- function(path) {
  if (
    !is.character(path) ||
      length(path) != 1L ||
      is.na(path) ||
      !grepl(.vue_bind_pattern, path, perl = TRUE)
  ) {
    stop(
      "`path` must start with $store, $inputs or $route and go on with ",
      ".<name>, ['<name>'] or [<index>]: \"$store.ui.open\", ",
      "\"$inputs['mod-size']\", \"$route.params.id\".",
      call. = FALSE
    )
  }
  # The package's articles prefix components' ids, many examples sharing
  # one page (.vue_ui_id()): an input's id is the prefixed one
  prefix <- getOption(
    "shiny.vue.id_prefix",
    getOption("shiny.element.id_prefix")
  )
  if (!is.null(prefix) && startsWith(path, "$inputs")) {
    m <- regmatches(
      path,
      regexec(
        "^\\$inputs(?:\\.([A-Za-z_$][A-Za-z0-9_$]*)|\\['([^']*)'\\]|\\[\"([^\"]*)\"\\])(.*)$",
        path,
        perl = TRUE
      )
    )[[1]]
    id <- m[2:4][nzchar(m[2:4])][1]
    path <- sprintf("$inputs['%s%s']%s", prefix, id, m[5])
  }
  structure(path, class = "vue_bind")
}

#' @export
print.vue_bind <- function(x, ...) {
  cat("<vue_bind> ", unclass(x), "\n", sep = "")
  invisible(x)
}

# A root and at least one segment: .name, ['name'] or ["name"], [index]
.vue_bind_pattern <- paste0(
  "^\\$(store|inputs|route)",
  "(\\.[A-Za-z_$][A-Za-z0-9_$]*|\\['([^'\\\\]|\\\\.)*'\\]|",
  "\\[\"([^\"\\\\]|\\\\.)*\"\\]|\\[[0-9]+\\])+$"
)

#' The fields of a component's data bound with vue_bind()
#'
#' A bound field keeps a placeholder (`NA`) in the data and its path in the
#' spec's `bound`, which the bridge follows. Only whole fields are bound;
#' a component's value only to a store.
#'
#' @param spec A host's spec, as [.vue_host()] receives it.
#' @return The spec, with `bound` when a field is.
#' @keywords internal
.vue_bound <- function(spec) {
  data <- spec$options$data
  if (!length(data) || !is.list(data)) {
    return(spec)
  }
  is_bound <- vapply(data, inherits, logical(1), "vue_bind")
  inner <- vapply(
    data[!is_bound],
    function(v) is.list(v) && .vue_has_bind(v),
    logical(1)
  )
  if (any(inner)) {
    stop(
      "vue_bind() binds a whole field; ",
      paste(sQuote(names(data)[!is_bound][inner], FALSE), collapse = ", "),
      " holds one inside.",
      call. = FALSE
    )
  }
  if (!any(is_bound)) {
    return(spec)
  }
  paths <- lapply(data[is_bound], unclass)
  values <- .vue_input_fields(c(
    spec$input,
    unlist(lapply(spec$absorbed, `[[`, "input"), use.names = FALSE)
  ))
  readonly <- names(paths)[
    names(paths) %in% values & !startsWith(unlist(paths), "$store")
  ]
  if (length(readonly)) {
    stop(
      "A component's value can be bound to a store alone: ",
      paste(
        sprintf("%s to %s", sQuote(readonly, FALSE), unlist(paths[readonly])),
        collapse = ", "
      ),
      " is read-only, and its user's change would be lost.",
      call. = FALSE
    )
  }
  spec$options$data[is_bound] <- list(NA)
  spec$bound <- paths
  spec
}

#' Arguments R reads to draw a component, which cannot follow state
#'
#' Called with the arguments by name; an error names those given
#' [vue_bind()].
#'
#' @param ... The arguments, named.
#' @return `NULL`, invisibly.
#' @keywords internal
.vue_unbound <- function(...) {
  args <- list(...)
  hit <- names(args)[vapply(args, inherits, logical(1), "vue_bind")]
  if (length(hit)) {
    stop(
      paste(sQuote(hit, FALSE), collapse = ", "),
      " cannot follow vue_bind(): R reads ",
      if (length(hit) == 1L) "it" else "them",
      " to draw the component.",
      call. = FALSE
    )
  }
  invisible(NULL)
}

#' Arguments of a component drawn as markup, given vue_bind()
#'
#' A component drawn as markup with a binding of its own (a dialog, tabs)
#' is no Vue app: the binding follows the paths itself, from
#' `data-shiny-vue-bind`, `{"<field>": "<path>"}`, applying each value as
#' an update of that field would. Each bound argument is drawn with its
#' default meanwhile. Its state -- its value -- can be bound to a store
#' alone.
#'
#' @param env The component function's environment.
#' @param defaults The function's formals, for the defaults.
#' @param args The arguments an update can set: those that may be bound.
#' @param state The one that is the component's value.
#' @return The attribute's JSON, or `NULL` when none is bound.
#' @keywords internal
.vue_bound_markup <- function(env, defaults, args, state) {
  values <- mget(args, envir = env)
  bound <- vapply(values, inherits, logical(1), "vue_bind")
  if (!any(bound)) {
    return(NULL)
  }
  if (bound[[state]] && !startsWith(values[[state]], "$store")) {
    stop(
      "`",
      state,
      "` can be bound to a store alone: ",
      values[[state]],
      " is read-only, and its user's change would be lost.",
      call. = FALSE
    )
  }
  for (a in names(values)[bound]) {
    assign(a, eval(defaults[[a]], env), envir = env)
  }
  paths <- lapply(values[bound], unclass)
  names(paths) <- vapply(names(paths), .vue_camel, "")
  as.character(jsonlite::toJSON(paths, auto_unbox = TRUE))
}

# Whether a list holds a vue_bind() anywhere
.vue_has_bind <- function(x) {
  if (inherits(x, "vue_bind")) {
    return(TRUE)
  }
  is.list(x) && any(vapply(x, .vue_has_bind, logical(1)))
}

# The fields an input expression reads: "value", "active || null",
# "({from: from, to: to})" -- as the bridge's inputFields()
.vue_input_fields <- function(exprs) {
  unlist(lapply(exprs, function(e) {
    several <- regmatches(e, regexec("^\\(\\{(.*)\\}\\)$", e))[[1]]
    if (length(several)) {
      parts <- strsplit(several[2], ",", fixed = TRUE)[[1]]
      return(trimws(sub(":.*$", "", parts)))
    }
    regmatches(e, regexpr("^[A-Za-z_$][A-Za-z0-9_$]*", e))
  }))
}
