#' Element UI Tooltip
#'
#' A hint shown when the pointer rests on something.
#'
#' @param id Tooltip ID. Auto-generated if `NULL`.
#' @param trigger The element the tooltip describes. Markup only -- raw
#'   Element tags from [el], or ordinary Shiny UI. It cannot be another
#'   shiny.element component: the tooltip compiles this into its own Vue
#'   instance, which would discard a mounted one. Use
#'   `el$button(type = "primary", "Save")` rather than `el_button()`.
#' @param content Text of the hint.
#' @param placement Where the hint appears: `"top"` (default), `"bottom"`,
#'   `"left"`, `"right"`, each also with `-start` and `-end`.
#' @param effect `"dark"` (default) or `"light"`.
#' @param disabled Whether the hint is suppressed.
#' @param offset Offset from the trigger, in pixels.
#' @param open_delay Delay before it appears, in milliseconds.
#' @param hide_after Hide it automatically after this many milliseconds. `0`
#'   (the default) keeps it until the pointer leaves.
#' @param enterable Whether the pointer may move onto the hint itself.
#' @param visible_arrow Whether to draw the little arrow. Default `TRUE`.
#' @param transition Name of the transition to animate with.
#' @param popper_class Extra class name for the hint.
#' @param popper_options Additional Popper.js options, as a named list.
#' @param manual Whether to control visibility yourself through
#'   [update_el_tooltip()] rather than on hover.
#' @param tabindex Tab index of the trigger.
#' @param width Component width, as a CSS unit.
#' @param session Shiny session for module support.
#'
#' @return A Shiny UI element.
#' @examples
#' el_tooltip("hint", el$button(type = "primary", "Save"),
#'            content = "Writes to disk")
#'
#' el_tooltip("hint",
#'   trigger = el$button(type = "danger", "Delete"),
#'   content = "This cannot be undone",
#'   placement = "right", effect = "light"
#' )
#' @export
el_tooltip <- function(id = NULL,
                       trigger = NULL,
                       content = NULL,
                       placement = NULL,
                       effect = NULL,
                       disabled = NULL,
                       offset = NULL,
                       open_delay = NULL,
                       hide_after = NULL,
                       enterable = NULL,
                       visible_arrow = NULL,
                       transition = NULL,
                       popper_class = NULL,
                       popper_options = NULL,
                       manual = NULL,
                       tabindex = NULL,
                       width = NULL,
                       session = shiny::getDefaultReactiveDomain()) {
  trigger <- .el_reject_widgets(trigger, "trigger", "el_tooltip")

  if (is.null(id)) id <- paste0("el_tooltip_", uuid::UUIDgenerate())
  ns_id <- if (!is.null(session)) session$ns(id) else id

  attrs <- list(
    "v-model"          = "value",
    ":content"         = .el_optional_bind("content"),
    ":placement"       = .el_optional_bind("placement"),
    ":effect"          = .el_optional_bind("effect"),
    ":disabled"        = .el_optional_bind("disabled"),
    ":offset"          = .el_optional_bind("offset"),
    ":open-delay"      = .el_optional_bind("openDelay"),
    ":hide-after"      = .el_optional_bind("hideAfter"),
    ":enterable"       = .el_optional_bind("enterable"),
    ":visible-arrow"   = .el_optional_bind("visibleArrow"),
    ":transition"      = .el_optional_bind("transition"),
    ":popper-class"    = .el_optional_bind("popperClass"),
    ":popper-options"  = .el_optional_bind("popperOptions"),
    ":manual"          = .el_optional_bind("manual"),
    ":tabindex"        = .el_optional_bind("tabindex")
  )

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-tooltip", c(attrs, list(trigger))),
    data   = list(
      value          = FALSE,
      content        = .el_or_na(content),
      placement      = .el_or_na(placement),
      effect         = .el_or_na(effect),
      disabled       = .el_or_na(disabled),
      offset         = .el_or_na(offset),
      openDelay      = .el_or_na(open_delay),
      hideAfter      = .el_or_na(hide_after),
      enterable      = .el_or_na(enterable),
      visibleArrow   = .el_or_na(visible_arrow),
      transition     = .el_or_na(transition),
      popperClass    = .el_or_na(popper_class),
      popperOptions  = .el_or_na(popper_options),
      manual         = .el_or_na(manual),
      tabindex       = .el_or_na(tabindex)
    ),
    width      = width,
    dependency = el_tooltip_handler_dependency()
  )
}


#' Update Element UI Tooltip
#'
#' Server-side update for [el_tooltip()]. Setting `value` only shows or hides
#' the hint when the tooltip was created with `manual = TRUE`.
#'
#' @param session Shiny session object.
#' @param id Tooltip ID (un-namespaced).
#' @param content,disabled,value New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$explain, {
#'     update_el_tooltip(session, "hint", content = why_disabled())
#'   })
#' }
#' @export
update_el_tooltip <- function(session, id, content = NULL, disabled = NULL,
                              value = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(content))  msg$content  <- content
  if (!is.null(disabled)) msg$disabled <- disabled
  if (!is.null(value))    msg$value    <- value
  session$sendCustomMessage("updateElTooltip", msg)
  invisible(NULL)
}


#' @keywords internal
el_tooltip_handler_dependency <- function() {
  .el_handler_dependency("tooltip")
}
