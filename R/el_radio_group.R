# Private helper: normalise choices to list of list(value=, label=)

# Private dependency loader (not exported)
el_radio_group_handler_dependency <- function() {
  .el_handler_dependency("radio-group")
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
#' @param fill Border and background colour of a checked radio button.
#' @param text_color Text colour of a checked radio button.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
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
    fill     = NULL,
    text_color = NULL,
    width    = NULL,
    slots    = NULL,
    session  = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_radio_group_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Choose el-radio or el-radio-button based on button param
  radio_tag_name <- if (button) "el-radio-button" else "el-radio"

  # Per-choice props are read off the option object, as in el_checkbox_group().
  radio_slot <- htmltools::tag(radio_tag_name, list(
    ":label"    = "opt.value",
    "v-for"     = "opt in options",
    ":key"      = "opt.value",
    ":disabled" = "opt.disabled",
    ":border"   = "opt.border",
    ":name"     = "opt.name",
    "@change"   = "handleItemChange(opt, $event)",
    htmltools::HTML("{{opt.label}}")
  ))

  # Build el-radio-group attributes
  group_attrs <- list(
    "v-model"   = "value",
    ":disabled" = "disabled",
    "@change"   = "handleChange"
  )
  group_attrs[[":size"]] <- .el_optional_bind("size")
  group_attrs[[":fill"]] <- .el_optional_bind("fill")
  group_attrs[[":text-color"]] <- .el_optional_bind("textColor")
  # Build Vue data
  vue_data <- list(
    value    = if (is.null(selected)) "" else selected,
    options  = .el_normalize_choices(choices),
    disabled = disabled
  )
  vue_data$size <- .el_or_na(size)
  vue_data$fill <- .el_or_na(fill)
  vue_data$textColor <- .el_or_na(text_color)
  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-radio-group", c(group_attrs, list(radio_slot))),
    data    = vue_data,
    methods = list(
      # Which choice changed, and to what: input$<id>_item_change
      handleItemChange = htmlwidgets::JS(sprintf(
        paste0("function(opt, checked) { ",
               "window.shinyElement.emit('%s', 'item_change', ",
               "[{value: opt.value, label: opt.label, checked: checked}]); }"),
        ns_id
      )),
      handleChange = htmlwidgets::JS(sprintf(
        "function(value) { Shiny.setInputValue('%s', value); }",
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots,
    dependency = el_radio_group_handler_dependency()
  )
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
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_radio_group(session, "plan", value = "pro")
#'   })
#' }
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
  if (!is.null(options))  msg$options  <- .el_normalize_choices(options)
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElRadioGroup", msg)
  invisible(NULL)
}
