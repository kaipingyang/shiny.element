# 工具函数示例
#' @keywords internal
el_ns <- function(id, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) session$ns(id) else id
}
