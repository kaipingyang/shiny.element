#' Element UI Statistic
#'
#' A headline number with a title, and an optional prefix and suffix.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param value The number.
#' @param title Label above it.
#' @param prefix,suffix Text before and after the number, such as a currency
#'   symbol or a unit.
#' @param precision Decimal places to show.
#' @param decimal_separator Decimal point. Default `"."`.
#' @param group_separator Separator between digit groups, such as `","`.
#'   Element's default is none, so `26048` shows as it is.
#' @param rate How the digits are grouped, as a power of ten: `1000` (the
#'   default) makes groups of three, `10000` groups of four. It only has an
#'   effect with a `group_separator`.
#' @param value_style CSS for the number, as a string or a named list.
#' @param formatter `htmlwidgets::JS()` function `function(value)` returning
#'   the text to show, in place of Element's formatting.
#' @param time_indices Count down to `value` rather than show it. `value` is
#'   then the moment to count down to, a `POSIXct` or milliseconds since the
#'   epoch.
#' @param format How a countdown is shown, such as `"HH:mm:ss"`. Default
#'   `"HH:mm:ss:SSS"`.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `prefix`, `suffix`,
#'   `title`, `formatter`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @section Shiny inputs:
#' With `time_indices = TRUE`:
#' - `input$<id>_finish` -- fires when the countdown reaches zero.
#' - `input$<id>_change` -- the milliseconds left. Element raises this on every
#'   frame; it is sent at most once a second, which is as often as a server
#'   can usefully hear it.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `suspend()` -- pause or resume a countdown
#'
#' @return A Shiny UI element.
#' @examples
#' el_statistic("users", value = 26048, title = "Active users",
#'              group_separator = ",")
#' el_statistic("revenue", value = 1318.5, title = "Revenue", prefix = "$",
#'              precision = 2)
#'
#' # A countdown to an hour from now
#' el_statistic("sale", title = "Sale ends in", time_indices = TRUE,
#'              value = Sys.time() + 3600, format = "HH:mm:ss")
#' @export
el_statistic <- function(id = NULL,
                         value = 0,
                         title = NULL,
                         prefix = NULL,
                         suffix = NULL,
                         precision = NULL,
                         decimal_separator = NULL,
                         group_separator = NULL,
                         rate = NULL,
                         value_style = NULL,
                         formatter = NULL,
                         time_indices = FALSE,
                         format = NULL,
                         width = NULL,
                         slots = NULL,
                         session = NULL) {
  if (is.null(id)) id <- paste0("el_statistic_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    ":value"             = "value",
    ":title"             = .el_optional_bind("title"),
    ":prefix"            = .el_optional_bind("prefix"),
    ":suffix"            = .el_optional_bind("suffix"),
    ":precision"         = .el_optional_bind("precision"),
    ":decimal-separator" = .el_optional_bind("decimalSeparator"),
    ":group-separator"   = .el_optional_bind("groupSeparator"),
    ":rate"              = .el_optional_bind("rate"),
    ":value-style"       = .el_optional_bind("valueStyle"),
    ":formatter"         = .el_optional_bind("formatter"),
    ":time-indices"      = "timeIndices",
    ":format"            = .el_optional_bind("format")
  )
  events <- .el_event_bindings(ns_id, c("finish", "change"), shapes = list(
    finish = "function() { return true; }",
    change = paste0("function(ms) { var now = Date.now(); ",
                    "if (this._elLastChange && now - this._elLastChange < 1000) return undefined; ",
                    "this._elLastChange = now; return ms; }")
  ))
  attrs <- c(attrs, events$attrs)

  if (inherits(value, "POSIXt")) value <- as.numeric(value) * 1000

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-statistic", attrs),
    data   = list(
      value            = value,
      title            = .el_or_na(title),
      prefix           = .el_or_na(prefix),
      suffix           = .el_or_na(suffix),
      precision        = .el_or_na(precision),
      decimalSeparator = .el_or_na(decimal_separator),
      groupSeparator   = .el_or_na(group_separator),
      rate             = .el_or_na(rate),
      valueStyle       = .el_or_na(value_style),
      formatter        = .el_or_na(formatter),
      timeIndices      = time_indices,
      format           = .el_or_na(format)
    ),
    methods    = events$methods,
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Statistic
#'
#' Server-side update for [el_statistic()].
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
#'   observe({
#'     invalidateLater(5000)
#'     update_el_statistic(session, "users", value = count_active_users())
#'   })
#' }
#' @export
update_el_statistic <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL, title = NULL,
                                prefix = NULL, suffix = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(value))  msg$value  <- value
  if (!is.null(title))  msg$title  <- title
  if (!is.null(prefix)) msg$prefix <- prefix
  if (!is.null(suffix)) msg$suffix <- suffix
  .el_send_update(session, msg)
  invisible(NULL)
}


