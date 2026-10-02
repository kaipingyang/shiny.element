#' Element's colours, recoloured
#'
#' Element compiles its colours into its stylesheet: each of primary, success,
#' warning and danger as itself, nine tints towards white and one shade
#' towards black. Element's own site changes the theme colour by replacing
#' those eleven values in the stylesheet's text (its theme picker); this does
#' the same, once, in R, and serves the result in place of Element's.
#'
#' Only these four are recoloured. Element's `info` grey is the same value as
#' its secondary text colour, `#909399`, and the two cannot be told apart once
#' compiled -- recolouring one would recolour every hint and placeholder.
#'
#' @name el_colors
#' @keywords internal
NULL

# Element 2.15's defaults, from theme-chalk's common/var.scss
.el_default_colors <- c(primary = "#409EFF", success = "#67C23A",
                        warning = "#E6A23C", danger = "#F56C6C")

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

#' The Element colours a theme changes
#'
#' @param colors A [bslib::bs_theme()], or a named list or vector of
#'   `primary`, `success`, `warning`, `danger`.
#' @return A named character vector of the colours that differ from
#'   Element's, possibly empty.
#' @keywords internal
.el_theme_colors <- function(colors) {
  if (is.null(colors)) return(character(0))
  if (inherits(colors, "bs_theme")) {
    colors <- bslib::bs_get_variables(colors, names(.el_default_colors))
  }
  colors <- unlist(colors)
  unknown <- setdiff(names(colors), names(.el_default_colors))
  if (length(unknown)) {
    stop("Element's colours that can be changed are ",
         paste(sprintf('"%s"', names(.el_default_colors)), collapse = ", "),
         "; not ", paste(sprintf('"%s"', unknown), collapse = ", "), ".", call. = FALSE)
  }
  colors <- colors[!is.na(colors) & nzchar(colors)]
  # A Sass expression, or a colour name: whatever R can read as a colour
  hex <- vapply(colors, function(x) {
    rgb <- tryCatch(grDevices::col2rgb(x)[, 1], error = function(e) NULL)
    if (is.null(rgb)) stop(sprintf('"%s" is not a colour.', x), call. = FALSE)
    sprintf("#%02x%02x%02x", rgb[1], rgb[2], rgb[3])
  }, character(1))
  hex[tolower(hex) != tolower(.el_default_colors[names(hex)])]
}

#' Element's dependency, with its stylesheet recoloured
#'
#' Carries Element's script too, under Element's own name and a later
#' version, so that it replaces -- rather than joins -- the copy every
#' component brings. Written once per set of colours, to the session's
#' temporary directory.
#'
#' @param colors Output of [.el_theme_colors()].
#' @return An htmlDependency, or `NULL` when nothing changes.
#' @keywords internal
.el_recoloured_dependency <- function(colors) {
  if (!length(colors)) return(NULL)
  root <- system.file("element-ui", package = "shiny.element")
  key <- paste(names(colors), colors, sep = "=", collapse = ";")
  dir <- file.path(tempdir(), paste0("shiny.element-colors-",
                                     gsub("[^a-z0-9]", "", tolower(key))))
  if (!dir.exists(dir)) {
    dir.create(file.path(dir, "theme-chalk"), recursive = TRUE)
    file.copy(file.path(root, "index.js"), dir)
    file.copy(file.path(root, "theme-chalk", "display.css"), file.path(dir, "theme-chalk"))
    file.copy(file.path(root, "theme-chalk", "fonts"), file.path(dir, "theme-chalk"),
              recursive = TRUE)
    css <- paste(readLines(file.path(root, "theme-chalk", "index.css"), warn = FALSE),
                 collapse = "\n")
    old <- unlist(lapply(names(colors), function(n) .el_color_cluster(.el_default_colors[[n]])))
    new <- unlist(lapply(colors, .el_color_cluster))
    # Through placeholders, so a new colour that happens to equal an old one
    # is not replaced a second time
    for (i in seq_along(old)) {
      css <- gsub(paste0(old[i], "(?![0-9a-fA-F])"), sprintf("\001%d\001", i), css,
                  ignore.case = TRUE, perl = TRUE)
    }
    for (i in seq_along(new)) css <- gsub(sprintf("\001%d\001", i), new[i], css, fixed = TRUE)
    writeLines(css, file.path(dir, "theme-chalk", "index.css"))
  }
  htmltools::htmlDependency(
    name       = "element-ui",
    version    = "2.15.14.1",
    src        = dir,
    script     = "index.js",
    stylesheet = c("theme-chalk/index.css", "theme-chalk/display.css"),
    all_files  = TRUE,
    head       = .el_css_fixes()
  )
}
