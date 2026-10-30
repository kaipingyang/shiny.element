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
  # an R value, not an expression: its JSON is the expression
  if (!is.character(expr) || inherits(expr, "json")) {
    expr <- .vue_literal(expr)
  }
  if (length(expr) != 1L || is.na(expr) || !nzchar(expr)) {
    stop("`expr` must be one JavaScript expression, a string.", call. = FALSE)
  }
  .vue_binding(expr, "v_bind", ns)
}

# An R value written as a JavaScript literal: a data.frame as rows
.vue_literal <- function(x) {
  json <- .vue_rows(x)
  if (!inherits(json, "json")) {
    json <- jsonlite::toJSON(
      json,
      auto_unbox = TRUE,
      null = "null",
      na = "null",
      digits = NA
    )
  }
  as.character(json)
}


#' @rdname v_bind
#' @export
v_model <- function(path, arg = NULL, modifiers = NULL, ns = NULL) {
  if (
    !is.character(path) ||
      length(path) != 1L ||
      is.na(path) ||
      !grepl(.vue_path_pattern, path, perl = TRUE)
  ) {
    stop(
      "`path` must be something a value can be assigned to: a name going ",
      "on with .<name>, ['<name>'] or [<index>] -- \"$vueStore.ui.open\" ",
      "on a component's argument, \"text\" in a template.",
      call. = FALSE
    )
  }
  for (x in list(arg, modifiers)) {
    if (
      !is.null(x) &&
        (!is.character(x) ||
          anyNA(x) ||
          !all(grepl("^[A-Za-z][A-Za-z0-9_-]*$", x)))
    ) {
      stop(
        "`arg` and `modifiers` are names, as Vue writes them.",
        call. = FALSE
      )
    }
  }
  structure(
    .vue_binding(path, "v_model", ns),
    arg = arg,
    modifiers = modifiers
  )
}

#' Vue's `v-on`: handlers in a template, or in a module
#'
#' In a template -- a `vue_app()`'s, `el$` tags, a slot, a cell --
#' `v_on(click = "n++", "keyup.enter" = "send()")` gives the tag its
#' handlers, as `@click="n++"` does: Vue's inline statements, `$event` the
#' event's first argument, modifiers in the name as Vue writes them.
#'
#' As a value of a component's `on`, `v_on("statement", ns = ns)` is a
#' statement run with a module's names, as [v_bind()] evaluates an
#' expression: `$vueStore.ui` is `vue_store(ns("ui"))`, `$inputs.size` the
#' module's input. Outside a module a plain string does the same:
#' `on = list(click = "$vueStore.ui.open = true")`.
#'
#' @param ... In a template, handlers by event: `click = "n++"`. As a value
#'   of `on`, one statement, unnamed.
#' @inheritParams v_bind
#' @return Attributes for a tag, or a handler for `on`.
#' @family directives
#' @examples
#' vue_app(
#'   "counter",
#'   htmltools::tags$button(v_on(click = "n++"), "Clicked {{ n }} times"),
#'   data = list(n = 0)
#' )
#'
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
v_on <- function(..., ns = NULL) {
  args <- list(...)
  named <- !is.null(names(args)) && all(nzchar(names(args)))
  ok <- function(x) is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
  if (length(args) == 1L && !named && ok(args[[1]])) {
    return(.vue_binding(args[[1]], "v_on", ns))
  }
  if (!length(args) || !named || !all(vapply(args, ok, logical(1)))) {
    stop(
      "Give v_on() handlers by event, `v_on(click = \"n++\")`, or one ",
      "statement for a component's `on`.",
      call. = FALSE
    )
  }
  if (!is.null(ns)) {
    stop(
      "`ns` is for a statement in a component's `on`; in a template, write ",
      "the names out.",
      call. = FALSE
    )
  }
  .vue_directive(stats::setNames(args, paste0("@", names(args))))
}

