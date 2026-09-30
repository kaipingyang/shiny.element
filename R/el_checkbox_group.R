

#' Element UI Checkbox Group
#'
#' Creates an Element UI checkbox group with Vue instance, supporting individual
#' checkboxes or button-style variants.
#'
#' @param id Checkbox group ID. Auto-generated UUID if `NULL`.
#' @param choices Named character vector `c(Label = value)` or list of
#'   `list(value = ..., label = ...)` defining available options.
#' @param selected Character vector of initially checked values. `NULL` for none.
#' @param disabled Whether the entire group is disabled. Default `FALSE`.
#' @param size Size for button style only: `"medium"`, `"small"`, `"mini"`.
#' @param min Minimum number of checked items.
#' @param max Maximum number of checked items.
#' @param button Whether to use button-style checkboxes (`el-checkbox-button`).
#'   Default `FALSE`.
#' @param session Shiny session for module support.
#' @param fill Border and background colour when `button = TRUE` and checked.
#' @param text_color Text colour when `button = TRUE` and checked.
#'
#' @return An `htmltools` tagList with a Vue-managed checkbox group component.
#'
#' @section Shiny input:
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
    choices,
    selected = NULL,
    disabled = FALSE,
    size     = NULL,
    min      = NULL,
    max      = NULL,
    button   = FALSE,
    fill     = NULL,
    text_color = NULL,
    session  = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_checkbox_group_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
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
  component_ui <- shiny::tagList(
    shiny::tags$div(id = container_id, style = .el_host_style(), group_tag),
    vueR::vue(
elementId = ns_id, width = 0, height = 0,
      list(
        el   = paste0("#", container_id),
        data = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(value) { Shiny.setInputValue('%s', value); }",
            ns_id
          ))
        ),
        mounted = .el_mounted_init(stats::setNames("value", ns_id))
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_checkbox_group_handler_dependency())
}


#' Update Element UI Checkbox Group
#'
#' Server-side update for [el_checkbox_group()]. Pass only the fields to change;
#' `NULL` fields are excluded from the update message.
#'
#' @param session Shiny session object.
#' @param id Checkbox group ID (un-namespaced).
#' @param value New character vector of selected values.
#' @param options New choices list (same format as the `choices` argument).
#' @param disabled New disabled state.
#' @param min New minimum checked count.
#' @param max New maximum checked count.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_checkbox_group(session, "langs", value = c("r", "py"))
#'   })
#' }
#' @export
update_el_checkbox_group <- function(
    session,
    id,
    value    = NULL,
    options  = NULL,
    disabled = NULL,
    min      = NULL,
    max      = NULL
) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(value))    msg$value    <- value
  if (!is.null(options))  msg$options  <- .el_normalize_choices(options)
  if (!is.null(disabled)) msg$disabled <- disabled
  if (!is.null(min))      msg$min      <- min
  if (!is.null(max))      msg$max      <- max
  session$sendCustomMessage("updateElCheckboxGroup", msg)
  invisible(NULL)
}


#' Checkbox Group Handler Dependency
#' @keywords internal
el_checkbox_group_handler_dependency <- function() {
  .el_handler_dependency("checkbox-group")
}
