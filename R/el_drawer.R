#' Element UI Drawer
#'
#' A panel that slides in from the edge of the screen. Behaviour and API
#' mirror [el_dialog()] but with a directional slide animation.
#'
#' @param id Drawer ID. Auto-generated UUID if `NULL`.
#' @param title Drawer title text. Default `""`.
#' @param content Content for the drawer body (tag or tagList). `NULL` for
#'   empty.
#' @param visible Whether the drawer is initially visible. Default `FALSE`.
#' @param direction Slide direction: `"rtl"` (right-to-left, default),
#'   `"ltr"`, `"ttb"` (top-to-bottom), `"btt"`.
#' @param size Drawer width (horizontal) or height (vertical). Numeric pixels
#'   or CSS string. Default `"30%"`.
#' @param modal Whether to show a background overlay. Default `TRUE`.
#' @param with_header Whether to render the header bar. Default `TRUE`.
#' @param show_close Whether to show the × close button. Default `TRUE`.
#' @param wrapper_closable Whether clicking the overlay closes the drawer.
#'   Default `TRUE`.
#' @param close_on_press_escape Whether pressing Escape closes the drawer.
#'   Default `TRUE`.
#' @param destroy_on_close Whether to destroy child components on close.
#'   Default `FALSE`.
#' @param append_to_body Whether to append the drawer to `document.body`.
#'   Default `FALSE`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed drawer component.
#'
#' @section Shiny input:
#' `input$<id>_visible` — Logical (`TRUE` when the drawer opens, `FALSE`
#' when it closes).
#'
#' @examples
#' el_drawer("drw1", title = "Settings", content = shiny::tags$p("Settings here."))
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
    destroy_on_close      = FALSE,
    append_to_body        = FALSE,
    session               = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_drawer_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  drawer_attrs <- list(
    ":title"                 = "title",
    ":visible.sync"          = "visible",
    ":direction"             = "direction",
    ":size"                  = "size",
    ":modal"                 = "modal",
    ":with-header"           = "withHeader",
    ":show-close"            = "showClose",
    ":wrapper-closable"      = "wrapperClosable",
    ":close-on-press-escape" = "closeOnPressEscape",
    ":destroy-on-close"      = "destroyOnClose",
    ":append-to-body"        = "appendToBody",
    "@open"                  = "handleOpen",
    "@close"                 = "handleClose"
  )

  drawer_children <- list()
  if (!is.null(content)) drawer_children <- c(drawer_children, list(content))

  vue_data <- list(
    title              = title,
    visible            = visible,
    direction          = direction,
    size               = as.character(size),
    modal              = modal,
    withHeader         = with_header,
    showClose          = show_close,
    wrapperClosable    = wrapper_closable,
    closeOnPressEscape = close_on_press_escape,
    destroyOnClose     = destroy_on_close,
    appendToBody       = append_to_body
  )

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-drawer", c(drawer_attrs, drawer_children))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleOpen  = htmlwidgets::JS(sprintf(
            "function() { Shiny.setInputValue('%s_visible', true); }",
            ns_id
          )),
          handleClose = htmlwidgets::JS(sprintf(
            "function() { Shiny.setInputValue('%s_visible', false); this.visible = false; }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_drawer_handler_dependency())
}


#' Update Element UI Drawer
#'
#' Server-side update for [el_drawer()]. Use `visible = TRUE` to open and
#' `visible = FALSE` to close.
#'
#' @param session Shiny session object.
#' @param id Drawer ID (un-namespaced).
#' @param visible Logical. `TRUE` to open, `FALSE` to close.
#' @param title New drawer title.
#' @param size New drawer size.
#'
#' @export
update_el_drawer <- function(session, id, visible = NULL, title = NULL,
                             size = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(visible)) msg$visible <- visible
  if (!is.null(title))   msg$title   <- title
  if (!is.null(size))    msg$size    <- as.character(size)
  session$sendCustomMessage("updateElDrawer", msg)
}


#' @keywords internal
el_drawer_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-drawer-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-drawer-handler.js",
    all_files = FALSE
  )
}
