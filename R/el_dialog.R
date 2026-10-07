#' Element Plus Dialog
#'
#' A modal dialog.
#'
#' Rendered as plain markup carrying Element Plus's own classes, driven by a
#' Shiny input binding rather than a Vue instance, so the body can hold other
#' components from this package.
#'
#' @param id Dialog ID. Auto-generated UUID if `NULL`.
#' @param title Header text. `""` renders the header bar without a title.
#' @param content Dialog body. Any tag or tagList, including this package's
#'   own components.
#' @param footer Footer content, usually buttons. `NULL` for none.
#' @param visible Whether it starts open: Element Plus's `model-value`.
#' @param width Dialog width, e.g. `"50%"` or `"600px"`.
#' @param top Distance from the top of the viewport. Ignored when
#'   `fullscreen = TRUE` or `align_center = TRUE`.
#' @param fullscreen Fill the viewport.
#' @param modal Show the backdrop.
#' @param modal_penetrable Let clicks through the backdrop to the page
#'   beneath, when `modal = FALSE`.
#' @param close_on_click_modal Close when the backdrop is clicked.
#' @param close_on_press_escape Close on Escape.
#' @param show_close Show the close button in the header.
#' @param close_icon The close button's icon, by name. Default `"Close"`.
#' @param center Centre the header and footer.
#' @param align_center Centre the dialog in the viewport, vertically too.
#' @param draggable Let the dialog be dragged by its header.
#' @param overflow With `draggable`, let it be dragged past the viewport.
#' @param lock_scroll Whether the page stops scrolling while it is open.
#' @param custom_class Extra class name for the panel.
#' @param modal_class,header_class,body_class,footer_class Extra class names
#'   for the backdrop, the header, the body and the footer.
#' @param append_to A CSS selector for where the overlay goes when it opens,
#'   so a container's `overflow` or `transform` cannot clip it. Its
#'   components keep working; they are moved, not re-created.
#' @param append_to_body `append_to = "body"`.
#' @param open_delay,close_delay Milliseconds to wait before opening and
#'   closing.
#' @param z_index The overlay's z-index, instead of the next one Element Plus
#'   hands out.
#' @param header_aria_level The title's `aria-level`. Default `"2"`.
#' @param transition The name of the transition it plays, instead of
#'   Element's `"dialog-fade"`.
#' @param destroy_on_close Re-create the content each time it opens, and remove
#'   it when it closes: inputs inside start from their initial values again.
#' @param before_close `htmltools::JS()` function `function(done)`, run when
#'   the user closes it -- by the cross, the backdrop or Escape; call `done()`
#'   to let it close.
#' @param session In `el_dialog()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_dialog()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @section Shiny inputs:
#' - `input$<id>` -- `TRUE` while the dialog is open, reported whenever it
#'   opens or closes, however that happens. Shiny routes an input binding's
#'   messages by element id, so the name matches the id, as it does for
#'   [el_tabs()] and [el_collapse()].
#' - `input$<id>_open`, `input$<id>_opened` -- fire as it opens, and once
#'   it has.
#' - `input$<id>_close`, `input$<id>_closed` -- likewise as it closes.
#' - `input$<id>_open_auto_focus`, `input$<id>_close_auto_focus` -- as focus
#'   moves into it on opening, and back on closing.
#'
#' @section Element methods:
#' Callable with [call_el()]: `resetPosition()` puts a dragged dialog back.
#'
#' @return An `htmltools` tag.
#'
#' @examples
#' el_dialog(
#'   "d1",
#'   title = "Confirm",
#'   content = shiny::tags$p("Are you sure?"),
#'   footer = el_button("ok", "OK", type = "primary")
#' )
#'
#' # The body can hold other components
#' el_dialog(
#'   "d2",
#'   title = "Filters",
#'   draggable = TRUE,
#'   content = shiny::tagList(el_input("q"), el_switch("live"))
#' )
#' @export
el_dialog <- function(
  id = NULL,
  title = "",
  content = NULL,
  footer = NULL,
  visible = FALSE,
  width = "50%",
  top = "15vh",
  fullscreen = FALSE,
  modal = TRUE,
  close_on_click_modal = TRUE,
  close_on_press_escape = TRUE,
  show_close = TRUE,
  center = FALSE,
  lock_scroll = TRUE,
  custom_class = NULL,
  append_to_body = FALSE,
  destroy_on_close = FALSE,
  before_close = NULL,
  modal_penetrable = FALSE,
  close_icon = NULL,
  align_center = FALSE,
  draggable = FALSE,
  overflow = FALSE,
  modal_class = NULL,
  header_class = NULL,
  body_class = NULL,
  footer_class = NULL,
  append_to = NULL,
  open_delay = NULL,
  close_delay = NULL,
  z_index = NULL,
  header_aria_level = "2",
  transition = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- .el_auto_id("el_dialog")
  }
  ns_id <- .el_ui_id(id, session)
  visible <- isTRUE(shiny::restoreInput(ns_id, visible))
  if (is.null(append_to) && isTRUE(append_to_body)) {
    append_to <- "body"
  }

  header <- shiny::tags$header(
    # Element pads a header with a close button, so a long title clears it
    class = paste(
      c("el-dialog__header", if (show_close) "show-close", header_class),
      collapse = " "
    ),
    shiny::tags$span(
      role = "heading",
      `aria-level` = header_aria_level,
      class = "el-dialog__title",
      title
    ),
    if (show_close) {
      shiny::tags$button(
        type = "button",
        `aria-label` = "Close",
        class = "el-dialog__headerbtn",
        if (is.null(close_icon)) {
          .el_close_icon("el-dialog__close")
        } else {
          el_icon(.el_icon_name(close_icon), class = "el-dialog__close")
        }
      )
    }
  )

  # Element Plus: the overlay (the mask) holds a full-screen box that holds
  # the panel; a click on that box, outside the panel, is a click on the mask
  htmltools::attachDependencies(
    shiny::tags$div(
      id = ns_id,
      class = paste(c("el-overlay", modal_class), collapse = " "),
      style = paste0(
        if (!visible) "display:none;",
        if (!modal) "background-color:transparent;",
        if (!modal && isTRUE(modal_penetrable)) "pointer-events:none;",
        if (!is.null(z_index)) sprintf("z-index:%s;", z_index)
      ),
      `data-el-overlay` = "dialog",
      `data-visible` = tolower(as.character(visible)),
      `data-modal` = tolower(as.character(modal)),
      `data-mask-close` = tolower(as.character(modal && close_on_click_modal)),
      `data-esc-close` = tolower(as.character(close_on_press_escape)),
      `data-lock-scroll` = tolower(as.character(lock_scroll)),
      `data-append-to` = append_to,
      `data-open-delay` = open_delay,
      `data-close-delay` = close_delay,
      `data-z-index` = z_index,
      `data-transition` = transition,
      `data-draggable` = if (isTRUE(draggable)) "true",
      `data-overflow` = if (isTRUE(overflow)) "true",
      `data-destroy-on-close` = tolower(as.character(destroy_on_close)),
      `data-before-close` = if (!is.null(before_close)) {
        as.character(before_close)
      },
      shiny::tags$div(
        class = paste(
          c(
            "el-overlay-dialog",
            if (!modal && isTRUE(modal_penetrable)) {
              "el-modal-dialog is-penetrable"
            }
          ),
          collapse = " "
        ),
        role = "dialog",
        `aria-modal` = "true",
        `aria-label` = if (is.character(title)) title,
        style = if (isTRUE(align_center)) "display:flex;",
        shiny::tags$div(
          class = paste(
            c(
              "el-dialog",
              if (fullscreen) "is-fullscreen",
              if (center) "el-dialog--center",
              if (isTRUE(align_center)) "is-align-center",
              if (isTRUE(draggable)) "is-draggable",
              custom_class
            ),
            collapse = " "
          ),
          tabindex = "-1",
          # as Element's use-dialog.ts: a fullscreen dialog takes its size
          # from is-fullscreen, which an inline width would override
          style = paste0(
            if (!fullscreen) sprintf("--el-dialog-width: %s;", width),
            if (!fullscreen && !isTRUE(align_center)) {
              sprintf(" --el-dialog-margin-top: %s;", top)
            },
            if (!modal && isTRUE(modal_penetrable)) " pointer-events:auto;"
          ),
          header,
          # Hidden rather than removed when closed, so a nested component stays
          # mounted between openings.
          shiny::tags$div(
            class = paste(c("el-dialog__body", body_class), collapse = " "),
            .el_overlay_content(content, destroy_on_close, visible)
          ),
          if (!is.null(footer)) {
            shiny::tags$footer(
              class = paste(
                c("el-dialog__footer", footer_class),
                collapse = " "
              ),
              footer
            )
          }
        )
      )
    ),
    el_overlay_dependency()
  )
}


