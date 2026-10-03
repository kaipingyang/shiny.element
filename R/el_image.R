#' Element Plus Image
#'
#' An image with a fit mode, optional lazy loading, and an optional
#' full-screen preview.
#'
#' @param id Image ID. Auto-generated if `NULL`.
#' @param src Image URL.
#' @param fit How the image fills its box: `"fill"`, `"contain"`, `"cover"`,
#'   `"none"` or `"scale-down"`.
#' @param alt Alternative text.
#' @param lazy Whether to load the image only once it scrolls into view.
#' @param scroll_container CSS selector of the scrolling element to watch when
#'   `lazy = TRUE`. `NULL` watches the nearest scrollable parent.
#' @param preview_src_list Character vector of image URLs to show in a
#'   full-screen preview when the image is clicked.
#' @param z_index Stacking order of the preview. Default `2000`.
#' @param initial_index Which image of `preview_src_list` the preview opens
#'   on, 0-based.
#' @param width Component width, as a CSS unit.
#' @param close_on_press_escape Whether the image-viewer can be closed by
#'   pressing ESC. Element Plus's `close-on-press-escape` (boolean).
#' @param crossorigin Native attribute crossorigin. Element Plus's
#'   `crossorigin` ('' | 'anonymous' | 'use-credentials').
#' @param hide_on_click_modal When enabling preview, use this flag to control
#'   whether clicking on backdrop can exit preview mode. Element Plus's
#'   `hide-on-click-modal` (boolean).
#' @param infinite Whether the viewer preview is infinite. Element Plus's
#'   `infinite` (boolean).
#' @param loading Indicates how the browser should load the image, same as
#'   native. Element Plus's `loading` ('eager' | 'lazy').
#' @param max_scale The max scale of the image viewer zoom event. Element
#'   Plus's `max-scale` (number).
#' @param min_scale The min scale of the image viewer zoom event. Element
#'   Plus's `min-scale` (number).
#' @param preview_teleported Whether to append image-viewer to body. A nested
#'   parent element attribute transform should have this attribute set to
#'   `true`. Element Plus's `preview-teleported` (boolean).
#' @param referrerpolicy Native attribute referrerPolicy. Element Plus's
#'   `referrerpolicy` (string).
#' @param scale The preview image scale. Element Plus's `scale` (number).
#' @param show_progress Whether to display the preview image progress content.
#'   Element Plus's `show-progress` (boolean).
#' @param zoom_rate The zoom rate of the image viewer zoom event. Element
#'   Plus's `zoom-rate` (number).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>_load` -- fires when the image has loaded.
#' - `input$<id>_error` -- fires when it fails to.
#'
#' @return A Shiny UI element.
#' @examples
#' el_image("photo", src = "https://example.org/a.png", width = 200)
#' el_image("photo", src = "a.png", fit = "cover", lazy = TRUE)
#'
#' # Click to open a gallery
#' el_image(
#'   "photo",
#'   src = "a.png",
#'   preview_src_list = c("a.png", "b.png", "c.png")
#' )
#' @export
el_image <- function(
  id = NULL,
  src = NULL,
  fit = NULL,
  alt = NULL,
  lazy = NULL,
  scroll_container = NULL,
  preview_src_list = NULL,
  z_index = NULL,
  initial_index = NULL,
  close_on_press_escape = NULL,
  crossorigin = NULL,
  hide_on_click_modal = NULL,
  infinite = NULL,
  loading = NULL,
  max_scale = NULL,
  min_scale = NULL,
  preview_teleported = NULL,
  referrerpolicy = NULL,
  scale = NULL,
  show_progress = NULL,
  zoom_rate = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_choices("el_image", environment())
  if (is.null(id)) {
    id <- paste0("el_image_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    ":src" = .el_optional_bind("src"),
    ":fit" = .el_optional_bind("fit"),
    ":alt" = .el_optional_bind("alt"),
    ":lazy" = .el_optional_bind("lazy"),
    ":scroll-container" = .el_optional_bind("scrollContainer"),
    ":preview-src-list" = .el_optional_bind("previewSrcList"),
    ":z-index" = .el_optional_bind("zIndex"),
    ":initial-index" = .el_optional_bind("initialIndex")
  )
  events <- .el_event_bindings(
    ns_id,
    c("load", "error", "close", "show", "switch")
  )
  attrs <- c(attrs, events$attrs)

  el_widget(
    props = .el_props(list(
      close_on_press_escape = close_on_press_escape,
      crossorigin = crossorigin,
      hide_on_click_modal = hide_on_click_modal,
      infinite = infinite,
      loading = loading,
      max_scale = max_scale,
      min_scale = min_scale,
      preview_teleported = preview_teleported,
      referrerpolicy = referrerpolicy,
      scale = scale,
      show_progress = show_progress,
      zoom_rate = zoom_rate
    )),
    id = ns_id,
    markup = htmltools::tag("el-image", attrs),
    data = list(
      src = .el_or_na(src),
      fit = .el_or_na(fit),
      alt = .el_or_na(alt),
      lazy = .el_or_na(lazy),
      scrollContainer = .el_or_na(scroll_container),
      previewSrcList = if (is.null(preview_src_list)) {
        NA
      } else {
        as.list(preview_src_list)
      },
      zIndex = .el_or_na(z_index),
      initialIndex = .el_or_na(initial_index)
    ),
    methods = events$methods,
    width = width,
    slots = slots
  )
}


#' Update Element Plus Image
#'
#' Server-side update for [el_image()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Image ID (un-namespaced).
#' @param src,fit,preview_src_list New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$next_photo, {
#'     update_el_image(session, "photo", src = photo_url())
#'   })
#' }
#' @export
update_el_image <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  src = NULL,
  fit = NULL,
  preview_src_list = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(src)) {
    msg$src <- src
  }
  if (!is.null(fit)) {
    msg$fit <- fit
  }
  if (!is.null(preview_src_list)) {
    msg$previewSrcList <- as.list(preview_src_list)
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
