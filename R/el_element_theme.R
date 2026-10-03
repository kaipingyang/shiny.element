#' Element's own stylesheet, themed
#'
#' Element compiles its look from Sass variables (`theme-chalk`'s
#' `common/var.scss`): `$--color-primary`, `$--border-radius-base`,
#' `$--font-size-base` and some five hundred more. A page whose theme changes
#' any of them gets Element's stylesheet built for it, served under Element's
#' own name at a later version, so it replaces -- rather than joins -- the copy
#' every component brings.
#'
#' Two ways to build it, as upstream has two:
#'
#' * Only the brand colours changed -- primary, success, warning, danger --
#'   the shipped stylesheet is recoloured in place, as Element's own theme
#'   picker does: each colour's eleven values (itself, nine tints, one shade)
#'   replaced. Instant, and byte for byte what Element's build would give.
#' * Anything else -- `info`, radii, sizes, fonts -- the bundled Sass sources
#'   are compiled with the variables set, as Element's theme tool does, by
#'   the sass package bslib already uses. About a second, once per theme and
#'   R session.
#'
#' @name el_element_theme
#' @keywords internal
NULL

# Element 2.15's defaults, from theme-chalk's common/var.scss
.el_default_colors <- c(primary = "#409EFF", success = "#67C23A",
                        warning = "#E6A23C", danger = "#F56C6C", info = "#909399")

#' A colour and the ten Element derives from it
#'
#' As Element's theme picker computes them, and Sass's `mix()` with them:
#' rounding half up, which R's `round()` does not.
#'
#' @param hex A colour, `"#RRGGBB"`.
#' @return Eleven lowercase hex colours: the colour, its tints at 10% to 90%
#'   towards white, and its 10% shade towards black.
#' @keywords internal
.el_color_cluster <- function(hex) {
  v <- grDevices::col2rgb(hex)[, 1]
  half_up <- function(x) floor(x + 0.5)
  as_hex <- function(x) sprintf("#%02x%02x%02x", x[1], x[2], x[3])
  tints <- vapply(1:9 / 10, function(t) as_hex(v + half_up(t * (255 - v))), character(1))
  c(as_hex(v), tints, as_hex(half_up(0.9 * v)))
}

