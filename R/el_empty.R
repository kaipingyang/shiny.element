#' Element Plus Empty
#'
#' A placeholder for a view with nothing in it yet.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param description Text under the picture. `NULL` for Element's own
#'   ("No Data", in the page's locale).
#' @param image URL of a picture to use instead of Element's.
#' @param image_size Width of the picture, in pixels.
#' @param ... Content under the description -- usually a button that fixes the
#'   emptiness. A shiny.element component here is absorbed, not nested.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `image`, `description`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @return A Shiny UI element.
#' @examples
#' el_empty("none", description = "No reports yet")
#'
#' el_empty("none", description = "No reports yet",
#'          el_button("create", "Create one", type = "primary"))
#' @export
el_empty <- function(id = NULL,
                     ...,
                     description = NULL,
                     image = NULL,
                     image_size = NULL,
                     width = NULL,
                     slots = NULL,
                     session = NULL) {
  if (is.null(id)) id <- paste0("el_empty_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  own <- list(
    markup = NULL,
    data = list(
      emptyDescription = .el_or_na(description),
      emptyImage       = .el_or_na(image),
      emptyImageSize   = .el_or_na(image_size)
    ),
    methods = list(), watch = list(), computed = list(), mounted = NULL,
    dependencies = list()
  )
  inners <- lapply(list(...), .el_absorb)
  merged <- do.call(.el_absorb_merge, c(list(own), inners))

  attrs <- list(
    ":description" = .el_optional_bind("emptyDescription"),
    ":image"       = .el_optional_bind("emptyImage"),
    ":image-size"  = .el_optional_bind("emptyImageSize")
  )

  el_widget(
    id       = ns_id,
    markup   = htmltools::tag("el-empty", c(attrs, merged$markups[-1])),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    slots    = slots,
    dependency = merged$dependencies
  )
}


#' Update Element Plus Empty
#'
#' Server-side update for [el_empty()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Component ID (un-namespaced).
#' @param description,image New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$search, {
#'     update_el_empty(session, "none",
#'                     description = paste("Nothing matches", input$search))
#'   })
#' }
#' @export
update_el_empty <- function(session = shiny::getDefaultReactiveDomain(), id, description = NULL, image = NULL) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(description)) msg$emptyDescription <- description
  if (!is.null(image))       msg$emptyImage       <- image
  .el_send_update(session, msg)
  invisible(NULL)
}


