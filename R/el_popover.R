#' Element Plus Popover
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
#' @param trigger How it opens: `"click"`, `"focus"`, `"hover"` (default) or
#'   `"contextmenu"`.
#' @param placement Where it appears: `"bottom"` (default), `"top"`, `"left"`,
#'   `"right"`, each also with `-start` and `-end`.
#' @param popover_width Width of the card, in pixels. Element's own `width`
#'   prop, named apart from `width` so the two are not confused.
#' @param disabled Whether the popover is suppressed.
#' @param offset Offset from the reference, in pixels.
#' @param transition Name of the transition to animate with.
#' @param popper_class Extra class name for the card.
#' @param popper_options Additional Popper.js options, as a named list.
#' @param width Component width, as a CSS unit.
#' @param append_to Which element the popover CONTENT appends to. Element
#'   Plus's `append-to` (CSSSelector / HTMLElement).
#' @param auto_close Timeout in milliseconds to hide tooltip, not valid in
#'   controlled mode. Element Plus's `auto-close` (number).
#' @param effect Tooltip theme, built-in theme: `dark` / `light`. Element
#'   Plus's `effect` ('dark' | 'light' / string).
#' @param hide_after Delay of disappear, in millisecond, not valid in
#'   controlled mode. Element Plus's `hide-after` (number).
#' @param persistent When popover inactive and `persistent` is `false` ,
#'   popover will be destroyed. Element Plus's `persistent` (boolean).
#' @param popper_style Custom style for popover. Element Plus's `popper-style`
#'   (string / object).
#' @param show_after Delay of appearance, in millisecond, not valid in
#'   controlled mode. Element Plus's `show-after` (number).
#' @param show_arrow Whether a tooltip arrow is displayed or not. For more
#'   info, please refer to ElPopper. Element Plus's `show-arrow` (boolean).
#' @param teleported Whether popover dropdown is teleported to the body.
#'   Element Plus's `teleported` (boolean).
#' @param trigger_keys When you click the mouse to focus on the trigger
#'   element, you can define a set of keyboard codes to control the display of
#'   popover through the keyboard, not valid in controlled mode. Element
#'   Plus's `trigger-keys` (Array).
#' @param ... Any other attribute of Element Plus's tooltip, which the popover
#'   inherits, in snake_case: `enterable = FALSE`, `offset = 20`.
#' @param virtual_ref A CSS selector, `"#help-icon"`, for an element elsewhere
#'   on the page that the popover is attached to, in place of a trigger of its
#'   own. Element Plus's `virtual-ref` takes the element itself; the selector
#'   is looked up in the browser.
#' @param virtual_triggering Whether virtual triggering is enabled. Element
#'   Plus's `virtual-triggering` (boolean); `TRUE` when `virtual_ref` is
#'   given.
#' @param visible Whether popover is visible. Element Plus's `visible`
#'   (boolean / null).
#' @param tabindex Tabindex of Popover. Element Plus's `tabindex` (number /
#'   string).
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
#' el_popover(
#'   "info",
#'   reference = el$button("Details"),
#'   title = "March",
#'   content = "Revenue up 4% on February."
#' )
#'
#' # Hover, with markup in the body
#' el_popover(
#'   "info",
#'   reference = el$button("Details"),
#'   body = shiny::tags$ul(shiny::tags$li("One"), shiny::tags$li("Two")),
#'   trigger = "hover",
#'   placement = "right"
#' )
#' @export
el_popover <- function(
  id = NULL,
  reference = NULL,
  title = NULL,
  content = NULL,
  body = NULL,
  trigger = NULL,
  placement = NULL,
  popover_width = NULL,
  disabled = NULL,
  offset = NULL,
  transition = NULL,
  popper_class = NULL,
  popper_options = NULL,
  tabindex = NULL,
  append_to = NULL,
  auto_close = NULL,
  effect = NULL,
  hide_after = NULL,
  persistent = NULL,
  popper_style = NULL,
  show_after = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL,
  visible = NULL,
  ...,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_choices("el_popover", environment())
  inner_ref <- .el_absorb(reference)
  inner_body <- .el_absorb(body)

  if (is.null(id)) {
    id <- .el_auto_id("el_popover")
  }
  ns_id <- .el_ui_id(id, session)

  attrs <- list(
    ":title" = .el_optional_bind("popTitle"),
    ":content" = .el_optional_bind("popContent"),
    ":trigger" = .el_optional_bind("popTrigger"),
    ":placement" = .el_optional_bind("popPlacement"),
    ":width" = .el_optional_bind("popPopoverWidth"),
    ":disabled" = .el_optional_bind("popDisabled"),
    ":offset" = .el_optional_bind("popOffset"),
    ":transition" = .el_optional_bind("popTransition"),
    ":popper-class" = .el_optional_bind("popPopperClass"),
    ":popper-options" = .el_optional_bind("popPopperOptions")
  )
  events <- .el_event_bindings(
    ns_id,
    c(
      "show",
      "hide",
      "after-enter",
      "after-leave",
      "before-enter",
      "before-leave"
    )
  )
  attrs <- c(attrs, events$attrs)

  own <- list(
    markup = NULL,
    data = list(
      popTitle = .el_or_na(title),
      popContent = .el_or_na(content),
      popTrigger = .el_or_na(trigger),
      popPlacement = .el_or_na(placement),
      popPopoverWidth = .el_or_na(popover_width),
      popDisabled = .el_or_na(disabled),
      popOffset = .el_or_na(offset),
      popTransition = .el_or_na(transition),
      popPopperClass = .el_or_na(popper_class),
      popPopperOptions = .el_or_na(popper_options)
    ),
    methods = events$methods,
    watch = list(),
    computed = list(),
    mounted = NULL,
    dependencies = list()
  )
  merged <- .el_absorb_merge(own, inner_ref, inner_body)
  # markups keeps the order the parts went in: own, reference, body
  ref_markup <- merged$markups[[2]]
  body_markup <- merged$markups[[3]]

  children <- list(body_markup)
  if (!is.null(ref_markup)) {
    children <- c(
      children,
      list(
        .el_slot("reference", htmltools::tags$span(ref_markup))
      )
    )
  }

  el_widget(
    props = .el_props(
      prefix = "pop",
      list(
        tabindex = tabindex,
        append_to = append_to,
        auto_close = auto_close,
        effect = effect,
        hide_after = hide_after,
        persistent = persistent,
        popper_style = popper_style,
        show_after = show_after,
        show_arrow = show_arrow,
        teleported = teleported,
        trigger_keys = trigger_keys,
        virtual_ref = virtual_ref,
        virtual_triggering = virtual_triggering,
        visible = visible,
        ...
      )
    ),
    id = ns_id,
    markup = htmltools::tag("el-popover", c(attrs, children)),
    data = merged$data,
    methods = merged$methods,
    watch = merged$watch,
    computed = merged$computed,
    mounted = merged$mounted,
    width = width,
    slots = slots,
    dependency = merged$dependencies
  )
}


#' Update Element Plus Popover
#'
#' Server-side update for [el_popover()]. Setting `visible` opens or closes
#' the card, which then stays as set: Element Plus's popover is controlled by
#' its `visible` once that is given.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Popover ID (un-namespaced).
#' @param title,content,disabled,visible New values; `NULL` leaves one unchanged.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$explain, {
#'     update_el_popover(session, "info", content = summary_text(), visible = TRUE)
#'   })
#' }
#' @export
update_el_popover <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  content = NULL,
  disabled = NULL,
  visible = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  # The popover's fields carry a prefix, kept apart from its reference's
  if (!is.null(title)) {
    msg$popTitle <- title
  }
  if (!is.null(content)) {
    msg$popContent <- content
  }
  if (!is.null(disabled)) {
    msg$popDisabled <- disabled
  }
  if (!is.null(visible)) {
    msg$popVisible <- visible
  }
  .el_send_update(session, msg)
  invisible(NULL)
}
