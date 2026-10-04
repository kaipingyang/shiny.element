#' Mark a string as JavaScript
#'
#' A prop that takes a function -- a table's `formatter`, a tree's
#' `filter_node_method`, a date picker's shortcuts -- takes JavaScript source
#' marked with `JS()`, which the page evaluates rather than passing on as
#' text. It is the same mark `htmlwidgets::JS()` makes, so either works, and
#' so does `DT::JS()`.
#'
#' @param ... JavaScript source, as one or more strings, joined by newlines.
#' @return The source, classed `"JS_EVAL"`.
#' @examples
#' JS("function(row, column, value) { return value.toFixed(2); }")
#' @export
JS <- function(...) {
  x <- c(...)
  if (is.null(x)) {
    return(NULL)
  }
  if (!is.character(x)) {
    stop("The arguments for JS() must be a character vector.", call. = FALSE)
  }
  x <- paste(x, collapse = "\n")
  structure(x, class = unique(c("JS_EVAL", oldClass(x))))
}

#' Where the JavaScript is in a list
#'
#' The paths, dot-separated, of every [JS()] value, for the page to evaluate. A dot in a name is escaped.
#'
#' @param x A list.
#' @return A character vector of paths.
#' @keywords internal
.el_js_paths <- function(x) .vue_js_paths(x)
