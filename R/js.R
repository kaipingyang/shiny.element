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
  if (is.null(x)) return(NULL)
  if (!is.character(x)) stop("The arguments for JS() must be a character vector.", call. = FALSE)
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
.el_js_paths <- function(x) {
  walk <- function(node, path) {
    if (is.list(node) && !inherits(node, "POSIXlt")) {
      n <- length(node)
      if (!n) return(character(0))
      nms <- names(node)
      if (is.null(nms)) nms <- as.character(seq_len(n) - 1L)
      nms <- gsub(".", "\\.", nms, fixed = TRUE)
      unlist(lapply(seq_len(n), function(i) {
        walk(node[[i]], if (is.null(path)) nms[i] else paste0(path, ".", nms[i]))
      }), use.names = FALSE)
    } else if (is.character(node) && inherits(node, "JS_EVAL")) {
      path
    } else character(0)
  }
  out <- walk(x, NULL)
  if (is.null(out)) character(0) else out
}
