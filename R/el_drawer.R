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
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tag.
#'
#' @section Shiny input:
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
    session               = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_drawer_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  vertical  <- direction %in% c("ttb", "btt")
  title_id  <- paste0(ns_id, "-title")

  header <- if (with_header) {
    shiny::tags$header(
      id = title_id, class = "el-drawer__header",
      shiny::tags$span(role = "heading", tabindex = "0", title = title, title),
      if (show_close) {
        shiny::tags$button(
          `aria-label` = paste("close", title), type = "button",
          class = "el-drawer__close-btn",
          shiny::tags$i(class = "el-dialog__close el-icon el-icon-close")
        )
      }
    )
  }

  htmltools::attachDependencies(
    shiny::tags$div(
      id    = ns_id,
      tabindex = "-1",
      class = "el-drawer__wrapper",
      style = if (!visible) "display:none",
      `data-el-overlay` = "true",
      `data-visible`    = tolower(as.character(visible)),
      `data-modal`      = tolower(as.character(modal)),
      `data-mask-close` = tolower(as.character(modal && wrapper_closable)),
      `data-esc-close`  = tolower(as.character(close_on_press_escape)),
      shiny::tags$div(
        role = "document", tabindex = "-1",
        # el-drawer__open is what triggers the slide-in; the binding adds it.
        class = paste(c("el-drawer__container",
                        if (visible) "el-drawer__open"), collapse = " "),
        shiny::tags$div(
          `aria-modal` = "true", `aria-labelledby` = title_id,
          `aria-label` = title, role = "dialog", tabindex = "-1",
          class = paste("el-drawer", direction),
          style = sprintf("%s: %s;", if (vertical) "height" else "width", size),
          header,
          shiny::tags$section(class = "el-drawer__body", content)
        )
      )
    ),
    el_overlay_dependency()
  )
}


#' Update Element UI Drawer
#'
#' Server-side update for [el_drawer()].
#'
#' @param session Shiny session object.
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
update_el_drawer <- function(session, id, visible = NULL, title = NULL,
                             size = NULL) {
  msg <- list()
  if (!is.null(visible)) msg$visible <- visible
  if (!is.null(title))   msg$title   <- title
  if (!is.null(size))    msg$size    <- size
  session$sendInputMessage(id, msg)
  invisible(NULL)
}
