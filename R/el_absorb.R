#' Take a component apart so it can be rendered inside another
#'
#' A component that wraps markup -- tooltip, popover, popconfirm -- compiles
#' that markup into its own Vue instance. Vue builds fresh DOM when it
#' compiles, and Element's tooltip keeps only the first node it is given, so a
#' component dropped in whole loses its mount point and its instance: the
#' inner component disappears, its inputs never report, and nothing is logged.
#'
#' Rather than refusing that, the inner component is taken apart and folded
#' into the outer one, so the two become a single Vue instance holding both
#' sets of markup, data and methods. Everything then works as it would
#' standalone -- including `Shiny.setInputValue()` calls, which name their ids
#' outright.
#'
#' The wrapper's own fields are prefixed, so nothing it declares can collide
#' with the absorbed component's.
#'
#' @param ui Output of [el_widget()], or plain markup.
#' @return A list with `markup`, the Vue options to merge (`data`, `methods`,
#'   `watch`, `mounted`, `computed`), and `dependencies`. Plain markup comes
#'   back as `markup` with everything else empty.
#' @keywords internal
.el_absorb <- function(ui) {
  empty <- list(markup = ui, data = list(), methods = list(), watch = list(),
                computed = list(), mounted = NULL, dependencies = list())
  if (is.null(ui)) return(empty)

  # Unwrap a one-element list of UI, as `...` collects
  if (is.list(ui) && !inherits(ui, c("shiny.tag", "shiny.tag.list", "htmlwidget")) &&
      length(ui) == 1L) {
    ui <- ui[[1]]
    empty$markup <- ui
  }
  # Several pieces -- text and components side by side, or two components --
  # are taken apart one by one and folded together, each keeping its place.
  # One component is itself a tag list, of its head and its host.
  is_component <- function(x) inherits(x, "shiny.tag.list") && any(vapply(x, function(p)
    inherits(p, "shiny.tag") && !is.null(attr(p, "el_spec")), logical(1)))
  if (is.list(ui) && !inherits(ui, "shiny.tag") && !is_component(ui)) {
    parts <- Filter(Negate(is.null), unclass(ui))
    if (!any(vapply(parts, function(p) is_component(p) ||
                      (is.list(p) && !inherits(p, "shiny.tag")), logical(1)))) return(empty)
    merged <- do.call(.el_absorb_merge, lapply(parts, .el_absorb))
    return(list(markup = htmltools::tagList(merged$markups), data = merged$data,
                methods = merged$methods %||% list(), watch = merged$watch %||% list(),
                computed = merged$computed %||% list(), mounted = merged$mounted,
                dependencies = merged$dependencies))
  }
  if (!inherits(ui, "shiny.tag.list")) return(empty)

  host <- NULL
  for (part in ui) {
    if (inherits(part, "shiny.tag") && !is.null(attr(part, "el_spec"))) host <- part
  }
  if (is.null(host)) return(empty)

  spec    <- attr(host, "el_spec")
  options <- spec$options
  list(
    markup       = spec$markup,
    data         = if (is.null(options$data)) list() else options$data,
    methods      = if (is.null(options$methods)) list() else options$methods,
    watch        = if (is.null(options$watch)) list() else options$watch,
    computed     = if (is.null(options$computed)) list() else options$computed,
    mounted      = options$mounted,
    dependencies = htmltools::findDependencies(ui)
  )
}


