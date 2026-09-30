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
#' @param session Shiny session for module support.
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
      shiny::tags$div(
        role = "dialog", `aria-modal` = "true", `aria-label` = title,
        class = paste(c("el-dialog",
                        if (fullscreen) "is-fullscreen",
                        if (center) "el-dialog--center"), collapse = " "),
        style = if (!fullscreen) sprintf("margin-top: %s; width: %s;", top, width),
        header,
        # Hidden rather than removed when closed, so a nested component stays
        # mounted between openings.
        shiny::tags$div(class = "el-dialog__body", content),
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
