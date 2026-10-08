#' Element Plus Card
#'
#' A card container with optional header and body. Supports `always`, `hover`,
#' and `never` shadow modes.
#'
#' @param ... Content placed inside the card body.
#' @param header Header content (string or tag). `NULL` for no header.
#' @param footer Footer content (string or tag). `NULL` for no footer.
#' @param body_style CSS for the card body, a string or a named list. `NULL`
#'   for default.
#' @param class,style Extra classes and inline style on the card itself, as
#'   Element passes them to its root.
#' @param header_class,body_class,footer_class Extra class names for the
#'   header, the body and the footer.
#' @param shadow Shadow display trigger: `"always"`, `"hover"` or `"never"`.
#'   `NULL`, the default, is Element's `"always"`, or a config provider's
#'   [el_config_provider(card =)][el_config_provider].
#'
#' @return An `htmltools` tag.
#'
#' @examples
#' el_card(shiny::tags$p("Card body text."), header = "My Card")
#' el_card(shiny::tags$p("No shadow."), shadow = "never")
#' @export
el_card <- function(
  ...,
  header = NULL,
  body_style = NULL,
  shadow = NULL,
  footer = NULL,
  header_class = NULL,
  body_class = NULL,
  footer_class = NULL,
  class = NULL,
  style = NULL
) {
  .el_check_choices("el_card", environment())
  # left to Element: "always", or a config provider's card setting
  shadow_default <- is.null(shadow)
  card_class <- paste0("el-card is-", shadow %||% "always", "-shadow")

  header_div <- if (!is.null(header)) {
    shiny::tags$div(
      class = paste(c("el-card__header", header_class), collapse = " "),
      header
    )
  }
  footer_div <- if (!is.null(footer)) {
    shiny::tags$div(
      class = paste(c("el-card__footer", footer_class), collapse = " "),
      footer
    )
  }

  if (is.list(body_style)) {
    # Element's own form is an object of camelCase names, marginBottom
    body_style <- paste0(
      .el_kebab_case(names(body_style)),
      ":",
      unlist(body_style),
      ";",
      collapse = ""
    )
  }
  body_attrs <- list(
    class = paste(c("el-card__body", body_class), collapse = " ")
  )
  if (!is.null(body_style)) {
    body_attrs[["style"]] <- body_style
  }

  body_div <- do.call(shiny::tags$div, c(body_attrs, list(...)))

  # Element Plus's stylesheet draws the card
  htmltools::attachDependencies(
    shiny::tags$div(
      class = paste(c(card_class, class), collapse = " "),
      style = style,
      `data-el-shadow-default` = if (shadow_default) "true",
      header_div,
      body_div,
      footer_div
    ),
    .el_plus_dependencies()
  )
}
