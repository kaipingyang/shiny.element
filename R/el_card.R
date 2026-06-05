#' Element UI Card
#'
#' A card container with optional header and body. Supports `always`, `hover`,
#' and `never` shadow modes.
#'
#' @param ... Content placed inside the card body.
#' @param header Header content (string or tag). `NULL` for no header.
#' @param body_style Inline CSS string for the card body. `NULL` for default.
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
el_card <- function(..., header = NULL, body_style = NULL, shadow = "always") {
  shadow <- match.arg(shadow, c("always", "hover", "never"))
  card_class <- paste0("el-card is-", shadow, "-shadow")

  header_div <- if (!is.null(header)) {
    shiny::tags$div(class = "el-card__header", header)
  }

  body_attrs <- list(class = "el-card__body")
  if (!is.null(body_style)) body_attrs[["style"]] <- body_style

  body_div <- do.call(shiny::tags$div, c(body_attrs, list(...)))

  shiny::tags$div(
    class = card_class,
    header_div,
    body_div
  )
}
