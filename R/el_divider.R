#' Element Plus Divider
#'
#' Renders a horizontal or vertical dividing line, optionally with inline text.
#'
#' @param content Optional text/tag placed inside the divider. Only for
#'   `direction = "horizontal"`.
#' @param direction Divider orientation: `"horizontal"` (default) or `"vertical"`.
#' @param content_position Position of inline text when `content` is supplied:
#'   `"center"` (default), `"left"`, or `"right"`.
#'
#' @param border_style The line's style, as CSS `border-style`: `"solid"`
#'   (the default), `"dashed"`, `"dotted"`.
#' @param class,style Extra classes and inline style, as Element passes them
#'   to its root -- `style = "height: auto"` for a vertical divider that
#'   stretches in a flex row.
#' @return An `htmltools` tag.
#'
#' @examples
#' el_divider()
#' el_divider("Title Text", content_position = "left")
#' el_divider(direction = "vertical")
#' @export
el_divider <- function(
  content = NULL,
  direction = "horizontal",
  content_position = "center",
  border_style = "solid",
  class = NULL,
  style = NULL
) {
  .el_check_choices("el_divider", environment())
  direction <- match.arg(direction, c("horizontal", "vertical"))
  content_position <- match.arg(content_position, c("center", "left", "right"))

  div_class <- paste(
    c("el-divider", paste0("el-divider--", direction), class),
    collapse = " "
  )
  # Element Plus draws the line from --el-border-style, which it always sets
  style <- .el_style(sprintf("--el-border-style:%s", border_style), style)

  divider <- if (!is.null(content) && direction == "horizontal") {
    text_class <- paste0("el-divider__text is-", content_position)
    shiny::tags$div(
      class = div_class,
      role = "separator",
      style = style,
      shiny::tags$div(class = text_class, content)
    )
  } else {
    shiny::tags$div(class = div_class, role = "separator", style = style)
  }
  # Element Plus's stylesheet draws the line
  htmltools::attachDependencies(divider, .el_plus_dependencies())
}
