#' Element Plus icon
#'
#' An icon from Element Plus's set, Font Awesome, or a plain tag. Follows the
#' same dispatch pattern as [shiny::icon()], with accessibility attributes
#' inspired by [bsicons::bs_icon()].
#'
#' Element Plus's icons are SVG components (`@element-plus/icons-vue`, bundled):
#' the tag is an `<i class="el-icon">` naming its icon, drawn by the page
#' wherever it lands -- inside a component or not.
#'
#' @param name Icon name, as Element Plus spells it -- `"Search"`,
#'   `"ArrowRight"` -- or in any of the forms that reach the same name:
#'   `"search"`, `"arrow-right"`, `"arrow right"`, and Element UI's
#'   `"el-icon-arrow-right"`.
#' @param size CSS size string (e.g. `"1.5em"`, `"20px"`), as Element Plus's
#'   `<el-icon size>`. `NULL` (default) follows the surrounding text.
#' @param color Icon colour, as Element Plus's `<el-icon color>`. `NULL`
#'   follows the surrounding text.
#' @param class Additional CSS class(es) to append.
#' @param title Accessible title string. When provided, it also drives `a11y`
#'   (see below).
#' @param a11y Accessibility mode. One of:
#'   \describe{
#'     \item{`"auto"` (default)}{`"deco"` when `title` is `NULL`, `"sem"` otherwise.}
#'     \item{`"deco"`}{Decorative icon: adds `aria-hidden="true"` and `role="img"`.}
#'     \item{`"sem"`}{Semantic icon: adds `aria-label` (using `title` or `name`)
#'       and `role="img"`.}
#'     \item{`"none"`}{No accessibility attributes added.}
#'   }
#' @param lib Icon library. One of:
#'   \describe{
#'     \item{`"element-plus"` (default)}{Element Plus's icon set.}
#'     \item{`"font-awesome"`}{Delegates to [fontawesome::fa_i()]. Requires the
#'       `fontawesome` package.}
#'     \item{`"none"`}{Renders a plain `<i>` tag with no icon class.}
#'   }
#' @param ... Additional HTML attributes passed to the `<i>` tag.
#'
#' @return An `htmltools` tag object.
#'
#' @examples
#' el_icon("Search")
#' el_icon("edit", size = "1.5em")
#' el_icon("Delete", title = "Delete item", color = "#f56c6c")
#' el_icon("close", a11y = "deco")
#' @export
el_icon <- function(
  name,
  size = NULL,
  class = NULL,
  title = NULL,
  a11y = c("auto", "deco", "sem", "none"),
  lib = c("element-plus", "font-awesome", "none"),
  ...,
  color = NULL
) {
  if (identical(lib, "element-ui")) {
    lib <- "element-plus"
  }
  lib <- match.arg(lib)
  a11y <- match.arg(a11y)

  switch(
    lib,

    "element-plus" = {
      icon <- .el_icon_pascal(name)
      if (a11y == "auto") {
        a11y <- if (is.null(title)) "deco" else "sem"
      }
      a11y_attrs <- switch(
        a11y,
        deco = list(`aria-hidden` = "true", role = "img"),
        sem = list(
          `aria-label` = if (is.null(title)) icon else title,
          role = "img"
        ),
        list()
      )
      style_val <- paste0(
        if (!is.null(size)) {
          paste0("font-size:", htmltools::validateCssUnit(size), ";")
        },
        if (!is.null(color)) paste0("--color:", color, ";")
      )
      do.call(
        shiny::tags$i,
        c(
          list(
            class = paste(c("el-icon", class), collapse = " "),
            `data-el-icon` = icon
          ),
          if (length(style_val) && nzchar(style_val)) list(style = style_val),
          if (!is.null(title)) list(title = title),
          a11y_attrs,
          list(...)
        )
      )
    },

    "font-awesome" = {
      if (!requireNamespace("fontawesome", quietly = TRUE)) {
        stop(
          "Package 'fontawesome' is required for lib = 'font-awesome'. ",
          "Install it with: install.packages('fontawesome')"
        )
      }
      # size, colour and title as for an Element icon: Font Awesome's glyph
      # is text, sized by font-size and coloured by color
      style_val <- paste(
        c(
          if (!is.null(size)) {
            paste0("font-size:", htmltools::validateCssUnit(size), ";")
          },
          if (!is.null(color)) paste0("color:", color, ";")
        ),
        collapse = ""
      )
      do.call(
        fontawesome::fa_i,
        c(
          list(name = name, class = class),
          if (nzchar(style_val)) list(style = style_val),
          if (!is.null(title)) list(title = title),
          list(...)
        )
      )
    },

    "none" = {
      shiny::tags$i(class = class, ...)
    }
  )
}


#' An icon name in Element Plus's PascalCase
#'
#' @param name `"Search"`, `"search"`, `"arrow-right"`, `"arrow right"` or
#'   `"el-icon-arrow-right"`.
#' @return `"Search"`, `"ArrowRight"`.
#' @keywords internal
.el_icon_pascal <- function(name) {
  if (grepl("^[A-Z]", name)) {
    return(name)
  }
  .el_icon_name(paste0(
    "el-icon-",
    gsub("[[:space:]_]+", "-", sub("^el-icon-", "", tolower(name)))
  ))
}
