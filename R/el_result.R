#' Element UI Result
#'
#' The outcome of an operation: an icon, a title, a line of detail, and
#' what to do next.
#'
#' @param id Component ID. Auto-generated if `NULL`.
#' @param icon `"success"`, `"warning"`, `"info"` or `"error"`.
#' @param title Headline.
#' @param sub_title Detail under the headline.
#' @param ... What to do next, shown under the text -- usually buttons. A
#'   shiny.element component here is absorbed, not nested, and keeps
#'   reporting its inputs.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `icon`, `title`,
#'   `subTitle`, `extra`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#'
#' @return A Shiny UI element.
#' @examples
#' el_result("done", icon = "success", title = "Report submitted",
#'           sub_title = "It will be reviewed within a day",
#'           el_button("back", "Back to the list", type = "primary"))
#' @export
el_result <- function(id = NULL,
                      ...,
                      icon = NULL,
                      title = NULL,
                      sub_title = NULL,
                      width = NULL,
                      slots = NULL,
                      session = NULL) {
  if (is.null(id)) id <- paste0("el_result_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  own <- list(
    markup = NULL,
    data = list(
      resultIcon     = .el_or_na(icon),
      resultTitle    = .el_or_na(title),
      resultSubTitle = .el_or_na(sub_title)
    ),
    methods = list(), watch = list(), computed = list(), mounted = NULL,
    dependencies = list()
  )
  inners <- lapply(list(...), .el_absorb)
  merged <- do.call(.el_absorb_merge, c(list(own), inners))

  attrs <- list(
    ":icon"      = .el_optional_bind("resultIcon"),
    ":title"     = .el_optional_bind("resultTitle"),
    ":sub-title" = .el_optional_bind("resultSubTitle")
  )
  extra <- merged$markups[-1]
  children <- if (length(extra)) {
    list(htmltools::tag("template", list(slot = "extra", extra)))
  } else list()

  el_widget(
    id       = ns_id,
    markup   = htmltools::tag("el-result", c(attrs, children)),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    slots    = slots,
    dependency = c(el_result_handler_dependency(), merged$dependencies)
  )
}


#' Update Element UI Result
#'
#' Server-side update for [el_result()].
#'
#' @param session Shiny session object.
#' @param id Component ID (un-namespaced).
#' @param icon,title,sub_title New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$submit, {
#'     ok <- tryCatch({ save(); TRUE }, error = function(e) FALSE)
#'     update_el_result(session, "outcome",
#'                      icon = if (ok) "success" else "error",
#'                      title = if (ok) "Saved" else "Could not save")
#'   })
#' }
#' @export
update_el_result <- function(session, id, icon = NULL, title = NULL,
                             sub_title = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(icon))      msg$resultIcon     <- icon
  if (!is.null(title))     msg$resultTitle    <- title
  if (!is.null(sub_title)) msg$resultSubTitle <- sub_title
  session$sendCustomMessage("updateElResult", msg)
  invisible(NULL)
}


#' @keywords internal
el_result_handler_dependency <- function() {
  .el_handler_dependency("result")
}
