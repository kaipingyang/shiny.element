#' Update one or more fields of a Vue component instance by id (namespaced)
#' @param session Shiny session object
#' @param id Vue component id (string)
#' @param ... Named fields and values to update
#' @export
update_vue_component <- function(session, id, ...) {
  ns_id <- session$ns(id)
  message <- list(id = ns_id, ...)
  session$sendCustomMessage("update_vue_component", message)
}

#' Update the entire data object of a Vue component instance by id (namespaced)
#' @param session Shiny session object
#' @param id Vue component id (string)
#' @param data Named list representing the full Vue data object
#' @export
update_vue_data <- function(session, id, data) {
  ns_id <- session$ns(id)
  message <- list(id = ns_id, data = data)
  session$sendCustomMessage("update_vue_data", message)
}