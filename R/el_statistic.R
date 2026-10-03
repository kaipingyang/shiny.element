#' Element Plus Statistic
#'
#' A headline number with a title, and an optional prefix and suffix.
#' `el_countdown()` counts down to a moment instead.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value The number; for `el_countdown()`, the moment to count down
#'   to, a `POSIXct` or milliseconds since the epoch.
#' @param title Label above it.
#' @param prefix,suffix Text before and after the number, such as a currency
#'   symbol or a unit.
#' @param precision Decimal places to show.
#' @param decimal_separator Decimal point. Default `"."`.
#' @param group_separator Separator between digit groups. Default `","`.
#' @param value_style CSS for the number, as a string or a named list.
#' @param formatter `JS()` function `function(value)` returning
#'   the text to show, in place of Element's formatting.
#' @param format How a countdown is shown, in day.js's tokens, such as
#'   `"HH:mm:ss"` (the default) or `"DD [days] HH:mm:ss"`.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `prefix`, `suffix`,
#'   `title`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @section Shiny inputs:
#' For `el_countdown()`:
#' - `input$<id>_finish` -- fires when the countdown reaches zero.
#' - `input$<id>_change` -- the milliseconds left. Element raises this on every
#'   frame; it is sent at most once a second, which is as often as a server
#'   can usefully hear it.
#'
#' @return A Shiny UI element.
#' @examples
#' el_statistic("users", value = 26048, title = "Active users")
#' el_statistic(
#'   "revenue",
#'   value = 1318.5,
#'   title = "Revenue",
#'   prefix = "$",
#'   precision = 2
#' )
#'
#' # A countdown to an hour from now
#' el_countdown(
#'   "sale",
#'   title = "Sale ends in",
#'   value = Sys.time() + 3600,
#'   format = "HH:mm:ss"
#' )
#' @export
el_statistic <- function(
  id = NULL,
  value = 0,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  precision = NULL,
  decimal_separator = NULL,
  group_separator = NULL,
  value_style = NULL,
  formatter = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- paste0("el_statistic_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, session)
  el_widget(
    id = ns_id,
    markup = htmltools::tag("el-statistic", list(":value" = "value")),
    props = .el_props(list(
      title = title,
      prefix = prefix,
      suffix = suffix,
      precision = precision,
      decimal_separator = decimal_separator,
      group_separator = group_separator,
      value_style = value_style,
      formatter = formatter
    )),
    data = list(value = value),
    width = width,
    slots = slots
  )
}


#' @rdname el_statistic
#' @export
el_countdown <- function(
  id = NULL,
  value = 0,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  format = NULL,
  value_style = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- paste0("el_countdown_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, session)
  events <- .el_event_bindings(
    ns_id,
    c("finish", "change"),
    shapes = list(
      finish = "function() { return true; }",
      change = paste0(
        "function(ms) { var now = Date.now(); ",
        "if (this._elLastChange && now - this._elLastChange < 1000) return undefined; ",
        "this._elLastChange = now; return ms; }"
      )
    )
  )
  if (inherits(value, "POSIXt")) {
    value <- as.numeric(value) * 1000
  }
  el_widget(
    id = ns_id,
    markup = htmltools::tag(
      "el-countdown",
      c(list(":value" = "value"), events$attrs)
    ),
    props = .el_props(list(
      title = title,
      prefix = prefix,
      suffix = suffix,
      format = .el_dayjs_format(format),
      value_style = value_style
    )),
    data = list(value = value),
    methods = events$methods,
    width = width,
    slots = slots
  )
}


#' Update Element Plus Statistic
#'
#' Server-side update for [el_statistic()] and [el_countdown()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Component ID (un-namespaced).
#' @param value,title,prefix,suffix New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observe(update_el_statistic(session, "users", value = n_users()))
#' }
#' @export
update_el_statistic <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  title = NULL,
  prefix = NULL,
  suffix = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (inherits(value, "POSIXt")) {
    value <- as.numeric(value) * 1000
  }
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(title)) {
    msg$title <- title
  }
  if (!is.null(prefix)) {
    msg$prefix <- prefix
  }
  if (!is.null(suffix)) {
    msg$suffix <- suffix
  }
  .el_send_update(session, msg)
  invisible(NULL)
}

#' @rdname update_el_statistic
#' @export
update_el_countdown <- update_el_statistic
