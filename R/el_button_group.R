#' Element Plus Button Group
#'
#' Buttons joined into one bar, as Element's `el-button-group` draws them:
#' shared borders, rounded only at the ends. Each [el_button()] inside keeps
#' reporting its own clicks as `input$<its id>`.
#'
#' The buttons are folded into the group's Vue instance rather than nested
#' (see [el_tooltip()]): Element styles the group through its direct
#' children, which a button with a host of its own would not be. So
#' `update_el_button()` cannot reach them; set their fields with
#' [update_vue()] on the group's id.
#'
#' @param ... Buttons: [el_button()]s, or raw `el$button()` tags.
#' @param id Group ID. Auto-generated if `NULL`.
#' @param size,type The size and type of every button in the group, as
#'   Element Plus's group hands them down: `size` `"large"`, `"default"` or
#'   `"small"`; `type` `"primary"`, `"success"`, `"warning"`, `"danger"` or
#'   `"info"`.
#' @param direction `"horizontal"` (default) or `"vertical"`.
#' @param width Component width, as a CSS unit.
#'
#' @template on
#' @return A Shiny UI element.
#' @examples
#' el_button_group(
#'   el_button("prev", "Previous", icon = "ArrowLeft", type = "primary"),
#'   el_button("next", "Next", type = "primary")
#' )
#' @export
el_button_group <- function(
  ...,
  id = NULL,
  size = NULL,
  type = NULL,
  direction = NULL,
  width = NULL,
  on = NULL
) {
  .el_check_choices("el_button_group", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_button_group")
  }
  own <- list(
    markup = NULL,
    data = list(),
    methods = list(),
    watch = list(),
    computed = list(),
    mounted = NULL,
    dependencies = list()
  )
  parts <- lapply(list(...), .el_absorb)
  merged <- do.call(.el_absorb_merge, c(list(own), parts))

  el_widget(
    id = id,
    # Prefixed: the buttons folded in have a size and a type of their own
    props = .el_props(
      list(size = size, type = type, direction = direction),
      prefix = "bg"
    ),
    markup = htmltools::tag("el-button-group", unname(merged$markups[-1])),
    data = merged$data,
    absorbed = merged$absorbed,
    methods = merged$methods,
    watch = merged$watch,
    computed = merged$computed,
    mounted = merged$mounted,
    width = width,
    dependency = merged$dependencies,
    on = on
  )
}


#' @rdname el_button_group
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @section Updating from the server:
#' `update_el_button_group()` changes the component from the server: every argument of
#' [el_button_group()] that can change once it is drawn, under the same name. One left
#' `NULL` stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_button_group()` is called for its side effect and returns `NULL` invisibly.
#' @export
update_el_button_group <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  size = NULL,
  type = NULL,
  direction = NULL
) {
  .el_check_session(session)
  .el_send_props_update(
    session,
    id,
    "el_button_group",
    list(
      size = size,
      type = type,
      direction = direction
    ),
    prefix = "bg"
  )
}
