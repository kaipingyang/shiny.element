#' Element Plus Image Viewer
#'
#' A full-screen viewer for a list of images, with zoom and rotation.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param visible Whether it starts open. Open and close it later with
#'   [update_el_image_viewer()].
#' @param url_list Preview link list. Element Plus's `url-list` (`string[]`).
#' @param z_index Preview backdrop z-index. Element Plus's `z-index` (number /
#'   string).
#' @param initial_index The initial preview image index, less than or equal to
#'   the length of `url-list`. Element Plus's `initial-index` (number).
#' @param infinite Whether preview is infinite. Element Plus's `infinite`
#'   (boolean).
#' @param hide_on_click_modal Whether user can emit close event when clicking
#'   backdrop. Element Plus's `hide-on-click-modal` (boolean).
#' @param teleported Whether to append image itself to body. A nested parent
#'   element attribute transform should have this attribute set to `true`.
#'   Element Plus's `teleported` (boolean).
#' @param zoom_rate The zoom rate of the image viewer zoom event. Element
#'   Plus's `zoom-rate` (number).
#' @param scale The preview image scale. Element Plus's `scale` (number).
#' @param min_scale The min scale of the image viewer zoom event. Element
#'   Plus's `min-scale` (number).
#' @param max_scale The max scale of the image viewer zoom event. Element
#'   Plus's `max-scale` (number).
#' @param close_on_press_escape Whether the image-viewer can be closed by
#'   pressing ESC. Element Plus's `close-on-press-escape` (boolean).
#' @param show_progress Whether to display the preview image progress content.
#'   Element Plus's `show-progress` (boolean).
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `progress`, `toolbar`,
#'   `viewer-error`. A scoped slot is written with [template()].
#'
#' @template events
#' @template on
#' @section Shiny inputs:
#' `r .el_events_md("el_image_viewer")`
#'
#' @section Element methods:
#' Callable with [call_el()]: `setActiveItem()`.
#'
#' @return A Shiny UI element.
#' @export
el_image_viewer <- function(
  id = NULL,
  url_list = NULL,
  visible = FALSE,
  z_index = NULL,
  initial_index = NULL,
  infinite = NULL,
  hide_on_click_modal = NULL,
  teleported = NULL,
  zoom_rate = NULL,
  scale = NULL,
  min_scale = NULL,
  max_scale = NULL,
  close_on_press_escape = NULL,
  show_progress = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL
) {
  .el_check_choices("el_image_viewer", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_image_viewer")
  }
  ns_id <- .el_ui_id(id, NULL)
  events <- .el_event_bindings(
    ns_id,
    "el_image_viewer",
    events,
    on = on
  )
  # Element Plus's viewer is open while it is mounted: v-if stands for its
  # visibility, and closing it unmounts it and reports
  attrs <- c(list("v-if" = "visible", "@close" = "handleClose"), events$attrs)
  if (!is.null(url_list)) {
    url_list <- as.list(url_list)
  }
  el_widget(
    id = ns_id,
    markup = htmltools::tag("el-image-viewer", attrs),
    props = .el_props(list(
      url_list = url_list,
      z_index = z_index,
      initial_index = initial_index,
      infinite = infinite,
      hide_on_click_modal = hide_on_click_modal,
      teleported = teleported,
      zoom_rate = zoom_rate,
      scale = scale,
      min_scale = min_scale,
      max_scale = max_scale,
      close_on_press_escape = close_on_press_escape,
      show_progress = show_progress
    )),
    data = list(visible = visible),
    methods = c(
      events$methods,
      list(
        handleClose = JS(sprintf(
          paste0(
            "function() { this.visible = false; window.Shiny && Shiny.setInputValue && ",
            "Shiny.setInputValue('%s_close', true, {priority: 'event'}); }"
          ),
          ns_id
        ))
      )
    ),
    width = width,
    slots = slots
  )
}


#' @rdname el_image_viewer
#' @section Updating from the server:
#' Open or close an [el_image_viewer()], or give it other images.
#'
#' Every other argument of [el_image_viewer()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_image_viewer()` is called for its side effect and returns `NULL` invisibly.
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$show,
#'     update_el_image_viewer(session, "photos", visible = TRUE)
#'   )
#' }
#' @export
update_el_image_viewer <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visible = NULL,
  url_list = NULL,
  initial_index = NULL,
  z_index = NULL,
  infinite = NULL,
  hide_on_click_modal = NULL,
  teleported = NULL,
  zoom_rate = NULL,
  scale = NULL,
  min_scale = NULL,
  max_scale = NULL,
  close_on_press_escape = NULL,
  show_progress = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(visible)) {
    msg$visible <- visible
  }
  if (!is.null(url_list)) {
    msg$urlList <- as.list(url_list)
  }
  if (!is.null(initial_index)) {
    msg$initialIndex <- initial_index
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_image_viewer",
      Filter(
        Negate(is.null),
        list(
          z_index = z_index,
          infinite = infinite,
          hide_on_click_modal = hide_on_click_modal,
          teleported = teleported,
          zoom_rate = zoom_rate,
          scale = scale,
          min_scale = min_scale,
          max_scale = max_scale,
          close_on_press_escape = close_on_press_escape,
          show_progress = show_progress
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
