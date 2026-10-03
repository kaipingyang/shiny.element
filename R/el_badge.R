#' Element Plus Badge
#'
#' Wraps any content with a numeric badge or red dot in the top-right corner.
#' When used without content, renders a standalone badge element.
#'
#' @param ... Content to wrap (e.g. a button or icon).
#' @param value Badge value: number or string. Ignored when `is_dot = TRUE`.
#' @param max Maximum numeric value to display. When `value > max` the badge
#'   shows `"<max>+"`. Only applies when `value` is numeric.
#' @param is_dot Show a small dot instead of a number. Default `FALSE`.
#' @param hidden Whether to hide the badge. Default `FALSE`.
#' @param type Badge colour type: `NULL` (red, default), `"primary"`,
#'   `"success"`, `"warning"`, `"info"`, `"danger"`.
#' @param show_zero Whether a value of `0` is shown. Default `TRUE`.
#' @param color Background colour of the badge.
#' @param offset Offset of the badge, `c(x, y)` in pixels.
#' @param badge_style,badge_class Extra CSS -- a string or a named list -- and
#'   class names for the badge.
#' @param id Give the badge an id and [update_el_badge()] can change it -- a
#'   count of unread messages, say. A component inside is then folded into
#'   the badge's Vue instance, as for [el_tooltip()]: it keeps reporting, but
#'   is reached through [update_vue_data()] on the badge's id.
#'
#' @return An `htmltools` tag, or with an `id` a Shiny UI element.
#'
#' @examples
#' el_badge(el_button("btn1", "Messages"), value = 5)
#' el_badge(el_button("btn2", "Alerts"),   value = 200, max = 99)
#' el_badge(el_button("btn3", "Updates"),  is_dot = TRUE)
#'
#' # Updated from the server: update_el_badge(session, "unread", value = 7)
#' el_badge(el_button("inbox", "Inbox"), value = 3, id = "unread")
#'
#' @export
el_badge <- function(...,
                     value = NULL,
                     max = NULL,
                     is_dot = FALSE,
                     hidden = FALSE,
                     type = NULL,
                     id = NULL,
                     show_zero = TRUE,
                     color = NULL,
                     offset = NULL,
                     badge_style = NULL,
                     badge_class = NULL) {
  .el_check_choices("el_badge", environment())
  if (!is.null(id)) {
    content <- list(...)
    inner <- .el_absorb(if (length(content) == 1) content[[1]] else htmltools::tagList(...))
    own <- list(
      markup = NULL,
      data = list(badgeValue = .el_or_na(value), badgeMax = .el_or_na(max),
                  badgeIsDot = is_dot, badgeHidden = hidden, badgeType = .el_or_na(type)),
      methods = list(), watch = list(), computed = list(), mounted = NULL,
      dependencies = list()
    )
    merged <- .el_absorb_merge(own, inner)
    return(el_widget(
      id     = .el_ui_id(id, NULL),
      props  = .el_props(prefix = "badge", list(
        show_zero = show_zero, color = color, offset = offset,
        badge_style = badge_style, badge_class = badge_class)),
      markup = htmltools::tag("el-badge", c(list(
        ":value"  = .el_optional_bind("badgeValue"),
        ":max"    = .el_optional_bind("badgeMax"),
        ":is-dot" = "badgeIsDot",
        ":hidden" = "badgeHidden",
        ":type"   = .el_optional_bind("badgeType")), list(merged$markups[[2]]))),
      data = merged$data, methods = merged$methods, watch = merged$watch,
      computed = merged$computed, mounted = merged$mounted,
      dependency = merged$dependencies
    ))
  }
  # Compute display content in R (mirrors ElementUI's computed `content`)
  display_value <- if (is_dot) {
    NULL
  } else if (!is.null(value) && !is.null(max) && is.numeric(value) && is.numeric(max)) {
    if (value > max) paste0(max, "+") else as.character(value)
  } else if (!is.null(value)) {
    as.character(value)
  } else {
    NULL
  }

  # Element Plus hides a zero unless show_zero says otherwise
  if (!isTRUE(show_zero) && identical(as.character(value), "0")) display_value <- NULL
  show_sup <- !hidden && (is_dot || !is.null(display_value))

  sup_classes <- c(
    "el-badge__content",
    paste0("el-badge__content--", if (is.null(type)) "danger" else type),
    badge_class,
    if (length(list(...)) > 0) "is-fixed",
    if (is_dot) "is-dot"
  )

  sup_tag <- if (show_sup) {
    style <- paste0(
      if (!is.null(color)) sprintf("background-color:%s;", color),
      if (length(offset) == 2) sprintf("margin-right:%spx;margin-top:%spx;", -offset[1], offset[2]),
      if (is.character(badge_style)) badge_style
      else if (is.list(badge_style)) paste0(names(badge_style), ":", unlist(badge_style), ";", collapse = ""))
    sup_attrs <- list(class = paste(sup_classes, collapse = " "),
                      style = if (length(style) && nzchar(style)) style)
    do.call(shiny::tags$sup, c(sup_attrs, list(display_value)))
  }

  shiny::tags$div(class = "el-badge", ..., sup_tag)
}


#' Update Element UI Badge
#'
#' Server-side update for an [el_badge()] given an `id`.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Badge ID (un-namespaced).
#' @param value,max,is_dot,hidden,type New values; `NULL` leaves one
#'   unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observe(update_el_badge(session, "unread", value = unread_count(),
#'                           hidden = unread_count() == 0))
#' }
#' @export
update_el_badge <- function(session = shiny::getDefaultReactiveDomain(), id,
                            value = NULL, max = NULL, is_dot = NULL, hidden = NULL,
                            type = NULL) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(value))  msg$badgeValue  <- value
  if (!is.null(max))    msg$badgeMax    <- max
  if (!is.null(is_dot)) msg$badgeIsDot  <- is_dot
  if (!is.null(hidden)) msg$badgeHidden <- hidden
  if (!is.null(type))   msg$badgeType   <- type
  .el_send_update(session, msg)
  invisible(NULL)
}