#' Merge what several absorbed components contribute
#'
#' @param ... Results of [.el_absorb()].
#' @return One set of Vue options, the dependencies to attach, and each
#'   part's markup as it now stands -- renaming rewrites it, so the caller
#'   must render `markups` rather than what it passed in.
#' @keywords internal
.el_absorb_merge <- function(...) {
  parts <- list(...)

  # Two components in one wrapper share a namespace, and most of them declare
  # a label, a type and a disabled. Rather than refuse the pair, rename the
  # later one's fields -- markup, methods and all -- so both can coexist.
  taken <- character(0)
  for (i in seq_along(parts)) {
    names_of <- function(p) unique(c(names(p$data), names(p$methods),
                                     names(p$computed)))
    fields <- names_of(parts[[i]])
    if (!length(fields)) next
    if (length(intersect(taken, fields))) {
      parts[[i]] <- .el_prefix_absorbed(parts[[i]], paste0("el", i))
      fields <- names_of(parts[[i]])
    }
    taken <- c(taken, fields)
  }
  pick <- function(field) {
    out <- list()
    for (p in parts) {
      value <- p[[field]]
      if (!length(value)) next
      clash <- intersect(names(out), names(value))
      if (length(clash)) {
        stop("Two components inside the same wrapper both declare ",
             paste(sQuote(clash), collapse = ", "), " in their Vue ", field,
             ", which renaming did not separate. Please report this.",
             call. = FALSE)
      }
      out <- c(out, value)
    }
    # An empty list serialises to [], and Vue rejects an array where it wants
    # an options object -- so hand back nothing at all instead.
    if (length(out)) out else NULL
  }

  mounts <- Filter(Negate(is.null), lapply(parts, `[[`, "mounted"))
  mounted <- if (!length(mounts)) NULL else JS(
    "function() { var self = this; [",
    paste(vapply(mounts, as.character, character(1)), collapse = ", "),
    "].forEach(function(f) { f.call(self); }); }"
  )
  # When every hook is only reporting -- what .el_mounted_init() writes --
  # say so, with every field each reports. el_widget() then binds the
  # wrapper's own value to Shiny, as it does for any other component, and
  # reports the absorbed components' under their ids as before.
  reports <- lapply(mounts, attr, "el_report")
  if (length(mounts) && !any(vapply(reports, is.null, logical(1)))) {
    attr(mounted, "el_report") <- do.call(c, unname(reports))
  }

  list(
    # Renaming rewrites the markup too, so the caller has to use what comes
    # back rather than what it passed in -- in the same order.
    markups  = lapply(parts, `[[`, "markup"),
    data     = pick("data"),
    methods  = pick("methods"),
    watch    = pick("watch"),
    computed = pick("computed"),
    # Each component's mounted hook runs in turn, on the shared instance
    mounted  = mounted,
    dependencies = unlist(lapply(parts, `[[`, "dependencies"), recursive = FALSE)
  )
}


#' Rename an absorbed component's Vue fields
#'
#' Two components folded into the same instance share one set of field names,
#' and most of them declare a `label`, a `type` or a `disabled`. Prefixing one
#' side's fields keeps them apart -- but the markup and the methods refer to
#' those fields by name, so they have to be rewritten to match.
#'
#' Only whole identifiers are renamed, and never inside a string literal:
#' `:class="data.isSelected ? 'is-selected' : ''"` names a CSS class, not a
#' field.
#'
#' @param absorbed Output of [.el_absorb()].
#' @param prefix Prefix to apply, already a valid JS identifier fragment.
#' @return The same list, with every field renamed.
#' @keywords internal
.el_prefix_absorbed <- function(absorbed, prefix) {
  # Methods collide as readily as data: most components call theirs
  # handleChange or handleClick. The markup names both, so both are renamed.
  fields <- unique(c(names(absorbed$data), names(absorbed$methods),
                     names(absorbed$computed)))
  if (!length(fields)) return(absorbed)

  rename <- stats::setNames(paste0(prefix, "_", fields), fields)

  rename_keys <- function(x) {
    if (!length(x)) return(x)
    stats::setNames(x, vapply(names(x),
      function(n) if (n %in% names(rename)) rename[[n]] else n, character(1)))
  }
  absorbed$data     <- rename_keys(absorbed$data)
  absorbed$methods  <- rename_keys(absorbed$methods)
  absorbed$computed <- rename_keys(absorbed$computed)
  if (length(absorbed$watch)) {
    absorbed$watch <- stats::setNames(
      absorbed$watch,
      vapply(names(absorbed$watch),
             function(n) if (!is.na(rename[n])) rename[[n]] else n, character(1))
    )
  }

  absorbed$markup  <- .el_rewrite_markup(absorbed$markup, rename)
  absorbed$methods <- lapply(absorbed$methods, .el_rewrite_js, rename = rename)
  absorbed$computed <- lapply(absorbed$computed, .el_rewrite_js, rename = rename)
  if (!is.null(absorbed$mounted)) {
    report <- attr(absorbed$mounted, "el_report")
    absorbed$mounted <- .el_rewrite_js(absorbed$mounted, rename)
    # The fields it reports are renamed with the rest
    if (!is.null(report)) {
      attr(absorbed$mounted, "el_report") <- vapply(
        report, .el_rewrite_expr, character(1), rename = rename)
    }
  }
  if (length(absorbed$watch)) {
    absorbed$watch <- lapply(absorbed$watch, .el_rewrite_js, rename = rename)
  }
  absorbed
}


