#' Element Plus Text
#'
#' Text in Element's colours and sizes, truncated to a line or a number of
#'   lines if asked.
#'
#' @param ... Its content: any Shiny UI. Components of this package are folded
#'   into this one's Vue instance, as [el_button_group()] folds its buttons.
#' @param id Component ID. Auto-generated if `NULL`.
#' @param type Text type. Element Plus's `type` ('primary' | 'success' |
#'   'warning' | 'danger' | 'info').
#' @param size Text size. Element Plus's `size` ('large' | 'default' |
#'   'small').
#' @param truncated Render ellipsis. Element Plus's `truncated` (boolean).
#' @param line_clamp Maximum lines. Element Plus's `line-clamp` (string /
#'   number).
#' @param tag Custom element tag. Element Plus's `tag` (string).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents. A scoped slot is written
#'   with [template()].
#'
#' @template on
#' @section Shiny inputs:
#' None: it reports nothing.
#'
#' @return A Shiny UI element.
#' @examples
#' el_text("Primary text", type = "primary")
#' el_text(strrep("A long sentence. ", 20), truncated = TRUE)
#' @export
el_text <- function(
  ...,
  id = NULL,
  type = NULL,
  size = NULL,
  truncated = NULL,
  line_clamp = NULL,
  tag = NULL,
  width = NULL,
  slots = NULL,
  on = NULL
) {
  .el_check_choices("el_text", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_text")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    "el_text",
    on = on
  )
  .el_wrap_widget(
    "el-text",
    ns_id,
    list(...),
    props = .el_props(list(
      type = type,
      size = size,
      truncated = truncated,
      line_clamp = line_clamp,
      tag = tag
    )),
    events = events,
    width = width,
    slots = slots
  )
}


#' @rdname el_text
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @section Updating from the server:
#' `update_el_text()` changes the component from the server: every argument of
#' [el_text()] that can change once it is drawn, under the same name. One left
#' `NULL` stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_text()` is called for its side effect and returns `NULL` invisibly.
#' @export
update_el_text <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  type = NULL,
  size = NULL,
  truncated = NULL,
  line_clamp = NULL,
  tag = NULL
) {
  .el_check_session(session)
  .el_send_props_update(
    session,
    id,
    "el_text",
    list(
      type = type,
      size = size,
      truncated = truncated,
      line_clamp = line_clamp,
      tag = tag
    )
  )
}
