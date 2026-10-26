# What travels to the browser as JSON: a component's spec, its data as
# rows, tags as HTML, JS() values marked for reviving.

#' A data.frame as rows, as `v-for` walks it and table components take it
#'
#' Factors become strings; a dot in a name becomes an underscore, since a
#' template expression cannot name `a.b`. A data.frame further in -- a row's
#' list of rows, a cell of a list column -- is rows too, and a list column's
#' cell is its value, not a list of one; `NA` is `null`.
#'
#' The rows are written by jsonlite, as JSON kept verbatim (class `json`):
#' its `dataframe = "rows"` is one vectorised pass, where a list of row lists
#' took jsonlite seconds for a table-v2's ten thousand rows. A data.frame
#' holding tags or [JS()] in a list column is turned into row lists instead,
#' so they are rendered and revived as anywhere else.
#'
#' @param data A data.frame, a list holding some, or anything else
#'   (returned as is).
#' @return The rows: JSON of class `json`, or a list of row lists.
#' @keywords internal
.vue_rows <- function(data) {
  if (!is.data.frame(data)) {
    if (is.list(data) && !inherits(data, "json") && length(data)) {
      data[] <- lapply(data, .vue_rows)
    }
    return(data)
  }
  names(data) <- gsub("\\.", "_", names(data))
  special <- function(x) {
    inherits(x, c("shiny.tag", "shiny.tag.list", "html", "JS_EVAL"))
  }
  in_cells <- vapply(
    data,
    function(col) is.list(col) && any(vapply(col, special, logical(1))),
    logical(1)
  )
  if (!any(in_cells)) {
    return(jsonlite::toJSON(
      data,
      dataframe = "rows",
      auto_unbox = TRUE,
      null = "null",
      na = "null",
      digits = NA,
      POSIXt = "ISO8601",
      UTC = TRUE,
      rownames = FALSE,
      factor = "string"
    ))
  }
  nms <- names(data)
  lapply(seq_len(nrow(data)), function(i) {
    row <- lapply(nms, function(col) {
      column <- data[[col]]
      if (is.list(column)) {
        return(.vue_rows(column[[i]]))
      }
      val <- column[i]
      if (is.factor(val)) as.character(val) else val
    })
    names(row) <- nms
    row
  })
}

#' Tags inside a list rendered to HTML strings
#'
#' @param x Anything.
#' @return `x`, with every tag in it rendered.
#' @keywords internal
.vue_tags_as_html <- function(x) {
  if (inherits(x, c("shiny.tag", "shiny.tag.list"))) {
    return(as.character(htmltools::renderTags(x)$html))
  }
  if (is.list(x) && !is.data.frame(x) && length(x)) {
    attrs <- attributes(x)
    x[] <- lapply(x, .vue_tags_as_html)
    attributes(x) <- attrs
  }
  x
}

#' Paths of the JS() values in a nested list, for the browser to revive
#'
#' @param x A nested list.
#' @return Dot-separated paths, dots inside names escaped.
#' @keywords internal
.vue_js_paths <- function(x) {
  walk <- function(node, path) {
    if (is.list(node) && !inherits(node, "POSIXlt")) {
      n <- length(node)
      if (!n) {
        return(character(0))
      }
      nms <- names(node)
      if (is.null(nms)) {
        nms <- as.character(seq_len(n) - 1L)
      }
      nms <- gsub(".", "\\.", nms, fixed = TRUE)
      unlist(
        lapply(seq_len(n), function(i) {
          walk(
            node[[i]],
            if (is.null(path)) nms[i] else paste0(path, ".", nms[i])
          )
        }),
        use.names = FALSE
      )
    } else if (is.character(node) && inherits(node, "JS_EVAL")) {
      path
    } else {
      character(0)
    }
  }
  out <- walk(x, NULL)
  if (is.null(out)) character(0) else out
}

#' A component's spec as the JSON its host carries
#'
#' Written by yyjsonr, in C: jsonlite walks the value in R, one S4 method
#' dispatch per element -- some 5 ms for a component's few dozen fields, half
#' of building it. What jsonlite was asked for, yyjsonr is given: one-element
#' vectors unboxed and `I()` ones kept as arrays, `NA` and `NULL` as `null`,
#' data frames by column, `JS()` code and `json` verbatim, full precision;
#' and what yyjsonr does otherwise, done first ([.vue_json_prepare()]): a
#' named vector is an object, a date-time ISO 8601 in UTC, a whole number
#' kept as a double written `1`, not `1.0`.
#'
#' @param spec `options`, and `input`, `rate`, `type`, `use`, ...
#' @return The JSON, as a single string, safe inside a `<script>`.
#' @keywords internal
.vue_json <- function(spec) {
  spec <- .vue_tags_as_html(spec)
  spec$evals <- I(.vue_js_paths(spec))
  json <- yyjsonr::write_json_str(
    .vue_json_prepare(spec),
    opts = .vue_memo("json_opts", function() {
      yyjsonr::opts_write_json(
        auto_unbox = TRUE,
        dataframe = "columns",
        factor = "string",
        num_specials = "null",
        str_specials = "null",
        json_verbatim = TRUE,
        null = "null",
        digits = -1
      )
    })
  )
  gsub("</", "<\\/", json, fixed = TRUE)
}

#' A value made ready for yyjsonr, as jsonlite would have written it
#'
#' A named atomic vector becomes a list (an object, as jsonlite's
#' `keep_vec_names` had it); a date-time an ISO 8601 string in UTC; a double
#' holding whole numbers within integer range an integer, which yyjsonr
#' writes `1` where it writes a double `1.0`. `JS()` and `json` values stay
#' as they are; `I()` keeps its class.
#'
#' @param x A value.
#' @return The value.
#' @keywords internal
.vue_json_prepare <- function(x) {
  if (inherits(x, c("json", "JS_EVAL"))) {
    return(x)
  }
  if (inherits(x, "POSIXt")) {
    out <- format(x, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
    out[is.na(x)] <- NA
    return(if (inherits(x, "AsIs")) I(out) else out)
  }
  if (is.list(x)) {
    x[] <- lapply(x, .vue_json_prepare)
    return(x)
  }
  if (is.double(x) && all(oldClass(x) %in% "AsIs")) {
    x <- .vue_json_whole(x)
  }
  if (
    is.atomic(x) &&
      length(x) &&
      !is.null(names(x)) &&
      !inherits(x, "AsIs")
  ) {
    return(as.list(x))
  }
  x
}

#' Whole doubles as integers, so yyjsonr writes `1` rather than `1.0`
#'
#' @param x A double vector, plain or `I()`.
#' @return `x`, an integer vector when every value is whole and within
#'   integer range (`NA` allowed).
#' @keywords internal
.vue_json_whole <- function(x) {
  v <- unclass(x)
  ok <- !is.na(v)
  if (
    !any(ok) ||
      any(!is.finite(v[ok])) ||
      any(abs(v[ok]) > .Machine$integer.max) ||
      any(v[ok] != trunc(v[ok])) ||
      any(v[ok] == 0 & 1 / v[ok] < 0)
  ) {
    return(x)
  }
  out <- as.integer(v)
  attributes(out) <- attributes(x)
  out
}
