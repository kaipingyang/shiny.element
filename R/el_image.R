#' Element UI Image
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
#' @param referrer_policy Value of the image's `referrerPolicy` attribute.
#' @param width Component width, as a CSS unit.
#' @param session Shiny session for module support.
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
#' el_image("photo",
#'   src = "a.png",
#'   preview_src_list = c("a.png", "b.png", "c.png")
#' )
#' @export
el_image <- function(id = NULL,
                     src = NULL,
                     fit = NULL,
                     alt = NULL,
                     lazy = NULL,
                     scroll_container = NULL,
                     preview_src_list = NULL,
                     z_index = NULL,
                     referrer_policy = NULL,
                     width = NULL,
                     session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) id <- paste0("el_image_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  attrs <- list(
    ":src"              = .el_optional_bind("src"),
    ":fit"              = .el_optional_bind("fit"),
    ":alt"              = .el_optional_bind("alt"),
    ":lazy"             = .el_optional_bind("lazy"),
    ":scroll-container" = .el_optional_bind("scrollContainer"),
    ":preview-src-list" = .el_optional_bind("previewSrcList"),
    ":z-index"          = .el_optional_bind("zIndex"),
    ":referrer-policy"  = .el_optional_bind("referrerPolicy")
  )
  events <- .el_event_bindings(ns_id, c("load", "error"))
  attrs <- c(attrs, events$attrs)

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-image", attrs),
    data   = list(
      src             = .el_or_na(src),
      fit             = .el_or_na(fit),
      alt             = .el_or_na(alt),
      lazy            = .el_or_na(lazy),
      scrollContainer = .el_or_na(scroll_container),
      previewSrcList  = if (is.null(preview_src_list)) NA else as.list(preview_src_list),
      zIndex          = .el_or_na(z_index),
      referrerPolicy  = .el_or_na(referrer_policy)
    ),
    methods    = events$methods,
    width      = width,
    dependency = el_image_handler_dependency()
  )
}


#' Update Element UI Image
#'
#' Server-side update for [el_image()].
#'
#' @param session Shiny session object.
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
update_el_image <- function(session, id, src = NULL, fit = NULL,
                            preview_src_list = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(src)) msg$src <- src
  if (!is.null(fit)) msg$fit <- fit
  if (!is.null(preview_src_list)) msg$previewSrcList <- as.list(preview_src_list)
  session$sendCustomMessage("updateElImage", msg)
  invisible(NULL)
}


#' @keywords internal
el_image_handler_dependency <- function() {
  .el_handler_dependency("image")
}
