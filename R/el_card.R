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
#' @param header_class,body_class,footer_class Extra class names for the
#'   header, the body and the footer.
#' @param shadow Shadow display trigger: `"always"` (default), `"hover"`,
#'   or `"never"`.
#'
#' @return An `htmltools` tag.
#'
#' @examples
#' el_card(shiny::tags$p("Card body text."), header = "My Card")
#' el_card(shiny::tags$p("No shadow."), shadow = "never")
#'
#' @export
el_card <- function(...,
                    header = NULL,
                    body_style = NULL,
                    shadow = "always",
                    footer = NULL,
                    header_class = NULL,
                    body_class = NULL,
                    footer_class = NULL) {
  .el_check_choices("el_card", environment())
  card_class <- paste0("el-card is-", shadow, "-shadow")

  header_div <- if (!is.null(header)) {
    shiny::tags$div(class = paste(c("el-card__header", header_class), collapse = " "), header)
  }
  footer_div <- if (!is.null(footer)) {
    shiny::tags$div(class = paste(c("el-card__footer", footer_class), collapse = " "), footer)
  }

  if (is.list(body_style)) {
    body_style <- paste0(names(body_style), ":", unlist(body_style), ";", collapse = "")
  }
  body_attrs <- list(class = paste(c("el-card__body", body_class), collapse = " "))
  if (!is.null(body_style)) body_attrs[["style"]] <- body_style

  body_div <- do.call(shiny::tags$div, c(body_attrs, list(...)))

  shiny::tags$div(
    class = card_class,
    header_div,
    body_div,
    footer_div
  )
}
