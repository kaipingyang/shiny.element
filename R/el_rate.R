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
    texts          = c("极差", "失望", "一般",
                       "满意", "惊喜"),
    text_color     = "#1f2d3d",
    score_template = "{value}",
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

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-rate", rate_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el   = paste0("#", container_id),
        data = list(
          value         = value,
          max           = max,
          disabled      = disabled,
          allowHalf     = allow_half,
          showText      = show_text,
          showScore     = show_score,
          textColor     = text_color,
          scoreTemplate = score_template,
          texts         = as.list(texts)
        ),
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(val) { Shiny.setInputValue('%s', val); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_rate_handler_dependency())
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
#' @export
update_el_rate <- function(session, id, value = NULL, disabled = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))    msg$value    <- value
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElRate", msg)
}


#' @keywords internal
el_rate_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-rate-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-rate-handler.js",
    all_files = FALSE
  )
}
