#' Element Plus Rate (Star Rating)
#'
#' A star-rating input. Supports half-stars, custom icons, and read-only display.
#'
#' @param id Rate ID. Auto-generated UUID if `NULL`.
#' @param value Initial rating value. Default `0`.
#' @param max Maximum number of stars. Default `5`.
#' @param disabled Read-only display mode. Default `FALSE`.
#' @param allow_half Whether to allow half-star selection. Default `FALSE`.
#' @param show_text Whether to show descriptive text beside the stars. Uses the
#'   `texts` vector. Default `FALSE`.
#' @param show_score Whether to show the numeric score. Default `FALSE`.
#' @param texts Character vector of length `max` used when `show_text = TRUE`.
#'   Defaults to `c("极差", "失望", "一般", "满意", "惊喜")`.
#' @param text_color Colour of the text/score. Default `"#1f2d3d"`.
#' @param score_template Template for score display. `{value}` is replaced.
#'   Default `"{value}"`.
#' @param aria_label Same as `aria-label` in Rate. Element Plus's `aria-label`
#'   (string).
#' @param clearable Whether value can be reset to `0`. Element Plus's
#'   `clearable` (boolean).
#' @param disabled_void_icon Component of unselected read-only icons. Element
#'   Plus's `disabled-void-icon` (string / Component). An icon's name, such as
#'   `"Search"`.
#' @param icons Icon components. If array, it should have 3 elements, each of
#'   which corresponds with a score level, else if object, the key should be
#'   threshold value between two levels, and the value should be corresponding
#'   icon component. Element Plus's `icons` (`string[] | Component[] /
#'   Record<number, string | Component>`). An icon's name, such as `"Search"`.
#' @param size Size of Rate. Element Plus's `size` ('large' | 'default' |
#'   'small').
#' @param void_icon Component of unselected icons. Element Plus's `void-icon`
#'   (string / Component). An icon's name, such as `"Search"`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param colors Colours for the three score levels, or a named list keyed by threshold.
#' @param void_color Colour of unselected icons.
#' @param disabled_void_color Colour of unselected icons when `disabled = TRUE`.
#' @param low_threshold Scores at or below this use the first colour and icon. Default `2`.
#' @param high_threshold Scores above this use the third colour and icon. Default `4`.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed rate component.
#'
#' @section Shiny inputs:
#' `input$<id>` — numeric rating value (0 to `max`, increments of 0.5 when
#' `allow_half = TRUE`).
#'
#' @examples
#' el_rate("rate1", value = 3)
#' el_rate("rate2", allow_half = TRUE, show_score = TRUE)
#' @export
el_rate <- function(
  id = NULL,
  value = 0,
  max = 5L,
  disabled = FALSE,
  allow_half = FALSE,
  show_text = FALSE,
  show_score = FALSE,
  # Escaped rather than literal: CRAN requires R code to be ASCII-only, so
  # that the package reads the same under any locale. These are Element Plus's
  # own default labels: 极差 失望 一般 满意 惊喜.
  texts = c(
    "\u6781\u5dee",
    "\u5931\u671b",
    "\u4e00\u822c",
    "\u6ee1\u610f",
    "\u60ca\u559c"
  ),
  text_color = "#1f2d3d",
  score_template = "{value}",
  colors = NULL,
  void_color = NULL,
  disabled_void_color = NULL,
  low_threshold = NULL,
  high_threshold = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  aria_label = NULL,
  clearable = NULL,
  disabled_void_icon = NULL,
  icons = NULL,
  size = NULL,
  void_icon = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_choices("el_rate", environment())
  if (is.null(id)) {
    id <- paste0("el_rate_", uuid::UUIDgenerate())
  }
  ns_id <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  rate_attrs <- list(
    "v-model" = "value",
    ":max" = "max",
    ":disabled" = "disabled",
    ":allow-half" = "allowHalf",
    ":show-text" = "showText",
    ":show-score" = "showScore",
    ":text-color" = "textColor",
    ":score-template" = "scoreTemplate",
    ":texts" = "texts",
    "@change" = "handleChange"
  )

  rate_attrs[[":colors"]] <- .el_optional_bind("colors")

  rate_attrs[[":void-color"]] <- .el_optional_bind("voidColor")

  rate_attrs[[":disabled-void-color"]] <- .el_optional_bind("disabledVoidColor")

  rate_attrs[[":low-threshold"]] <- .el_optional_bind("lowThreshold")

  rate_attrs[[":high-threshold"]] <- .el_optional_bind("highThreshold")

  # Element's rate is 20px tall where a form item's line is 40px, so beside
  # a label the stars would sit above the label's text; padded to the line
  if (!is.null(label) && label_position[1] %in% c("left", "right")) {
    rate_attrs$style <- "padding: 10px 0"
  }

  el_widget(
    props = .el_props(list(
      aria_label = aria_label,
      clearable = clearable,
      disabled_void_icon = .el_icon_name(disabled_void_icon),
      icons = .el_icon_name(icons),
      size = size,
      void_icon = .el_icon_name(void_icon)
    )),
    label = label,
    label_position = label_position,
    label_width = label_width,
    label_suffix = label_suffix,
    required = required,
    error = error,
    show_message = show_message,
    inline_message = inline_message,
    id = ns_id,
    markup = htmltools::tag("el-rate", rate_attrs),
    data = list(
      value = value,
      max = max,
      disabled = disabled,
      allowHalf = allow_half,
      showText = show_text,
      showScore = show_score,
      textColor = text_color,
      scoreTemplate = score_template,
      texts = as.list(texts),
      colors = .el_or_na(colors),
      voidColor = .el_or_na(void_color),
      disabledVoidColor = .el_or_na(disabled_void_color),
      lowThreshold = .el_or_na(low_threshold),
      highThreshold = .el_or_na(high_threshold)
    ),
    methods = list(
      handleChange = JS(sprintf(
        "function(val) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', val); }",
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width = width,
    slots = slots
  )
}


#' Update Element Plus Rate
#'
#' Server-side update for [el_rate()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Rate ID (un-namespaced).
#' @param value New rating value.
#' @param disabled New disabled state.
#'
#' @param label New label, as for [shiny::updateTextInput()]: text, or
#'   tags or `HTML()` drawn as markup. Only a component built with a `label`
#'   has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_rate(session, "stars", value = 5)
#'   })
#' }
#' @export
update_el_rate <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(value)) {
    msg$value <- value
  }
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}
