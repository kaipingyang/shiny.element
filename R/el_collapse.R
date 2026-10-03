#' Element UI Collapse / Accordion
#'
#' Collapsible panels. Several can be open at once unless `accordion = TRUE`.
#'
#' Rendered as plain markup carrying Element's own classes, driven by a Shiny
#' input binding rather than a Vue instance. That is what lets a panel hold
#' other components from this package: a Vue instance mounted here would
#' rebuild the DOM underneath them, detaching them from the server. See
#' `.claude/docs/lessons.md`.
#'
#' @param id Collapse ID. Auto-generated UUID if `NULL`.
#' @param items A list of panels. Each is a named list with:
#'   \describe{
#'     \item{name}{Unique panel identifier (string). Required.}
#'     \item{title}{Panel header text. Required.}
#'     \item{content}{Panel body. Any tag or tagList, including this package's
#'       own components.}
#'     \item{disabled}{Whether the header is disabled. Default `FALSE`.}
#'   }
#' @param value Character vector of initially open panel names. In accordion
#'   mode only the first is used.
#' @param accordion Single-open accordion mode. Default `FALSE`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @return An `htmltools` tag.
#'
#' @section Shiny inputs:
#' `input$<id>` — character vector of open panel names, reported on load and on
#' every change. Empty when all are closed, which Shiny reports as `NULL`.
#'
#' @examples
#' el_collapse("col1",
#'   items = list(
#'     list(name = "p1", title = "Panel 1", content = shiny::tags$p("Content 1")),
#'     list(name = "p2", title = "Panel 2", content = shiny::tags$p("Content 2"))
#'   ),
#'   value = "p1"
#' )
#'
#' # A panel can hold other components
#' el_collapse("col2",
#'   items = list(
#'     list(name = "f", title = "Filters",
#'          content = shiny::tagList(el_input("q"), el_switch("live")))
#'   )
#' )
#'
#' @export
el_collapse <- function(
    id        = NULL,
    items     = list(),
    value     = character(0),
    accordion = FALSE,
    session   = NULL
) {
  .el_check_items(items, "items", c("name", "title"))
  if (is.null(id)) id <- paste0("el_collapse_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)
  value <- shiny::restoreInput(ns_id, value)

  if (accordion && length(value) > 1) value <- value[1]

  panels <- lapply(items, function(item) {
    open     <- item$name %in% value
    disabled <- isTRUE(item$disabled)

    # Element's markup and ARIA: a tab wrapping a header button, and a
    # tabpanel the two name each other through
    key     <- gsub("[^A-Za-z0-9_-]", "_", item$name)
    head_id <- paste0(ns_id, "-head-", key)
    body_id <- paste0(ns_id, "-content-", key)
    header <- shiny::tags$div(
      role = "tab",
      `aria-expanded`    = tolower(as.character(open)),
      `aria-controls`    = body_id,
      `aria-describedby` = body_id,
      shiny::tags$div(
        id    = head_id,
        role  = "button",
        tabindex = if (!disabled) "0",
        class = paste(c("el-collapse-item__header",
                        if (open) "is-active"), collapse = " "),
        item$title,
        shiny::tags$i(class = paste(c("el-collapse-item__arrow el-icon-arrow-right",
                                      if (open) "is-active"), collapse = " "))
      )
    )

    # The wrapper stays in the document when closed: hiding it with a style
    # keeps any nested component mounted, where removing it would not.
    body <- shiny::tags$div(
      id    = body_id,
      role  = "tabpanel",
      `aria-hidden`     = tolower(as.character(!open)),
      `aria-labelledby` = head_id,
      class = "el-collapse-item__wrap",
      style = if (!open) "display:none",
      shiny::tags$div(class = "el-collapse-item__content", item$content)
    )

    shiny::tags$div(
      class = paste(c("el-collapse-item",
                      if (open) "is-active",
                      if (disabled) "is-disabled"), collapse = " "),
      `data-el-name` = item$name,
      header, body
    )
  })

  htmltools::attachDependencies(
    shiny::tags$div(
      id    = ns_id,
      class = "el-collapse",
      role  = "tablist",
      `aria-multiselectable` = "true",
      `data-el-collapse` = "true",
      `data-accordion`   = tolower(as.character(accordion)),
      panels
    ),
    el_collapse_dependency()
  )
}

#' Collapse Binding Dependency
#'
#' The collapse is markup with a Shiny input binding rather than a Vue
#' instance, so that the components inside it stay mounted.
#'
#' @return An htmlDependency object.
#' @keywords internal
el_collapse_dependency <- function() {
  list(
    .el_jquery_dependency(),
    htmltools::htmlDependency(
      name      = "el-collapse-binding",
      version   = "1.0.0",
      src       = system.file("js", package = "shiny.element"),
      script    = "el-collapse-binding.js",
      all_files = FALSE
    )
  )
}


#' Update Element UI Collapse
#'
#' Server-side update for [el_collapse()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Collapse ID (un-namespaced).
#' @param value Character vector of panel names to open. Pass
#'   `character(0)` to close them all.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_collapse(session, "panels", value = "filters")
#'   })
#' }
#' @export
update_el_collapse <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL) {
  .el_check_session(session)
  msg <- list()
  # An input message rather than a custom message: the binding owns this
  # element, and Shiny routes the message to it by id.
  if (!is.null(value)) msg$value <- as.list(value)
  session$sendInputMessage(id, msg)
  invisible(NULL)
}
