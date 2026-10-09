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
#' @param session In `el_statistic()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_statistic()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @section Shiny inputs:
#' `el_statistic()` reports nothing. `el_countdown()`:
#'
#' `r .el_events_md("el_countdown")`
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
    id <- .el_auto_id("el_statistic")
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
#' @template events
#' @template on
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
  events = NULL,
  on = NULL,
  session = NULL
) {
  if (is.null(id)) {
    id <- .el_auto_id("el_countdown")
  }
  ns_id <- .el_ui_id(id, session)
  events <- .el_event_bindings(
    ns_id,
    "el_countdown",
    events,
    on = on,
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


#' @rdname el_statistic
#' @section Updating from the server:
#' Server-side update for [el_statistic()] and [el_countdown()].
#'
#' Every other argument of [el_statistic()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_statistic()` is called for its side effect and returns `NULL` invisibly.
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
  suffix = NULL,
  precision = NULL,
  decimal_separator = NULL,
  group_separator = NULL,
  value_style = NULL,
  formatter = NULL
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
  msg <- c(
    msg,
    .el_update_props(
      "el_statistic",
      Filter(
        Negate(is.null),
        list(
          precision = precision,
          decimal_separator = decimal_separator,
          group_separator = group_separator,
          value_style = value_style,
          formatter = formatter
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}

#' @rdname el_statistic
#' @section Updating a countdown:
#' `update_el_countdown()` changes the countdown from the server: every argument
#' of [el_countdown()] that can change once it is drawn, under the same name.
#' One left `NULL` stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_countdown()` is called for its side effect and returns `NULL` invisibly.
#' @export
update_el_countdown <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  title = NULL,
  prefix = NULL,
  suffix = NULL,
  format = NULL,
  value_style = NULL
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
  msg <- c(
    msg,
    .el_update_props(
      "el_countdown",
      Filter(Negate(is.null), list(format = format, value_style = value_style))
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
