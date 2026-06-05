#' Element UI Button with Vue Instance
#'
#' Creates an Element UI button with Vue instance, supporting all Element UI
#' button variants including `plain`, `round`, `circle`, and `loading` states.
#'
#' @param id Button ID. Auto-generated UUID if `NULL`.
#' @param label Button text. Ignored (and defaults to `""`) when `circle = TRUE`.
#' @param type Button type: `"default"`, `"primary"`, `"success"`, `"warning"`,
#'   `"danger"`, `"info"`, `"text"`.
#' @param size Button size: `NULL`, `"medium"`, `"small"`, `"mini"`.
#' @param plain Whether to use the plain (hollow) style. Default `FALSE`.
#' @param round Whether to use rounded corners. Default `FALSE`.
#' @param circle Whether to render as a circle button (icon only, no label).
#'   Default `FALSE`.
#' @param loading Whether to show loading spinner. Disables click while active.
#'   Default `FALSE`.
#' @param disabled Whether the button is disabled. Default `FALSE`.
#' @param icon Icon tag (e.g. `el_icon("search")`, `shiny::icon("star")`).
#' @param native_type HTML native button type: `"button"` (default), `"submit"`,
#'   `"reset"`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed button component.
#'
#' @section Shiny input:
#' `input$<id>` — click count (integer), incremented on each click when neither
#' `disabled` nor `loading` is `TRUE`.
#'
#' @examples
#' # Basic usage
#' el_button("btn_primary", "Primary", type = "primary")
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_button("btn1", "Primary", type = "primary"),
#'     verbatimTextOutput("count")
#'   )
#'   server <- function(input, output, session) {
#'     output$count <- renderPrint(input$btn1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_button <- function(
    id          = NULL,
    label       = "Button",
    type        = "default",
    size        = NULL,
    plain       = FALSE,
    round       = FALSE,
    circle      = FALSE,
    loading     = FALSE,
    disabled    = FALSE,
    icon        = NULL,
    native_type = "button",
    session     = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_button_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # circle buttons show no label
  if (circle) label <- ""

  # Vue binding attributes
  btn_attrs <- list(
    ":type"        = "type",
    ":plain"       = "plain",
    ":round"       = "round",
    ":circle"      = "circle",
    ":loading"     = "loading",
    ":disabled"    = "disabled",
    ":native-type" = "native_type",
    "@click"       = "handleClick"
  )
  if (!is.null(size)) btn_attrs[[":size"]] <- "size"

  btn_content <- shiny::tagList(
    if (!is.null(icon) && inherits(icon, "shiny.tag")) icon,
    "{{label}}"
  )

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-button", append(btn_attrs, btn_content))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el   = paste0("#", container_id),
        data = list(
          label       = label,
          type        = type,
          size        = size,
          plain       = plain,
          round       = round,
          circle      = circle,
          loading     = loading,
          disabled    = disabled,
          native_type = native_type,
          count       = 0L
        ),
        methods = list(
          handleClick = htmlwidgets::JS(sprintf(
            "function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('%s', this.count); } }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_button_handler_dependency())
}


#' Update Element UI Button
#'
#' Server-side update for [el_button()]. Supports all visual states including
#' `size`, `plain`, `round`, and `loading`.
#'
#' @param session Shiny session object.
#' @param id Button ID (un-namespaced).
#' @param label New label text.
#' @param type New button type.
#' @param size New button size.
#' @param plain New plain state.
#' @param round New round state.
#' @param loading New loading state.
#' @param disabled New disabled state.
#'
#' @export
update_el_button <- function(
    session,
    id,
    label    = NULL,
    type     = NULL,
    size     = NULL,
    plain    = NULL,
    round    = NULL,
    loading  = NULL,
    disabled = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(label))    msg$label    <- label
  if (!is.null(type))     msg$type     <- type
  if (!is.null(size))     msg$size     <- size
  if (!is.null(plain))    msg$plain    <- plain
  if (!is.null(round))    msg$round    <- round
  if (!is.null(loading))  msg$loading  <- loading
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElButton", msg)
}
