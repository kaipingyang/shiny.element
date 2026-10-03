

#' Element UI Checkbox Group
#'
#' Creates an Element UI checkbox group with Vue instance, supporting individual
#' checkboxes or button-style variants.
#'
#' @param id Checkbox group ID. Auto-generated UUID if `NULL`.
#' @param choices,options The choices: a named character vector
#'   (`c(Label = value)`) or a list of `list(value = ..., label = ...)`.
#'   `choices` is Shiny's name for it, `options` Element's; give either.
#' @param selected,value Character vector of initially checked values; none
#'   by default. `selected` is Shiny's name, `value` Element's (its
#'   `v-model`); give either.
#' @param disabled Whether the entire group is disabled. Default `FALSE`.
#' @param size `"large"`, `"default"` or `"small"`.
#' @param min Minimum number of checked items.
#' @param max Maximum number of checked items.
#' @param button Whether to use button-style checkboxes (`el-checkbox-button`).
#'   Default `FALSE`.
#' @param aria_label Native `aria-label` attribute. Element Plus's
#'   `aria-label` (string).
#' @param props Configuration options. Element Plus's `props` ({ value?:
#'   string, label?: string, disabled?: string}).
#' @param tag Element tag of the checkbox group. Element Plus's `tag`
#'   (string).
#' @param type Component type to render options (e.g. `'button'`). Element
#'   Plus's `type` ('checkbox' | 'button').
#' @param validate_event Whether to trigger form validation. Element Plus's
#'   `validate-event` (boolean).
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param fill Border and background colour when `button = TRUE` and checked.
#' @param text_color Text colour when `button = TRUE` and checked.
#' @inheritParams el_widget
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @return An `htmltools` tagList with a Vue-managed checkbox group component.
#'
#' @section Shiny inputs:
#' `input$<id>` — character vector of currently selected values.
#'
#' @examples
#' el_checkbox_group(
#'   "cb1",
#'   choices = c("Option A" = "a", "Option B" = "b")
#' )
#'
#' if (interactive()) {
#'   library(shiny)
#'   library(shiny.element)
#'   ui <- el_page(
#'     el_checkbox_group(
#'       "cb1",
#'       choices  = c("Apple" = "apple", "Banana" = "banana"),
#'       selected = "apple"
#'     ),
#'     verbatimTextOutput("selected")
#'   )
#'   server <- function(input, output, session) {
#'     output$selected <- renderPrint(input$cb1)
#'   }
#'   shinyApp(ui, server)
#' }
#'
#' @export
el_checkbox_group <- function(
    id       = NULL,
    choices  = NULL,
    selected = NULL,
    disabled = FALSE,
    size     = NULL,
    min      = NULL,
    max      = NULL,
    button   = FALSE,
    fill     = NULL,
    text_color = NULL,
    aria_label = NULL,
    props = NULL,
    tag = NULL,
    type = NULL,
    validate_event = NULL,
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
  .el_check_choices("el_checkbox_group", environment())
  selected <- .el_alias(selected, value, "selected", "value")
  choices  <- .el_alias(choices, options, "choices", "options")
  if (is.null(choices)) stop("`choices` (or `options`) is required.", call. = FALSE)
  if (is.null(id)) id <- paste0("el_checkbox_group_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")

  cb_tag_name <- if (button) "el-checkbox-button" else "el-checkbox"
  # Per-choice props are read off the option object, so a choice may be given
  # as list(value =, label =, disabled = TRUE, border = TRUE). A key that is
  # absent reads back as undefined, which is Element's own default.
  cb_slot <- htmltools::tag(cb_tag_name, list(
    ":label"         = "opt.value",
    "v-for"          = "opt in options",
    ":key"           = "opt.value",
    ":disabled"      = "opt.disabled",
    ":border"        = "opt.border",
    ":name"          = "opt.name",
    "@change"        = "handleItemChange(opt, $event)",
    ":checked"       = "opt.checked",
    ":indeterminate" = "opt.indeterminate",
    ":true-label"    = "opt.trueLabel",
    ":false-label"   = "opt.falseLabel",
    htmltools::HTML("{{opt.label}}")
  ))

  group_attrs <- list(
    "v-model"   = "value",
    ":disabled" = "disabled",
    "@change"   = "handleChange"
  )
  group_attrs[[":size"]] <- .el_optional_bind("size")
  group_attrs[[":min"]] <- .el_optional_bind("min")
  group_attrs[[":max"]] <- .el_optional_bind("max")
  group_attrs[[":fill"]] <- .el_optional_bind("fill")
  group_attrs[[":text-color"]] <- .el_optional_bind("textColor")
  group_tag <- htmltools::tag("el-checkbox-group", c(group_attrs, list(cb_slot)))

  vue_data <- list(
    value    = if (is.null(selected)) list() else as.list(selected),
    options  = .el_normalize_choices(choices),
    disabled = disabled
  )
  vue_data$size <- .el_or_na(size)
  vue_data$min <- if (is.null(min)) NA else min
  vue_data$max <- if (is.null(max)) NA else max
  vue_data$fill <- .el_or_na(fill)
  vue_data$textColor <- .el_or_na(text_color)
  el_widget(
    props = .el_props(list(
      aria_label = aria_label,
      props = props,
      tag = tag,
      type = type,
      validate_event = validate_event)),
    label = label, label_position = label_position,
    label_width = label_width, label_suffix = label_suffix, required = required,
    error = error, show_message = show_message, inline_message = inline_message,
    id     = ns_id,
    markup = group_tag,
    data = vue_data,
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


#' Update Element UI Checkbox Group
#'
#' Server-side update for [el_checkbox_group()]. Pass only the fields to change;
#' `NULL` fields are excluded from the update message.
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Checkbox group ID (un-namespaced).
#' @param selected,value New character vector of checked values.
#'   `selected` is Shiny's name, `value` Element's; give either.
#' @param choices,options New choices, as for [el_checkbox_group()].
#'   `choices` is Shiny's name, `options` Element's; give either.
#' @param disabled New disabled state.
#' @param min New minimum checked count.
#' @param max New maximum checked count.
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
#'     update_el_checkbox_group(session, "langs", selected = c("r", "py"))
#'   })
#' }
#' @export
update_el_checkbox_group <- function(
    session = shiny::getDefaultReactiveDomain(),
    id,
    selected = NULL,
    choices  = NULL,
    disabled = NULL,
    min      = NULL,
    max      = NULL,
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
  if (!is.null(min))      msg$min      <- min
  if (!is.null(max))      msg$max      <- max
  msg <- .el_form_item_update(msg, label, error)
  .el_send_update(session, msg)
  invisible(NULL)
}


