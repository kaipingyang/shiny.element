#' Element UI Timeline
#'
#' A vertical sequence of events.
#'
#' Entries are rendered with `v-for` from a data field, so
#' [update_el_timeline()] can replace them -- useful for a log that grows.
#' Their content is therefore a string rather than markup; pass `html = TRUE`
#' to render it as HTML.
#'
#' @param id Timeline ID (auto-generated if NULL).
#' @param items A list of entries. Each is a list with `content` and
#'   optionally `timestamp`, `type` (`"primary"`, `"success"`, `"warning"`,
#'   `"danger"` or `"info"`), `color`, `size` (`"normal"` or `"large"`),
#'   `icon` (an Element icon class) and `placement` (`"bottom"` or `"top"`,
#'   where the timestamp goes).
#' @param reverse Show the entries newest first.
#' @param html Render each entry's `content` as HTML rather than text. Only
#'   use it with content you control: it goes through `v-html`, which does not
#'   escape anything.
#' @param session Shiny session for module support.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_timeline(
#'   id = "log",
#'   items = list(
#'     list(content = "Order placed",  timestamp = "2026-03-01", type = "primary"),
#'     list(content = "Order shipped", timestamp = "2026-03-02", type = "success",
#'          icon = "el-icon-check", size = "large"),
#'     list(content = "Delivered",     timestamp = "2026-03-04", color = "#0bbd87")
#'   )
#' )
#'
#' # Newest first, timestamps above each entry
#' el_timeline(
#'   id = "log", reverse = TRUE,
#'   items = list(
#'     list(content = "Second", timestamp = "10:30", placement = "top"),
#'     list(content = "First",  timestamp = "09:15", placement = "top")
#'   )
#' )
el_timeline <- function(id = NULL,
                        items = list(),
                        reverse = FALSE,
                        html = FALSE,
                        width   = NULL,
                        slots   = NULL,
                        session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) id <- paste0("el_timeline_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # One v-for over a data field, so update_el_timeline() can replace the lot.
  body <- if (html) {
    htmltools::HTML('<span v-html="item.content"></span>')
  } else {
    htmltools::HTML("{{ item.content }}")
  }

  item_tag <- htmltools::tag("el-timeline-item", list(
    "v-for"      = "(item, index) in items",
    ":key"       = "index",
    ":timestamp" = "item.timestamp",
    ":type"      = "item.type",
    ":color"     = "item.color",
    ":size"      = "item.size",
    ":icon"      = "item.icon",
    ":placement" = "item.placement",
    ":hide-timestamp" = "!item.timestamp",
    body
  ))

  vue_data <- list(
    items   = .el_timeline_items(items),
    reverse = reverse
  )

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-timeline", list(":reverse" = "reverse", item_tag)),
    data   = vue_data,
    width      = width,
    slots      = slots,
    dependency = el_timeline_handler_dependency()
  )
}

#' Keep only the fields an entry actually sets
#'
#' A `v-for` binding reading a missing property gets `undefined`, which is what
#' makes Element fall back to a prop's default. Filling the gaps with NA would
#' send JSON null instead, and null is a value: an entry without `placement`
#' then matched neither `placement === 'top'` nor `'bottom'`, so its timestamp
#' rendered nowhere at all.
#'
#' @param items A list of entries.
#' @return The entries with unknown and empty fields dropped.
#' @keywords internal
.el_timeline_items <- function(items) {
  fields <- c("content", "timestamp", "type", "color", "size", "icon", "placement")
  lapply(items, function(item) {
    kept <- item[intersect(fields, names(item))]
    kept[!vapply(kept, is.null, logical(1))]
  })
}

#' Update an Element UI Timeline
#'
#' @param session Shiny session object.
#' @param id Timeline ID (un-namespaced).
#' @param items Replacement entries, in the same shape [el_timeline()] takes.
#' @param reverse New ordering.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @export
#' @examples
#' if (interactive()) {
#'   # Append an entry to a growing log
#'   observeEvent(input$refresh, {
#'     log_entries(c(log_entries(), list(list(content = "Refreshed",
#'                                            timestamp = format(Sys.time(), "%H:%M")))))
#'     update_el_timeline(session, "log", items = log_entries())
#'   })
#' }
update_el_timeline <- function(session, id, items = NULL, reverse = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(items))   msg$items   <- .el_timeline_items(items)
  if (!is.null(reverse)) msg$reverse <- reverse
  session$sendCustomMessage("updateElTimeline", msg)
  invisible(NULL)
}
