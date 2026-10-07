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
  if (!length(parts)) {
    return(NULL)
  }
  paste(sub(";\\s*$", "", parts), collapse = "; ")
}

#' Add gutter padding to a column
#'
#' Element Plus's Col reads `gutter` off its parent Row and emits the padding
#' inline, so the same has to happen here rather than through a CSS class.
#'
#' @param child A column tag, or any other child (returned untouched).
#' @param half Half the gutter width, in pixels.
#' @return The child with padding merged into its `style`.
#' @keywords internal
.el_col_gutter <- function(child, half) {
  if (!inherits(child, "shiny.tag")) {
    return(child)
  }
  child$attribs$style <- .el_style(
    child$attribs$style,
    sprintf("padding-left:%gpx", half),
    sprintf("padding-right:%gpx", half)
  )
  child
}

#' Element Plus Layout Row
#'
#' Emits `<div class="el-row">` directly rather than an `<el-row>` custom tag.
#' Nothing mounts a Vue instance over page-level markup, so a custom tag would
#' never be compiled and would render as an unstyled inline element; the
#' Element Plus stylesheet is already loaded, so the class name is all that is
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
#' @param tag HTML element to render, as Element's `tag`. Default `"div"`;
#'   `"ul"` and `"li"` suit a grid of list items.
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
#'   type = "flex",
#'   justify = "center",
#'   align = "middle",
#'   el_col(span = 8, "centred")
#' )
el_row <- function(
  ...,
  gutter = NULL,
  type = NULL,
  justify = NULL,
  align = NULL,
  tag = "div",
  class = NULL,
  style = NULL
) {
  .el_check_choices("el_row", environment())
  children <- list(...)
  is_flex <- identical(type, "flex")

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
  if (
    !is.null(gutter) &&
      !(is.numeric(gutter) && length(gutter) == 1L && !is.na(gutter))
  ) {
    stop("`gutter` must be a single number of pixels.", call. = FALSE)
  }
  if (!is.null(gutter) && gutter > 0) {
    half <- gutter / 2
    gutter_style <- c(
      sprintf("margin-left:-%gpx", half),
      sprintf("margin-right:-%gpx", half)
    )
    children <- lapply(children, .el_col_gutter, half = half)
  }

  htmltools::tag(
    tag,
    c(
      list(class = paste(classes, collapse = " ")),
      list(style = .el_style(gutter_style, style)),
      children
    )
  )
}

#' Element Plus Layout Column
#'
#' Emits `<div class="el-col el-col-N">` directly; see [el_row()] for why.
#'
#' @param ... Column content.
#' @param span Column span out of 24. Defaults to 24, as in Element Plus.
#' @param offset Columns to offset by.
#' @param push Columns to push right.
#' @param pull Columns to pull left.
#' @param xs,sm,md,lg,xl Responsive spans. Either a number (the span) or a
#'   list such as `list(span = 12, offset = 6)`.
#' @param tag HTML element to render, as Element's `tag`. Default `"div"`;
#'   `"ul"` and `"li"` suit a grid of list items.
#' @param class Extra CSS classes.
#' @param style Extra inline style.
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_col(span = 12, "half width")
#' el_col(span = 6, offset = 6, "quarter, pushed right")
#' el_col(xs = 24, sm = 12, md = 8, "responsive")
#' el_col(md = list(span = 12, offset = 6), "responsive with offset")
el_col <- function(
  ...,
  span = 24,
  offset = NULL,
  push = NULL,
  pull = NULL,
  xs = NULL,
  sm = NULL,
  md = NULL,
  lg = NULL,
  xl = NULL,
  tag = "div",
  class = NULL,
  style = NULL
) {
  classes <- c("el-col", sprintf("el-col-%s", span))

  for (nm in c("offset", "push", "pull")) {
    val <- get(nm)
    if (!is.null(val)) classes <- c(classes, sprintf("el-col-%s-%s", nm, val))
  }

  breakpoints <- list(xs = xs, sm = sm, md = md, lg = lg, xl = xl)
  for (bp in names(breakpoints)) {
    val <- breakpoints[[bp]]
    if (is.null(val)) {
      next
    }
    if (is.list(val)) {
      if (!is.null(val$span)) {
        classes <- c(classes, sprintf("el-col-%s-%s", bp, val$span))
      }
      for (nm in c("offset", "push", "pull")) {
        if (!is.null(val[[nm]])) {
          classes <- c(classes, sprintf("el-col-%s-%s-%s", bp, nm, val[[nm]]))
        }
      }
    } else {
      classes <- c(classes, sprintf("el-col-%s-%s", bp, val))
    }
  }

  htmltools::tag(
    tag,
    c(
      list(class = paste(c(classes, class), collapse = " ")),
      list(style = .el_style(style)),
      list(...)
    )
  )
}

