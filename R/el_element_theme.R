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
#' and `info`, which follow Bootstrap's CSS variables, and whatever was given to
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
    # Every brand colour is taken, even one equal to Element's: it is
    # linked to Bootstrap's CSS variable below, so a theme changed while the
    # app runs reaches it -- el_theme() gives Bootstrap Element's colours,
    # so the page looks the same until then
    for (n in names(bs)) {
      hex <- tryCatch(.el_hex(bs[[n]]), error = function(e) NA)
      if (!is.na(hex)) {
        vars[[paste0("color-", n)]] <- tolower(hex)
      }
    }
    extra <- attr(theme, "el_element")
  } else {
    extra <- theme
  }
  # colours taken from Bootstrap's: these follow its CSS variables, so a
  # theme changed while the app runs (session$setCurrentTheme(),
  # bs_themer()) reaches Element too
  from_bs <- names(vars)
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
    from_bs <- setdiff(from_bs, names(extra))
  }
  attr(vars, "from_bs") <- from_bs
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
#' @param live Whether the theme is the page's Bootstrap theme: its colours
#'   then follow Bootstrap's CSS variables, live; otherwise they are written
#'   out, and only those that differ from Element's.
#' @return An htmlDependency holding the `<style>`, or `NULL` when nothing
#'   changes.
#' @keywords internal
.el_themed_dependency <- function(vars, live = FALSE) {
  from_bs <- attr(vars, "from_bs")
  if (!isTRUE(live) && length(from_bs)) {
    # a theme that is not the page's: as Element ships, but for what it
    # changes
    keep <- !names(vars) %in% from_bs |
      tolower(vars) != .el_default_colors[sub("^color-", "", names(vars))]
    keep[is.na(keep)] <- TRUE
    from_bs <- intersect(from_bs, names(vars)[keep])
    vars <- vars[keep]
    attr(vars, "from_bs") <- if (isTRUE(live)) from_bs else character()
  }
  if (!length(vars)) {
    return(NULL)
  }
  brand <- grepl(
    "^color-(primary|success|warning|danger|error|info)$",
    names(vars)
  )
  # A colour Bootstrap's theme gave follows Bootstrap's CSS variable, and
  # its tints are mixed in the browser (color-mix(), as Sass's mix());
  # one given to Element alone is written out, its tints mixed here
  live <- isTRUE(live) & names(vars) %in% attr(vars, "from_bs")
  bs_name <- function(name) {
    sub("^color-", "", sub("^color-error$", "color-danger", name))
  }
  tint <- function(name, value, is_live, with, weight) {
    if (is_live) {
      sprintf(
        "color-mix(in srgb, var(--el-%s) %d%%, %s)",
        name,
        round((1 - weight) * 100),
        with
      )
    } else {
      .el_mix(value, with, weight)
    }
  }
  light <- unlist(Map(
    function(name, value, is_brand, is_live) {
      out <- sprintf(
        "--el-%s: %s;",
        name,
        if (is_live) {
          sprintf("var(--bs-%s, %s)", bs_name(name), value)
        } else {
          value
        }
      )
      if (is_brand) {
        for (l in c(3, 5, 7, 8, 9)) {
          out <- c(
            out,
            sprintf(
              "--el-%s-light-%d: %s;",
              name,
              l,
              tint(name, value, is_live, "#ffffff", l / 10)
            )
          )
        }
        out <- c(
          out,
          sprintf(
            "--el-%s-dark-2: %s;",
            name,
            tint(name, value, is_live, "#000000", 0.2)
          )
        )
      }
      out
    },
    names(vars),
    unname(vars),
    brand,
    live
  ))
  # Element Plus's dark mode mixes the tints against its dark background
  dark <- unlist(Map(
    function(name, value, is_live) {
      c(
        vapply(
          c(3, 5, 7, 8, 9),
          function(l) {
            sprintf(
              "--el-%s-light-%d: %s;",
              name,
              l,
              tint(name, value, is_live, "#141414", l / 10)
            )
          },
          ""
        ),
        sprintf(
          "--el-%s-dark-2: %s;",
          name,
          tint(name, value, is_live, "#ffffff", 0.2)
        )
      )
    },
    names(vars)[brand],
    unname(vars)[brand],
    live[brand]
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

#' Element's variables for a theme, decided when the page is drawn
#'
#' When `theme` is the page's own Bootstrap theme -- [el_page()] gives it to
#' the page, a bslib page function was given the same one -- Element's
#' colours follow Bootstrap's CSS variables, so a theme changed while the
#' app runs reaches them. Any other theme, or one drawn outside a page that
#' has it, is written out as it stands.
#'
#' @param theme A theme, or `NULL`.
#' @return A tag function giving the dependency, or `NULL`.
#' @keywords internal
.el_theme_tag <- function(theme) {
  if (is.null(theme)) {
    return(NULL)
  }
  # read once, now: reading a theme's variables compiles its Sass
  vars <- .el_element_vars(theme)
  htmltools::tagFunction(function() {
    current <- tryCatch(shiny::getCurrentTheme(), error = function(e) NULL)
    .el_themed_dependency(
      vars,
      live = !is.null(current) && identical(current, theme)
    )
  })
}
