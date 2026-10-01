#' Element UI's look, as a Bootstrap theme
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
#' @param version Bootstrap major version. Default `5`.
#'
#' @return A `bs_theme` object, for [el_page()]'s `theme` or any page that
#'   takes a bslib theme.
#'
#' @details
#' The values follow Element 2.15's `theme-chalk` variables:
#'
#' | Bootstrap | Element | value |
#' |---|---|---|
#' | `primary` | `$--color-primary` | `#409EFF` |
#' | `success` | `$--color-success` | `#67C23A` |
#' | `warning` | `$--color-warning` | `#E6A23C` |
#' | `danger` | `$--color-danger` | `#F56C6C` |
#' | `info`, `secondary` | `$--color-info` | `#909399` |
#' | `fg` | `$--color-text-primary` | `#303133` |
#' | `border-color` | `$--border-color-base` | `#DCDFE6` |
#' | `border-radius` | `$--border-radius-base` | `4px` |
#' | `font-size-base` | `$--font-size-base` | `14px` |
#' | input and button padding | `$--input-height`, `$--button-padding-*` | `40px` tall |
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
#' if (interactive()) {
#'   el_page(theme = el_theme(), shiny::actionButton("go", "Shiny's own button"))
#' }
#' @export
el_theme <- function(..., version = 5) {
  element <- list(
    version   = version,
    primary   = "#409EFF",
    secondary = "#909399",
    success   = "#67C23A",
    info      = "#909399",
    warning   = "#E6A23C",
    danger    = "#F56C6C",
    fg        = "#303133",
    bg        = "#FFFFFF",
    # Element's documentation font stack. Its own components declare no font
    # family, so this is the one they show in.
    base_font = bslib::font_collection(
      "Helvetica Neue", "Helvetica", "PingFang SC", "Hiragino Sans GB",
      "Microsoft YaHei", "Arial", "sans-serif"
    ),
    "font-size-base"          = "0.875rem",
    # Element's 40px controls: a 14px line with its padding and border.
    # bslib's defaults draw Shiny's inputs and buttons a size larger.
    "input-font-size"         = "0.875rem",
    "input-color"             = "#606266",
    "input-line-height"       = "1.5",
    "input-padding-y"         = "8.5px",
    "input-padding-x"         = "15px",
    "btn-font-size"           = "0.875rem",
    "btn-line-height"         = "1",
    "btn-padding-y"           = "12px",
    "btn-padding-x"           = "20px",
    "border-color"            = "#DCDFE6",
    "input-border-color"      = "#DCDFE6",
    "input-focus-border-color" = "#409EFF",
    "input-placeholder-color" = "#C0C4CC",
    "text-muted"              = "#909399",
    "border-radius"           = "4px",
    "border-radius-sm"        = "3px",
    "border-radius-lg"        = "4px",
    "headings-font-weight"    = "500",
    "min-contrast-ratio"      = "2"
  )
  if (version < 5) {
    # Bootstrap 3 and 4 have no min-contrast-ratio
    element[["min-contrast-ratio"]] <- NULL
  }
  do.call(bslib::bs_theme, utils::modifyList(element, list(...)))
}
