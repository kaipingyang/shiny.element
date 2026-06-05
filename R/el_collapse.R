#' Element UI Collapse / Accordion
#'
#' A collapsible accordion panel. Multiple panels can be open simultaneously
#' unless `accordion = TRUE` is set.
#'
#' @param id Collapse ID. Auto-generated UUID if `NULL`.
#' @param items A list of panels. Each element is a named list with:
#'   \describe{
#'     \item{name}{Unique panel identifier (string). Required.}
#'     \item{title}{Panel header text. Required.}
#'     \item{content}{Panel body content (tag or tagList). Required.}
#'     \item{disabled}{Whether the panel header is disabled. Default `FALSE`.}
#'   }
#' @param value Character vector of initially active panel names. Ignored (use
#'   a single-element vector) when `accordion = TRUE`.
#' @param accordion Single-open accordion mode. Default `FALSE`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed collapse component.
#'
#' @section Shiny input:
#' `input$<id>` — character vector of currently open panel names (empty
#' character vector when all are closed). In accordion mode a single string.
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
#' @export
el_collapse <- function(
    id        = NULL,
    items     = list(),
    value     = character(0),
    accordion = FALSE,
    session   = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_collapse_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Build el-collapse-item tags
  item_tags <- lapply(items, function(item) {
    item_attrs <- list(":name" = item$name, ":title" = item$title)
    if (isTRUE(item$disabled)) item_attrs[[":disabled"]] <- "true"
    htmltools::tag("el-collapse-item",
      c(item_attrs, list(item$content))
    )
  })

  collapse_attrs <- list(
    ":value"     = "activeNames",
    ":accordion" = "accordion",
    "@change"    = "handleChange"
  )

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-collapse", c(collapse_attrs, item_tags))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el   = paste0("#", container_id),
        data = list(
          activeNames = if (accordion) value[1] else as.list(value),
          accordion   = accordion
        ),
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(val) { Shiny.setInputValue('%s', val); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_collapse_handler_dependency())
}


#' Update Element UI Collapse
#'
#' Server-side update for [el_collapse()].
#'
#' @param session Shiny session object.
#' @param id Collapse ID (un-namespaced).
#' @param value Character vector of panel names to activate.
#'
#' @export
update_el_collapse <- function(session, id, value = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value)) msg$activeNames <- as.list(value)
  session$sendCustomMessage("updateElCollapse", msg)
}


#' @keywords internal
el_collapse_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-collapse-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-collapse-handler.js",
    all_files = FALSE
  )
}
