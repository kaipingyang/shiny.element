#' Element UI Popover
#'
#' A card shown on click or hover, with a title and body.
#'
#' @param id Popover ID. Auto-generated if `NULL`.
#' @param reference The element the popover hangs off. Any Shiny UI,
#'   including another shiny.element component -- that component is folded
#'   into the popover's Vue instance rather than nested inside it, so its
#'   inputs keep reporting. Its `update_el_*()` no longer reaches it.
#' @param title Title of the card.
#' @param content Body text. For richer content pass `body`.
#' @param body Body markup, used instead of `content`. Components are
#'   absorbed here too.
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
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
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
                       slots   = NULL,
                       session = NULL) {
  .el_check_choices("el_popover", environment())
  inner_ref  <- .el_absorb(reference)
  inner_body <- .el_absorb(body)

  if (is.null(id)) id <- paste0("el_popover_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    "v-model"         = "popValue",
    ":title"          = .el_optional_bind("popTitle"),
    ":content"        = .el_optional_bind("popContent"),
    ":trigger"        = .el_optional_bind("popTrigger"),
    ":placement"      = .el_optional_bind("popPlacement"),
    ":width"          = .el_optional_bind("popPopoverWidth"),
    ":disabled"       = .el_optional_bind("popDisabled"),
    ":offset"         = .el_optional_bind("popOffset"),
    ":open-delay"     = .el_optional_bind("popOpenDelay"),
    ":close-delay"    = .el_optional_bind("popCloseDelay"),
    ":visible-arrow"  = .el_optional_bind("popVisibleArrow"),
    ":transition"     = .el_optional_bind("popTransition"),
    ":popper-class"   = .el_optional_bind("popPopperClass"),
    ":popper-options" = .el_optional_bind("popPopperOptions"),
    ":tabindex"       = .el_optional_bind("popTabindex")
  )
  events <- .el_event_bindings(ns_id, c("show", "hide", "after-enter", "after-leave"))
  attrs <- c(attrs, events$attrs)



  own <- list(
    markup = NULL,
    data = list(
      popValue         = FALSE,
      popTitle         = .el_or_na(title),
      popContent       = .el_or_na(content),
      popTrigger       = .el_or_na(trigger),
      popPlacement     = .el_or_na(placement),
      popPopoverWidth  = .el_or_na(popover_width),
      popDisabled      = .el_or_na(disabled),
      popOffset        = .el_or_na(offset),
      popOpenDelay     = .el_or_na(open_delay),
      popCloseDelay    = .el_or_na(close_delay),
      popVisibleArrow  = .el_or_na(visible_arrow),
      popTransition    = .el_or_na(transition),
      popPopperClass   = .el_or_na(popper_class),
      popPopperOptions = .el_or_na(popper_options),
      popTabindex   = .el_or_na(tabindex)
    ),
    methods = events$methods,
    watch = list(), computed = list(), mounted = NULL, dependencies = list()
  )
  merged <- .el_absorb_merge(own, inner_ref, inner_body)
  # markups keeps the order the parts went in: own, reference, body
  ref_markup  <- merged$markups[[2]]
  body_markup <- merged$markups[[3]]

  children <- list(body_markup)
  if (!is.null(ref_markup)) {
    children <- c(children, list(
      htmltools::tags$span(slot = "reference", ref_markup)
    ))
  }

  el_widget(
    id       = ns_id,
    markup   = htmltools::tag("el-popover", c(attrs, children)),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    slots      = slots,
    dependency = c(el_popover_handler_dependency(), merged$dependencies)
  )
}


#' Update Element UI Popover
#'
#' Server-side update for [el_popover()]. Setting `value` opens or closes the
#' card, which is how `trigger = "manual"` is driven.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
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
update_el_popover <- function(session = shiny::getDefaultReactiveDomain(), id, title = NULL, content = NULL,
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
