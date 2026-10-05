#' Element Plus Cascader Panel
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
#'   `disabled`, `leaf`. With `lazy = TRUE` and no `lazyLoad` of your own,
#'   the server loads each column.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. The default slot, scoped
#'   with `{node, data}`, renders one option; write it with [template()].
#' @param height Menu height for virtual scrolling (px). Element Plus's
#'   `height` (number).
#' @param item_size Node height for virtual scrolling (px). Element Plus's
#'   `item-size` (number).
#' @param virtual_scroll Whether to enable virtual scrolling for large data.
#'   Element Plus's `virtual-scroll` (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the selected path, on load and on change.
#' - `input$<id>_expand_change` -- the path of the column just opened.
#' - `input$<id>_lazy_load` -- with `props = list(lazy = TRUE)`, a column to
#'   load; answer with [el_load_children()]. See [el_cascader()].
#'
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `getCheckedNodes()` -- the selected options
#' - `clearCheckedNodes()` -- clear the selection
#'
#' @return A Shiny UI element.
#' @examples
#' regions <- list(
#'   list(
#'     value = "asia",
#'     label = "Asia",
#'     children = list(
#'       list(value = "cn", label = "China"),
#'       list(value = "jp", label = "Japan")
#'     )
#'   ),
#'   list(
#'     value = "europe",
#'     label = "Europe",
#'     children = list(
#'       list(value = "fr", label = "France")
#'     )
#'   )
#' )
#' el_cascader_panel("where", options = regions, value = c("asia", "jp"))
#'
#' # Several at once
#' el_cascader_panel("where", options = regions, props = list(multiple = TRUE))
#' @export
el_cascader_panel <- function(
  id = NULL,
  options = list(),
  value = NULL,
  props = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  height = NULL,
  item_size = NULL,
  virtual_scroll = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- .el_auto_id("el_cascader_panel")
  }
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    "v-model" = "value",
    ":options" = "options",
    ":props" = "elProps",
    "@change" = "handleChange"
  )
  events <- .el_event_bindings(ns_id, c("expand-change", "close"))
  attrs <- c(attrs, events$attrs)

  el_widget(
    props = .el_props(list(
      height = height,
      item_size = item_size,
      virtual_scroll = virtual_scroll
    )),
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tag("el-cascader-panel", attrs),
    data = list(
      value = if (is.null(value)) list() else as.list(value),
      options = unname(options),
      props = .el_or_na(props)
    ),
    methods = c(
      events$methods,
      list(
        handleChange = JS(sprintf(
          "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }",
          ns_id
        ))
      )
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    computed = list(elProps = .el_lazy_props(ns_id)),
    width = width,
    slots = slots
  )
}


#' Update Element Plus Cascader Panel
#'
#' Server-side update for [el_cascader_panel()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Panel ID (un-namespaced).
#' @param value,options New values; `NULL` leaves one unchanged.
#'
#' @param label New label, as for [shiny::updateTextInput()]: text, or
#'   tags or `HTML()` drawn as markup. Only a component built with a `label`
#'   has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$reset,
#'     update_el_cascader_panel(session, "where", value = list())
#'   )
#' }
#' @export
update_el_cascader_panel <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value)) {
    msg$value <- as.list(value)
  }
  if (!is.null(options)) {
    msg$options <- unname(options)
  }
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}
