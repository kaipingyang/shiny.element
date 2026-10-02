# Private helper: normalise choices to list of list(value=, label=)

# Private dependency loader (not exported)

#' Element UI Radio Group Component
#'
#' Creates an Element UI `<el-radio-group>` component backed by a Vue instance.
#' Supports both standard radio buttons (`<el-radio>`) and button-style radios
#' (`<el-radio-button>`).
#'
#' @param id Input ID. Auto-generated UUID if `NULL`.
#' @param choices,options The choices: a named character vector
#'   (`c(Label = value)`) or a list of `list(value = ..., label = ...)`.
#'   Unnamed vectors are allowed; the element is used as both value and
#'   label. `choices` is Shiny's name for it, `options` Element's; give
#'   either.
#' @param selected,value Initially selected value; nothing by default.
#'   `selected` is Shiny's name, `value` Element's (its `v-model`); give
#'   either.
#' @param disabled Whether the entire group is disabled. Default `FALSE`.
#' @param size Component size: `NULL`, `"medium"`, `"small"`, or `"mini"`.
#'   Only affects button-style radios (`button = TRUE`).
#' @param button Whether to render as `<el-radio-button>` (pill/button style)
#'   instead of standard `<el-radio>`. Default `FALSE`.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param fill Border and background colour of a checked radio button.
#' @param text_color Text colour of a checked radio button.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList containing the Vue-managed radio group.
#'
#' @section Shiny inputs:
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
    choices  = NULL,
    selected = NULL,
    disabled = FALSE,
    size     = NULL,
    button   = FALSE,
    fill     = NULL,
    text_color = NULL,
    label = NULL,
    label_position = c("top", "left", "right"),
    label_width = NULL,
    label_suffix = NULL,
    required = FALSE,
    error = NULL,
    show_message = TRUE,
    inline_message = FALSE,
    width    = NULL,
    slots    = NULL,
    value    = NULL,
    options  = NULL,
    session  = NULL
) {
  .el_check_choices("el_radio_group", environment())
  selected <- .el_alias(selected, value, "selected", "value")
  choices  <- .el_alias(choices, options, "choices", "options")
  if (is.null(choices)) stop("`choices` (or `options`) is required.", call. = FALSE)
  if (is.null(id)) id <- paste0("el_radio_group_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
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
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = htmltools::tag("el-radio-group", c(group_attrs, list(radio_slot))),
    data    = vue_data,
    methods = list(
      # Which choice changed, and to what: input$<id>_item_change
      handleItemChange = JS(sprintf(
        paste0("function(opt, checked) { ",
               "window.shinyVue.emit('%s', 'item_change', ",
               "[{value: opt.value, label: opt.label, checked: checked}]); }"),
        ns_id
      )),
      handleChange = JS(sprintf(
        "function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', value); }",
        ns_id
      ))
    ),
    mounted = .el_mounted_init(stats::setNames("value", ns_id)),
    width      = width,
    slots      = slots
  )
}


#' Update Element UI Radio Group
#'
#' Server-side update for [el_radio_group()]. Sends a custom message to update
#' reactive fields on the underlying Vue instance.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Radio group input ID (un-namespaced).
#' @param selected,value New selected value. `selected` is Shiny's name,
#'   `value` Element's; give either.
#' @param choices,options New choices, as for [el_radio_group()]. `choices`
#'   is Shiny's name, `options` Element's; give either.
#' @param disabled New disabled state.
#'
#' @param label New label text, as for [shiny::updateTextInput()]. Only a
#'   component built with a `label` has one to change.
#' @param error An error message to show on the component, as Element's
#'   `error` does -- for a check only the server can make, such as whether
#'   a name is taken. `""` clears it.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_radio_group(session, "plan", selected = "pro")
#'   })
#' }
#' @export
update_el_radio_group <- function(
    session = shiny::getDefaultReactiveDomain(),
    id,
    selected = NULL,
    choices  = NULL,
    disabled = NULL,
    value    = NULL,
    options  = NULL,
    label = NULL, error = NULL) {
  .el_check_session(session)
  selected <- .el_alias(selected, value, "selected", "value")
  choices  <- .el_alias(choices, options, "choices", "options")
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(selected)) msg$value    <- selected
  if (!is.null(choices))  msg$options  <- .el_normalize_choices(choices)
  if (!is.null(disabled)) msg$disabled <- disabled
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}
