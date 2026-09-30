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
  if (!inherits(ui, "shiny.tag.list")) return(empty)

  widget <- NULL
  host <- NULL
  for (part in ui) {
    if (inherits(part, "htmlwidget")) widget <- part
    else if (inherits(part, "shiny.tag") && identical(part$name, "div") &&
             identical(part$attribs$style, .el_host_style())) host <- part
  }
  if (is.null(widget) || is.null(host)) return(empty)

  options <- widget$x
  list(
    markup       = host$children,
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
#' @return One set of Vue options, plus the dependencies to attach.
#' @keywords internal
.el_absorb_merge <- function(...) {
  parts <- list(...)
  pick <- function(field) {
    out <- list()
    for (p in parts) {
      value <- p[[field]]
      if (!length(value)) next
      clash <- intersect(names(out), names(value))
      if (length(clash)) {
        stop("Two components inside the same wrapper both declare ",
             paste(sQuote(clash), collapse = ", "), " in their Vue ", field,
             ". Give one of them a different id, or place it outside.",
             call. = FALSE)
      }
      out <- c(out, value)
    }
    # An empty list serialises to [], and Vue rejects an array where it wants
    # an options object -- so hand back nothing at all instead.
    if (length(out)) out else NULL
  }

  mounts <- Filter(Negate(is.null), lapply(parts, `[[`, "mounted"))

  list(
    data     = pick("data"),
    methods  = pick("methods"),
    watch    = pick("watch"),
    computed = pick("computed"),
    # Each component's mounted hook runs in turn, on the shared instance
    mounted  = if (!length(mounts)) NULL else htmlwidgets::JS(
      "function() { var self = this; [",
      paste(vapply(mounts, as.character, character(1)), collapse = ", "),
      "].forEach(function(f) { f.call(self); }); }"
    ),
    dependencies = unlist(lapply(parts, `[[`, "dependencies"), recursive = FALSE)
  )
}
