#' Merge inline style fragments
#'
#' [htmltools::tagAppendAttributes()] joins repeated `style` attributes with a
#' space, producing invalid CSS (`"color:red padding-left:10px"`), so style
#' fragments are assembled here instead.
#'
#' @param ... Style fragments; `NULL` entries are dropped.
#' @return A single `;`-separated style string, or `NULL` if nothing was given.
#' @keywords internal
.el_style <- function(...) {
  parts <- unlist(list(...))
  parts <- parts[!is.na(parts) & nzchar(parts)]
  if (!length(parts)) return(NULL)
  paste(sub(";\\s*$", "", parts), collapse = "; ")
}

#' Add gutter padding to a column
#'
#' Element UI's Col reads `gutter` off its parent Row and emits the padding
#' inline, so the same has to happen here rather than through a CSS class.
#'
#' @param child A column tag, or any other child (returned untouched).
#' @param half Half the gutter width, in pixels.
#' @return The child with padding merged into its `style`.
#' @keywords internal
.el_col_gutter <- function(child, half) {
  if (!inherits(child, "shiny.tag")) return(child)
  child$attribs$style <- .el_style(
    child$attribs$style,
    sprintf("padding-left:%gpx", half),
    sprintf("padding-right:%gpx", half)
  )
  child
}

#' Element UI Layout Row
#'
#' Emits `<div class="el-row">` directly rather than an `<el-row>` custom tag.
#' Nothing mounts a Vue instance over page-level markup, so a custom tag would
#' never be compiled and would render as an unstyled inline element; the
#' Element UI stylesheet is already loaded, so the class name is all that is
#' needed.
#'
#' @param ... Child columns ([el_col()]) or other content.
#' @param gutter Spacing between columns, in pixels.
#' @param type Set to `"flex"` for the flex layout, which `justify` and
#'   `align` require.
#' @param justify Flex horizontal alignment: `"start"` (default), `"center"`,
#'   `"end"`, `"space-between"` or `"space-around"`.
#' @param align Flex vertical alignment: `"top"` (default), `"middle"` or
#'   `"bottom"`.
#' @param class Extra CSS classes.
#' @param style Extra inline style.
#' @return A Shiny UI element.
#' @export
#' @examples
#' # Two equal columns with a 20px gutter
#' el_row(
#'   gutter = 20,
#'   el_col(span = 12, "left"),
#'   el_col(span = 12, "right")
#' )
#'
#' # Centred flex row
#' el_row(
#'   type = "flex", justify = "center", align = "middle",
#'   el_col(span = 8, "centred")
#' )
el_row <- function(..., gutter = NULL, type = NULL, justify = NULL,
                   align = NULL, class = NULL, style = NULL) {
  children <- list(...)
  is_flex  <- identical(type, "flex")

  classes <- c(
    "el-row",
    if (is_flex) "el-row--flex",
    # start / top are the defaults and have no class of their own.
    if (is_flex && !is.null(justify) && !identical(justify, "start")) {
      paste0("is-justify-", justify)
    },
    if (is_flex && !is.null(align) && !identical(align, "top")) {
      paste0("is-align-", align)
    },
    class
  )

  gutter_style <- NULL
  if (!is.null(gutter) && gutter > 0) {
    half <- gutter / 2
    gutter_style <- c(
      sprintf("margin-left:-%gpx", half),
      sprintf("margin-right:-%gpx", half)
    )
    children <- lapply(children, .el_col_gutter, half = half)
  }

  htmltools::tag("div", c(
    list(class = paste(classes, collapse = " ")),
    list(style = .el_style(gutter_style, style)),
    children
  ))
}