#' @rdname el_dialog
#' @section Updating from the server:
#' Server-side update for [el_dialog()].
#'
#' `update_el_dialog()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_dialog(session, "confirm", visible = TRUE)
#'   })
#' }
#' @export
update_el_dialog <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visible = NULL,
  title = NULL,
  width = NULL
) {
  .el_check_session(session)
  msg <- list()
  if (!is.null(visible)) {
    msg$visible <- visible
  }
  if (!is.null(title)) {
    msg$title <- title
  }
  if (!is.null(width)) {
    msg$width <- width
  }
  session$sendInputMessage(id, msg)
  invisible(NULL)
}


#' Overlay Binding Dependency
#'
#' Shared by [el_dialog()] and [el_drawer()]: both are markup with a Shiny
#' input binding rather than Vue instances, and both need the same backdrop, scroll lock and
#' z-index stacking.
#'
#' @return An htmlDependency object.
#' @keywords internal
el_overlay_dependency <- function() {
  c(
    list(.el_jquery_dependency()),
    .el_plus_dependencies(),
    list(htmltools::htmlDependency(
      name = "el-overlay-binding",
      version = "1.0.0",
      src = system.file("js", package = "shiny.element"),
      script = "el-overlay-binding.js",
      all_files = FALSE
    ))
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
  if (!isTRUE(destroy)) {
    return(content)
  }
  htmltools::tagList(
    htmltools::tag("template", list(`data-el-pristine` = "true", content)),
    if (isTRUE(visible)) shiny::tags$div(`data-el-live` = "true", content)
  )
}
