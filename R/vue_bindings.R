# A component's arguments given v_bind() or v_model(): which may follow
# the page's state, how a bound field travels to the bridge (.vue_host())
# and to a component drawn as markup, and what is checked on the way.
# The bindings themselves are made in vue_directives.R.

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

# What travels to the browser for a binding: its code, whether it writes
# back, and its scope
.vue_binding_spec <- function(x) {
  Filter(
    Negate(is.null),
    list(
      expr = unclass(x)[1],
      model = if (inherits(x, "v_model")) TRUE,
      scope = attr(x, "scope"),
      shape = attr(x, "shape")
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

#' A component's arguments, by kind: which follow state and which do not
#'
#' A component library says what each argument of its components is where
#' it is not a prop -- a named character vector, `kinds`:
#'
#' * `"markup: <why>"`: R draws with it; a binding is refused, the why
#'   given;
#' * `"data"` or `"data:<shape>"`: R converts an R value; a binding is the
#'   library's own form (`shape` for the development build's check);
#' * `"stands:<field>,<field>"`: one argument for several fields;
#' * `"alias:<argument>"`: another name of an argument.
#'
#' An argument not named is a prop: it follows a binding. One unnamed
#' string is the kind of every argument. The library keeps the facts; this
#' is the mechanism, as `.vue_event_bindings()` is for events.
#'
#' @param kinds The kinds, as above.
#' @param arg An argument's name.
#' @return `list(kind, detail)`.
#' @keywords internal
.vue_arg_kind <- function(kinds, arg) {
  k <- if (length(kinds) == 1L && is.null(names(kinds))) {
    kinds
  } else if (arg %in% names(kinds)) {
    kinds[[arg]]
  } else {
    "prop"
  }
  list(
    kind = sub(":.*$", "", k),
    detail = trimws(
      if (grepl(":", k, fixed = TRUE)) sub("^[^:]*:", "", k) else ""
    )
  )
}

#' Refuse a binding of an argument R draws with
#'
#' Run first in a component, over its own environment: an argument whose
#' kind is `markup` and which was given [v_bind()] or [v_model()] is an
#' error naming the function, the argument and the reason.
#'
#' @param fn The component function's name, for the message.
#' @param env Its environment.
#' @param kinds Its arguments' kinds (`.vue_arg_kind()`).
#' @return `NULL`, invisibly.
#' @keywords internal
.vue_check_bindings <- function(fn, env, kinds) {
  # the arguments the kinds name -- or, for one kind of them all, every
  # argument given; one not given is not looked at
  names <- if (length(kinds) == 1L && is.null(names(kinds))) {
    setdiff(ls(env), "...")
  } else {
    names(kinds)
  }
  for (a in names) {
    v <- tryCatch(get(a, envir = env, inherits = FALSE), error = function(e) {
      NULL
    })
    if (!inherits(v, "vue_binding")) {
      next
    }
    k <- .vue_arg_kind(kinds, a)
    if (k$kind == "markup") {
      stop(
        sQuote(a, FALSE),
        " of ",
        fn,
        "() cannot follow v_bind() or v_model(): ",
        if (nzchar(k$detail)) k$detail else "R draws with it",
        ".",
        call. = FALSE
      )
    }
  }
  invisible(NULL)
}

#' The arguments a component drawn as markup binds
#'
#' Its arguments but its frame (`skip`) and those whose kind is not a
#' prop: the fields its binding follows, as its update sets them.
#'
#' @param args The function's arguments' names.
#' @param kinds Their kinds.
#' @param skip Arguments of the component's frame (id, session, ...).
#' @return The names.
#' @keywords internal
.vue_bindable <- function(args, kinds, skip) {
  args <- setdiff(args, skip)
  args[vapply(args, function(a) .vue_arg_kind(kinds, a)$kind == "prop", TRUE)]
}

#' A component's help-page sentence on bindings
#'
#' Every argument can follow [v_bind()] but those it names: R's markup,
#' with the why; data, with the form a binding gives. Written from the
#' kinds, so the page says what the component does.
#'
#' @param args The function's arguments' names.
#' @param kinds Their kinds.
#' @param skip Arguments of the component's frame.
#' @param library Whose form a binding gives, in words: `"the library's"`.
#' @return A markdown sentence.
#' @keywords internal
.vue_bindings_md <- function(args, kinds, skip, library = "the library's") {
  args <- setdiff(args, skip)
  ks <- lapply(stats::setNames(args, args), function(a) .vue_arg_kind(kinds, a))
  kind <- vapply(ks, `[[`, "", "kind")
  if (all(kind == "markup")) {
    return(paste0(
      "No argument follows [v_bind()]: ",
      ks[[1]]$detail %||% "R draws with them",
      "."
    ))
  }
  out <- "Every argument can follow [v_bind()] or [v_model()]"
  markup <- args[kind == "markup"]
  if (length(markup)) {
    why <- vapply(ks[markup], `[[`, "", "detail")
    why[!nzchar(why)] <- "R draws with it"
    # the arguments one reason covers, together
    groups <- vapply(
      unique(why),
      function(w) {
        paste0(
          paste0("`", markup[why == w], "`", collapse = ", "),
          " (",
          w,
          ")"
        )
      },
      ""
    )
    out <- paste0(out, " except ", paste(groups, collapse = "; "))
  }
  out <- paste0(out, ".")
  data <- args[kind == "data"]
  if (length(data)) {
    shape <- vapply(ks[data], `[[`, "", "detail")
    form <- ifelse(
      shape == "records",
      paste(library, "records, `[{ value, label }]`"),
      paste(library, "own form")
    )
    out <- paste0(
      out,
      " Given a binding, ",
      paste0("`", data, "` takes ", form, collapse = "; "),
      ", as it is; an R value is converted."
    )
  }
  out
}

#' Arguments of a component drawn as markup, given v_bind() or v_model()
#'
#' A component drawn as markup with a binding of its own (a dialog, tabs)
#' is no Vue app: the binding follows the expressions itself, from
#' `data-shiny-vue-bind`, `{"<field>": {expr, model, scope}}`, applying
#' each value as an update of that field would. Each bound argument is
#' drawn with its default meanwhile: the caller takes `values` back.
#'
#' @param values The arguments an update can set, by name: those that may
#'   be bound.
#' @param defaults The component function's formals, for the defaults.
#' @return A list: `values`, the bound ones replaced by their defaults, and
#'   `json`, the attribute's value, or `NULL` when none is bound.
#' @keywords internal
.vue_bound_markup <- function(values, defaults) {
  bound <- vapply(values, inherits, logical(1), c("v_bind", "v_model"))
  if (!any(bound)) {
    return(list(values = values, json = NULL))
  }
  lapply(values[bound], .vue_store_field)
  specs <- lapply(values[bound], .vue_binding_spec)
  names(specs) <- vapply(names(specs), .vue_camel, "")
  values[bound] <- lapply(names(values)[bound], function(a) {
    eval(defaults[[a]], baseenv())
  })
  list(
    values = values,
    json = as.character(jsonlite::toJSON(specs, auto_unbox = TRUE))
  )
}

# Whether a list holds a binding anywhere
.vue_has_binding <- function(x) {
  if (inherits(x, "vue_binding")) {
    return(TRUE)
  }
  is.list(x) && any(vapply(x, .vue_has_binding, logical(1)))
}

#' A data argument: an R value converted, a binding passed as it is
#'
#' Two rules, as DT's `JS()` and Shiny's `I()`: an R value is converted from
#' R's terms (a named vector, renamed fields) to the component's; a
#' [v_bind()] is the component's own form -- a library's `[{ value, label }]`
#' -- and goes to it as it is, followed in the browser, its content never
#' checked in R. A [v_model()] is refused: the component reads the
#' argument, it never sets it.
#'
#' @param x The argument.
#' @param convert The conversion of an R value.
#' @param name The argument's name, for the message.
#' @param shape What a binding gives, for the bridge's check in Vue's
#'   development build: `"records"`, a list of objects.
#' @return `convert(x)`, or the binding.
#' @keywords internal
.vue_data_arg <- function(x, convert = identity, name = "", shape = NULL) {
  if (inherits(x, "v_model")) {
    stop(
      sQuote(name, FALSE),
      " is read by the component, never set by it: give it v_bind().",
      call. = FALSE
    )
  }
  if (inherits(x, "vue_binding")) {
    attr(x, "shape") <- shape
    return(x)
  }
  convert(x)
}
