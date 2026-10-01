#' Element UI Color Picker
#'
#' A colour picker input that returns a CSS colour string.
#'
#' @param id Color picker ID. Auto-generated UUID if `NULL`.
#' @param value Initial colour value (CSS hex/rgb string). `NULL` for empty.
#' @param disabled Whether the picker is disabled. Default `FALSE`.
#' @param size Component size: `NULL`, `"medium"`, `"small"`, `"mini"`.
#' @param show_alpha Whether to show an alpha channel slider. Default `FALSE`.
#'   When `TRUE`, the returned value is an `rgba(...)` string.
#' @param color_format Output format: `NULL` (auto), `"hex"`, `"rgb"`,
#'   `"hsv"`, `"hsl"`.
#' @param predefine Character vector of preset colour swatches. `NULL` for
#'   none.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param popper_class Extra class name for the dropdown panel.
#' @param label A label shown with the component, as Shiny's inputs have:
#'   text or a tag. `NULL`, the default, shows none. It is the component's
#'   accessible name too.
#' @param label_position `"top"` (the default, as Shiny's labels sit) or
#'   `"left"`, beside the component as in a horizontal Element form.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed color-picker component.
#'
#' @section Shiny input:
#' `input$<id>` — colour string (e.g. `"#409EFF"` or `"rgba(64,158,255,0.5)"`).
#' `NULL` / `NA` when the user clears the picker.
#'
#' @examples
#' el_color_picker("cp1", value = "#409EFF")
#' el_color_picker("cp2", show_alpha = TRUE, predefine = c("#ff4500", "#ff8c00"))
#'
#' @export
el_color_picker <- function(
    id           = NULL,
    value        = NULL,
    disabled     = FALSE,
    size         = NULL,
    show_alpha   = FALSE,
    color_format = NULL,
    predefine    = NULL,
    popper_class = NULL,
    label = NULL,
    label_position = c("top", "left"),
    width        = NULL,
    slots        = NULL,
    session      = NULL
) {
  .el_check_choices("el_color_picker", environment())
  if (is.null(id)) id <- paste0("el_color_picker_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  cp_attrs <- list(
    "v-model"      = "value",
    ":disabled"    = "disabled",
    ":show-alpha"  = "showAlpha",
    "@change"      = "handleChange"
  )
  cp_attrs[[":size"]] <- .el_optional_bind("size")
  cp_attrs[[":color-format"]] <- .el_optional_bind("colorFormat")
  cp_attrs[[":predefine"]] <- .el_optional_bind("predefine")
  cp_attrs[[":popper-class"]] <- .el_optional_bind("popperClass")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(ns_id, c(
    "active-change"
  ))
  cp_attrs <- c(cp_attrs, events$attrs)
  vue_data <- list(
    value      = value,
    disabled   = disabled,
    showAlpha  = show_alpha
  )
  vue_data$size <- .el_or_na(size)
  vue_data$colorFormat <- .el_or_na(color_format)
  vue_data$predefine <- if (is.null(predefine)) NA else as.list(predefine)
  vue_data$popperClass <- .el_or_na(popper_class)

  el_widget(
    label = label, label_position = label_position,
    id     = ns_id,
    markup = htmltools::tag("el-color-picker", cp_attrs),
    data    = vue_data,
    methods = c(events$methods, list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(val) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', val); }",
        ns_id
      ))
    )),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Color Picker
#'
#' Server-side update for [el_color_picker()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Color picker ID (un-namespaced).
#' @param value New colour string.
#' @param disabled New disabled state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_color_picker(session, "shade", value = "#67C23A")
#'   })
#' }
#' @export
update_el_color_picker <- function(session = shiny::getDefaultReactiveDomain(), id, value = NULL, disabled = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))    msg$value    <- value
  if (!is.null(disabled)) msg$disabled <- disabled
  .el_send_update(session, msg)
  invisible(NULL)
}


