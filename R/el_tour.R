#' Element Plus Tour
#'
#' A guided tour: a card pointing at one element of the page after another,
#' with the rest of the page dimmed.
#'
#' @param id Tour ID. Auto-generated if `NULL`.
#' @param steps The steps, each an [el_tour_step()] -- or a
#'   `list(target = "#css-selector", title =,
#'   description =)`, each with Element Plus's other step props if wanted --
#'   `placement`, `mask`, `type`, `show_arrow`, `show_close`,
#'   `content_style`, `scroll_into_view_options`, and `header`, markup in
#'   place of the title. A step without a `target` shows in the middle of the
#'   screen.
#' @param open Whether it starts open: Element Plus's `model-value`. Open it
#'   later with [update_el_tour()].
#' @param current The step it starts on, from 0.
#' @param show_arrow,placement,content_style,mask,gap,type,scroll_into_view_options,z_index,show_close,close_icon,close_on_press_escape,target_area_clickable,append_to
#'   Element Plus's tour props of those names: the defaults for every step.
#' @param width Component width, as a CSS unit.
#' @param slots Named list of Element slot contents: `indicators`.
#'
#' @section Shiny inputs:
#' - `input$<id>` -- whether it is open.
#' - `input$<id>_change` -- the step, from 0, as it changes.
#' - `input$<id>_close` -- the step it was closed on.
#' - `input$<id>_finish` -- fires when the last step is done.
#'
#' @return A Shiny UI element.
#' @examples
#' el_tour(
#'   "intro",
#'   open = TRUE,
#'   steps = list(
#'     list(
#'       target = "#upload",
#'       title = "Upload",
#'       description = "Put your file here."
#'     ),
#'     list(target = "#run", title = "Run", description = "Then press this.")
#'   )
#' )
#' @export
el_tour <- function(
  id = NULL,
  steps = list(),
  open = FALSE,
  current = NULL,
  show_arrow = NULL,
  placement = NULL,
  content_style = NULL,
  mask = NULL,
  gap = NULL,
  type = NULL,
  scroll_into_view_options = NULL,
  z_index = NULL,
  show_close = NULL,
  close_icon = NULL,
  close_on_press_escape = NULL,
  target_area_clickable = NULL,
  append_to = NULL,
  width = NULL,
  slots = NULL
) {
  .el_check_choices("el_tour", environment())
  .el_check_items(steps, "steps", c("target", "title"))
  if (is.null(id)) {
    id <- .el_auto_id("el_tour")
  }
  ns_id <- .el_ui_id(id, NULL)
  step_tags <- lapply(steps, function(st) {
    attrs <- list()
    # A header that is markup fills the step's header slot
    header <- st$header
    st$header <- NULL
    for (k in names(st)) {
      v <- st[[k]]
      if (k == "close_icon") {
        v <- .el_icon_name(v)
      }
      attrs[[paste0(":", gsub("_", "-", k))]] <- jsonlite::toJSON(
        v,
        auto_unbox = TRUE
      )
    }
    htmltools::tag(
      "el-tour-step",
      c(attrs, if (!is.null(header)) list(.el_slot("header", header)))
    )
  })
  events <- .el_event_bindings(ns_id, c("change", "finish"))
  el_widget(
    id = ns_id,
    markup = htmltools::tag(
      "el-tour",
      c(
        list(
          "v-model" = "open",
          "v-model:current" = "current",
          "@close" = "handleClose"
        ),
        events$attrs,
        step_tags
      )
    ),
    props = .el_props(list(
      show_arrow = show_arrow,
      placement = placement,
      content_style = content_style,
      mask = mask,
      gap = gap,
      type = type,
      scroll_into_view_options = scroll_into_view_options,
      z_index = z_index,
      show_close = show_close,
      close_icon = .el_icon_name(close_icon),
      close_on_press_escape = close_on_press_escape,
      target_area_clickable = target_area_clickable,
      append_to = append_to
    )),
    data = list(
      open = isTRUE(.el_restore(ns_id, open)),
      current = if (is.null(current)) 0L else current
    ),
    methods = c(
      events$methods,
      list(
        handleClose = JS(sprintf(
          paste0(
            "function(step) { window.Shiny && Shiny.setInputValue && ",
            "Shiny.setInputValue('%s_close', step, {priority: 'event'}); }"
          ),
          ns_id
        ))
      )
    ),
    watch = list(
      open = JS(sprintf(
        "function(v) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', v); }",
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("open", ns_id)),
    width = width,
    slots = slots
  )
}


#' Update Element Plus Tour
#'
#' Open or close an [el_tour()], or move it to a step.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Tour ID (un-namespaced).
#' @param open,current New values; `NULL` leaves one unchanged.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(
#'     input$help,
#'     update_el_tour(session, "intro", open = TRUE, current = 0)
#'   )
#' }
#' @inheritParams el_tour
#' @details Every other argument of [el_tour()] that can change once it is
#'   drawn is an argument here too, under the same name. One left `NULL`
#'   stays as it is; `NA` returns it to Element's default.
#' @export
update_el_tour <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  open = NULL,
  current = NULL,
  show_arrow = NULL,
  placement = NULL,
  content_style = NULL,
  mask = NULL,
  gap = NULL,
  type = NULL,
  scroll_into_view_options = NULL,
  z_index = NULL,
  show_close = NULL,
  close_icon = NULL,
  close_on_press_escape = NULL,
  target_area_clickable = NULL,
  append_to = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(open)) {
    msg$open <- open
  }
  if (!is.null(current)) {
    msg$current <- current
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_tour",
      Filter(
        Negate(is.null),
        list(
          show_arrow = show_arrow,
          placement = placement,
          content_style = content_style,
          mask = mask,
          gap = gap,
          type = type,
          scroll_into_view_options = scroll_into_view_options,
          z_index = z_index,
          show_close = show_close,
          close_icon = close_icon,
          close_on_press_escape = close_on_press_escape,
          target_area_clickable = target_area_clickable,
          append_to = append_to
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
