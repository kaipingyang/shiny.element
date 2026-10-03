#' Element UI Descriptions
#'
#' A read-only grid of labelled values -- the detail view of a record.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param items The fields, as a list of `list(label =, content =)`, or a named
#'   list or vector whose names are the labels. `content` may be any Shiny UI,
#'   a shiny.element component included, which is absorbed rather than nested.
#'   An item may also carry `span`, `label_class_name`, `content_class_name`,
#'   `label_style` and `content_style`. A `label` that is markup rather than
#'   text fills the item's label slot.
#' @param title Heading above the grid.
#' @param extra Text at the heading's right end. For something interactive,
#'   use `slots = list(extra = ...)`.
#' @param column Items per row. Default `3`.
#' @param direction `"horizontal"` (default) puts each label beside its value;
#'   `"vertical"` puts it above.
#' @param border Whether to draw cell borders.
#' @param size `"medium"`, `"small"` or `"mini"`.
#' @param colon Whether labels end in a colon. Default `TRUE`.
#' @param label_class_name,content_class_name Class names for every label and
#'   every value.
#' @param label_style,content_style CSS for every label and every value, as a
#'   named list.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `title`, `extra`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @return A Shiny UI element.
#' @examples
#' el_descriptions("user", title = "Account", border = TRUE, items = list(
#'   list(label = "Name", content = "Ada Lovelace"),
#'   list(label = "Plan", content = el_tag("plan", "Pro", type = "success")),
#'   list(label = "Address", content = "12 St James's Square, London", span = 2)
#' ))
#'
#' # The quick form: names are labels
#' el_descriptions("car", items = as.list(mtcars[1, 1:6]))
#' @export
el_descriptions <- function(id = NULL,
                            items = list(),
                            title = NULL,
                            extra = NULL,
                            column = NULL,
                            direction = NULL,
                            border = NULL,
                            size = NULL,
                            colon = NULL,
                            label_class_name = NULL,
                            content_class_name = NULL,
                            label_style = NULL,
                            content_style = NULL,
                            width = NULL,
                            slots = NULL,
                            session = NULL) {
  .el_check_choices("el_descriptions", environment())
  if (is.null(id)) id <- paste0("el_descriptions_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  items <- .el_descriptions_items(items)

  own <- list(
    markup = NULL,
    data = list(
      dTitle            = .el_or_na(title),
      dExtra            = .el_or_na(extra),
      dColumn           = .el_or_na(column),
      dDirection        = .el_or_na(direction),
      dBorder           = .el_or_na(border),
      dSize             = .el_or_na(size),
      dColon            = .el_or_na(colon),
      dLabelClassName   = .el_or_na(label_class_name),
      dContentClassName = .el_or_na(content_class_name),
      dLabelStyle       = .el_or_na(label_style),
      dContentStyle     = .el_or_na(content_style)
    ),
    methods = list(), watch = list(), computed = list(), mounted = NULL,
    dependencies = list()
  )
  inners <- lapply(items, function(it) .el_absorb(it$content))
  merged <- do.call(.el_absorb_merge, c(list(own), inners))

  # Items are markup rather than v-for, because each one's content is
  # arbitrary UI -- which may itself be a component folded in above.
  item_tags <- Map(function(it, content) {
    # A label may be markup too -- an icon beside the text, say -- which goes
    # in the item's label slot rather than its label attribute.
    label_ui <- !is.character(it$label)
    attrs <- if (label_ui) list() else list(label = it$label)
    if (label_ui) {
      attrs <- c(attrs, list(htmltools::tag("template", list(slot = "label", it$label))))
    }
    for (key in c("span", "labelClassName", "contentClassName")) {
      if (!is.null(it[[key]])) attrs[[paste0(":", .el_kebab_case(key))]] <-
        jsonlite::toJSON(it[[key]], auto_unbox = TRUE)
    }
    for (key in c("labelStyle", "contentStyle")) {
      if (!is.null(it[[key]])) attrs[[paste0(":", .el_kebab_case(key))]] <-
        jsonlite::toJSON(it[[key]], auto_unbox = TRUE)
    }
    htmltools::tag("el-descriptions-item", c(attrs, list(content)))
  }, items, merged$markups[-1])

  attrs <- list(
    ":title"              = .el_optional_bind("dTitle"),
    ":extra"              = .el_optional_bind("dExtra"),
    ":column"             = .el_optional_bind("dColumn"),
    ":direction"          = .el_optional_bind("dDirection"),
    ":border"             = .el_optional_bind("dBorder"),
    ":size"               = .el_optional_bind("dSize"),
    ":colon"              = .el_optional_bind("dColon"),
    ":label-class-name"   = .el_optional_bind("dLabelClassName"),
    ":content-class-name" = .el_optional_bind("dContentClassName"),
    ":label-style"        = .el_optional_bind("dLabelStyle"),
    ":content-style"      = .el_optional_bind("dContentStyle")
  )

  el_widget(
    id       = ns_id,
    markup   = htmltools::tag("el-descriptions", c(attrs, unname(item_tags))),
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


#' Normalise descriptions items
#'
#' A named list or vector is the quick form: names are the labels. Keys
#' written in snake_case are turned to camelCase, as for table columns.
#'
#' @param items The items as given.
#' @return A list of items, each with `label` and `content`.
#' @keywords internal
.el_descriptions_items <- function(items) {
  if (!length(items)) return(list())
  if (is.null(names(items)) && (is.atomic(items) || inherits(items, c("shiny.tag", "shiny.tag.list")))) {
    stop("`items` must be named, as in c(Name = \"Ada\"), or a list of ",
         "list(label = ..., content = ...).", call. = FALSE)
  }
  is_item <- function(x) is.list(x) && !inherits(x, c("shiny.tag", "shiny.tag.list")) &&
    !is.null(x$label)
  if (!is.null(names(items)) && !all(vapply(items, is_item, logical(1)))) {
    items <- Map(function(label, content) {
      list(label = label, content = if (is.atomic(content)) format(content) else content)
    }, names(items), items)
  }
  lapply(unname(items), function(it) {
    for (key in grep("_", names(it), value = TRUE)) {
      it[[.el_camel_case(key)]] <- it[[key]]
      it[[key]] <- NULL
    }
    it
  })
}


#' Turn a camelCase name into kebab-case
#'
#' @param x A name.
#' @return The same name in kebab-case.
#' @keywords internal
.el_kebab_case <- function(x) {
  tolower(gsub("([a-z0-9])([A-Z])", "\\1-\\2", x))
}


#' Update Element UI Descriptions
#'
#' Server-side update for [el_descriptions()]. The items themselves are
#' markup, so replace them by re-rendering; this changes the settings around
#' them.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Component ID (un-namespaced).
#' @param title,extra,column,direction,border New values; `NULL` leaves one
#'   unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$narrow, {
#'     update_el_descriptions(session, "user", column = 1)
#'   })
#' }
#' @export
update_el_descriptions <- function(session = shiny::getDefaultReactiveDomain(), id, title = NULL, extra = NULL,
                                   column = NULL, direction = NULL,
                                   border = NULL) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(title))     msg$dTitle     <- title
  if (!is.null(extra))     msg$dExtra     <- extra
  if (!is.null(column))    msg$dColumn    <- column
  if (!is.null(direction)) msg$dDirection <- direction
  if (!is.null(border))    msg$dBorder    <- border
  .el_send_update(session, msg)
  invisible(NULL)
}


