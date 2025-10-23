#' Element UI icon tag
#' @param name Icon name (e.g. "search", "edit")
#' @param ... Other tag attributes
#' @export
el_icon <- function(name, ...) {
  tags$i(class = paste0("el-icon-", name), ...)
}
