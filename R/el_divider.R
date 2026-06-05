#' Element UI Divider
#'
#' Renders a horizontal or vertical dividing line, optionally with inline text.
#'
#' @param content Optional text/tag placed inside the divider. Only for
#'   `direction = "horizontal"`.
#' @param direction Divider orientation: `"horizontal"` (default) or `"vertical"`.
#' @param content_position Position of inline text when `content` is supplied:
#'   `"center"` (default), `"left"`, or `"right"`.
#'
#' @return An `htmltools` tag.
#'
#' @examples
#' el_divider()
#' el_divider("Title Text", content_position = "left")
#' el_divider(direction = "vertical")
#'
#' @export
el_divider <- function(content = NULL, direction = "horizontal",
                       content_position = "center") {
  direction        <- match.arg(direction, c("horizontal", "vertical"))
  content_position <- match.arg(content_position, c("center", "left", "right"))

  div_class <- paste0("el-divider el-divider--", direction)

  if (!is.null(content) && direction == "horizontal") {
    text_class <- paste0("el-divider__text is-", content_position)
    shiny::tags$div(
      class = div_class,
      shiny::tags$div(class = text_class, content)
    )
  } else {
    shiny::tags$div(class = div_class)
  }
}
