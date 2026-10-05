#' Element Plus Breadcrumb
#'
#' A trail of links showing where a page sits.
#'
#' @param id Breadcrumb ID. Auto-generated if `NULL`.
#' @param items The trail, a list of [el_breadcrumb_item()]s -- or of
#'   `list(label =, to =)`. `to` is
#'   optional and makes that step a link; the last step is usually plain text.
#' @param separator Separator character. Default `"/"`.
#' @param width Component width, as a CSS unit.
#' @param separator_icon Icon component of icon separator. Element Plus's
#'   `separator-icon` (string / Component). An icon's name, such as
#'   `"Search"`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the `label` of the step last clicked. Steps without a
#'   `to` are still reported, so a breadcrumb can drive navigation inside a
#'   Shiny app without any routing.
#'
#' @return A Shiny UI element.
#' @examples
#' el_breadcrumb(
#'   "trail",
#'   items = list(
#'     list(label = "Home"),
#'     list(label = "Reports"),
#'     list(label = "March")
#'   )
#' )
#'
#' # An arrow instead of a slash
#' el_breadcrumb(
#'   "trail",
#'   items = list(list(label = "Home"), list(label = "Detail")),
#'   separator_icon = "ArrowRight"
#' )
#' @export
el_breadcrumb <- function(
  id = NULL,
  items = list(),
  separator = NULL,
  separator_icon = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- .el_auto_id("el_breadcrumb")
  }
  ns_id <- .el_ui_id(id, session)

  item_tag <- htmltools::tag(
    "el-breadcrumb-item",
    list(
      "v-for" = "(item, index) in items",
      ":key" = "index",
      ":to" = "item.to",
      ":replace" = "item.replace",
      "@click" = "handleClick(item)",
      htmltools::HTML("{{item.label}}")
    )
  )

  attrs <- list(
    ":separator" = .el_optional_bind("separator")
  )

  el_widget(
    props = .el_props(list(
      separator_icon = .el_icon_name(separator_icon)
    )),
    id = ns_id,
    markup = htmltools::tag("el-breadcrumb", c(attrs, list(item_tag))),
    data = list(
      items = unname(items),
      separator = .el_or_na(separator)
    ),
    methods = list(
      handleClick = JS(sprintf(
        "function(item) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', item.label, {priority: 'event'}); }",
        ns_id
      ))
    ),
    width = width,
    slots = slots
  )
}


#' Update Element Plus Breadcrumb
#'
#' Server-side update for [el_breadcrumb()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Breadcrumb ID (un-namespaced).
#' @param items,separator New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$open_detail, {
#'     update_el_breadcrumb(
#'       session,
#'       "trail",
#'       items = list(
#'         list(label = "Home"),
#'         list(label = "Detail")
#'       )
#'     )
#'   })
#' }
#' @export
update_el_breadcrumb <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  items = NULL,
  separator = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(items)) {
    msg$items <- unname(items)
  }
  if (!is.null(separator)) {
    msg$separator <- separator
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
