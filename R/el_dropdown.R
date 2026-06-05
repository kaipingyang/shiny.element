#' Element UI Dropdown Menu
#'
#' A dropdown menu triggered by hover or click. Each menu item fires a
#' command that is reported as a Shiny input.
#'
#' @param id Dropdown ID. Auto-generated UUID if `NULL`.
#' @param trigger_label Label or tag placed as the dropdown trigger. Default
#'   `"Dropdown"`.
#' @param items A list of menu items. Each element is a named list with:
#'   \describe{
#'     \item{command}{Command value sent to `input$<id>` on click. Required.}
#'     \item{label}{Display text. Defaults to `command`.}
#'     \item{icon}{Icon class string (e.g. `"el-icon-edit"`). Optional.}
#'     \item{disabled}{Whether the item is disabled. Default `FALSE`.}
#'     \item{divided}{Whether to show a divider above this item. Default
#'       `FALSE`.}
#'   }
#' @param trigger Trigger event: `"hover"` (default) or `"click"`.
#' @param type Button type when `split_button = TRUE`: `"primary"`, etc.
#' @param size Component size: `NULL`, `"medium"`, `"small"`, `"mini"`.
#' @param split_button Whether to render as a split button (main + dropdown
#'   arrow). Default `FALSE`.
#' @param hide_on_click Whether to close the menu after an item is clicked.
#'   Default `TRUE`.
#' @param placement Dropdown placement: `"bottom-end"` (default), `"bottom"`,
#'   `"bottom-start"`, `"top"`, `"top-start"`, `"top-end"`.
#' @param disabled Whether the entire dropdown is disabled. Default `FALSE`.
#' @param session Shiny session for module support.
#'
#' @return An `htmltools` tagList with a Vue-managed dropdown component.
#'
#' @section Shiny inputs:
#' - `input$<id>` — the `command` value of the last clicked item.
#' - `input$<id>_count` — click counter, incremented for each item click
#'   (useful to detect re-clicks of the same command).
#'
#' @examples
#' el_dropdown("dd1", "Actions",
#'   items = list(
#'     list(command = "edit",   label = "Edit",   icon = "el-icon-edit"),
#'     list(command = "copy",   label = "Copy",   icon = "el-icon-document"),
#'     list(command = "delete", label = "Delete", icon = "el-icon-delete",
#'          divided = TRUE)
#'   )
#' )
#'
#' @export
el_dropdown <- function(
    id           = NULL,
    trigger_label = "Dropdown",
    items        = list(),
    trigger      = "hover",
    type         = NULL,
    size         = NULL,
    split_button = FALSE,
    hide_on_click = TRUE,
    placement    = "bottom-end",
    disabled     = FALSE,
    session      = shiny::getDefaultReactiveDomain()
) {
  if (is.null(id)) id <- paste0("el_dropdown_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  # Build el-dropdown-item tags
  item_tags <- lapply(items, function(item) {
    cmd     <- item$command
    lbl     <- if (!is.null(item$label)) item$label else as.character(cmd)
    i_attrs <- list(":command" = jsonlite::toJSON(cmd, auto_unbox = TRUE))
    if (isTRUE(item$disabled)) i_attrs[[":disabled"]] <- "true"
    if (isTRUE(item$divided))  i_attrs[[":divided"]]  <- "true"
    if (!is.null(item$icon))   i_attrs[["icon"]]      <- item$icon

    htmltools::tag("el-dropdown-item", c(i_attrs, list(lbl)))
  })

  menu_tag <- htmltools::tag(
    "el-dropdown-menu",
    c(list(slot = "dropdown"), item_tags)
  )

  # Trigger slot content
  trigger_content <- if (isTRUE(split_button)) {
    # split button — label is the main button text
    trigger_label
  } else {
    shiny::tags$span(
      class = "el-dropdown-link",
      trigger_label,
      shiny::tags$i(class = "el-icon-arrow-down el-icon--right")
    )
  }

  dd_attrs <- list(
    ":trigger"       = "trigger",
    ":hide-on-click" = "hideOnClick",
    ":placement"     = "placement",
    ":disabled"      = "disabled",
    ":split-button"  = "splitButton",
    "@command"       = "handleCommand"
  )
  if (!is.null(type)) dd_attrs[[":type"]] <- "type"
  if (!is.null(size)) dd_attrs[[":size"]] <- "size"

  vue_data <- list(
    trigger      = trigger,
    hideOnClick  = hide_on_click,
    placement    = placement,
    disabled     = disabled,
    splitButton  = split_button,
    count        = 0L
  )
  if (!is.null(type)) vue_data$type <- type
  if (!is.null(size)) vue_data$size <- size

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id,
      htmltools::tag("el-dropdown",
        c(dd_attrs, list(trigger_content, menu_tag))
      )
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el      = paste0("#", container_id),
        data    = vue_data,
        methods = list(
          handleCommand = htmlwidgets::JS(sprintf(
            "function(cmd) { this.count++; Shiny.setInputValue('%s', cmd); Shiny.setInputValue('%s_count', this.count); }",
            ns_id, ns_id
          ))
        )
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_dropdown_handler_dependency())
}


#' Update Element UI Dropdown
#'
#' Server-side update for [el_dropdown()].
#'
#' @param session Shiny session object.
#' @param id Dropdown ID (un-namespaced).
#' @param disabled New disabled state.
#'
#' @export
update_el_dropdown <- function(session, id, disabled = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElDropdown", msg)
}


#' @keywords internal
el_dropdown_handler_dependency <- function() {
  htmltools::htmlDependency(
    name      = "el-dropdown-handler",
    version   = "1.0.0",
    src       = system.file("js", package = "shiny.element"),
    script    = "el-dropdown-handler.js",
    all_files = FALSE
  )
}
