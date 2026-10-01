#' Element UI Tooltip
#'
#' A hint shown when the pointer rests on something.
#'
#' @details
#' A component passed as `trigger` becomes part of the tooltip's Vue instance
#' rather than a separate one, which is what lets it survive being compiled
#' into the tooltip's markup. It reports its inputs as usual, but it no longer
#' has a widget of its own, so its `update_el_*()` cannot find it -- drive it
#' through [update_vue_data()] on the tooltip's id instead.
#'
#' @param id Tooltip ID. Auto-generated if `NULL`.
#' @param trigger The element the tooltip describes. Any Shiny UI, including
#'   another shiny.element component -- that component is folded into the
#'   tooltip's own Vue instance rather than nested inside it, so its inputs
#'   keep reporting. Its `update_el_*()` no longer reaches it, though; see
#'   Details.
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
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return A Shiny UI element.
#' @examples
#' # A plain tag as the trigger
#' el_tooltip("hint", el$button(type = "primary", "Save"),
#'            content = "Writes to disk")
#'
#' # Or a component, which keeps working
#' el_tooltip("hint", el_button("save", "Save"), content = "Writes to disk")
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
                       slots   = NULL,
                       session = NULL) {
  .el_check_choices("el_tooltip", environment())
  # A component handed in here is folded into this one's Vue instance rather
  # than nested inside it -- see .el_absorb().
  inner <- .el_absorb(trigger)

  if (is.null(id)) id <- paste0("el_tooltip_", uuid::UUIDgenerate())
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    "v-model"          = "tipValue",
    ":content"         = .el_optional_bind("tipContent"),
    ":placement"       = .el_optional_bind("tipPlacement"),
    ":effect"          = .el_optional_bind("tipEffect"),
    ":disabled"        = .el_optional_bind("tipDisabled"),
    ":offset"          = .el_optional_bind("tipOffset"),
    ":open-delay"      = .el_optional_bind("tipOpenDelay"),
    ":hide-after"      = .el_optional_bind("tipHideAfter"),
    ":enterable"       = .el_optional_bind("tipEnterable"),
    ":visible-arrow"   = .el_optional_bind("tipVisibleArrow"),
    ":transition"      = .el_optional_bind("tipTransition"),
    ":popper-class"    = .el_optional_bind("tipPopperClass"),
    ":popper-options"  = .el_optional_bind("tipPopperOptions"),
    ":manual"          = .el_optional_bind("tipManual"),
    ":tabindex"        = .el_optional_bind("tipTabindex")
  )

  own <- list(
    markup = NULL,
    data = list(
      tipValue          = FALSE,
      tipContent        = .el_or_na(content),
      tipPlacement      = .el_or_na(placement),
      tipEffect         = .el_or_na(effect),
      tipDisabled       = .el_or_na(disabled),
      tipOffset         = .el_or_na(offset),
      tipOpenDelay      = .el_or_na(open_delay),
      tipHideAfter      = .el_or_na(hide_after),
      tipEnterable      = .el_or_na(enterable),
      tipVisibleArrow   = .el_or_na(visible_arrow),
      tipTransition     = .el_or_na(transition),
      tipPopperClass    = .el_or_na(popper_class),
      tipPopperOptions  = .el_or_na(popper_options),
      tipManual         = .el_or_na(manual),
      tipTabindex       = .el_or_na(tabindex)
    ),
    methods = list(), watch = list(), computed = list(), mounted = NULL,
    dependencies = list()
  )
  merged <- .el_absorb_merge(own, inner)

  el_widget(
    id       = ns_id,
    markup   = htmltools::tag("el-tooltip", c(attrs, list(merged$markups[[2]]))),
    data     = merged$data,
    methods  = merged$methods,
    watch    = merged$watch,
    computed = merged$computed,
    mounted  = merged$mounted,
    width    = width,
    slots      = slots,
    dependency = merged$dependencies
  )
}


#' Update Element UI Tooltip
#'
#' Server-side update for [el_tooltip()]. Setting `value` only shows or hides
#' the hint when the tooltip was created with `manual = TRUE`.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
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
update_el_tooltip <- function(session = shiny::getDefaultReactiveDomain(), id, content = NULL, disabled = NULL,
                              value = NULL) {
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(content))  msg$content  <- content
  if (!is.null(disabled)) msg$disabled <- disabled
  if (!is.null(value))    msg$value    <- value
  .el_send_update(session, msg)
  invisible(NULL)
}


