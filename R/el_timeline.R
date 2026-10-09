#' Element Plus Timeline
#'
#' A vertical sequence of events.
#'
#' Entries are rendered with `v-for` from a data field, so
#' [update_el_timeline()] can replace them -- useful for a log that grows.
#' Content given as tags -- `el_card(...)` -- is drawn as markup; a string
#' is text unless `html = TRUE`.
#'
#' @param id Timeline ID (auto-generated if NULL).
#' @param items A list of entries, each an [el_timeline_item()] -- or a list
#'   with the same fields: `content` and
#'   optionally `timestamp`, `type` (`"primary"`, `"success"`, `"warning"`,
#'   `"danger"` or `"info"`), `color`, `size` (`"normal"` or `"large"`),
#'   `hide_timestamp`,
#'   `icon` (an icon's name), `placement` (`"bottom"` or `"top"`, where the
#'   timestamp goes), `center` (centre the dot against the content) and
#'   `hollow` (draw the dot hollow).
#' @param reverse Show the entries newest first.
#' @param html Render each entry's `content` as HTML rather than text --
#'   a string of markup, or tags. Only use it with content you control: it
#'   goes through `v-html`, which does not escape anything.
#' @param mode Relative position of timeline and content. Element Plus's
#'   `mode` ('start' | 'alternate' | 'alternate-reverse' | 'end').
#' @param session In `el_timeline()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_timeline()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @template on
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_timeline(
#'   id = "log",
#'   items = list(
#'     list(content = "Order placed", timestamp = "2026-03-01", type = "primary"),
#'     list(
#'       content = "Order shipped",
#'       timestamp = "2026-03-02",
#'       type = "success",
#'       icon = "el-icon-check",
#'       size = "large"
#'     ),
#'     list(content = "Delivered", timestamp = "2026-03-04", color = "#0bbd87")
#'   )
#' )
#'
#' # Newest first, timestamps above each entry
#' el_timeline(
#'   id = "log",
#'   reverse = TRUE,
#'   items = list(
#'     list(content = "Second", timestamp = "10:30", placement = "top"),
#'     list(content = "First", timestamp = "09:15", placement = "top")
#'   )
#' )
el_timeline <- function(
  id = NULL,
  items = list(),
  reverse = FALSE,
  html = FALSE,
  mode = NULL,
  width = NULL,
  slots = NULL,
  on = NULL,
  session = NULL
) {
  .el_check_choices("el_timeline", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_timeline")
  }
  ns_id <- .el_ui_id(id, session)

  # One v-for over a data field, so update_el_timeline() can replace the lot.
  # An entry whose content is tags is markup the app built: shown as such,
  # where a string stays text unless `html`
  body <- if (html) {
    htmltools::HTML('<span v-html="item.content"></span>')
  } else {
    htmltools::HTML(paste0(
      '<span v-if="item.contentHtml" v-html="item.content"></span>',
      '<template v-else>{{ item.content }}</template>'
    ))
  }

  item_tag <- htmltools::tag(
    "el-timeline-item",
    list(
      "v-for" = "(item, index) in items",
      ":key" = "index",
      ":timestamp" = "item.timestamp",
      ":type" = "item.type",
      ":color" = "item.color",
      ":size" = "item.size",
      ":icon" = "item.icon",
      ":placement" = "item.placement",
      ":center" = "item.center",
      ":hollow" = "item.hollow",
      ":hide-timestamp" = "item.hide_timestamp != null ? item.hide_timestamp : !item.timestamp",
      body
    )
  )

  vue_data <- list(
    items = .el_timeline_items(items),
    reverse = reverse
  )

  el_widget(
    props = .el_props(list(
      mode = mode
    )),
    id = ns_id,
    markup = htmltools::tag(
      "el-timeline",
      list(":reverse" = "reverse", item_tag)
    ),
    data = vue_data,
    width = width,
    slots = slots,
    on = on
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
  fields <- c(
    "content",
    "timestamp",
    "hide_timestamp",
    "type",
    "color",
    "size",
    "icon",
    "placement",
    "center",
    "hollow"
  )
  lapply(items, function(item) {
    kept <- item[intersect(fields, names(item))]
    kept <- kept[!vapply(kept, is.null, logical(1))]
    if (inherits(kept$content, c("shiny.tag", "shiny.tag.list", "html"))) {
      kept$contentHtml <- TRUE
    }
    kept
  })
}

#' @rdname el_timeline
#' @section Updating from the server:
#' `update_el_timeline()` changes the component from the server.
#'
#' Every other argument of [el_timeline()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_timeline()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # Append an entry to a growing log
#'   observeEvent(input$refresh, {
#'     log_entries(c(
#'       log_entries(),
#'       list(list(content = "Refreshed", timestamp = format(Sys.time(), "%H:%M")))
#'     ))
#'     update_el_timeline(session, "log", items = log_entries())
#'   })
#' }
#' @export
update_el_timeline <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  items = NULL,
  reverse = NULL,
  mode = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(items)) {
    msg$items <- .el_timeline_items(items)
  }
  if (!is.null(reverse)) {
    msg$reverse <- reverse
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_timeline",
      Filter(
        Negate(is.null),
        list(
          mode = mode
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
