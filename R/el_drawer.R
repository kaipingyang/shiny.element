#' Element UI Drawer
#'
#' A panel that slides in from an edge of the viewport.
#'
#' Rendered as plain markup carrying Element's own classes, driven by a Shiny
#' input binding rather than a Vue instance, so the body can hold other
#' components from this package. See `.claude/docs/lessons.md` §1.2.
#'
#' @param id Drawer ID. Auto-generated UUID if `NULL`.
#' @param title Header text.
#' @param content Drawer body. Any tag or tagList, including this package's
#'   own components.
#' @param visible Whether it starts open.
#' @param direction Edge it slides from: `"rtl"` (from the right, the
#'   default), `"ltr"`, `"ttb"` or `"btt"`.
#' @param size Width for a horizontal drawer, height for a vertical one.
#' @param modal Show the backdrop.
#' @param with_header Show the header bar.
#' @param show_close Show the close button in the header.
#' @param wrapper_closable Close when the backdrop is clicked.
#' @param close_on_press_escape Close on Escape.
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
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- whether it is open.
#' - `input$<id>_open`, `input$<id>_opened` -- fire as it opens, and once
#'   it has.
#' - `input$<id>_close`, `input$<id>_closed` -- likewise as it closes.
#'
#' @return An `htmltools` tag.
#'
#' @section Shiny inputs:
#' `input$<id>` — `TRUE` while the drawer is open, reported whenever it opens
#' or closes, however that happens. (It was `input$<id>_visible` while this was
#' a Vue component; see [el_dialog()].)
#'
#' @examples
#' el_drawer("w1", title = "Settings", content = shiny::tags$p("Body"))
#'
#' # Sliding up from the bottom, holding other components
#' el_drawer("w2", title = "Filters", direction = "btt", size = "40%",
#'           content = shiny::tagList(el_input("q"), el_switch("live")))
#'
#' @export
el_drawer <- function(
    id                    = NULL,
    title                 = "",
    content               = NULL,
    visible               = FALSE,
    direction             = "rtl",
    size                  = "30%",
    modal                 = TRUE,
    with_header           = TRUE,
    show_close            = TRUE,
    wrapper_closable      = TRUE,
    close_on_press_escape = TRUE,
    custom_class          = NULL,
    append_to_body        = FALSE,
    modal_append_to_body  = TRUE,
    destroy_on_close      = FALSE,
    before_close          = NULL,
    session               = NULL
) {
  if (is.null(id)) id <- paste0("el_drawer_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)
  visible <- isTRUE(shiny::restoreInput(ns_id, visible))

  vertical  <- direction %in% c("ttb", "btt")
  title_id  <- paste0(ns_id, "-title")

  header <- if (with_header) {
    shiny::tags$header(
      class = "el-drawer__header",
      shiny::tags$span(id = title_id, role = "heading", class = "el-drawer__title",
                       title),
      if (show_close) {
        shiny::tags$button(
          `aria-label` = paste("close", title), type = "button",
          class = "el-drawer__close-btn",
          .el_close_icon("el-drawer__close")
        )
      }
    )
  }

  htmltools::attachDependencies(
    shiny::tags$div(
      id    = ns_id,
      class = "el-overlay",
      style = paste0(if (!visible) "display:none;", if (!modal) "background-color:transparent;"),
      `data-el-overlay` = "drawer",
      `data-visible`    = tolower(as.character(visible)),
      `data-modal`      = tolower(as.character(modal)),
      `data-mask-close` = tolower(as.character(wrapper_closable)),
      `data-esc-close`  = tolower(as.character(close_on_press_escape)),
      `data-lock-scroll` = "true",
      `data-append-to-body` = tolower(as.character(append_to_body)),
      `data-destroy-on-close` = tolower(as.character(destroy_on_close)),
      `data-before-close` = if (!is.null(before_close)) as.character(before_close),
      shiny::tags$div(
        `aria-modal` = "true", `aria-labelledby` = if (with_header) title_id,
        `aria-label` = if (is.character(title)) title, role = "dialog", tabindex = "-1",
        class = paste(c("el-drawer", direction, if (visible) "open", custom_class),
                      collapse = " "),
        style = sprintf("%s: %s;", if (vertical) "height" else "width", size),
        header,
        shiny::tags$div(class = "el-drawer__body",
                        .el_overlay_content(content, destroy_on_close, visible))
      )
    ),
    el_overlay_dependency()
  )
}


#' Update Element UI Drawer
#'
#' Server-side update for [el_drawer()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Drawer ID (un-namespaced).
#' @param visible Open or close it.
#' @param title New header text.
#' @param size New width or height.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_drawer(session, "settings", visible = TRUE)
#'   })
#' }
#' @export
update_el_drawer <- function(session = shiny::getDefaultReactiveDomain(), id, visible = NULL, title = NULL,
                             size = NULL) {
  .el_check_session(session)
  msg <- list()
  if (!is.null(visible)) msg$visible <- visible
  if (!is.null(title))   msg$title   <- title
  if (!is.null(size))    msg$size    <- size
  session$sendInputMessage(id, msg)
  invisible(NULL)
}
