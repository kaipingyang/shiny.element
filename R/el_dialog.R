#' Element UI Dialog
#'
#' A modal dialog.
#'
#' Rendered as plain markup carrying Element's own classes, driven by a Shiny
#' input binding rather than a Vue instance, so the body can hold other
#' components from this package. See `.claude/docs/lessons.md` §1.2.
#'
#' @param id Dialog ID. Auto-generated UUID if `NULL`.
#' @param title Header text. `""` renders the header bar without a title.
#' @param content Dialog body. Any tag or tagList, including this package's
#'   own components.
#' @param footer Footer content, usually buttons. `NULL` for none.
#' @param visible Whether it starts open.
#' @param width Dialog width, e.g. `"50%"` or `"600px"`.
#' @param top Distance from the top of the viewport. Ignored when
#'   `fullscreen = TRUE`.
#' @param fullscreen Fill the viewport.
#' @param modal Show the backdrop.
#' @param close_on_click_modal Close when the backdrop is clicked.
#' @param close_on_press_escape Close on Escape.
#' @param show_close Show the close button in the header.
#' @param center Centre the header and footer.
#' @param lock_scroll Whether the page stops scrolling while it is open.
#' @param custom_class Extra class name for the panel.
#' @param append_to_body Move the overlay to `<body>` when it opens, so a
#'   container's `overflow` or `transform` cannot clip it. Its components keep
#'   working; they are moved, not re-created.
#' @param modal_append_to_body Whether the backdrop goes on `<body>` (the
#'   default) or beside the overlay.
#' @param destroy_on_close Re-create the content each time it opens, and remove
#'   it when it closes: inputs inside start from their initial values again.
#' @param before_close `htmltools::JS()` function `function(done)`, run when
#'   the user closes it -- by the cross, the backdrop or Escape; call `done()`
#'   to let it close.
#' @param session Shiny session for module support.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- whether it is open.
#' - `input$<id>_open`, `input$<id>_opened` -- fire as it opens, and once
#'   it has.
#' - `input$<id>_close`, `input$<id>_closed` -- likewise as it closes.
#'
#' @return An `htmltools` tag.
#'
#' @section Shiny input:
#' `input$<id>` — `TRUE` while the dialog is open, reported whenever it opens
#' or closes, however that happens. (It was `input$<id>_visible` while this was
#' a Vue component; Shiny routes an input binding's messages by element id, so
#' the name now matches the id, as it does for [el_tabs()] and
#' [el_collapse()].)
#'
#' @examples
#' el_dialog("d1", title = "Confirm", content = shiny::tags$p("Are you sure?"),
#'           footer = el_button("ok", "OK", type = "primary"))
#'
#' # The body can hold other components
#' el_dialog("d2", title = "Filters",
#'           content = shiny::tagList(el_input("q"), el_switch("live")))
#'
#' @export
el_dialog <- function(
    id                    = NULL,
    title                 = "",
    content               = NULL,
    footer                = NULL,
    visible               = FALSE,
    width                 = "50%",
    top                   = "15vh",
    fullscreen            = FALSE,
    modal                 = TRUE,
    close_on_click_modal  = TRUE,
    close_on_press_escape = TRUE,
    show_close            = TRUE,
    center                = FALSE,
    lock_scroll           = TRUE,
    custom_class          = NULL,
    append_to_body        = FALSE,
    modal_append_to_body  = TRUE,
    destroy_on_close      = FALSE,
    before_close          = NULL,
    session               = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_dialog_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  header <- shiny::tags$div(
    class = "el-dialog__header",
    shiny::tags$span(class = "el-dialog__title", title),
    if (show_close) {
      shiny::tags$button(
        type = "button", `aria-label` = "Close", class = "el-dialog__headerbtn",
        shiny::tags$i(class = "el-dialog__close el-icon el-icon-close")
      )
    }
  )

  htmltools::attachDependencies(
    shiny::tags$div(
      id    = ns_id,
      class = "el-dialog__wrapper",
      style = if (!visible) "display:none",
      `data-el-overlay`  = "true",
      `data-visible`     = tolower(as.character(visible)),
      `data-modal`       = tolower(as.character(modal)),
      `data-mask-close`  = tolower(as.character(modal && close_on_click_modal)),
      `data-esc-close`   = tolower(as.character(close_on_press_escape)),
      `data-lock-scroll` = tolower(as.character(lock_scroll)),
      `data-append-to-body` = tolower(as.character(append_to_body)),
      `data-modal-append-to-body` = tolower(as.character(modal_append_to_body)),
      `data-destroy-on-close` = tolower(as.character(destroy_on_close)),
      `data-before-close` = if (!is.null(before_close)) as.character(before_close),
      shiny::tags$div(
        role = "dialog", `aria-modal` = "true",
        `aria-label` = if (is.character(title)) title,
        class = paste(c("el-dialog",
                        if (fullscreen) "is-fullscreen",
                        if (center) "el-dialog--center", custom_class), collapse = " "),
        style = if (!fullscreen) sprintf("margin-top: %s; width: %s;", top, width),
        header,
        # Hidden rather than removed when closed, so a nested component stays
        # mounted between openings.
        shiny::tags$div(class = "el-dialog__body",
                        .el_overlay_content(content, destroy_on_close, visible)),
        if (!is.null(footer)) shiny::tags$div(class = "el-dialog__footer", footer)
      )
    ),
    el_overlay_dependency()
  )
}


#' Update Element UI Dialog
#'
#' Server-side update for [el_dialog()].
#'
#' @param session Shiny session object.
#' @param id Dialog ID (un-namespaced).
#' @param visible Open or close it.
#' @param title New header text.
#' @param width New width.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_dialog(session, "confirm", visible = TRUE)
#'   })
#' }
#' @export
update_el_dialog <- function(session, id, visible = NULL, title = NULL,
                             width = NULL) {
  msg <- list()
  if (!is.null(visible)) msg$visible <- visible
  if (!is.null(title))   msg$title   <- title
  if (!is.null(width))   msg$width   <- width
  session$sendInputMessage(id, msg)
  invisible(NULL)
}


#' Overlay Binding Dependency
#'
#' Shared by [el_dialog()] and [el_drawer()]: both are Shiny input bindings
#' rather than htmlwidgets, and both need the same backdrop, scroll lock and
#' z-index stacking.
#'
#' @return An htmlDependency object.
#' @keywords internal
el_overlay_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-overlay-binding",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-overlay-binding.js",
    all_files = FALSE
  )
}


#' An overlay's content, kept for re-creation when it is destroyed on close
#'
#' With `destroy_on_close`, the content lives in an inert `<template>` and is
#' instantiated each time the overlay opens -- so its inputs start from their
#' initial values -- then unbound and removed when it closes. Shown from the
#' start, a live copy is rendered as well.
#'
#' @param content The overlay's content.
#' @param destroy Whether it is destroyed on close.
#' @param visible Whether the overlay starts open.
#' @return Markup.
#' @keywords internal
.el_overlay_content <- function(content, destroy, visible) {
  if (!isTRUE(destroy)) return(content)
  htmltools::tagList(
    htmltools::tag("template", list(`data-el-pristine` = "true", content)),
    if (isTRUE(visible)) shiny::tags$div(`data-el-live` = "true", content)
  )
}
