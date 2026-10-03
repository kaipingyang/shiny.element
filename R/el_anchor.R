#' Element Plus Anchor
#'
#' Links to sections of the page, the one in view marked as the page
#' scrolls.
#'
#' @param id Anchor ID. Auto-generated if `NULL`.
#' @param links The links: a list of `list(title =, href = "#section")`, each
#'   with optional `children`, a list of links one level down.
#' @param container A CSS selector for the element that scrolls, when it is
#'   not the page.
#' @param offset Offset of the scroll position, in pixels.
#' @param bound Distance from the top at which a section counts as reached,
#'   in pixels. Default `15`.
#' @param duration Duration of the scroll, in milliseconds. Default `300`.
#' @param marker Whether to show the marker beside the current link.
#' @param type `"default"` or `"underline"`.
#' @param direction `"vertical"` (the default) or `"horizontal"`.
#' @param select_scroll_top Whether a link counts as current once its
#'   section is scrolled to the top.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- the `href` of the current link, as the page scrolls.
#' - `input$<id>_click` -- the `href` of a link the user clicked.
#'
#' @section Element methods:
#' Callable with [el_call()]: `scrollTo(href)`.
#'
#' @return A Shiny UI element.
#' @examples
#' el_anchor(
#'   "toc",
#'   links = list(
#'     list(title = "Basic usage", href = "#basic"),
#'     list(
#'       title = "API",
#'       href = "#api",
#'       children = list(
#'         list(title = "Attributes", href = "#attributes")
#'       )
#'     )
#'   )
#' )
#' @export
el_anchor <- function(
  id = NULL,
  links = list(),
  container = NULL,
  offset = NULL,
  bound = NULL,
  duration = NULL,
  marker = NULL,
  type = NULL,
  direction = NULL,
  select_scroll_top = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_anchor", environment())
  .el_check_items(links, "links", c("title", "href"))
  if (is.null(id)) {
    id <- paste0("el_anchor_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, NULL)
  link_tags <- function(links) {
    lapply(links, function(l) {
      htmltools::tag(
        "el-anchor-link",
        c(
          list(title = l$title, href = l$href),
          if (length(l$children)) {
            list(.el_slot("sub-link", link_tags(l$children)))
          }
        )
      )
    })
  }
  events <- .el_event_bindings(
    ns_id,
    "click",
    shapes = list(
      click = "function(e, href) { return href; }"
    )
  )
  el_widget(
    id = ns_id,
    markup = htmltools::tag(
      "el-anchor",
      c(
        list("@change" = "handleChange"),
        events$attrs,
        link_tags(links)
      )
    ),
    props = .el_props(list(
      container = container,
      offset = offset,
      bound = bound,
      duration = duration,
      marker = marker,
      type = type,
      direction = direction,
      select_scroll_top = select_scroll_top
    )),
    data = list(),
    methods = c(
      events$methods,
      list(
        handleChange = JS(sprintf(
          "function(href) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', href); }",
          ns_id
        ))
      )
    ),
    width = width,
    slots = slots
  )
}
