#' Element Plus Drawer
#'
#' A panel that slides in from an edge of the viewport.
#'
#' Rendered as plain markup carrying Element Plus's own classes, driven by a
#' Shiny input binding rather than a Vue instance, so the body can hold other
#' components from this package.
#'
#' @param id Drawer ID. Auto-generated UUID if `NULL`.
#' @param title Header text.
#' @param content Drawer body. Any tag or tagList, including this package's
#'   own components.
#' @param footer Footer content, usually buttons. `NULL` for none.
#' @param visible Whether it starts open: Element Plus's `model-value`.
#' @param direction Edge it slides from: `"rtl"` (from the right, the
#'   default), `"ltr"`, `"ttb"` or `"btt"`.
#' @param size Width for a horizontal drawer, height for a vertical one.
#' @param resizable Let the drawer be resized by dragging its inner edge.
#' @param modal Show the backdrop.
#' @param modal_penetrable Let clicks through the backdrop to the page
#'   beneath, when `modal = FALSE`.
#' @param with_header Show the header bar.
#' @param show_close Show the close button in the header.
#' @param close_on_click_modal Close when the backdrop is clicked. (Element
#'   UI's `wrapper-closable`.)
#' @param close_on_press_escape Close on Escape.
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
#' @param destroy_on_close Re-create the content each time it opens, and remove
#'   it when it closes: inputs inside start from their initial values again.
#' @param before_close `htmltools::JS()` function `function(done)`, run when
#'   the user closes it -- by the cross, the backdrop or Escape; call `done()`
#'   to let it close.
#' @param session In `el_drawer()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_drawer()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @section Shiny inputs:
#' - `input$<id>` -- `TRUE` while the drawer is open, reported whenever it
#'   opens or closes, however that happens; see [el_dialog()].
#' - `input$<id>_open`, `input$<id>_opened` -- fire as it opens, and once
#'   it has.
#' - `input$<id>_close`, `input$<id>_closed` -- likewise as it closes.
#' - `input$<id>_open_auto_focus`, `input$<id>_close_auto_focus` -- as focus
#'   moves into it on opening, and back on closing.
#' - `input$<id>_resize_start`, `input$<id>_resize`, `input$<id>_resize_end`
#'   -- with `resizable`, the size in pixels as it is dragged.
#'
#' @section Element methods:
#' Callable with [call_el()]: `handleClose()` closes it the way the user
#' would, through `before_close` (`closeDrawer()`, Element UI's name, too).
#'
#' @return An `htmltools` tag.
#'
#' @examples
#' el_drawer("w1", title = "Settings", content = shiny::tags$p("Body"))
#'
#' # Sliding up from the bottom, holding other components
#' el_drawer(
#'   "w2",
#'   title = "Filters",
#'   direction = "btt",
#'   size = "40%",
#'   content = shiny::tagList(el_input("q"), el_switch("live"))
#' )
#' @export
el_drawer <- function(
  id = NULL,
  title = "",
  content = NULL,
  visible = FALSE,
  direction = "rtl",
  size = "30%",
  modal = TRUE,
  with_header = TRUE,
  show_close = TRUE,
  close_on_press_escape = TRUE,
  custom_class = NULL,
  append_to_body = FALSE,
  destroy_on_close = FALSE,
  before_close = NULL,
  footer = NULL,
  resizable = FALSE,
  modal_penetrable = FALSE,
  close_on_click_modal = TRUE,
  lock_scroll = TRUE,
  modal_class = NULL,
  header_class = NULL,
  body_class = NULL,
  footer_class = NULL,
  append_to = NULL,
  open_delay = NULL,
  close_delay = NULL,
  z_index = NULL,
  header_aria_level = "2",
  session = NULL
) {
  .el_check_choices("el_drawer", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_drawer")
  }
  ns_id <- .el_ui_id(id, session)
  visible <- isTRUE(shiny::restoreInput(ns_id, visible))
  if (is.null(append_to) && isTRUE(append_to_body)) {
    append_to <- "body"
  }

  vertical <- direction %in% c("ttb", "btt")
  title_id <- paste0(ns_id, "-title")

  header <- if (with_header) {
    shiny::tags$header(
      class = paste(c("el-drawer__header", header_class), collapse = " "),
      shiny::tags$span(
        id = title_id,
        role = "heading",
        `aria-level` = header_aria_level,
        class = "el-drawer__title",
        title
      ),
      if (show_close) {
        shiny::tags$button(
          `aria-label` = paste("close", title),
          type = "button",
          class = "el-drawer__close-btn",
          .el_close_icon("el-drawer__close")
        )
      }
    )
  }

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
      `data-el-overlay` = "drawer",
      `data-visible` = tolower(as.character(visible)),
      `data-modal` = tolower(as.character(modal)),
      `data-mask-close` = tolower(as.character(modal && close_on_click_modal)),
      `data-esc-close` = tolower(as.character(close_on_press_escape)),
      `data-lock-scroll` = tolower(as.character(lock_scroll)),
      `data-append-to` = append_to,
      `data-open-delay` = open_delay,
      `data-close-delay` = close_delay,
      `data-z-index` = z_index,
      `data-resizable` = if (isTRUE(resizable)) "true",
      `data-destroy-on-close` = tolower(as.character(destroy_on_close)),
      `data-before-close` = if (!is.null(before_close)) {
        as.character(before_close)
      },
      shiny::tags$div(
        `aria-modal` = "true",
        `aria-labelledby` = if (with_header) title_id,
        `aria-label` = if (is.character(title)) title,
        role = "dialog",
        tabindex = "-1",
        class = paste(
          c("el-drawer", direction, if (visible) "open", custom_class),
          collapse = " "
        ),
        style = paste0(
          sprintf("%s: %s;", if (vertical) "height" else "width", size),
          if (!modal && isTRUE(modal_penetrable)) " pointer-events:auto;"
        ),
        if (isTRUE(resizable)) shiny::tags$div(class = "el-drawer__dragger"),
        header,
        shiny::tags$div(
          class = paste(c("el-drawer__body", body_class), collapse = " "),
          .el_overlay_content(content, destroy_on_close, visible)
        ),
        if (!is.null(footer)) {
          shiny::tags$div(
            class = paste(c("el-drawer__footer", footer_class), collapse = " "),
            footer
          )
        }
      )
    ),
    el_overlay_dependency()
  )
}


#' @rdname el_drawer
#' @section Updating from the server:
#' Server-side update for [el_drawer()].
#'
#' `update_el_drawer()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_drawer(session, "settings", visible = TRUE)
#'   })
#' }
#' @export
update_el_drawer <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visible = NULL,
  title = NULL,
  size = NULL
) {
  .el_check_session(session)
  msg <- list()
  if (!is.null(visible)) {
    msg$visible <- visible
  }
  if (!is.null(title)) {
    msg$title <- title
  }
  if (!is.null(size)) {
    msg$size <- size
  }
  session$sendInputMessage(id, msg)
  invisible(NULL)
}