#' Element Plus Page Wrapper with Theme Support
#'
#' Top-level page constructor that loads Element-UI, Vue, and layout CSS dependencies,
#' and supports both bslib/shiny themes and Element-UI layout CSS.
#'
#' Use this as the root UI function for your Shiny app. You can combine bslib layouts
#' (such as \code{page_sidebar}, \code{layout_columns}) and Element components (such as \code{el_button}).
#'
#' @param ... UI elements to include in the page body.
#' @param title Optional page title.
#' @param theme Bootstrap theme for the rest of the page: a
#'   [bslib::bs_theme()]. The default, [el_theme()], carries Element's own
#'   colours, font and sizes, so Shiny's inputs and outputs match the Element
#'   components beside them. `NULL` gives Shiny's plain Bootstrap 3.
#' @param theme_css Element's layout CSS, [el_layout_css_dependency()];
#'   `NULL` leaves it out.
#' @param offline Serve Element Plus from the copy bundled with this package
#'   rather than the unpkg CDN. See [element_plus_dependency()].
#' @param locale Language for Element Plus's built-in text -- pagination
#'   summaries, date-picker buttons, select placeholders. English by default,
#'   or `getOption("shiny.element.locale")` when set; `"zh-CN"` gives Element's
#'   own Simplified Chinese. See [el_locales()] for the rest.
#' @param dev Load Vue's development build (`vue.global.js`) instead of the
#'   production one. The production build strips every warning, which is why a template that
#'   fails to compile renders nothing and says nothing. Defaults to
#'   `getOption("shiny.vue.dev")` (or `shiny.element.dev`), `FALSE` unless
#'   set, so it can be turned on for a
#'   whole session without touching the UI code.
#' @inheritParams use_element
#'
#' @details
#' Element's layout (`el_container()`, `el_row()`, `el_col()`) and bslib's
#' (`page_sidebar()`, `layout_columns()`) each work here; nest one inside a
#' cell of the other rather than interleaving them.
#'
#' @return A Shiny UI element.
#'
#' @examples
#' el_page(
#'   title = "My app",
#'   el_input("name", value = "Ada"),
#'   el_button("go", "Submit", type = "primary")
#' )
#'
#' # English component text, and Vue's development build for debugging
#' el_page(locale = "en", dev = TRUE, el_input("name"))
#' @export
el_page <- function(
  ...,
  title = NULL,
  theme = el_theme(),
  theme_css = el_layout_css_dependency(),
  offline = TRUE,
  locale = getOption("shiny.element.locale", "en"),
  dev = .vue_dev(),
  size = NULL,
  z_index = NULL
) {
  deps <- c(
    list(.el_vue_dependency(dev = dev)),
    element_plus_dependency(offline = offline),
    # the bridge and Element's side of it, which checks for raw el$ tags
    # left outside any component -- a page may hold nothing else
    .el_vue_dependencies(),
    el_locale_dependency(locale),
    .el_config_dependency(size, z_index),
    # The theme's colours, and any Element variable it sets, on Element's own
    # components too: Element's stylesheet built for the theme
    list(el_feedback_dependency())
  )
  if (!is.null(theme_css) && !inherits(theme_css, "html_dependency")) {
    stop(
      "`theme_css` must be an htmlDependency, such as el_layout_css_dependency(), ",
      "or NULL.",
      call. = FALSE
    )
  }
  if (!is.null(theme_css)) {
    deps <- c(deps, list(theme_css))
  }

  # Given to fluidPage() rather than attached as dependencies, so that Shiny
  # knows the page's theme -- bslib::bs_themer() and session$setCurrentTheme()
  # work on it.
  page <- shiny::fluidPage(
    theme = theme,
    if (!is.null(title)) shiny::titlePanel(title),
    htmltools::attachDependencies(
      htmltools::tags$head(),
      deps
    ),
    # Element's colours: the page's theme, so they follow it live
    .el_theme_tag(theme),
    ...
  )
  # the theme it was given, for a page drawn inside another (the site's
  # screenshots) to take on
  attr(page, "el_page_theme") <- theme
  page
}
