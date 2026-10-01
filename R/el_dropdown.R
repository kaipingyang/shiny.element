#' Element UI Dropdown Menu
#'
#' A dropdown menu triggered by hover or click. Each menu item fires a
#' command that is reported as a Shiny input.
#'
#' @param id Dropdown ID. Auto-generated UUID if `NULL`.
#' @param trigger_label The dropdown's trigger. Text gets a down arrow after
#'   it; a tag -- an icon, an avatar -- is used as it is. Default
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
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param show_timeout Delay in ms before the menu appears, for `trigger = "hover"`.
#' @param hide_timeout Delay in ms before the menu hides, for `trigger = "hover"`.
#' @param tabindex Tab index of the dropdown trigger.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
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
    show_timeout = NULL,
    hide_timeout = NULL,
    tabindex     = NULL,
    width        = NULL,
    slots        = NULL,
    session      = NULL
) {
  .el_check_choices("el_dropdown", environment())
  if (is.null(id)) id <- paste0("el_dropdown_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
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
  } else if (is.character(trigger_label)) {
    shiny::tags$span(
      class = "el-dropdown-link",
      trigger_label,
      shiny::tags$i(class = "el-icon-arrow-down el-icon--right")
    )
  } else {
    # A tag is the trigger as given -- an icon, an avatar -- with no arrow
    # added, as Element's own examples write it.
    shiny::tags$span(class = "el-dropdown-link", trigger_label)
  }

  dd_attrs <- list(
    ":trigger"       = "trigger",
    ":hide-on-click" = "hideOnClick",
    ":placement"     = "placement",
    ":disabled"      = "disabled",
    ":split-button"  = "splitButton",
    "@command"       = "handleCommand"
  )
  dd_attrs[[":type"]] <- .el_optional_bind("type")
  dd_attrs[[":size"]] <- .el_optional_bind("size")
  dd_attrs[[":show-timeout"]] <- .el_optional_bind("showTimeout")
  dd_attrs[[":hide-timeout"]] <- .el_optional_bind("hideTimeout")
  dd_attrs[[":tabindex"]] <- .el_optional_bind("tabindex")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(ns_id, c(
    "click",
    "visible-change"
  ))
  dd_attrs <- c(dd_attrs, events$attrs)
  vue_data <- list(
    trigger      = trigger,
    hideOnClick  = hide_on_click,
    placement    = placement,
    disabled     = disabled,
    splitButton  = split_button,
    count        = 0L
  )
  vue_data$type <- .el_or_na(type)
  vue_data$size <- .el_or_na(size)
  vue_data$showTimeout <- .el_or_na(show_timeout)
  vue_data$hideTimeout <- .el_or_na(hide_timeout)
  vue_data$tabindex <- .el_or_na(tabindex)
  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-dropdown", c(dd_attrs, list(trigger_content, menu_tag))),
    data   = vue_data,
    methods = c(events$methods, list(
      handleCommand = htmlwidgets::JS(sprintf(
        "function(cmd) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', cmd); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_count', this.count); }",
        ns_id, ns_id
      ))
    )),
    width      = width,
    slots      = slots,
    dependency = el_dropdown_handler_dependency()
  )
}


#' Update Element UI Dropdown
#'
#' Server-side update for [el_dropdown()].
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Dropdown ID (un-namespaced).
#' @param disabled New disabled state.
#'
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_dropdown(session, "actions", disabled = TRUE)
#'   })
#' }
#' @export
update_el_dropdown <- function(session = shiny::getDefaultReactiveDomain(), id, disabled = NULL) {
  ns_id <- session$ns(id)
  msg   <- list(id = ns_id)
  if (!is.null(disabled)) msg$disabled <- disabled
  session$sendCustomMessage("updateElDropdown", msg)
  invisible(NULL)
}


#' @keywords internal
el_dropdown_handler_dependency <- function() {
  .el_handler_dependency("dropdown")
}
