#' Element UI Rate (Star Rating)
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
#' @param session Shiny session for module support.
#' @param colors Colours for the three score levels, or a named list keyed by threshold.
#' @param void_color Colour of unselected icons.
#' @param disabled_void_color Colour of unselected icons when `disabled = TRUE`.
#' @param icon_classes Icon classes for the three score levels, or a named list keyed by threshold.
#' @param void_icon_class Icon class for unselected icons.
#' @param disabled_void_icon_class Icon class for unselected icons when `disabled = TRUE`.
#' @param low_threshold Scores at or below this use the first colour and icon. Default `2`.
#' @param high_threshold Scores above this use the third colour and icon. Default `4`.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#'
#' @return An `htmltools` tagList with a Vue-managed rate component.
#'
#' @section Shiny input:
#' `input$<id>` — numeric rating value (0 to `max`, increments of 0.5 when
#' `allow_half = TRUE`).
#'
#' @examples
#' el_rate("rate1", value = 3)
#' el_rate("rate2", allow_half = TRUE, show_score = TRUE)
#'
#' @export
el_rate <- function(
    id             = NULL,
    value          = 0,
    max            = 5L,
    disabled       = FALSE,
    allow_half     = FALSE,
    show_text      = FALSE,
    show_score     = FALSE,
    # Escaped rather than literal: CRAN requires R code to be ASCII-only, so
    # that the package reads the same under any locale. These are Element UI's
    # own default labels: 极差 失望 一般 满意 惊喜.
    texts          = c("\u6781\u5dee", "\u5931\u671b", "\u4e00\u822c",
                       "\u6ee1\u610f", "\u60ca\u559c"),
    text_color     = "#1f2d3d",
    score_template = "{value}",
    colors         = NULL,
    void_color     = NULL,
    disabled_void_color = NULL,
    icon_classes   = NULL,
    void_icon_class = NULL,
    disabled_void_icon_class = NULL,
    low_threshold  = NULL,
    high_threshold = NULL,
    width          = NULL,
    session        = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_rate_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  rate_attrs <- list(
    "v-model"        = "value",
    ":max"           = "max",
    ":disabled"      = "disabled",
    ":allow-half"    = "allowHalf",
    ":show-text"     = "showText",
    ":show-score"    = "showScore",
    ":text-color"    = "textColor",
    ":score-template"= "scoreTemplate",
    ":texts"         = "texts",
    "@change"        = "handleChange"
  )

  rate_attrs[[":colors"]] <- .el_optional_bind("colors")

  rate_attrs[[":void-color"]] <- .el_optional_bind("voidColor")

  rate_attrs[[":disabled-void-color"]] <- .el_optional_bind("disabledVoidColor")

  rate_attrs[[":icon-classes"]] <- .el_optional_bind("iconClasses")

  rate_attrs[[":void-icon-class"]] <- .el_optional_bind("voidIconClass")

  rate_attrs[[":disabled-void-icon-class"]] <- .el_optional_bind("disabledVoidIconClass")

  rate_attrs[[":low-threshold"]] <- .el_optional_bind("lowThreshold")

  rate_attrs[[":high-threshold"]] <- .el_optional_bind("highThreshold")

  .el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-rate", rate_attrs),
    data = list(
      value         = value,
      max           = max,
      disabled      = disabled,
      allowHalf     = allow_half,
      showText      = show_text,
      showScore     = show_score,
      textColor     = text_color,
      scoreTemplate = score_template,
      texts         = as.list(texts),
    colors = .el_or_na(colors),
    voidColor = .el_or_na(void_color),
    disabledVoidColor = .el_or_na(disabled_void_color),
    iconClasses = .el_or_na(icon_classes),
    voidIconClass = .el_or_na(void_icon_class),
    disabledVoidIconClass = .el_or_na(disabled_void_icon_class),
    lowThreshold = .el_or_na(low_threshold),
    highThreshold = .el_or_na(high_threshold)
    ),
    methods = list(
      handleChange = htmlwidgets::JS(sprintf(
        "function(val) { Shiny.setInputValue('%s', val); }",
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    dependency = el_rate_handler_dependency()
  )
}


#' Update Element UI Rate
#'
#' Server-side update for [el_rate()].
#'
#' @param session Shiny session object.
#' @param id Rate ID (un-namespaced).
#' @param value New rating value.
#' @param disabled New disabled state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_rate(session, "stars", value = 5)
#'   })
#' }
#' @export
update_el_rate <- function(session, id, value = NULL, disabled = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))    msg$value    <- value
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElRate", msg)
  invisible(NULL)
}


#' @keywords internal
el_rate_handler_dependency <- function() {
  .el_handler_dependency("rate")
}
