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

#' Button Handler Dependency
#' @export
button_handler_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-button-handler",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "button-handler.js"
  )
}

#' Cascader Handler Dependency
#' @export
cascader_handler_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-cascader-handler",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "cascader-handler.js"
  )
}

#' Table Handler Dependency
#' @export
table_handler_dependency <- function() {
  htmltools::htmlDependency(
    name = "el-table-handler",
    version = "1.0.0",
    src = system.file("js", package = "shiny.element"),
    script = "table-handler.js"
  )
}
