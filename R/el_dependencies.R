#' Load All Element-UI Dependencies  
#'   
#' Convenience function to load Vue, Element-UI, and layout CSS dependencies.  
#' Use this when you want to use Element-UI components in non-el_page layouts  
#' (e.g., bslib::page_sidebar, shiny::navbarPage).  
#'   
#' @param theme CSS dependency function or list (optional, default is el_layout_css_dependency())  
#' @return A list of htmlDependency objects  
#' @export  
#' @examples  
#' \dontrun{  
#' library(bslib)  
#' ui <- page_sidebar(  
#'   use_element(),  
#'   el_button("btn1", "Click me")  
#' )  
#' }  
use_element <- function(theme = el_layout_css_dependency()) {  
  deps <- list(  
    vueR::html_dependency_vue(),  
    element_ui_dependency()  
  )  
    
  if (!is.null(theme)) {  
    deps <- c(deps, list(theme))  
  }  
    
  htmltools::tagList(deps)  
}

#' Element UI Dependency
#' @export
element_ui_dependency <- function() {
  htmltools::htmlDependency(
    name = "element-ui",
    version = "2.13.2",
    src = c(href = "https://unpkg.com/element-ui@2.13.2/lib/"),
    script = "index.js",
    stylesheet = "theme-chalk/index.css"
  )
}

#' Element UI Layout CSS Dependency
#'
#' Provides default CSS styles for Element-UI layout and grid components,
#' including el-container, el-header, el-main, el-footer, el-aside, el-row, el-col, etc.
#' This dependency is automatically attached by el_page() for consistent layout appearance.
#'
#' @export
el_layout_css_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-layout-css",
    version = "1.0.0",
    src = c(file = "css"),
    stylesheet = "el-layout.css",
    package = "shiny.element"
  )
}

#' Button Handler Dependency
#' @export
el_button_handler_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-button-handler",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "el-button-handler.js"
  )
}

#' Cascader Handler Dependency
#' @export
el_cascader_handler_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-cascader-handler",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "el-cascader-handler.js"
  )
}

#' Table Handler Dependency
#' @export
el_table_handler_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-table-handler",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "el-table-handler.js"
  )
}

