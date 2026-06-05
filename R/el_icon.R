#' Element UI icon tag
#'
#' Creates an icon tag supporting Element UI icons, Font Awesome, or plain tags.
#' Follows the same dispatch pattern as [shiny::icon()], with accessibility
#' attributes inspired by [bsicons::bs_icon()].
#'
#' @param name Icon name. For `lib = "element-ui"`, the `el-icon-` prefix is
#'   optional and will not be doubled (e.g. `"search"` and `"el-icon-search"`
#'   both work). Names are lowercased and spaces replaced with `-`.
#' @param size CSS size string (e.g. `"1.5em"`, `"20px"`). Applied as
#'   `font-size` on the `<i>` tag. `NULL` (default) leaves the size unset.
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
#'     \item{`"element-ui"` (default)}{Renders `<i class="el-icon-{name}">`.}
#'     \item{`"font-awesome"`}{Delegates to [fontawesome::fa_i()]. Requires the
#'       `fontawesome` package.}
#'     \item{`"none"`}{Renders a plain `<i>` tag with no icon class.}
#'   }
#' @param ... Additional HTML attributes passed to the `<i>` tag.
#'
#' @return An `htmltools` tag object.
#'
#' @examples
#' el_icon("search")
#' el_icon("edit", size = "1.5em")
#' el_icon("delete", title = "Delete item")
#' el_icon("close", a11y = "deco")
#'
#' @export
el_icon <- function(
    name,
    size  = NULL,
    class = NULL,
    title = NULL,
    a11y  = c("auto", "deco", "sem", "none"),
    lib   = c("element-ui", "font-awesome", "none"),
    ...
) {
  lib  <- match.arg(lib)
  a11y <- match.arg(a11y)

  switch(lib,

    "element-ui" = {
      # Normalize: lowercase, spaces -> dashes, strip accidental prefix
      name <- sub("\\s+", "-", tolower(name))
      name <- sub("^el-icon-", "", name)

      # Resolve auto a11y
      if (a11y == "auto") {
        a11y <- if (is.null(title)) "deco" else "sem"
      }

      # Accessibility attributes
      a11y_attrs <- switch(a11y,
        deco = list(`aria-hidden` = "true", role = "img"),
        sem  = list(`aria-label`  = if (is.null(title)) name else title,
                    role          = "img"),
        none = list(),
        list()
      )

      # Build full class string
      full_class <- paste(c(paste0("el-icon-", name), class), collapse = " ")

      # Build style
      style_val <- if (!is.null(size)) {
        paste0("font-size:", htmltools::validateCssUnit(size), ";")
      } else {
        NULL
      }

      do.call(
        shiny::tags$i,
        c(
          list(class = full_class),
          if (!is.null(style_val)) list(style = style_val),
          if (!is.null(title))    list(title = title),
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
      fontawesome::fa_i(name = name, class = class, ...)
    },

    "none" = {
      shiny::tags$i(class = class, ...)
    }
  )
}
