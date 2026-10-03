#' Set fields of a component's Vue instance
#'
#' The escape hatch beside `update_el_*()`: assigns any declared field of
#' the instance behind `id` -- a field of a component built with
#' [el_widget()], or of one absorbed into a wrapper, which has no update
#' function of its own. A field the instance does not declare is refused,
#' with a `[shiny-vue]` warning in the browser console.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Vue component id (string)
#' @param data Named list of fields and their new values.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @export
#' @examples
#' \dontrun{
#'   # In a Shiny server function:
#'   # Set two fields of a component of your own
#'   update_vue_data(session, "price", list(range = list(0, 50), max = 500))
#' }
update_vue_data <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  data
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  .el_send_update(session, c(list(id = ns_id), data))
  invisible(NULL)
}
