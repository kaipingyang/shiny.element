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
#'     \item{closable}{Whether this one tab can be closed, when `closable`
#'       is off for the rest.}
#'     \item{lazy}{Render the content only when the tab is first selected.
#'       Its components do not exist, and report nothing, until then.}
#'   }
#' @param selected Name of the initially selected tab. Defaults to the first.
#' @param type `NULL` for plain tabs, `"card"` or `"border-card"`.
#' @param tab_position `"top"` (default), `"right"`, `"bottom"` or `"left"`.
#' @param closable Show a close button on each tab. Closing removes the tab
#'   from the page; the server is told through `input$<id>_tab_remove`.
#' @param addable Show a "+" button; clicking it reports
#'   `input$<id>_tab_add`, and the server adds a tab with [insert_el_tab()].
#' @param editable `closable` and `addable` together.
#' @param before_leave `JS()` function
#'   `function(activeName, oldActiveName)` run before switching tabs; return
#'   `false`, or a promise that rejects, to stay put.
#' @param stretch Stretch the tabs to fill the available width.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @return An `htmltools` tag.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- name of the selected tab, on load and on every change.
#' - `input$<id>_tab_click` -- name of the tab clicked, even if it was already
#'   selected.
#' - `input$<id>_tab_remove` -- name of a tab just closed.
#' - `input$<id>_tab_add` -- fires when the "+" button is clicked.
#' - `input$<id>_edit` -- either of the last two, as Element's `edit` event:
#'   a list of `target` (the tab name, or `NULL` for an add) and `action`
#'   (`"remove"` or `"add"`).
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
    addable      = FALSE,
    editable     = FALSE,
    stretch      = FALSE,
    before_leave = NULL,
    session      = NULL
) {
  .el_check_items(tabs, "tabs", c("name", "label"))
  .el_check_choices("el_tabs", environment())
  if (is.null(id)) id <- paste0("el_tabs_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)
  selected <- shiny::restoreInput(ns_id, selected)

  # Element's editable is closable and addable together
  if (isTRUE(editable)) {
    closable <- TRUE
    addable  <- TRUE
  }

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
    .el_tab_item(ns_id, t, active = identical(as.character(t$name), selected),
                 closable = isTRUE(t$closable) || isTRUE(closable),
                 pos_class = pos_class)
  })
  panes <- lapply(tabs, function(t) {
    .el_tab_pane(ns_id, t, active = identical(as.character(t$name), selected))
  })

  root_class <- paste(c("el-tabs", paste0("el-tabs--", tab_position),
                        if (!is.null(type)) paste0("el-tabs--", type)),
                      collapse = " ")

  new_tab <- if (isTRUE(addable)) {
    shiny::tags$span(class = "el-tabs__new-tab", tabindex = "0",
                     shiny::tags$i(class = "el-icon-plus"))
  }

  htmltools::attachDependencies(
    shiny::tags$div(
      id    = ns_id,
      class = root_class,
      `data-el-tabs`  = "true",
      `data-position` = tab_position,
      `data-carded`   = tolower(as.character(!is.null(type))),
      `data-closable` = tolower(as.character(isTRUE(closable))),
      # A function's source, turned back into one by the binding
      `data-before-leave` = if (!is.null(before_leave)) as.character(before_leave),
      shiny::tags$div(
        class = paste("el-tabs__header", pos_class),
        new_tab,
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


#' One tab's header item
#'
#' @param ns_id The tabs' namespaced id.
#' @param t The tab description.
#' @param active,closable Whether it is selected, and whether it can be closed.
#' @param pos_class `is-top`, `is-left`, ...
#' @return A tag.
#' @keywords internal
.el_tab_item <- function(ns_id, t, active, closable, pos_class) {
  disabled <- isTRUE(t$disabled)
  shiny::tags$div(
    id    = paste0(ns_id, "-tab-", t$name),
    role  = "tab",
    `aria-controls` = paste0(ns_id, "-pane-", t$name),
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
}


#' One tab's pane
#'
#' A `lazy` tab that is not showing keeps its content in a `<template>`, which
#' the browser leaves inert: nothing in it renders, binds or runs until the
#' binding instantiates it the first time the tab is selected.
#'
#' @param ns_id The tabs' namespaced id.
#' @param t The tab description.
#' @param active Whether it is selected.
#' @return A tag.
#' @keywords internal
.el_tab_pane <- function(ns_id, t, active) {
  content <- if (isTRUE(t$lazy) && !active) {
    htmltools::tag("template", list(`data-el-lazy` = "true", t$content))
  } else {
    t$content
  }
  # Hidden rather than removed, so a nested component stays mounted.
  shiny::tags$div(
    role  = "tabpanel",
    id    = paste0(ns_id, "-pane-", t$name),
    `aria-labelledby` = paste0(ns_id, "-tab-", t$name),
    `aria-hidden` = if (!active) "true",
    class = "el-tab-pane",
    style = if (!active) "display:none",
    `data-el-name` = t$name,
    content
  )
}


#' Update Element UI Tabs
#'
#' Server-side update for [el_tabs()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Tabs ID (un-namespaced).
#' @param selected Name of the tab to select.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_tabs(session, "section", selected = "data")
#'   })
#' }
#' @export
update_el_tabs <- function(session = shiny::getDefaultReactiveDomain(), id, selected = NULL) {
  .el_check_session(session)
  msg <- list()
  if (!is.null(selected)) msg$selected <- selected
  session$sendInputMessage(id, msg)
  invisible(NULL)
}


#' Add or remove a tab from the server
#'
#' Element's addable and editable tabs leave adding to the app: clicking "+"
#' reports `input$<id>_tab_add`, and the app decides what the new tab holds.
#' These are how, in the manner of [shiny::insertTab()] and
#' [shiny::removeTab()]. The content may hold any UI, this package's
#' components included.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Tabs ID (un-namespaced).
#' @param name,label The new tab's name and label.
#' @param content The new tab's content.
#' @param closable Whether it can be closed. `NULL` follows the tabs'
#'   own setting.
#' @param select Whether to switch to it. Default `TRUE`.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   ui <- el_page(el_tabs("docs", editable = TRUE, tabs = list(
#'     list(name = "t1", label = "Tab 1", content = tags$p("First"))
#'   )))
#'   server <- function(input, output, session) {
#'     n <- 1
#'     observeEvent(input$docs_tab_add, {
#'       n <<- n + 1
#'       insert_el_tab(session, "docs", name = paste0("t", n),
#'                     label = paste("Tab", n), content = tags$p("New"))
#'     })
#'   }
#'   shinyApp(ui, server)
#' }
#' @export
insert_el_tab <- function(session = shiny::getDefaultReactiveDomain(), id, name, label, content = NULL,
                          closable = NULL, select = TRUE) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  # The pane goes in through insertUI, which renders its dependencies and
  # binds what is inside; the header item is built by the binding, which knows
  # the tabs' position and closability.
  shiny::insertUI(
    selector = paste0("#", ns_id, " > .el-tabs__content"),
    where = "beforeEnd", immediate = TRUE, session = session,
    ui = .el_tab_pane(ns_id, list(name = name, content = content), active = FALSE)
  )
  session$sendInputMessage(id, list(
    add_tab = list(name = name, label = label, closable = closable),
    selected = if (isTRUE(select)) name
  ))
  invisible(NULL)
}

#' @rdname insert_el_tab
#' @export
remove_el_tab <- function(session = shiny::getDefaultReactiveDomain(), id, name) {
  .el_check_session(session)
  session$sendInputMessage(id, list(remove_tab = name))
  invisible(NULL)
}


#' Tabs Binding Dependency
#'
#' Tabs are markup with a Shiny input binding rather than a Vue instance, so
#' that the components inside the panes stay mounted.
#'
#' @return An htmlDependency object.
#' @keywords internal
el_tabs_dependency <- function() {
  list(
    .el_jquery_dependency(),
    htmltools::htmlDependency(
      name      = "el-tabs-binding",
      version   = "1.0.0",
      src       = system.file("js", package = "shiny.element"),
      script    = "el-tabs-binding.js",
      all_files = FALSE
    )
  )
}
