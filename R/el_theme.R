#' Element Plus's look, as a Bootstrap theme
#'
#' A [bslib::bs_theme()] carrying Element's own design tokens -- its blue,
#' its success, warning and danger colours, its greys, borders, 4px corners,
#' 14px type and font stack -- so that the Bootstrap side of a page, Shiny's
#' own inputs and outputs among it, matches the Element components next to
#' it. It is [el_page()]'s default.
#'
#' Element styles its components but not the page they sit on, and most of
#' its components set no font of their own: they inherit one. Under a
#' Bootswatch theme they inherit that theme's font instead of Element's,
#' while Element's sizes and colours stay -- a mix of the two looks.
#'
#' @param ... Overrides, passed on to [bslib::bs_theme()]: its own arguments
#'   (`primary = "#7c3aed"`, `base_font =`), or any Bootstrap Sass variable by
#'   name (`"font-size-base" = "1rem"`). An override replaces the Element
#'   value of the same name.
#' @param element Element Plus's own theme variables, as a named list --
#'   `list("border-radius-base" = "8px", "font-size-base" = "13px")` -- by
#'   their CSS variable names without the `--el-`. They are set on the page,
#'   as Element Plus's theming guide sets them.
#' @param version Bootstrap major version. Default `5`.
#'
#' @return A `bs_theme` object, for [el_page()]'s `theme` or any page that
#'   takes a bslib theme.
#'
#' @details
#' The values follow Element Plus's CSS variables:
#'
#' | Bootstrap | Element Plus | value |
#' |---|---|---|
#' | `primary` | `--el-color-primary` | `#409EFF` |
#' | `success` | `--el-color-success` | `#67C23A` |
#' | `warning` | `--el-color-warning` | `#E6A23C` |
#' | `danger` | `--el-color-danger` | `#F56C6C` |
#' | `info`, `secondary` | `--el-color-info` | `#909399` |
#' | `fg` | `--el-text-color-primary` | `#303133` |
#' | `border-color` | `--el-border-color` | `#DCDFE6` |
#' | `border-radius` | `--el-border-radius-base` | `4px` |
#' | `font-size-base` | `--el-font-size-base` | `14px` |
#'
#' `primary`, `success`, `warning`, `danger` and `info` reach Element's
#' components too, with the tints and shades Element derives from each, and
#' so does anything given to `element`: [el_page()] sets Element Plus's CSS
#' variables for the theme, as its theming guide does -- no build involved.
#'
#' Element puts white text on all five of its colours, some of which fall
#' short of Bootstrap's default minimum contrast; left alone, Bootstrap would
#' switch those buttons to black text. `min-contrast-ratio` is lowered so the
#' text stays white, as Element has it. Pass `"min-contrast-ratio" = 4.5` to
#' put contrast first.
#'
#' @examples
#' el_theme()
#'
#' # Element's look with another brand colour
#' el_theme(primary = "#7c3aed")
#'
#' # Rounder and smaller, all through Element
#' el_theme(
#'   element = list("border-radius-base" = "10px", "font-size-base" = "13px")
#' )
#'
#' if (interactive()) {
#'   el_page(theme = el_theme(), shiny::actionButton("go", "Shiny's own button"))
#' }
#' @export
el_theme <- function(..., element = NULL, version = 5) {
  bs <- list(
    version = version,
    primary = "#409EFF",
    secondary = "#909399",
    success = "#67C23A",
    info = "#909399",
    warning = "#E6A23C",
    danger = "#F56C6C",
    fg = "#303133",
    bg = "#FFFFFF",
    # Element's documentation font stack. Its own components declare no font
    # family, so this is the one they show in.
    base_font = bslib::font_collection(
      "Helvetica Neue",
      "Helvetica",
      "PingFang SC",
      "Hiragino Sans GB",
      "Microsoft YaHei",
      "Arial",
      "sans-serif"
    ),
    "font-size-base" = "0.875rem",
    # Element's 40px controls: a 14px line with its padding and border.
    # bslib's defaults draw Shiny's inputs and buttons a size larger.
    "input-font-size" = "0.875rem",
    "input-color" = "#606266",
    "input-line-height" = "1.5",
    "input-padding-y" = "8.5px",
    "input-padding-x" = "15px",
    "btn-font-size" = "0.875rem",
    "btn-line-height" = "1",
    "btn-padding-y" = "12px",
    "btn-padding-x" = "20px",
    "border-color" = "#DCDFE6",
    "input-border-color" = "#DCDFE6",
    "input-focus-border-color" = "#409EFF",
    "input-placeholder-color" = "#C0C4CC",
    "text-muted" = "#909399",
    "border-radius" = "4px",
    "border-radius-sm" = "3px",
    "border-radius-lg" = "4px",
    "headings-font-weight" = "500",
    "min-contrast-ratio" = "2"
  )
  if (version < 5) {
    # Bootstrap 3 and 4 have no min-contrast-ratio
    bs[["min-contrast-ratio"]] <- NULL
  }
  overrides <- list(...)
  # A focused input is ringed in the brand colour, as Element's are
  if (
    !is.null(overrides$primary) &&
      is.null(overrides[["input-focus-border-color"]])
  ) {
    overrides[["input-focus-border-color"]] <- overrides$primary
  }
  theme <- do.call(bslib::bs_theme, utils::modifyList(bs, overrides))
  if (length(element)) {
    # Checked now, so a misspelt variable fails where it was written
    .el_element_vars(element)
    attr(theme, "el_element") <- element
  }
  theme
}
