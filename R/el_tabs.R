#' Element UI Tabs Component
#'
#' Creates an Element UI tabs component with Vue instance.
#' Each tab can have a label, content, and optional disabled state.
#'
#' @param id Tabs ID. Auto-generated UUID if `NULL`.
#' @param tabs A list of tab definitions. Each element is a list with:
#'   \describe{
#'     \item{`name`}{Unique string identifier for the tab (v-model value).}
#'     \item{`label`}{Display text for the tab.}
#'     \item{`content`}{Optional tagList/tag for the tab body. `NULL` for empty.}
#'     \item{`disabled`}{Logical. Whether the tab is disabled. Default `FALSE`.}
#'   }
#' @param selected Initial active tab name. Defaults to the first tab's name.
#' @param type Tab style type: `NULL` (default), `"card"`, or `"border-card"`.
#' @param tab_position Position of the tab bar: `"top"` (default), `"right"`,
#'   `"bottom"`, or `"left"`.
#' @param closable Whether tabs show a close button. Default `FALSE`.
#' @param stretch Whether tab headers stretch to fill the tab bar. Default `FALSE`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed tabs component.
#'
#' @section Shiny input:
#' `input$<id>` — String (active tab name), updated on each tab click.
#'
#' @examples
#' # Basic usage
#' el_tabs(
#'   id = "my_tabs",
#'   tabs = list(
#'     list(name = "tab1", label = "Tab 1", content = shiny::tags$p("Content 1")),
#'     list(name = "tab2", label = "Tab 2", content = shiny::tags$p("Content 2")),
#'     list(name = "tab3", label = "Tab 3", disabled = TRUE)
#'   ),
#'   selected = "tab1"
#' )
#'
#' # Card style with position
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_tabs(
#'       id = "tabs1",
#'       type = "card",
#'       tab_position = "top",
#'       tabs = list(
#'         list(name = "a", label = "First",  content = shiny::tags$p("Hello")),
#'         list(name = "b", label = "Second", content = shiny::tags$p("World"))
#'       )
#'     ),
#'     verbatimTextOutput("active")
#'   )
#'   server <- function(input, output, session) {
#'     output$active <- renderPrint(input$tabs1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_tabs <- function(
    id           = NULL,
    tabs,
    selected     = NULL,
    type         = NULL,
    tab_position = "top",
    closable     = FALSE,
    stretch      = FALSE,
    session      = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_tabs_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Generate el-tab-pane tags from list
  tab_panes <- lapply(tabs, function(tab) {
    pane_attrs <- list(
      name  = tab$name,
      label = tab$label
    )
    if (isTRUE(tab$disabled)) pane_attrs$disabled <- NA
    pane_children <- if (!is.null(tab$content)) list(tab$content) else list()
    htmltools::tag("el-tab-pane", c(pane_attrs, pane_children))
  })

  # Build el-tabs attributes
  tabs_attrs <- list(
    "v-model"       = "activeTab",
    ":tab-position" = "tabPosition",
    ":stretch"      = "stretch",
    "@tab-click"    = "handleTabClick"
  )
  if (!is.null(type))  tabs_attrs$type          <- type
  if (closable)        tabs_attrs[[":closable"]] <- "closable"

  # Vue data
  vue_data <- list(
    activeTab   = if (is.null(selected)) tabs[[1]]$name else selected,
    tabPosition = tab_position,
    stretch     = stretch,
    closable    = closable
  )

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-tabs", c(tabs_attrs, tab_panes))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleTabClick = htmlwidgets::JS(sprintf(
            "function(tab, event) { Shiny.setInputValue('%s', tab.name); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_tabs_handler_dependency())
}


#' Update Element UI Tabs
#'
#' Server-side update for [el_tabs()]. Switches the active tab programmatically.
#'
#' @param session Shiny session object.
#' @param id Tabs ID (un-namespaced).
#' @param selected New active tab name.
#'
#' @export
update_el_tabs <- function(session, id, selected = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(selected)) msg$activeTab <- selected
  session$sendCustomMessage("updateElTabs", msg)
}


#' Tabs Handler Dependency
#' @keywords internal
el_tabs_handler_dependency <- function() {
  htmltools::htmlDependency(
    name    = "el-tabs-handler",
    version = "1.0.0",
    src     = system.file("js", package = "shiny.element"),
    script  = "el-tabs-handler.js",
    all_files = FALSE
  )
}