#' Element UI Layout Column
#'
#' Emits `<div class="el-col el-col-N">` directly; see [el_row()] for why.
#'
#' @param ... Column content.
#' @param span Column span out of 24. Defaults to 24, as in Element UI.
#' @param offset Columns to offset by.
#' @param push Columns to push right.
#' @param pull Columns to pull left.
#' @param xs,sm,md,lg,xl Responsive spans. Either a number (the span) or a
#'   list such as `list(span = 12, offset = 6)`.
#' @param class Extra CSS classes.
#' @param style Extra inline style.
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_col(span = 12, "half width")
#' el_col(span = 6, offset = 6, "quarter, pushed right")
#' el_col(xs = 24, sm = 12, md = 8, "responsive")
#' el_col(md = list(span = 12, offset = 6), "responsive with offset")
el_col <- function(..., span = 24, offset = NULL, push = NULL, pull = NULL,
                   xs = NULL, sm = NULL, md = NULL, lg = NULL, xl = NULL,
                   class = NULL, style = NULL) {
  classes <- c("el-col", sprintf("el-col-%s", span))

  for (nm in c("offset", "push", "pull")) {
    val <- get(nm)
    if (!is.null(val)) classes <- c(classes, sprintf("el-col-%s-%s", nm, val))
  }

  breakpoints <- list(xs = xs, sm = sm, md = md, lg = lg, xl = xl)
  for (bp in names(breakpoints)) {
    val <- breakpoints[[bp]]
    if (is.null(val)) next
    if (is.list(val)) {
      if (!is.null(val$span)) classes <- c(classes, sprintf("el-col-%s-%s", bp, val$span))
      for (nm in c("offset", "push", "pull")) {
        if (!is.null(val[[nm]])) {
          classes <- c(classes, sprintf("el-col-%s-%s-%s", bp, nm, val[[nm]]))
        }
      }
    } else {
      classes <- c(classes, sprintf("el-col-%s-%s", bp, val))
    }
  }

  htmltools::tag("div", c(
    list(class = paste(c(classes, class), collapse = " ")),
    list(style = .el_style(style)),
    list(...)
  ))
}

#' Element UI Page Wrapper with Theme Support
#'
#' Top-level page constructor that loads Element-UI, Vue, and layout CSS dependencies,
#' and supports both bslib/shiny themes and Element-UI layout CSS.
#'
#' Use this as the root UI function for your Shiny app. You can combine bslib layouts
#' (such as \code{page_sidebar}, \code{layout_columns}) and Element-UI widgets (such as \code{el_button}).
#'
#' @param ... UI elements to include in the page body.
#' @param title Optional page title.
#' @param theme Optional bslib or shiny theme object (e.g., \code{bs_theme()}) for Bootstrap styling.
#'   If provided, Bootstrap dependencies will be included.
#' @param theme_css Optional Element-UI layout CSS dependency (default: \code{el_layout_css_dependency()}).
#' @param offline Serve Element UI from the copy bundled with this package
#'   rather than the unpkg CDN. See [element_ui_dependency()].
#' @param locale Language for Element UI's built-in text -- pagination
#'   summaries, date-picker buttons and so on. `NULL` keeps its bundled
#'   Simplified Chinese; `"en"` is also bundled. See [el_locale_dependency()].
#' @param dev Load the development build of Vue instead of `vue.min.js`.
#'   The production build strips every warning, which is why a template that
#'   fails to compile renders nothing and says nothing. Defaults to
#'   `getOption("shiny.element.dev", FALSE)`, so it can be turned on for a
#'   whole session without touching the UI code.
#'   Set to \code{NULL} to disable Element-UI layout CSS.
#'
#' @details
#' The \code{el_page} function is designed to work with both bslib layouts and Element-UI widgets.
#' Do not mix Element-UI layout functions (\code{el_container}, \code{el_row}, \code{el_col}) with bslib layouts,
#' as they are not compatible. The Element-UI layout functions are experimental and may be deprecated in the future.
#'
#' @export
el_page <- function(
  ..., 
  title = NULL, 
  theme = bslib::bs_theme(version = 5, bootswatch = "minty"), 
  theme_css = el_layout_css_dependency(),
  offline = TRUE,
  locale = NULL,
  dev = getOption("shiny.element.dev", FALSE)
) {
  deps <- c(
    list(
      vueR::html_dependency_vue(minified = !dev),
      vue_handler_dependency(),
      element_ui_dependency(offline = offline)
    ),
    el_locale_dependency(locale),
    list(el_feedback_dependency())
  )
  if (!is.null(theme_css)) deps <- c(deps, list(theme_css))
  if (!is.null(theme)) deps <- c(deps, bslib::bs_theme_dependencies(theme))

  shiny::fluidPage(
    if (!is.null(title)) titlePanel(title),
    htmltools::attachDependencies(
      htmltools::tags$head(),
      deps
    ),
    ...
  )
}