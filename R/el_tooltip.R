#' Element UI Tooltip
#'
#' A hint shown when the pointer rests on something.
#'
#' @details
#' A component passed as `trigger` becomes part of the tooltip's Vue instance
#' rather than a separate one, which is what lets it survive being compiled
#' into the tooltip's markup. It reports its inputs as usual, but it no longer
#' has a host of its own, so its `update_el_*()` cannot find it -- drive it
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
#' @param hide_after Hide it automatically after this many milliseconds. `0`
#'   (the default) keeps it until the pointer leaves.
#' @param enterable Whether the pointer may move onto the hint itself.
#' @param transition Name of the transition to animate with.
#' @param popper_class Extra class name for the hint.
#' @param popper_options Additional Popper.js options, as a named list.
#' @param width Component width, as a CSS unit.
#' @param append_to Which element the tooltip CONTENT appends to. Element
#'   Plus's `append-to` (CSSSelector / HTMLElement).
#' @param aria_label Same as `aria-label`. Element Plus's `aria-label`
#'   (string).
#' @param arrow_offset Controls the offset (padding) of the tooltip’s arrow
#'   relative to the popper. Element Plus's `arrow-offset` (number).
#' @param auto_close Timeout in milliseconds to hide tooltip, not valid in
#'   controlled mode. Element Plus's `auto-close` (number).
#' @param fallback_placements List of possible positions for Tooltip
#'   popper.js. Element Plus's `fallback-placements` (`Placement[]`).
#' @param focus_on_target When triggering tooltips through hover, whether to
#'   focus the trigger element, which improves accessibility. Element Plus's
#'   `focus-on-target` (boolean).
#' @param persistent When tooltip inactive and `persistent` is `false` ,
#'   tooltip will be destroyed. Element Plus's `persistent` (boolean).
#' @param popper_style Custom style for Tooltip's popper. Element Plus's
#'   `popper-style` (string / object).
#' @param raw_content Whether `content` is treated as HTML string. Element
#'   Plus's `raw-content` (boolean).
#' @param show_after Delay of appearance, in millisecond, not valid in
#'   controlled mode. Element Plus's `show-after` (number).
#' @param show_arrow Whether the tooltip content has an arrow. Element Plus's
#'   `show-arrow` (boolean).
#' @param teleported Whether tooltip content is teleported, if `true` it will
#'   be teleported to where `append-to` sets. Element Plus's `teleported`
#'   (boolean).
#' @param trigger_keys When you click the mouse to focus on the trigger
#'   element, you can define a set of keyboard codes to control the display of
#'   tooltip through the keyboard, not valid in controlled mode. Element
#'   Plus's `trigger-keys` (Array).
#' @param virtual_ref Indicates the reference element to which the tooltip is
#'   attached. Element Plus's `virtual-ref` (HTMLElement).
#' @param virtual_triggering Indicates whether virtual triggering is enabled.
#'   Element Plus's `virtual-triggering` (boolean).
#' @param visible Visibility of Tooltip. Element Plus's `visible` (boolean).
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
                       hide_after = NULL,
                       enterable = NULL,
                       transition = NULL,
                       popper_class = NULL,
                       popper_options = NULL,
                       append_to = NULL,
                       aria_label = NULL,
                       arrow_offset = NULL,
                       auto_close = NULL,
                       fallback_placements = NULL,
                       focus_on_target = NULL,
                       persistent = NULL,
                       popper_style = NULL,
                       raw_content = NULL,
                       show_after = NULL,
                       show_arrow = NULL,
                       teleported = NULL,
                       trigger_keys = NULL,
                       virtual_ref = NULL,
                       virtual_triggering = NULL,
                       visible = NULL,
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
    ":content"         = .el_optional_bind("tipContent"),
    ":placement"       = .el_optional_bind("tipPlacement"),
    ":effect"          = .el_optional_bind("tipEffect"),
    ":disabled"        = .el_optional_bind("tipDisabled"),
    ":offset"          = .el_optional_bind("tipOffset"),
    ":hide-after"      = .el_optional_bind("tipHideAfter"),
    ":enterable"       = .el_optional_bind("tipEnterable"),
    ":transition"      = .el_optional_bind("tipTransition"),
    ":popper-class"    = .el_optional_bind("tipPopperClass"),
    ":popper-options"  = .el_optional_bind("tipPopperOptions")
  )

  events <- .el_event_bindings(ns_id, c("show", "hide", "before-show", "before-hide"))
  attrs <- c(attrs, events$attrs)

  own <- list(
    markup = NULL,
    data = list(
      tipContent        = .el_or_na(content),
      tipPlacement      = .el_or_na(placement),
      tipEffect         = .el_or_na(effect),
      tipDisabled       = .el_or_na(disabled),
      tipOffset         = .el_or_na(offset),
      tipHideAfter      = .el_or_na(hide_after),
      tipEnterable      = .el_or_na(enterable),
      tipTransition     = .el_or_na(transition),
      tipPopperClass    = .el_or_na(popper_class),
      tipPopperOptions  = .el_or_na(popper_options)
    ),
    methods = events$methods, watch = list(), computed = list(), mounted = NULL,
    dependencies = list()
  )
  merged <- .el_absorb_merge(own, inner)

  el_widget(
    props = .el_props(prefix = "tip", list(
      append_to = append_to,
      aria_label = aria_label,
      arrow_offset = arrow_offset,
      auto_close = auto_close,
      fallback_placements = fallback_placements,
      focus_on_target = focus_on_target,
      persistent = persistent,
      popper_style = popper_style,
      raw_content = raw_content,
      show_after = show_after,
      show_arrow = show_arrow,
      teleported = teleported,
      trigger_keys = trigger_keys,
      virtual_ref = virtual_ref,
      virtual_triggering = virtual_triggering,
      visible = visible)),
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
#' Server-side update for [el_tooltip()]. Setting `visible` shows or hides
#' the hint, which then stays as set: Element Plus's tooltip is controlled by
#' its `visible` once that is given.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Tooltip ID (un-namespaced).
#' @param content,disabled,visible New values; `NULL` leaves one unchanged.
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
update_el_tooltip <- function(session = shiny::getDefaultReactiveDomain(),
                              id,
                              content = NULL,
                              disabled = NULL,
                              visible = NULL) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  # The tooltip's fields carry a prefix, kept apart from a trigger's own
  if (!is.null(content))  msg$tipContent  <- content
  if (!is.null(disabled)) msg$tipDisabled <- disabled
  if (!is.null(visible))  msg$tipVisible  <- visible
  .el_send_update(session, msg)
  invisible(NULL)
}


