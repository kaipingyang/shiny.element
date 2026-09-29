#' Element UI Tabs
#'
#' A tabbed panel.
#'
#' Rendered as plain markup carrying Element's own classes, driven by a Shiny
#' input binding rather than a Vue instance. That is what lets a tab hold other
#' components from this package: a Vue instance mounted here would rebuild the
#' DOM underneath them, leaving them rendered but disconnected from the server.
#' See `.claude/docs/lessons.md` §1.2.
#'
#' @param id Tabs ID. Auto-generated UUID if `NULL`.
#' @param tabs A list of tabs. Each is a named list with:
#'   \describe{
#'     \item{name}{Unique tab identifier (string). Required.}
#'     \item{label}{Tab label. Required.}
#'     \item{content}{Tab body. Any tag or tagList, including this package's
#'       own components.}
#'     \item{disabled}{Whether the tab can be selected. Default `FALSE`.}
#'   }
#' @param selected Name of the initially selected tab. Defaults to the first.
#' @param type `NULL` for plain tabs, `"card"` or `"border-card"`.
#' @param tab_position `"top"` (default), `"right"`, `"bottom"` or `"left"`.
#' @param closable Show a close button on each tab. Closing removes the tab
#'   from the page; the server is told through `input$<id>_closed`.
#' @param stretch Stretch the tabs to fill the available width.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tag.
#'
#' @section Shiny inputs:
#' `input$<id>` — name of the selected tab, reported on load and on every
#' change. `input$<id>_closed` — name of the most recently closed tab, when
#' `closable = TRUE`.
#'
#' @examples
#' el_tabs("t1", selected = "a", tabs = list(
#'   list(name = "a", label = "First",  content = shiny::tags$p("One")),
#'   list(name = "b", label = "Second", content = shiny::tags$p("Two"))
#' ))
#'
#' # A tab can hold other components
#' el_tabs("t2", tabs = list(
#'   list(name = "data", label = "Data", content = el_table(data = head(iris, 3))),
#'   list(name = "opts", label = "Options", content = el_switch("live"))
#' ))
#'
#' @export
el_tabs <- function(
    id           = NULL,
    tabs         = list(),
    selected     = NULL,
    type         = NULL,
    tab_position = "top",
    closable     = FALSE,
    stretch      = FALSE,
    session      = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_tabs_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  names_vec <- vapply(tabs, function(t) as.character(t$name), character(1))
  if (is.null(selected) || !selected %in% names_vec) {
    selected <- if (length(names_vec)) names_vec[1] else ""
  }

  pos_class <- paste0("is-", tab_position)

  # Element renders no active bar for the card types; the active tab is shown
  # by its own border instead.
  bar <- if (is.null(type)) {
    shiny::tags$div(class = paste("el-tabs__active-bar", pos_class))
  }

  items <- lapply(tabs, function(t) {
    active   <- identical(as.character(t$name), selected)
    disabled <- isTRUE(t$disabled)
    shiny::tags$div(
      id    = paste0(ns_id, "-tab-", t$name),
      role  = "tab",
      `aria-selected` = if (active) "true",
      tabindex        = if (active) "0" else "-1",
      class = paste(c("el-tabs__item", pos_class,
                      if (active) "is-active",
                      if (disabled) "is-disabled",
                      if (closable) "is-closable"), collapse = " "),
      `data-el-name` = t$name,
      t$label,
      if (closable) shiny::tags$span(class = "el-icon-close")
    )
  })

  panes <- lapply(tabs, function(t) {
    active <- identical(as.character(t$name), selected)
    # Hidden rather than removed, so a nested component stays mounted.
    shiny::tags$div(
      role  = "tabpanel",
      id    = paste0(ns_id, "-pane-", t$name),
      class = "el-tab-pane",
      style = if (!active) "display:none",
      `data-el-name` = t$name,
      t$content
    )
  })

  root_class <- paste(c("el-tabs", paste0("el-tabs--", tab_position),
                        if (!is.null(type)) paste0("el-tabs--", type)),
                      collapse = " ")

  htmltools::attachDependencies(
    shiny::tags$div(
      id    = ns_id,
      class = root_class,
      `data-el-tabs`  = "true",
      `data-position` = tab_position,
      `data-carded`   = tolower(as.character(!is.null(type))),
      shiny::tags$div(
        class = paste("el-tabs__header", pos_class),
        shiny::tags$div(
          class = paste("el-tabs__nav-wrap", pos_class),
          shiny::tags$div(
            class = "el-tabs__nav-scroll",
            shiny::tags$div(
              role  = "tablist",
              class = paste(c("el-tabs__nav", pos_class,
                              if (stretch) "is-stretch"), collapse = " "),
              bar, items
            )
          )
        )
      ),
      shiny::tags$div(class = "el-tabs__content", panes)
    ),
    el_tabs_dependency()
  )
}


#' Update Element UI Tabs
#'
#' Server-side update for [el_tabs()].
#'
#' @param session Shiny session object.
#' @param id Tabs ID (un-namespaced).
#' @param selected Name of the tab to select.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @export
update_el_tabs <- function(session, id, selected = NULL) {
  msg <- list()
  if (!is.null(selected)) msg$selected <- selected
  session$sendInputMessage(id, msg)
  invisible(NULL)
}


#' Tabs Binding Dependency
#'
#' Tabs are a Shiny input binding rather than an htmlwidget, so this loads the
#' binding instead of a message handler.
#'
#' @return An htmlDependency object.
#' @keywords internal
el_tabs_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-tabs-binding",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-tabs-binding.js",
    all_files = FALSE
  )
}
