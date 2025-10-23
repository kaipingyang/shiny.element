#' Element UI Container
#'
#' @param ... Child components
#' @param id Unique container id (auto-generated if NULL)
#' @param style CSS style
#' @param class CSS class
#' @param session Shiny session for module support
#' @export
el_container <- function(...,
                        id = NULL,
                        style = NULL,
                        class = NULL,
                        session = getDefaultReactiveDomain()) {
  if (is.null(id)) {
    id <- paste0("el_container_", uuid::UUIDgenerate())
  }
  ns_id <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  attrs <- list()
  if (!is.null(style)) attrs[["style"]] <- style
  if (!is.null(class)) attrs[["class"]] <- class
  content <- htmltools::tag("el-container", c(attrs, list(...)))

  component_ui <- htmltools::tagList(
    htmltools::tags$div(
      id = container_id
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el = paste0("#", container_id),
        template = as.character(content)
      )
    )
  )

  component_ui
  # htmltools::attachDependencies(
  #   component_ui,
  #   list(
  #     vueR::html_dependency_vue(),
  #     element_ui_dependency()
  #   )
  # )
}

#' Element UI Header
#'
#' @param ... Content
#' @param height Height (e.g. "60px")
#' @param style CSS style
#' @param class CSS class
#' @export
el_header <- function(..., height = NULL, style = NULL, class = NULL) {
  attrs <- list()
  if (!is.null(height)) style <- paste0("height:", height, ";", style)
  if (!is.null(style)) attrs[["style"]] <- style
  if (!is.null(class)) attrs[["class"]] <- class
  htmltools::tag("el-header", c(attrs, list(...)))
}

#' Element UI Aside
#'
#' @param ... Content
#' @param width Width (e.g. "200px")
#' @param style CSS style
#' @param class CSS class
#' @export
el_aside <- function(..., width = NULL, style = NULL, class = NULL) {
  attrs <- list()
  if (!is.null(width)) style <- paste0("width:", width, ";", style)
  if (!is.null(style)) attrs[["style"]] <- style
  if (!is.null(class)) attrs[["class"]] <- class
  htmltools::tag("el-aside", c(attrs, list(...)))
}

#' Element UI Main
#'
#' @param ... Content
#' @param style CSS style
#' @param class CSS class
#' @export
el_main <- function(..., style = NULL, class = NULL) {
  attrs <- list()
  if (!is.null(style)) attrs[["style"]] <- style
  if (!is.null(class)) attrs[["class"]] <- class
  htmltools::tag("el-main", c(attrs, list(...)))
}

#' Element UI Footer
#'
#' @param ... Content
#' @param height Height (e.g. "60px")
#' @param style CSS style
#' @param class CSS class
#' @export
el_footer <- function(..., height = NULL, style = NULL, class = NULL) {
  attrs <- list()
  if (!is.null(height)) style <- paste0("height:", height, ";", style)
  if (!is.null(style)) attrs[["style"]] <- style
  if (!is.null(class)) attrs[["class"]] <- class
  htmltools::tag("el-footer", c(attrs, list(...)))
}
