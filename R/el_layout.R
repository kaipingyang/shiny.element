#' Element UI Layout Row
#'
#' @param ... Child columns (el_col)
#' @param gutter Spacing between columns
#' @param type Layout type, e.g. "flex"
#' @param justify Flex horizontal alignment
#' @param align Flex vertical alignment
#' @param class CSS class
#' @param style CSS style
#' @export
el_row <- function(..., gutter = NULL, type = NULL, justify = NULL, align = NULL, class = NULL, style = NULL) {
  attrs <- list()
  if (!is.null(gutter)) attrs[["gutter"]] <- gutter
  if (!is.null(type)) attrs[["type"]] <- type
  if (!is.null(justify)) attrs[["justify"]] <- justify
  if (!is.null(align)) attrs[["align"]] <- align
  if (!is.null(class)) attrs[["class"]] <- class
  if (!is.null(style)) attrs[["style"]] <- style
  htmltools::tag("el-row", c(attrs, list(...)))
}

#' Element UI Layout Column
#'
#' @param ... Content
#' @param span Column span (1-24)
#' @param offset Offset columns
#' @param push Push columns
#' @param pull Pull columns
#' @param xs Responsive xs
#' @param sm Responsive sm
#' @param md Responsive md
#' @param lg Responsive lg
#' @param xl Responsive xl
#' @param class CSS class
#' @param style CSS style
#' @export
el_col <- function(..., span = NULL, offset = NULL, push = NULL, pull = NULL,
                   xs = NULL, sm = NULL, md = NULL, lg = NULL, xl = NULL,
                   class = NULL, style = NULL) {
  attrs <- list()
  if (!is.null(span)) attrs[["span"]] <- span
  if (!is.null(offset)) attrs[["offset"]] <- offset
  if (!is.null(push)) attrs[["push"]] <- push
  if (!is.null(pull)) attrs[["pull"]] <- pull
  if (!is.null(xs)) attrs[["xs"]] <- xs
  if (!is.null(sm)) attrs[["sm"]] <- sm
  if (!is.null(md)) attrs[["md"]] <- md
  if (!is.null(lg)) attrs[["lg"]] <- lg
  if (!is.null(xl)) attrs[["xl"]] <- xl
  if (!is.null(class)) attrs[["class"]] <- class
  if (!is.null(style)) attrs[["style"]] <- style
  htmltools::tag("el-col", c(attrs, list(...)))
}

#' Element UI Page Wrapper with Theme Support
#'
#' Wraps a Shiny UI with Element-UI, Vue, and layout CSS dependencies.
#'
#' @param ... UI elements
#' @param title Page title (optional)
#' @param theme CSS dependency function or list (optional, default is el_layout_css_dependency())
#' @export
el_page <- function(..., title = NULL, theme = el_layout_css_dependency()) {
  shiny::fluidPage(
    if (!is.null(title)) titlePanel(title),
    htmltools::attachDependencies(
      htmltools::tags$head(), # attach to head so dependencies load globally
      c(
        list(
          vueR::html_dependency_vue(),
          element_ui_dependency()
        ),
        if (!is.null(theme)) list(theme) else NULL
      )
    ),
    ...
  )
}
