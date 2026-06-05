#' Normalize choices for el_checkbox_group
#'
#' Converts various choice formats into a uniform list of
#' `list(value = ..., label = ...)` items.
#'
#' @param choices Named character vector, list of lists, or unnamed vector.
#' @return A list of `list(value, label)` items.
#' @keywords internal
normalize_choices <- function(choices) {
  if (is.character(choices) && !is.null(names(choices))) {
    result <- mapply(
      function(lbl, val) list(value = val, label = lbl),
      names(choices), unname(choices),
      SIMPLIFY = FALSE
    )
    unname(result)
  } else if (is.list(choices)) {
    choices
  } else {
    lapply(choices, function(x) list(value = x, label = as.character(x)))
  }
}


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
    session  = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_checkbox_group_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  cb_tag_name <- if (button) "el-checkbox-button" else "el-checkbox"
  cb_slot <- htmltools::tag(cb_tag_name, list(
    ":label" = "opt.value",
    "v-for"  = "opt in options",
    ":key"   = "opt.value",
    htmltools::HTML("{{opt.label}}")
  ))

  group_attrs <- list(
    "v-model"   = "value",
    ":disabled" = "disabled",
    "@change"   = "handleChange"
  )
  if (!is.null(size)) group_attrs[[":size"]] <- "size"
  if (!is.null(min))  group_attrs[[":min"]]  <- "min"
  if (!is.null(max))  group_attrs[[":max"]]  <- "max"

  group_tag <- htmltools::tag("el-checkbox-group", c(group_attrs, list(cb_slot)))

  vue_data <- list(
    value    = if (is.null(selected)) list() else as.list(selected),
    options  = normalize_choices(choices),
    disabled = disabled
  )
  if (!is.null(size)) vue_data$size <- size
  if (!is.null(min))  vue_data$min  <- min
  if (!is.null(max))  vue_data$max  <- max

  component_ui <- shiny::tagList(
    shiny::tags$div(id = container_id, group_tag),
    vueR::vue(
      elementId = ns_id,
      list(
        el   = paste0("#", container_id),
        data = vue_data,
        methods = list(
          handleChange = htmlwidgets::JS(sprintf(
            "function(value) { Shiny.setInputValue('%s', value); }",
            ns_id
          ))
        )
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
  if (!is.null(options))  msg$options  <- options
  if (!is.null(disabled)) msg$disabled <- disabled
  if (!is.null(min))      msg$min      <- min
  if (!is.null(max))      msg$max      <- max
  session$sendCustomMessage("updateElCheckboxGroup", msg)
}


#' Checkbox Group Handler Dependency
#' @keywords internal
el_checkbox_group_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-checkbox-group-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-checkbox-group-handler.js",
    all_files = FALSE
  )
}
