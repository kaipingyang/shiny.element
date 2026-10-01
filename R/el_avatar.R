#' Element UI Avatar
#'
#' A user avatar, from an image, an icon, or text.
#'
#' @param id Avatar ID. Auto-generated if `NULL`.
#' @param content Text shown when there is no `src` or `icon`, such as initials.
#' @param src Image URL.
#' @param icon Element icon class, such as `"el-icon-user-solid"`.
#' @param size `"large"` (default), `"medium"`, `"small"`, or a number of pixels.
#' @param shape `"circle"` (default) or `"square"`.
#' @param fit How an image fills the avatar: `"cover"` (default), `"fill"`,
#'   `"contain"`, `"none"` or `"scale-down"`.
#' @param src_set Candidate image sources, as a `srcset` string.
#' @param alt Alternative text for the image.
#' @param width Component width, as a CSS unit.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Shiny inputs:
#' - `input$<id>_error` -- fires when the image fails to load.
#'
#' @return A Shiny UI element.
#' @examples
#' el_avatar("me", src = "https://example.org/face.png")
#' el_avatar("initials", content = "KY", shape = "square", size = 40)
#' el_avatar("anon", icon = "el-icon-user-solid")
#' @export
el_avatar <- function(id = NULL,
                      content = NULL,
                      src = NULL,
                      icon = NULL,
                      size = NULL,
                      shape = NULL,
                      fit = NULL,
                      src_set = NULL,
                      alt = NULL,
                      width = NULL,
                      slots   = NULL,
                      session = NULL) {
  .el_check_choices("el_avatar", environment())
  if (is.null(id)) id <- paste0("el_avatar_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  avatar_attrs <- list(
    ":src"     = .el_optional_bind("src"),
    ":icon"    = .el_optional_bind("icon"),
    ":size"    = .el_optional_bind("size"),
    ":shape"   = .el_optional_bind("shape"),
    ":fit"     = .el_optional_bind("fit"),
    ":src-set" = .el_optional_bind("srcSet"),
    ":alt"     = .el_optional_bind("alt")
  )
  events <- .el_event_bindings(ns_id, "error")
  avatar_attrs <- c(avatar_attrs, events$attrs)

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-avatar", c(avatar_attrs, list("{{content}}"))),
    data   = list(
      content = .el_or_na(content),
      src     = .el_or_na(src),
      icon    = .el_or_na(icon),
      size    = .el_or_na(size),
      shape   = .el_or_na(shape),
      fit     = .el_or_na(fit),
      srcSet  = .el_or_na(src_set),
      alt     = .el_or_na(alt)
    ),
    methods    = events$methods,
    width      = width,
    slots      = slots,
    dependency = el_avatar_handler_dependency()
  )
}


#' Update Element UI Avatar
#'
#' Server-side update for [el_avatar()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Avatar ID (un-namespaced).
#' @param content,src,icon,size,shape New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$sign_in, {
#'     update_el_avatar(session, "me", src = user_photo())
#'   })
#' }
#' @export
update_el_avatar <- function(session = shiny::getDefaultReactiveDomain(), id, content = NULL, src = NULL,
                             icon = NULL, size = NULL, shape = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(content)) msg$content <- content
  if (!is.null(src))     msg$src     <- src
  if (!is.null(icon))    msg$icon    <- icon
  if (!is.null(size))    msg$size    <- size
  if (!is.null(shape))   msg$shape   <- shape
  session$sendCustomMessage("updateElAvatar", msg)
  invisible(NULL)
}


#' @keywords internal
el_avatar_handler_dependency <- function() {
  .el_handler_dependency("avatar")
}
