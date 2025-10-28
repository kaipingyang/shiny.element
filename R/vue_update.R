#' Update one or more fields of a Vue component instance by id (namespaced)
#' @param session Shiny session object
#' @param id Vue component id (string)
#' @param ... Named fields and values to update
#' @export
#' @examples
#' \dontrun{
#' # In a Shiny server function:
#' # Update the 'value' field of a calendar component
#' update_vue_component(session, "my_calendar", value = format(Sys.Date(), "%Y-%m-%d"))
#'
#' # Update multiple fields at once
#' update_vue_component(session, "my_calendar", value = "2025-12-31", first_day_of_week = 3)
#' }
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
#' @examples
#' \dontrun{
#' # In a Shiny server function:
#' # Replace the data object of a calendar component
#' update_vue_data(session, "my_calendar", list(
#'   value = "2025-12-31",
#'   first_day_of_week = 3
#' ))
#' }
update_vue_data <- function(session, id, data) {
  ns_id <- session$ns(id)
  message <- list(id = ns_id, data = data)
  session$sendCustomMessage("update_vue_data", message)
}