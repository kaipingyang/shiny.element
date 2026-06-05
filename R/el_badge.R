#' Element UI Badge
#'
#' Wraps any content with a numeric badge or red dot in the top-right corner.
#' When used without content, renders a standalone badge element.
#'
#' @param ... Content to wrap (e.g. a button or icon).
#' @param value Badge value: number or string. Ignored when `is_dot = TRUE`.
#' @param max Maximum numeric value to display. When `value > max` the badge
#'   shows `"<max>+"`. Only applies when `value` is numeric.
#' @param is_dot Show a small dot instead of a number. Default `FALSE`.
#' @param hidden Whether to hide the badge. Default `FALSE`.
#' @param type Badge colour type: `NULL` (red, default), `"primary"`,
#'   `"success"`, `"warning"`, `"info"`, `"danger"`.
#'
#' @return An `htmltools` tag.
#'
#' @examples
#' el_badge(el_button("btn1", "Messages"), value = 5)
#' el_badge(el_button("btn2", "Alerts"),   value = 200, max = 99)
#' el_badge(el_button("btn3", "Updates"),  is_dot = TRUE)
#'
#' @export
el_badge <- function(..., value = NULL, max = NULL, is_dot = FALSE,
                     hidden = FALSE, type = NULL) {
  # Compute display content in R (mirrors ElementUI's computed `content`)
  display_value <- if (is_dot) {
    NULL
  } else if (!is.null(value) && !is.null(max) && is.numeric(value) && is.numeric(max)) {
    if (value > max) paste0(max, "+") else as.character(value)
  } else if (!is.null(value)) {
    as.character(value)
  } else {
    NULL
  }

  show_sup <- !hidden && (is_dot || !is.null(display_value))

  sup_classes <- c(
    "el-badge__content",
    if (!is.null(type)) paste0("el-badge__content--", type),
    if (length(list(...)) > 0) "is-fixed",
    if (is_dot) "is-dot"
  )

  sup_tag <- if (show_sup) {
    sup_attrs <- list(class = paste(sup_classes, collapse = " "))
    do.call(shiny::tags$sup, c(sup_attrs, list(display_value)))
  }

  shiny::tags$div(class = "el-badge", ..., sup_tag)
}
