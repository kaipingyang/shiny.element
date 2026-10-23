#' A date format in day.js's tokens
#'
#' Element Plus formats dates with day.js (`YYYY-MM-DD`, `x` for a
#' timestamp); Element UI used its own tokens (`yyyy-MM-dd`, `timestamp`).
#' The year and day tokens are the ones that differ.
#'
#' @param x A format, or `NULL`.
#' @return `x` in day.js's tokens.
#' @keywords internal
.el_dayjs_format <- function(x) {
  if (!is.character(x) || length(x) != 1L) {
    return(x)
  }
  if (identical(x, "timestamp")) {
    return("x")
  }
  x <- gsub("yyyy", "YYYY", x, fixed = TRUE)
  x <- gsub("yy", "YY", x, fixed = TRUE)
  gsub("(?<![D])dd(?!d)", "DD", x, perl = TRUE)
}
