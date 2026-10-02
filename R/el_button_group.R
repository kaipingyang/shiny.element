#' Element UI Button Group
#'
#' Buttons joined into one bar, as Element's `el-button-group` draws them:
#' shared borders, rounded only at the ends. Each [el_button()] inside keeps
#' reporting its own clicks as `input$<its id>`.
#'
#' The buttons are folded into the group's Vue instance rather than nested
#' (see [el_tooltip()]): Element styles the group through its direct
#' children, which a button with a host of its own would not be. So
#' `update_el_button()` cannot reach them; set their fields with
#' [update_vue_data()] on the group's id.
#'
#' @param ... Buttons: [el_button()]s, or raw `el$button()` tags.
#' @param id Group ID. Auto-generated if `NULL`.
#' @param width Component width, as a CSS unit.
#'
#' @return A Shiny UI element.
#' @examples
#' el_button_group(
#'   el_button("prev", "Previous", icon = "el-icon-arrow-left", type = "primary"),
#'   el_button("next", "Next", type = "primary")
#' )
#' @export
el_button_group <- function(..., id = NULL, width = NULL) {
  if (is.null(id)) id <- paste0("el_button_group_", uuid::UUIDgenerate())
  own <- list(markup = NULL, data = list(), methods = list(), watch = list(),
              computed = list(), mounted = NULL, dependencies = list())
  parts <- lapply(list(...), .el_absorb)
  merged <- do.call(.el_absorb_merge, c(list(own), parts))

  el_widget(
    id       = id,
    markup   = htmltools::tag("el-button-group", unname(merged$markups[-1])),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    dependency = merged$dependencies
  )
}
