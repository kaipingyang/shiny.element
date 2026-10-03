#' Does this child carry one of the given layout classes?
#'
#' @param x A candidate child element.
#' @param classes Layout class names to look for.
#' @return `TRUE` when `x` is a tag carrying one of `classes`.
#' @keywords internal
.el_has_class <- function(x, classes) {
  if (!inherits(x, "shiny.tag")) return(FALSE)
  own <- unlist(strsplit(paste(x$attribs$class, collapse = " "), "\\s+"))
  any(classes %in% own)
}

#' Build one of the Element Plus container parts
#'
#' @param class The Element Plus class name, e.g. `"el-header"`.
#' @param children Child elements.
#' @param size Inline `height` or `width` value, or `NULL`.
#' @param size_prop Which CSS property `size` sets.
#' @param style Extra inline style.
#' @param extra_class Extra CSS classes.
#' @return A Shiny UI element.
#' @keywords internal
.el_container_part <- function(class, children, size = NULL, size_prop = NULL,
                               style = NULL, extra_class = NULL) {
  htmltools::tag("div", c(
    list(class = paste(c(class, extra_class), collapse = " ")),
    list(style = .el_style(
      if (!is.null(size)) sprintf("%s:%s", size_prop, size),
      style
    )),
    children
  ))
}

#' Element Plus Container
#'
#' Emits `<div class="el-container">` directly.
#'
#' Element's container styles are plain CSS, so no Vue instance is needed --
#' and none is wanted: one mounted over the container would recompile the
#' components placed inside it and detach them.
#'
#' @param ... Child components, typically [el_header()], [el_aside()],
#'   [el_main()] and [el_footer()].
#' @param id Optional container id.
#' @param direction `"horizontal"` or `"vertical"`. Defaults to vertical when a
#'   direct child is a header or footer, matching Element Plus.
#' @param style Extra inline style.
#' @param class Extra CSS classes.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @return A Shiny UI element.
#' @export
#' @examples
#' # Header above a sidebar and main area
#' el_container(
#'   el_header("Title"),
#'   el_container(
#'     el_aside(width = "200px", "Sidebar"),
#'     el_main("Content")
#'   )
#' )
#'
#' # Nested inputs work, unlike with the previous Vue template approach
#' el_container(
#'   el_header(el_switch("dark_mode", value = FALSE)),
#'   el_main(el_slider("amount", value = 50))
#' )
el_container <- function(...,
                         id = NULL,
                         direction = NULL,
                         style = NULL,
                         class = NULL,
                         session = NULL) {
  .el_check_choices("el_container", environment())
  children <- list(...)

  vertical <- if (!is.null(direction)) {
    identical(direction, "vertical")
  } else {
    any(vapply(children, .el_has_class, logical(1),
               classes = c("el-header", "el-footer")))
  }

  attrs <- list(
    class = paste(c("el-container", if (vertical) "is-vertical", class),
                  collapse = " "),
    style = .el_style(style)
  )
  if (!is.null(id)) {
    attrs$id <- .el_ui_id(id, session)
  }

  htmltools::tag("div", c(attrs, children))
}

#' Element Plus Header
#'
#' @param ... Content.
#' @param height Header height. Defaults to `"60px"`, as in Element Plus, which
#'   sets it inline rather than through the stylesheet.
#' @param style Extra inline style.
#' @param class Extra CSS classes.
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_header("Dashboard")
#' el_header(height = "80px", el_button("refresh", "Refresh"))
el_header <- function(..., height = "60px", style = NULL, class = NULL) {
  .el_container_part("el-header", list(...), height, "height", style, class)
}

#' Element Plus Aside
#'
#' @param ... Content.
#' @param width Aside width. Defaults to `"300px"`, as in Element Plus, which
#'   sets it inline rather than through the stylesheet.
#' @param style Extra inline style.
#' @param class Extra CSS classes.
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_aside("Navigation")
#' el_aside(width = "200px", el_radio_group("nav", choices = c(Home = "h")))
el_aside <- function(..., width = "300px", style = NULL, class = NULL) {
  .el_container_part("el-aside", list(...), width, "width", style, class)
}

#' Element Plus Main
#'
#' @param ... Content.
#' @param style Extra inline style.
#' @param class Extra CSS classes.
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_main("Body content")
#' el_main(el_table(data = head(iris, 3)))
el_main <- function(..., style = NULL, class = NULL) {
  .el_container_part("el-main", list(...), style = style, extra_class = class)
}

#' Element Plus Footer
#'
#' @param ... Content.
#' @param height Footer height. Defaults to `"60px"`, as in Element Plus, which
#'   sets it inline rather than through the stylesheet.
#' @param style Extra inline style.
#' @param class Extra CSS classes.
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_footer("(c) 2026")
#' el_footer(height = "40px", "Compact footer")
el_footer <- function(..., height = "60px", style = NULL, class = NULL) {
  .el_container_part("el-footer", list(...), height, "height", style, class)
}
