# Private helper: normalise choices to list of list(value=, label=)
.normalize_choices_radio <- function(choices) {
  if (is.character(choices) && !is.null(names(choices))) {
    # named character vector: names = label, values = value
    mapply(
      function(label, value) list(value = value, label = label),
      names(choices), unname(choices),
      SIMPLIFY = FALSE, USE.NAMES = FALSE
    )
  } else if (is.list(choices)) {
    choices  # already list of list(value=, label=)
  } else {
    # unnamed vector: use as both value and label
    lapply(choices, function(x) list(value = x, label = as.character(x)))
  }
}

# Private dependency loader (not exported)
el_radio_group_handler_dependency <- function() {
  htmltools::htmlDependency(
    name    = "el-radio-group-handler",
    version = "1.0.0",
    src     = system.file("js", package = "shiny.element"),
    script  = "el-radio-group-handler.js"
  )
}

#' Element UI Radio Group Component
#'
#' Creates an Element UI `<el-radio-group>` component backed by a Vue instance.
#' Supports both standard radio buttons (`<el-radio>`) and button-style radios
#' (`<el-radio-button>`).
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param choices Named character vector (`c(Label = value)`) or a list of
#'   `list(value = ..., label = ...)` items. Unnamed vectors are allowed; the
#'   element is used as both value and label.
#' @param selected Initial selected value. Defaults to `""` (nothing selected).
#' @param disabled Whether the entire group is disabled. Default `FALSE`.
#' @param size Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`.
#'   Only affects button-style radios (`button = TRUE`).
#' @param button Whether to render as `<el-radio-button>` (pill/button style)
#'   instead of standard `<el-radio>`. Default `FALSE`.
#' @param session Shiny session for module namespace support.
#'
#' @return An `htmltools` tagList containing the Vue-managed radio group.
#'
#' @section Shiny input:
#' `input$<id>` — string or number reflecting the currently selected value,
#' updated on each change.
#'
#' @examples
#' # Standard radio buttons from a named vector
#' el_radio_group("size",
#'   choices  = c(Small = "s", Medium = "m", Large = "l"),
#'   selected = "m"
#' )
#'
#' # Button-style radio group
#' el_radio_group("theme",
#'   choices = c(Light = "light", Dark = "dark"),
#'   button  = TRUE,
#'   size    = "small"
#' )
#'
#' # Shiny app example
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_radio_group("fruit",
#'       choices  = c(Apple = "apple", Banana = "banana", Cherry = "cherry"),
#'       selected = "apple"
#'     ),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$fruit)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_radio_group <- function(
    id       = NULL,
    choices,
    selected = NULL,
    disabled = FALSE,
    size     = NULL,
    button   = FALSE,
    session  = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_radio_group_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Choose el-radio or el-radio-button based on button param
  radio_tag_name <- if (button) "el-radio-button" else "el-radio"

  radio_slot <- htmltools::tag(radio_tag_name, list(
    ":label" = "opt.value",
    "v-for"  = "opt in options",
    ":key"   = "opt.value",
    htmltools::HTML("{{opt.label}}")
  ))

  # Build el-radio-group attributes
  group_attrs <- list(
    "v-model"   = "value",
    ":disabled" = "disabled",
    "@change"   = "handleChange"
  )
  if (!is.null(size)) group_attrs[[":size"]] <- "size"

  # Build Vue data
  vue_data <- list(
    value    = if (is.null(selected)) "" else selected,
    options  = .normalize_choices_radio(choices),
    disabled = disabled
  )
  if (!is.null(size)) vue_data$size <- size

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-radio-group", c(group_attrs, list(radio_slot)))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(value) { Shiny.setInputValue('%s', value); }",
            ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_radio_group_handler_dependency())
}


#' Update Element UI Radio Group
#'
#' Server-side update for [el_radio_group()]. Sends a custom message to update
#' reactive fields on the underlying Vue instance.
#'
#' @param session Shiny session object.
#' @param id Radio group input ID (un-namespaced).
#' @param value New selected value.
#' @param options New choices: named character vector or
#'   `list(list(value=, label=), ...)`.
#' @param disabled New disabled state.
#'
#' @export
update_el_radio_group <- function(
    session,
    id,
    value    = NULL,
    options  = NULL,
    disabled = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))    msg$value    <- value
  if (!is.null(options))  msg$options  <- .normalize_choices_radio(options)
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElRadioGroup", msg)
}
