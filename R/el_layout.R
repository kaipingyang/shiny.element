#' Element UI Layout Row
#'
#' @param ... Child columns (el_col) or other Element UI components
#' @param gutter Spacing between columns
#' @param type Layout type, e.g. "flex"
#' @param justify Flex horizontal alignment
#' @param align Flex vertical alignment
#' @param class CSS class
#' @param style CSS style
#' @export
el_row <- function(..., gutter = NULL, type = NULL, justify = NULL, align = NULL,   
                   class = NULL, style = NULL) {  
  attrs <- list()  
  if (!is.null(gutter)) attrs[["gutter"]] <- gutter  
  if (!is.null(type)) attrs[["type"]] <- type  
  if (!is.null(justify)) attrs[["justify"]] <- justify  
  if (!is.null(align)) attrs[["align"]] <- align  
  if (!is.null(class)) attrs[["class"]] <- class  
  if (!is.null(style)) attrs[["style"]] <- style  
  
  children <- list(...)  
    
  # 提取子组件依赖  
  all_deps <- lapply(children, function(child) {  
    if (inherits(child, "shiny.tag.list") || inherits(child, "shiny.tag")) {  
      htmltools::htmlDependencies(child)  
    } else {  
      NULL  
    }  
  })  
  all_deps <- unlist(all_deps, recursive = FALSE)  
    
  # 直接创建标签,不转换为字符串  
  tag <- htmltools::tag("el-row", c(attrs, children))  
    
  # 附加依赖  
  if (length(all_deps) > 0) {  
    tag <- htmltools::attachDependencies(tag, all_deps)  
  }  
    
  tag  
}

#' Element UI Layout Column
#'
#' @param ... Content or other Element UI components
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
  
  children <- list(...)  
    
  # 提取子组件依赖  
  all_deps <- lapply(children, function(child) {  
    if (inherits(child, "shiny.tag.list") || inherits(child, "shiny.tag")) {  
      htmltools::htmlDependencies(child)  
    } else {  
      NULL  
    }  
  })  
  all_deps <- unlist(all_deps, recursive = FALSE)  
    
  # 直接创建标签,不转换为字符串  
  tag <- htmltools::tag("el-col", c(attrs, children))  
    
  # 附加依赖  
  if (length(all_deps) > 0) {  
    tag <- htmltools::attachDependencies(tag, all_deps)  
  }  
    
  tag  
}

#' Element UI Page Wrapper with Theme Support
#'
#' Top-level page constructor that loads Element-UI, Vue, and layout CSS dependencies,
#' and supports both bslib/shiny themes and Element-UI layout CSS.
#'
#' Use this as the root UI function for your Shiny app. You can combine bslib layouts
#' (such as \code{page_sidebar}, \code{layout_columns}) and Element-UI widgets (such as \code{el_button}).
#'
#' @param ... UI elements to include in the page body.
#' @param title Optional page title.
#' @param theme Optional bslib or shiny theme object (e.g., \code{bs_theme()}) for Bootstrap styling.
#'   If provided, Bootstrap dependencies will be included.
#' @param theme_css Optional Element-UI layout CSS dependency (default: \code{el_layout_css_dependency()}).
#'   Set to \code{NULL} to disable Element-UI layout CSS.
#'
#' @details
#' The \code{el_page} function is designed to work with both bslib layouts and Element-UI widgets.
#' Do not mix Element-UI layout functions (\code{el_container}, \code{el_row}, \code{el_col}) with bslib layouts,
#' as they are not compatible. The Element-UI layout functions are experimental and may be deprecated in the future.
#'
#' @export
el_page <- function(
  ..., 
  title = NULL, 
  theme = bslib::bs_theme(version = 5, bootswatch = "minty"), 
  theme_css = el_layout_css_dependency()
) {
  deps <- list(
    vueR::html_dependency_vue(),
    vue_handler_dependency(),
    element_ui_dependency()
  )
  if (!is.null(theme_css)) deps <- c(deps, list(theme_css))
  if (!is.null(theme)) deps <- c(deps, bslib::bs_theme_dependencies(theme))

  shiny::fluidPage(
    if (!is.null(title)) titlePanel(title),
    htmltools::attachDependencies(
      htmltools::tags$head(),
      deps
    ),
    ...
  )
}