#' Vue's other directives, for a template
#'
#' Attributes for a tag in a Vue template -- a [vue_app()]'s, `el$` and
#' [vtags] tags, a slot, a table cell -- given as an unnamed argument, as
#' Vue writes them: `tags$li(v_for("item in items", key = "item.id"),
#' "{{ item.name }}")` is `<li v-for="item in items" :key="item.id">`. The
#' expressions are Vue's, evaluated in the component's scope -- its data,
#' `setup()`, a slot's scope -- and the page's names (`$vueStore`,
#' `$inputs`, `$route`). Nothing else in the tag is touched; the backtick
#' attributes they stand for -- `` `v-if` = "ok" `` -- work as well.
#'
#' With them, [v_bind()], [v_model()] and [v_on()] work in a template too:
#' as a named argument's value, `el$space(size = v_bind("size"))` is
#' `:size="size"`, `el$input(value = v_model("text"))` is
#' `v-model:value="text"`; unnamed, `v_bind("attrs")` is `v-bind="attrs"`
#' and `v_model("text")` is `v-model="text"`. An R value given to
#' [v_bind()] is a literal: `el$select(options = v_bind(df))`.
#'
#' Outside a template a directive means nothing, and drawing one says so.
#'
#' @param expr A JavaScript expression, a string.
#' @param key For `v_for()`, the expression of each item's key: `:key`.
#' @param name For `v_slot()`, the slot's name; for `v_directive()`, the
#'   directive's, without `v-`.
#' @param scope For `v_slot()`, the slot's props as a destructuring
#'   pattern: `"{ row }"`.
#' @param deps For `v_memo()`, an array expression: `"[item.id]"`.
#' @param value,arg,modifiers For `v_directive()`, the parts of
#'   `v-name:arg.modifiers="value"`.
#' @return Attributes for a tag, as an unnamed argument.
#' @family directives
#' @examples
#' vue_app(
#'   "todo",
#'   htmltools::tags$div(
#'     htmltools::tags$input(v_model("draft"), v_on("keyup.enter" = "add()")),
#'     htmltools::tags$ul(
#'       htmltools::tags$li(v_for("t in todos", key = "t"), "{{ t }}")
#'     ),
#'     htmltools::tags$p(v_if("!todos.length"), "Nothing yet"),
#'     htmltools::tags$p(v_else(), "{{ todos.length }} to do")
#'   ),
#'   data = list(draft = "", todos = list()),
#'   methods = list(
#'     add = JS("function() { this.todos.push(this.draft); this.draft = ''; }")
#'   )
#' )
#' @name directives
NULL

#' @rdname directives
#' @export
v_if <- function(expr) .vue_directive(list(`v-if` = .vue_expr(expr)))

#' @rdname directives
#' @export
v_else_if <- function(expr) .vue_directive(list(`v-else-if` = .vue_expr(expr)))

#' @rdname directives
#' @export
v_else <- function() .vue_directive(list(`v-else` = NA))

#' @rdname directives
#' @export
v_show <- function(expr) .vue_directive(list(`v-show` = .vue_expr(expr)))

#' @rdname directives
#' @export
v_for <- function(expr, key = NULL) {
  .vue_directive(c(
    list(`v-for` = .vue_expr(expr)),
    if (!is.null(key)) list(`:key` = .vue_expr(key, "key"))
  ))
}

#' @rdname directives
#' @export
v_slot <- function(name = "default", scope = NULL) {
  if (!is.character(name) || length(name) != 1L || !nzchar(name)) {
    stop("`name` must be a slot's name.", call. = FALSE)
  }
  .vue_directive(stats::setNames(
    list(if (is.null(scope)) NA else .vue_expr(scope, "scope")),
    paste0("v-slot:", name)
  ))
}

#' @rdname directives
#' @export
v_html <- function(expr) .vue_directive(list(`v-html` = .vue_expr(expr)))

#' @rdname directives
#' @export
v_text <- function(expr) .vue_directive(list(`v-text` = .vue_expr(expr)))

#' @rdname directives
#' @export
v_once <- function() .vue_directive(list(`v-once` = NA))

#' @rdname directives
#' @export
v_pre <- function() .vue_directive(list(`v-pre` = NA))

#' @rdname directives
#' @export
v_memo <- function(deps) {
  .vue_directive(list(`v-memo` = .vue_expr(deps, "deps")))
}

#' @rdname directives
#' @export
v_directive <- function(name, value = NULL, arg = NULL, modifiers = NULL) {
  for (x in list(name, arg, modifiers)) {
    if (
      !is.null(x) &&
        (!is.character(x) ||
          anyNA(x) ||
          !all(grepl("^[A-Za-z][A-Za-z0-9_-]*$", x)))
    ) {
      stop(
        "`name`, `arg` and `modifiers` are names, as Vue writes them.",
        call. = FALSE
      )
    }
  }
  if (length(name) != 1L) {
    stop("`name` must be one directive's name.", call. = FALSE)
  }
  attr_name <- paste0(
    "v-",
    name,
    if (!is.null(arg)) paste0(":", arg),
    if (length(modifiers)) paste0(".", modifiers, collapse = "")
  )
  .vue_directive(stats::setNames(
    list(if (is.null(value)) NA else .vue_expr(value, "value")),
    attr_name
  ))
}

# A directive: the attributes it puts on its tag
.vue_directive <- function(attrs) {
  structure(list(attrs = attrs), class = "vue_directive")
}

.vue_expr <- function(x, arg = "expr") {
  if (!is.character(x) || length(x) != 1L || is.na(x) || !nzchar(x)) {
    stop(
      "`",
      arg,
      "` must be one JavaScript expression, a string.",
      call. = FALSE
    )
  }
  x
}

#' @export
as.tags.vue_directive <- function(x, ...) {
  stop(
    "A directive (",
    names(x$attrs)[1],
    ") belongs in a Vue template: a vue_app()'s, el$ tags, a slot, a cell.",
    call. = FALSE
  )
}

