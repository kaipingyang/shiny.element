#' A page's theme, compiled once per machine rather than once per process
#'
#' Shiny draws a bslib theme with [bslib::bs_theme_dependencies()], which
#' compiles it with `sass()` into a file under [tempdir()]. sass keeps the CSS
#' in its cache across sessions (`~/.cache/R/sass`), but counts a file output
#' as cached only when the file is already there -- never in a new process --
#' so every R process compiled the page's theme again: 1.5 to 2 seconds before
#' its first page, for `el_theme()` or any theme but bslib's default (which
#' bslib ships precompiled).
#'
#' The page's theme is drawn with a cache standing in for sass's own: asked
#' whether it holds a key, it answers as sass's cache does and, holding it,
#' writes the CSS and the theme's files where that output goes. sass then
#' finds them there and compiles nothing. Should either package change how
#' it names or checks that output, sass finds nothing there and compiles, as
#' it always did.
#'
#' @name el_theme_cache
#' @keywords internal
NULL

#' The page's theme function, drawn with the cache
#'
#' `shiny::fluidPage(theme =)` puts the theme on the page as a tag function
#' calling [bslib::bs_theme_dependencies()]; it reads sass's cache from the
#' `sass.cache` option, set here while it runs.
#'
#' @param page A page from [shiny::fluidPage()].
#' @param theme The theme it was given.
#' @return The page.
#' @keywords internal
.el_page_theme_cached <- function(page, theme) {
  if (!inherits(theme, "bs_theme")) {
    return(page)
  }
  for (i in seq_along(page)) {
    f <- page[[i]]
    if (!inherits(f, "shiny.tag.function")) {
      next
    }
    # Shiny's own: its closure holds the theme
    if (!identical(environment(f)$theme, theme)) {
      next
    }
    page[[i]] <- htmltools::tagFunction(function() {
      cache <- .el_theme_cache(theme)
      if (is.null(cache)) {
        return(f())
      }
      old <- options(sass.cache = cache)
      on.exit(options(old), add = TRUE)
      f()
    })
    break
  }
  page
}

#' sass's cache, placing what it holds where sass's file output goes
#'
#' @param theme The page's theme.
#' @return An object sass takes for its cache (class `FileCache`), or
#'   `NULL` when sass's caching is off (`options(sass.cache = FALSE)`, Shiny's
#'   developer mode).
#' @keywords internal
.el_theme_cache <- function(theme) {
  base <- sass::sass_cache_get()
  if (is.null(base)) {
    return(NULL)
  }
  cache <- new.env(parent = emptyenv())
  cache$exists <- function(key) {
    if (!base$exists(key)) {
      return(FALSE)
    }
    .el_theme_place(base, key, theme)
    TRUE
  }
  cache$get_content <- function(key, ...) base$get_content(key, ...)
  cache$set_content <- function(key, content) base$set_content(key, content)
  cache$get_file <- function(key, ...) base$get_file(key, ...)
  cache$set_file <- function(key, ...) base$set_file(key, ...)
  class(cache) <- "FileCache"
  cache
}

#' A theme's CSS and files, written where its compiled output goes
#'
#' bslib compiles a theme to `bootstrap.min.css` in `tempdir()/bslib-<key>`,
#' the key being sass's; sass takes that file as already compiled when its
#' key is in `.sass_cache_keys` beside it.
#'
#' @param base sass's cache.
#' @param key The theme's key in it.
#' @param theme The theme, whose files (fonts) go beside the CSS, as
#'   `sass::as_sass_layer()` lists them: destination = source.
#' @return The output's directory, invisibly.
#' @keywords internal
.el_theme_place <- function(base, key, theme) {
  dir <- file.path(tempdir(), paste0("bslib-", key))
  out <- file.path(dir, "bootstrap.min.css")
  if (file.exists(out)) {
    return(invisible(dir))
  }
  attachments <- tryCatch(
    sass::as_sass_layer(theme)$file_attachments,
    error = function(e) character()
  )
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  css <- base$get_content(key)
  writeBin(charToRaw(enc2utf8(css)), out)
  # by position: two sources may share a destination ("fonts")
  for (i in seq_along(attachments)) {
    from <- attachments[[i]]
    target <- file.path(dir, names(attachments)[[i]])
    if (dir.exists(from)) {
      dir.create(target, showWarnings = FALSE, recursive = TRUE)
      file.copy(
        list.files(from, full.names = TRUE),
        target,
        recursive = TRUE
      )
    } else {
      dir.create(dirname(target), showWarnings = FALSE, recursive = TRUE)
      file.copy(from, target)
    }
  }
  cat(key, file = file.path(dir, ".sass_cache_keys"), append = TRUE)
  invisible(dir)
}