#' A colour, as hex
#' @param x A colour R or Sass can read.
#' @return `"#rrggbb"`.
#' @keywords internal
.el_hex <- function(x) {
  rgb <- tryCatch(grDevices::col2rgb(x)[, 1], error = function(e) NULL)
  if (is.null(rgb)) stop(sprintf('"%s" is not a colour.', x), call. = FALSE)
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
#' @return A named character vector, names without the `$--` prefix.
#' @keywords internal
.el_element_vars <- function(theme) {
  if (is.null(theme)) return(character(0))
  vars <- character(0)
  if (inherits(theme, "bs_theme")) {
    bs <- unlist(bslib::bs_get_variables(theme, names(.el_default_colors)))
    bs <- bs[!is.na(bs) & nzchar(bs)]
    for (n in names(bs)) {
      hex <- tryCatch(.el_hex(bs[[n]]), error = function(e) NA)
      if (!is.na(hex) && tolower(hex) != tolower(.el_default_colors[[n]])) {
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
      stop("Element's variables must be named, as in `list(\"border-radius-base\" = \"8px\")`.",
           call. = FALSE)
    }
    names(extra) <- sub("^\\$?--", "", names(extra))
    known <- .el_known_vars()
    unknown <- setdiff(names(extra), known)
    if (length(unknown)) {
      stop("Element has no theme variable ",
           paste(sprintf("`$--%s`", unknown), collapse = ", "),
           ". They are listed in theme-chalk's common/var.scss.", call. = FALSE)
    }
    vars[names(extra)] <- as.character(extra)
  }
  vars
}

#' Element's theme variables, by name
#' @return Names, without the `$--` prefix.
#' @keywords internal
.el_known_vars <- function() {
  src <- readLines(file.path(.el_theme_src(), "common", "var.scss"), warn = FALSE)
  sub("^\\$--([A-Za-z0-9_-]+):.*$", "\\1", grep("^\\$--[A-Za-z0-9_-]+:", src, value = TRUE))
}

#' Element's dependency, with its stylesheet built for a theme
#'
#' @param vars Output of [.el_element_vars()].
#' @return An htmlDependency, or `NULL` when nothing changes.
#' @keywords internal
.el_themed_dependency <- function(vars) {
  if (!length(vars)) return(NULL)
  # Element Plus draws from CSS variables, --el-<name>: setting them is the
  # whole theme. A brand colour also sets the tints and shade Element's Sass
  # would have mixed from it.
  mix <- function(hex, with, weight) {
    a <- grDevices::col2rgb(hex)[, 1]; b <- grDevices::col2rgb(with)[, 1]
    m <- round(b * weight + a * (1 - weight))
    grDevices::rgb(m[1], m[2], m[3], maxColorValue = 255)
  }
  decl <- unlist(Map(function(name, value) {
    out <- sprintf("--el-%s: %s;", name, value)
    if (grepl("^color-(primary|success|warning|danger|info|error)$", name)) {
      for (l in c(3, 5, 7, 8, 9)) {
        out <- c(out, sprintf("--el-%s-light-%d: %s;", name, l, mix(value, "#ffffff", l / 10)))
      }
      out <- c(out, sprintf("--el-%s-dark-2: %s;", name, mix(value, "#000000", 0.2)))
    }
    out
  }, names(vars), unname(vars)))
  key <- paste(decl, collapse = "")
  stamp <- sum(utf8ToInt(key) * seq_len(nchar(key))) %% 999983
  htmltools::htmlDependency(
    name    = "element-plus-theme",
    version = paste0("1.0.", stamp),
    src     = system.file("element-plus", package = "shiny.element"),
    head    = paste0("<style>:root {", paste(decl, collapse = " "), "}</style>"),
    all_files = FALSE
  )
}

#' Recolour the shipped stylesheet
#' @param vars Brand colours, named `color-<name>`.
#' @return The stylesheet, as text.
#' @keywords internal
.el_recolour <- function(vars) {
  root <- system.file("element-ui", "theme-chalk", package = "shiny.element")
  css <- paste(readLines(file.path(root, "index.css"), warn = FALSE), collapse = "\n")
  names(vars) <- sub("^color-", "", names(vars))
  old <- unlist(lapply(names(vars), function(n) .el_color_cluster(.el_default_colors[[n]])))
  new <- unlist(lapply(vars, function(v) .el_color_cluster(.el_hex(v))))
  # Through placeholders, so a new colour that happens to equal an old one is
  # not replaced a second time
  for (i in seq_along(old)) {
    css <- gsub(paste0(old[i], "(?![0-9a-fA-F])"), sprintf("\001%d\001", i), css,
                ignore.case = TRUE, perl = TRUE)
  }
  for (i in seq_along(new)) css <- gsub(sprintf("\001%d\001", i), new[i], css, fixed = TRUE)
  css
}

#' Compile Element's Sass with variables set
#'
#' Element's variables are all `!default`, so setting them before its
#' sources are read is enough. Two of its mixins are rewritten in the bundled
#' copy -- they built a selector list with a trailing comma, which crashes the
#' libsass the sass package uses; the selectors they produce are unchanged.
#'
#' @param vars Element variables, names without `$--`.
#' @return The stylesheet, as text.
#' @keywords internal
.el_compile <- function(vars) {
  src <- .el_theme_src()
  # $B and $E are set !global by Element's b() and e() mixins; declared
  # first, as libsass asks, so it does not warn on every compile
  input <- paste0("$B: null;\n$E: null;\n",
                  paste0("$--", names(vars), ": ", vars, ";", collapse = "\n"),
                  "\n@import \"index\";\n")
  css <- suppressMessages(sass::sass(
    input, options = sass::sass_options(include_path = src, output_style = "compressed"),
    cache = FALSE
  ))
  as.character(css)
}

#' Element's theme Sass sources, unpacked
#'
#' They ship as one archive -- a fifth of the size of the files -- and are
#' unpacked once per R session, into its temporary directory.
#'
#' @return The directory holding `index.scss`.
#' @keywords internal
.el_theme_src <- function() {
  dir <- file.path(tempdir(), "shiny.element-theme-chalk-src")
  if (!file.exists(file.path(dir, "index.scss"))) {
    dir.create(dir, showWarnings = FALSE, recursive = TRUE)
    utils::untar(system.file("element-ui", "theme-chalk-src.tar.gz", package = "shiny.element"),
                 exdir = dir)
  }
  dir
}