#' @export
print.vue_directive <- function(x, ...) {
  a <- x$attrs
  cat(
    "<vue_directive> ",
    paste0(
      names(a),
      ifelse(is.na(a), "", paste0('="', a, '"')),
      collapse = " "
    ),
    "\n",
    sep = ""
  )
  invisible(x)
}

#' Directives in a template, as the attributes they stand for
#'
#' Run on every template before it is drawn (`.vue_islands()`,
#' `.vue_template()`, `.vue_tags_as_html()`): a [v_bind()], [v_model()] or
#' [v_on()] as an attribute's value gives the attribute its prefix -- `:`,
#' `v-model:`, `@` -- and a directive given unnamed becomes its
#' attributes. Nothing else is touched.
#'
#' @param x A tag, a tag list, or anything else (returned as it is).
#' @return `x`, its directives as attributes.
#' @keywords internal
.vue_directives <- function(x) {
  if (inherits(x, "shiny.tag")) {
    a <- x$attribs
    nms <- names(a)
    if (length(a)) {
      for (i in seq_along(a)) {
        v <- a[[i]]
        if (!inherits(v, "vue_binding")) {
          next
        }
        .vue_in_template(v)
        nms[i] <- if (inherits(v, "v_model")) {
          .vue_model_name(v, nms[i])
        } else if (inherits(v, "v_on")) {
          paste0("@", nms[i])
        } else {
          paste0(":", nms[i])
        }
        a[i] <- list(unclass(v)[1])
      }
      names(a) <- nms
    }
    kids <- x$children
    extra <- list()
    keep <- rep(TRUE, length(kids))
    for (i in seq_along(kids)) {
      k <- kids[[i]]
      if (inherits(k, "vue_directive")) {
        extra <- c(extra, k$attrs)
        keep[i] <- FALSE
      } else if (inherits(k, "vue_binding")) {
        .vue_in_template(k)
        if (inherits(k, "v_on")) {
          stop(
            "In a template, give v_on() its event: `v_on(click = \"...\")`.",
            call. = FALSE
          )
        }
        extra[[if (inherits(k, "v_model")) .vue_model_name(k) else "v-bind"]] <-
          unclass(k)[1]
        keep[i] <- FALSE
      }
    }
    x$attribs <- c(a, extra)
    x$children <- lapply(kids[keep], .vue_directives)
    return(x)
  }
  if (
    is.list(x) &&
      !inherits(x, c("vue_directive", "html_dependency", "json")) &&
      !is.data.frame(x)
  ) {
    kept <- attributes(x)
    x <- lapply(x, .vue_directives)
    attributes(x) <- kept
  }
  x
}

# v-model, with its argument (a named attribute's name, or arg =) and its
# modifiers
.vue_model_name <- function(x, name = NULL) {
  arg <- attr(x, "arg") %||% name
  paste0(
    "v-model",
    if (!is.null(arg)) paste0(":", arg),
    if (length(attr(x, "modifiers"))) {
      paste0(".", attr(x, "modifiers"), collapse = "")
    }
  )
}

# A module's names belong to a component's argument, not to a template,
# whose expressions Vue compiles in the component's own scope
.vue_in_template <- function(x) {
  if (!is.null(attr(x, "scope")$store)) {
    stop(
      "`ns` is for a component's argument; in a template, write the ",
      "names out: `$vueStore['",
      sub("-$", "", attr(x, "scope")$store),
      "-ui']`.",
      call. = FALSE
    )
  }
  invisible(NULL)
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

# Something assigned to: a name, then .name, ['name'], ["name"] or [index]
.vue_path_pattern <- paste0(
  "^[A-Za-z_$][A-Za-z0-9_$]*",
  "(\\.[A-Za-z_$][A-Za-z0-9_$]*|\\['([^'\\\\]|\\\\.)*'\\]|",
  "\\[\"([^\"\\\\]|\\\\.)*\"\\]|\\[[0-9]+\\])*$"
)

# On a component's argument a v_model() writes back to the page's state,
# which only a store's field is: $vueStore, its store, a field
.vue_store_field <- function(x) {
  if (!inherits(x, "v_model")) {
    return(invisible(NULL))
  }
  ok <- grepl(
    "^\\$vueStore(\\.[A-Za-z_$][A-Za-z0-9_$]*|\\[[^]]+\\]){2,}",
    unclass(x)[1],
    perl = TRUE
  )
  if (!ok) {
    stop(
      "v_model(\"",
      unclass(x)[1],
      "\") on a component's argument writes ",
      "back to a store's field: \"$vueStore.<id>.<field>\".",
      call. = FALSE
    )
  }
  invisible(NULL)
}

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
  lapply(data[is_bound], .vue_store_field)
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
  lapply(values[bound], .vue_store_field)
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
