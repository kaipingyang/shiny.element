#' Element UI Button with Vue Instance
#' @param id Button ID (auto-generated if NULL)
#' @param label Button text
#' @param type Button type (primary, success, warning, danger, info, text)
#' @param size Button size (medium, small, mini)
#' @param disabled Whether button is disabled
#' @param icon Icon tag (e.g. el_icon("search"), shiny::icon("star"), fontawesome::fa_icon("github"))
#' @param session Shiny session for module support
#' @export
#' @examples
#' # Basic usage
#' el_button("btn_primary", "Primary", type = "primary")
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_button("btn_primary", "Primary", type = "primary"),
#'     verbatimTextOutput("btn_primary_count")
#'   )
#'   server <- function(input, output, session) {
#'     output$btn_primary_count <- renderPrint(input$btn_primary)
#'   }
#'   shinyApp(ui, server)
#' }
el_button <- function(id = NULL,
                      label = "Button",
                      type = "default",
                      size = NULL,
                      disabled = FALSE,
                      icon = NULL,
                      session = getDefaultReactiveDomain()) {
  if (is.null(id)) {
    id <- paste0("el_button_", uuid::UUIDgenerate())
  }
  ns_id <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  button_attrs <- list(
    ":type" = "type",
    ":disabled" = "disabled",
    "@click" = "handleClick"
  )
  if (!is.null(size)) button_attrs[[":size"]] <- "size"

  # 构建按钮内容，只接受 icon 为 shiny.tag
  button_content <- tagList(
    if (!is.null(icon) && inherits(icon, "shiny.tag")) icon,
    "{{label}}"
  )

  component_ui <- tagList(
    tags$div(
      id = container_id,
      tag("el-button", append(button_attrs, button_content))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el = paste0("#", container_id),
        data = list(
          label = label,
          type = type,
          size = size,
          disabled = disabled,
          count = 0
        ),
        methods = list(
          handleClick = htmlwidgets::JS(sprintf(
            "function() {\n  if (!this.disabled) {\n    this.count++;\n    Shiny.setInputValue('%s', this.count);\n  }\n}", ns_id))
        )
      )
    )
  )

  htmltools::attachDependencies(
    component_ui,
    el_button_handler_dependency()
  )
}

#' Update Element UI Button
#' @param session Shiny session object
#' @param id Button ID
#' @param label New button label
#' @param type New button type
#' @param disabled New disabled state
#' @export
update_el_button <- function(session, id, label = NULL, type = NULL, disabled = NULL) {
  ns_id <- session$ns(id)
  message <- list(id = ns_id)
  if (!is.null(label)) message$label <- label
  if (!is.null(type)) message$type <- type
  if (!is.null(disabled)) message$disabled <- disabled
  
  session$sendCustomMessage('updateElButton', message)
}
