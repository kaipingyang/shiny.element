#' Element UI Cascader Panel
#'
#' The panel of an [el_cascader()] on its own, always open: nested options in
#' side-by-side columns, for when there is room to show them rather than tuck
#' them into a dropdown.
#'
#' @param id Panel ID. Auto-generated if `NULL`.
#' @param options Nested options, each `list(value =, label =, children =)`,
#'   as for [el_cascader()]. [df_to_cascader_options()] builds them from a
#'   data.frame.
#' @param value Initially selected path, as a vector of values from the top
#'   level down -- or a list of paths with `props = list(multiple = TRUE)`.
#' @param props Element's `props`, as a named list: `multiple`,
#'   `checkStrictly`, `expandTrigger` (`"click"` or `"hover"`), `lazy`,
#'   `lazyLoad`, and the field names `value`, `label`, `children`,
#'   `disabled`, `leaf`.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. The default slot, scoped
#'   with `{node, data}`, renders one option; write it with [template()].
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the selected path, on load and on change.
#' - `input$<id>_expand_change` -- the path of the column just opened.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `getCheckedNodes()` -- the selected options
#' - `clearCheckedNodes()` -- clear the selection
#'
#' @return A Shiny UI element.
#' @examples
#' regions <- list(
#'   list(value = "asia", label = "Asia", children = list(
#'     list(value = "cn", label = "China"), list(value = "jp", label = "Japan"))),
#'   list(value = "europe", label = "Europe", children = list(
#'     list(value = "fr", label = "France")))
#' )
#' el_cascader_panel("where", options = regions, value = c("asia", "jp"))
#'
#' # Several at once
#' el_cascader_panel("where", options = regions, props = list(multiple = TRUE))
#' @export
el_cascader_panel <- function(id = NULL,
                              options = list(),
                              value = NULL,
                              props = NULL,
                              width = NULL,
                              slots = NULL,
                              session = NULL) {
  if (is.null(id)) id <- paste0("el_cascader_panel_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    "v-model"  = "value",
    ":options" = "options",
    ":props"   = .el_optional_bind("props"),
    "@change"  = "handleChange"
  )
  events <- .el_event_bindings(ns_id, "expand-change")
  attrs <- c(attrs, events$attrs)

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-cascader-panel", attrs),
    data   = list(
      value   = if (is.null(value)) list() else as.list(value),
      options = unname(options),
      props   = .el_or_na(props)
    ),
    methods = c(events$methods, list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }", ns_id
      ))
    )),
    mounted    = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots,
    dependency = el_cascader_panel_handler_dependency()
  )
}


#' Update Element UI Cascader Panel
#'
#' Server-side update for [el_cascader_panel()].
#'
#' @param session Shiny session object.
#' @param id Panel ID (un-namespaced).
#' @param value,options New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$reset, update_el_cascader_panel(session, "where", value = list()))
#' }
#' @export
update_el_cascader_panel <- function(session, id, value = NULL, options = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(value))   msg$value   <- as.list(value)
  if (!is.null(options)) msg$options <- unname(options)
  session$sendCustomMessage("updateElCascaderPanel", msg)
  invisible(NULL)
}


#' @keywords internal
el_cascader_panel_handler_dependency <- function() {
  .el_handler_dependency("cascader-panel")
}
