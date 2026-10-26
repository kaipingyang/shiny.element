#' A slot's content, in Vue 3's syntax
#'
#' `<template v-slot:name>` -- Vue 3 has no `slot="name"` attribute, and an
#' element carrying one is rendered into the default slot instead.
#'
#' @param name The slot's name.
#' @param ... Its content.
#' @param scope The scope's name or destructuring, for a scoped slot.
#' @return A template tag.
#' @keywords internal
.vue_slot <- function(name, ..., scope = NULL) {
  htmltools::tag(
    "template",
    c(
      stats::setNames(
        list(if (is.null(scope)) NA else scope),
        paste0("v-slot:", name)
      ),
      list(...)
    )
  )
}

#' Markup as a string, for a `v-html` field
#'
#' A field read by `v-html` travels as JSON, where a tag would arrive as its
#' serialised object and show as text. Tags and tag lists are rendered to
#' their HTML first; a character value is taken as markup already.
#'
#' @param x A character string, tag, tag list or `HTML()`, or `NULL`.
#' @param arg The argument's name, for the error.
#' @return A single string, or `NULL`.
#' @keywords internal
.vue_html_string <- function(x, arg = "html") {
  if (is.null(x)) {
    return(NULL)
  }
  if (
    inherits(x, c("shiny.tag", "shiny.tag.list")) ||
      (is.list(x) && !is.data.frame(x))
  ) {
    return(as.character(htmltools::renderTags(x)$html))
  }
  if (is.character(x)) {
    return(paste(x, collapse = ""))
  }
  stop(
    "`",
    arg,
    "` must be a string of HTML or htmltools tags, not ",
    class(x)[1],
    ".",
    call. = FALSE
  )
}

#' Inline style for a component's Vue mount point
#'
#' Vue mounts onto the `<div id="<id>_container">` each component renders, but it
#' does not remove that div: it stays in the document as a block-level box.
#' Every component therefore started on its own line, so two buttons or two
#' tags could never sit side by side without wrapping them in a grid.
#'
#' `display: contents` makes the box itself generate no layout, leaving the
#' component to take part in the surrounding flow with its own display -- inline
#' for a button, block for an alert. The style is inline rather than in a
#' stylesheet so that leaving out a page's stylesheet cannot switch it off.
#'
#' @return A CSS declaration string.
#' @keywords internal
.vue_mount_style <- function() {
  "display: contents"
}
