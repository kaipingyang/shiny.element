#' Element UI Link
#'
#' A styled hyperlink that follows Element UI's design language.
#'
#' @param label Link text. Accepts a string or HTML tag.
#' @param href URL target. `NULL` for a non-navigating link.
#' @param type Link colour type: `"default"` (default), `"primary"`,
#'   `"success"`, `"warning"`, `"danger"`, `"info"`.
#' @param underline Whether to underline on hover. Default `TRUE`.
#' @param disabled Whether the link is disabled. Default `FALSE`.
#' @param icon Icon class string (e.g. `"el-icon-edit"`). Placed before the
#'   label. `NULL` for none.
#' @param ... Additional HTML attributes passed to the `<a>` tag.
#'
#' @return An `htmltools` `<a>` tag.
#'
#' @examples
#' el_link("Visit GitHub", href = "https://github.com", type = "primary")
#' el_link("Disabled", disabled = TRUE)
#' el_link("With icon", icon = "el-icon-edit", type = "success")
#'
#' @export
el_link <- function(label = "Link", href = NULL, type = "default",
                    underline = TRUE, disabled = FALSE, icon = NULL, ...) {
  link_classes <- c(
    "el-link",
    paste0("el-link--", type),
    if (disabled) "is-disabled",
    if (underline && !disabled) "is-underline"
  )

  a_attrs <- list(
    class = paste(link_classes, collapse = " "),
    href  = if (!disabled && !is.null(href)) href else NULL,
    ...
  )

  icon_tag <- if (!is.null(icon)) shiny::tags$i(class = icon)
  label_tag <- shiny::tags$span(class = "el-link--inner", label)

  do.call(shiny::tags$a, c(a_attrs, list(icon_tag, label_tag)))
}