#' Rewrite the field names a template expression refers to
#'
#' @param expr A Vue template expression.
#' @param rename Named character vector, old name to new.
#' @return The expression, rewritten.
#' @keywords internal
.el_rewrite_expr <- function(expr, rename) {
  if (!is.character(expr) || !length(expr)) return(expr)

  # Protect string literals, which may contain anything
  literals <- list()
  protect <- function(x) {
    repeat {
      m <- regexpr("'[^']*'|\"[^\"]*\"", x)
      if (m == -1) break
      lit <- regmatches(x, m)
      key <- sprintf("\u0001%d\u0001", length(literals) + 1L)
      literals[[length(literals) + 1L]] <<- lit
      regmatches(x, m) <- key
    }
    x
  }
  out <- vapply(expr, protect, character(1), USE.NAMES = FALSE)

  for (old in names(rename)) {
    # A whole identifier, not preceded by a dot (obj.value is a member)
    out <- gsub(paste0("(?<![A-Za-z0-9_$.])", old, "(?![A-Za-z0-9_$])"),
                rename[[old]], out, perl = TRUE)
  }

  for (i in rev(seq_along(literals))) {
    out <- gsub(sprintf("\u0001%d\u0001", i), literals[[i]], out, fixed = TRUE)
  }
  out
}


#' Rewrite field names throughout a tag tree
#'
#' @param ui Markup.
#' @param rename Named character vector, old name to new.
#' @return The markup, rewritten.
#' @keywords internal
.el_rewrite_markup <- function(ui, rename) {
  if (inherits(ui, "shiny.tag")) {
    bindings <- grepl("^[:@]|^v-(model|if|for|show|bind|on)", names(ui$attribs))
    ui$attribs[bindings] <- lapply(ui$attribs[bindings], .el_rewrite_expr,
                                   rename = rename)
    ui$children <- lapply(ui$children, .el_rewrite_markup, rename = rename)
    return(ui)
  }
  if (is.list(ui)) return(lapply(ui, .el_rewrite_markup, rename = rename))
  # Interpolation in a text node: {{label}}
  if (is.character(ui) && grepl("\\{\\{", ui)) {
    return(htmltools::HTML(.el_rewrite_expr(as.character(ui), rename)))
  }
  ui
}


#' Rewrite field names inside a JS function body
#'
#' @param js An `JS()` string.
#' @param rename Named character vector, old name to new.
#' @return The function, rewritten.
#' @keywords internal
.el_rewrite_js <- function(js, rename) {
  if (is.null(js)) return(NULL)
  body <- paste(as.character(js), collapse = "\n")
  for (old in names(rename)) {
    # Only fields reached off the instance: this.value, self.value
    body <- gsub(paste0("((?:this|self)\\.)", old, "(?![A-Za-z0-9_$])"),
                 paste0("\\1", rename[[old]]), body, perl = TRUE)
  }
  JS(body)
}


#' A component holding other UI, as one Vue instance
#'
#' For Element Plus's containers -- affix, space, scrollbar, watermark and the
#' like -- whose content is arbitrary UI: each child that is a component of
#' this package is folded into the container's instance ([.el_absorb()]),
#' the rest is markup inside its template. The container's own fields are
#' taken first, so a child's field of the same name is the one renamed.
#'
#' @param tag The Element Plus tag.
#' @param ns_id The namespaced id.
#' @param children A list of UI.
#' @param props Output of [.el_props()], or `NULL`.
#' @param events Output of [.el_event_bindings()], or `NULL`.
#' @param attrs Further attributes of the tag.
#' @param width,slots As for [el_widget()].
#' @param data Further fields of the container's own.
#' @return A Shiny UI element.
#' @keywords internal
.el_wrap_widget <- function(tag, ns_id, children, props = NULL, events = NULL,
                            attrs = list(), width = NULL, slots = NULL, data = list()) {
  own <- list(markup = NULL, data = c(data, props$data),
              methods = if (is.null(events)) list() else events$methods,
              watch = list(), computed = list(), mounted = NULL, dependencies = list())
  parts <- lapply(Filter(Negate(is.null), children), .el_absorb)
  merged <- do.call(.el_absorb_merge, c(list(own), parts))
  el_widget(
    id       = ns_id,
    markup   = htmltools::tag(tag, c(attrs, props$attrs, events$attrs,
                                     unname(merged$markups[-1]))),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    slots    = slots,
    dependency = merged$dependencies
  )
}
