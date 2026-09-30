#' Element UI Popover
#'
#' A card shown on click or hover, with a title and body.
#'
#' @param id Popover ID. Auto-generated if `NULL`.
#' @param reference The element the popover hangs off. Markup only -- raw
#'   Element tags from [el], or ordinary Shiny UI. It cannot be another
#'   shiny.element component: the popover compiles this into its own Vue
#'   instance, which would discard a mounted one.
#' @param title Title of the card.
#' @param content Body text. For richer content pass `body`.
#' @param body Body markup, used instead of `content`. Markup only, as above.
#' @param trigger How it opens: `"click"` (default), `"focus"`, `"hover"` or
#'   `"manual"`.
#' @param placement Where it appears: `"bottom"` (default), `"top"`, `"left"`,
#'   `"right"`, each also with `-start` and `-end`.
#' @param popover_width Width of the card, in pixels. Element's own `width`
#'   prop, named apart from `width` so the two are not confused.
#' @param disabled Whether the popover is suppressed.
#' @param offset Offset from the reference, in pixels.
#' @param open_delay,close_delay Delays in milliseconds, for
#'   `trigger = "hover"`.
#' @param visible_arrow Whether to draw the little arrow. Default `TRUE`.
#' @param transition Name of the transition to animate with.
#' @param popper_class Extra class name for the card.
#' @param popper_options Additional Popper.js options, as a named list.
#' @param tabindex Tab index of the reference.
#' @param width Component width, as a CSS unit.
#' @param session Shiny session for module support.
#'
#' @section Shiny inputs:
#' - `input$<id>_show`, `input$<id>_hide` -- fire as the card opens and closes.
#' - `input$<id>_after_enter`, `input$<id>_after_leave` -- fire once the
#'   animation has finished.
#'
#' @return A Shiny UI element.
#' @examples
#' el_popover("info",
#'   reference = el$button("Details"),
#'   title = "March",
#'   content = "Revenue up 4% on February."
#' )
#'
#' # Hover, with markup in the body
#' el_popover("info",
#'   reference = el$button("Details"),
#'   body = shiny::tags$ul(shiny::tags$li("One"), shiny::tags$li("Two")),
#'   trigger = "hover", placement = "right"
#' )
#' @export
el_popover <- function(id = NULL,
                       reference = NULL,
                       title = NULL,
                       content = NULL,
                       body = NULL,
                       trigger = NULL,
                       placement = NULL,
                       popover_width = NULL,
                       disabled = NULL,
                       offset = NULL,
                       open_delay = NULL,
                       close_delay = NULL,
                       visible_arrow = NULL,
                       transition = NULL,
                       popper_class = NULL,
                       popper_options = NULL,
                       tabindex = NULL,
                       width = NULL,
                       session = shiny::getDefaultReactiveDomain()) {
  reference <- .el_reject_widgets(reference, "reference", "el_popover")
  body      <- .el_reject_widgets(body, "body", "el_popover")

  if (is.null(id)) id <- paste0("el_popover_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  attrs <- list(
    "v-model"         = "value",
    ":title"          = .el_optional_bind("title"),
    ":content"        = .el_optional_bind("content"),
    ":trigger"        = .el_optional_bind("trigger"),
    ":placement"      = .el_optional_bind("placement"),
    ":width"          = .el_optional_bind("popoverWidth"),
    ":disabled"       = .el_optional_bind("disabled"),
    ":offset"         = .el_optional_bind("offset"),
    ":open-delay"     = .el_optional_bind("openDelay"),
    ":close-delay"    = .el_optional_bind("closeDelay"),
    ":visible-arrow"  = .el_optional_bind("visibleArrow"),
    ":transition"     = .el_optional_bind("transition"),
    ":popper-class"   = .el_optional_bind("popperClass"),
    ":popper-options" = .el_optional_bind("popperOptions"),
    ":tabindex"       = .el_optional_bind("tabindex")
  )
  events <- .el_event_bindings(ns_id, c("show", "hide", "after-enter", "after-leave"))
  attrs <- c(attrs, events$attrs)

  children <- list(body)
  if (!is.null(reference)) {
    children <- c(children, list(
      htmltools::tags$span(slot = "reference", reference)
    ))
  }

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-popover", c(attrs, children)),
    data   = list(
      value         = FALSE,
      title         = .el_or_na(title),
      content       = .el_or_na(content),
      trigger       = .el_or_na(trigger),
      placement     = .el_or_na(placement),
      popoverWidth  = .el_or_na(popover_width),
      disabled      = .el_or_na(disabled),
      offset        = .el_or_na(offset),
      openDelay     = .el_or_na(open_delay),
      closeDelay    = .el_or_na(close_delay),
      visibleArrow  = .el_or_na(visible_arrow),
      transition    = .el_or_na(transition),
      popperClass   = .el_or_na(popper_class),
      popperOptions = .el_or_na(popper_options),
      tabindex      = .el_or_na(tabindex)
    ),
    methods    = events$methods,
    width      = width,
    dependency = el_popover_handler_dependency()
  )
}


#' Update Element UI Popover
#'
#' Server-side update for [el_popover()]. Setting `value` opens or closes the
#' card, which is how `trigger = "manual"` is driven.
#'
#' @param session Shiny session object.
#' @param id Popover ID (un-namespaced).
#' @param title,content,disabled,value New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$explain, {
#'     update_el_popover(session, "info", content = summary_text(), value = TRUE)
#'   })
#' }
#' @export
update_el_popover <- function(session, id, title = NULL, content = NULL,
                              disabled = NULL, value = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(title))    msg$title    <- title
  if (!is.null(content))  msg$content  <- content
  if (!is.null(disabled)) msg$disabled <- disabled
  if (!is.null(value))    msg$value    <- value
  session$sendCustomMessage("updateElPopover", msg)
  invisible(NULL)
}


#' @keywords internal
el_popover_handler_dependency <- function() {
  .el_handler_dependency("popover")
}
