#' Element Plus's look, themed
#'
#' Element Plus draws from CSS variables -- `--el-color-primary`,
#' `--el-border-radius-base`, `--el-font-size-base` and some three hundred
#' more, listed in its stylesheet's `:root`. A page whose theme changes any of
#' them gets a `<style>` setting them, after Element's own stylesheet: no
#' build, no recompiling, as Element Plus's own theming guide does it.
#'
#' A brand colour also sets the tints and the shade Element's Sass mixes from
#' it -- `--el-color-primary-light-3` to `-light-9`, `-dark-2` -- for the light
#' page and, mixed against the dark background, for `html.dark`.
#'
#' @name el_element_theme
#' @keywords internal
NULL

# Element Plus's defaults, from theme-chalk's common/var.scss
.el_default_colors <- c(
  primary = "#409eff",
  success = "#67c23a",
  warning = "#e6a23c",
  danger = "#f56c6c",
  info = "#909399"
)

#' A colour mixed with another, as Sass's `mix()`
#'
#' @param hex The colour.
#' @param with What it is mixed with.
#' @param weight How much of `with`, from 0 to 1.
#' @return `"#rrggbb"`.
#' @keywords internal
.el_mix <- function(hex, with, weight) {
  a <- grDevices::col2rgb(hex)[, 1]
  b <- grDevices::col2rgb(with)[, 1]
  m <- floor(b * weight + a * (1 - weight) + 0.5)
  sprintf("#%02x%02x%02x", m[1], m[2], m[3])
}

#' A colour, as hex
#' @param x A colour R can read.
#' @return `"#rrggbb"`.
#' @keywords internal
.el_hex <- function(x) {
  rgb <- tryCatch(grDevices::col2rgb(x)[, 1], error = function(e) NULL)
  if (is.null(rgb)) {
    stop(sprintf('"%s" is not a colour.', x), call. = FALSE)
  }
  sprintf("#%02x%02x%02x", rgb[1], rgb[2], rgb[3])
}

#' The Element variables a theme sets
#'
#' From a [bslib::bs_theme()]: its `primary`, `success`, `warning`, `danger`
#' and `info` where they differ from Element's, and whatever was given to
#' [el_theme()]'s `element`. A plain named list is taken as Element
#' variables directly.
#'
#' @param theme A theme, a named list, or `NULL`.
#' @return A named character vector, names without the `--el-` prefix.
#' @keywords internal
.el_element_vars <- function(theme) {
  if (is.null(theme)) {
    return(character(0))
  }
  vars <- character(0)
  if (inherits(theme, "bs_theme")) {
    bs <- unlist(bslib::bs_get_variables(theme, names(.el_default_colors)))
    bs <- bs[!is.na(bs) & nzchar(bs)]
    for (n in names(bs)) {
      hex <- tryCatch(.el_hex(bs[[n]]), error = function(e) NA)
      if (!is.na(hex) && tolower(hex) != .el_default_colors[[n]]) {
        vars[[paste0("color-", n)]] <- hex
      }
    }
    extra <- attr(theme, "el_element")
  } else {
    extra <- theme
  }
  if (length(extra)) {
    extra <- unlist(extra)
    if (is.null(names(extra)) || any(!nzchar(names(extra)))) {
      stop(
        "Element's variables must be named, as in `list(\"border-radius-base\" = \"8px\")`.",
        call. = FALSE
      )
    }
    names(extra) <- sub("^(\\$|--)?(el-|--)?", "", names(extra))
    unknown <- setdiff(names(extra), .el_known_vars())
    if (length(unknown)) {
      stop(
        "Element Plus has no theme variable ",
        paste(sprintf("`--el-%s`", unknown), collapse = ", "),
        ". They are listed in its stylesheet's :root.",
        call. = FALSE
      )
    }
    vars[names(extra)] <- as.character(extra)
  }
  vars
}

#' Element Plus's theme variables, by name
#' @return Names, without the `--el-` prefix.
#' @keywords internal
.el_known_vars <- function() {
  css <- paste(
    readLines(
      system.file(
        "element-plus",
        "theme-chalk",
        "index.css",
        package = "shiny.element"
      ),
      warn = FALSE
    ),
    collapse = ""
  )
  found <- regmatches(
    css,
    gregexpr("--el-[A-Za-z0-9_-]+(?=:)", css, perl = TRUE)
  )[[1]]
  sort(unique(sub("^--el-", "", found)))
}

#' Element Plus's variables, set for a theme
#'
#' @param vars Output of [.el_element_vars()].
#' @return An htmlDependency holding the `<style>`, or `NULL` when nothing
#'   changes.
#' @keywords internal
.el_themed_dependency <- function(vars) {
  if (!length(vars)) {
    return(NULL)
  }
  brand <- grepl(
    "^color-(primary|success|warning|danger|error|info)$",
    names(vars)
  )
  light <- unlist(Map(
    function(name, value, is_brand) {
      out <- sprintf("--el-%s: %s;", name, value)
      if (is_brand) {
        for (l in c(3, 5, 7, 8, 9)) {
          out <- c(
            out,
            sprintf(
              "--el-%s-light-%d: %s;",
              name,
              l,
              .el_mix(value, "#ffffff", l / 10)
            )
          )
        }
        out <- c(
          out,
          sprintf("--el-%s-dark-2: %s;", name, .el_mix(value, "#000000", 0.2))
        )
      }
      out
    },
    names(vars),
    unname(vars),
    brand
  ))
  # Element Plus's dark mode mixes the tints against its dark background
  dark <- unlist(Map(
    function(name, value) {
      c(
        vapply(
          c(3, 5, 7, 8, 9),
          function(l) {
            sprintf(
              "--el-%s-light-%d: %s;",
              name,
              l,
              .el_mix(value, "#141414", l / 10)
            )
          },
          ""
        ),
        sprintf("--el-%s-dark-2: %s;", name, .el_mix(value, "#ffffff", 0.2))
      )
    },
    names(vars)[brand],
    unname(vars)[brand]
  ))
  css <- paste0(
    ":root {",
    paste(light, collapse = " "),
    "}",
    if (length(dark)) paste0(" html.dark {", paste(dark, collapse = " "), "}")
  )
  stamp <- sum(utf8ToInt(css) * seq_len(nchar(css))) %% 999983
  htmltools::htmlDependency(
    name = "element-plus-theme",
    version = paste0("1.0.", stamp),
    src = system.file("element-plus", package = "shiny.element"),
    head = paste0("<style>", css, "</style>"),
    all_files = FALSE
  )
}
