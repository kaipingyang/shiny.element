#' Element UI Tags (auto-generated, pure tag generators)
#'
#' Provides a list of functions for generating Element UI tags (el-*), similar to `tags$p`.
#' These functions do not create Vue instances or Shiny bindings.
#'
#' Categories:
#' - Basic: button, link, icon
#' - Layout: container, header, aside, main, footer, row, col
#' - Form: form, form-item, input, input-number, radio, radio-group, radio-button,
#'   checkbox, checkbox-group, switch, select, option, option-group, cascader, cascader-panel,
#'   slider, time-picker, time-select, date-picker, upload, rate, color-picker, transfer, autocomplete
#' - Data: table, table-column, tag, progress, tree, pagination, badge, avatar, calendar, card,
#'   carousel, carousel-item, collapse, collapse-item, timeline, timeline-item, divider, image,
#'   empty, skeleton, result, statistic, descriptions, descriptions-item
#' - Navigation: menu, submenu, menu-item, menu-item-group, tabs, tab-pane, breadcrumb,
#'   breadcrumb-item, dropdown, dropdown-menu, dropdown-item, steps, step, page-header,
#'   backtop, anchor, anchor-link
#' - Feedback: dialog, alert, drawer, popover, tooltip, popconfirm, loading
#'
#' @examples
#' # List all available Element UI tag generators
#' names(el)
#'
#' # Use with auto-generated tag functions
#' el$button("Submit", type = "primary")
#' el$table(
#'   el$table_column(prop = "name", label = "Name"),
#'   el$table_column(prop = "age", label = "Age")
#' )
#' el$icon("star")
#' @export
el <- local({
  el <- list()

  # List of Element UI tag names (from official docs, not exhaustive)
  el_tag_names <- c(
    # Basic
    "button", "link", "icon",
    # Layout
    "container", "header", "aside", "main", "footer", "row", "col",
    # Form
    "form", "form-item", "input", "input-number", "radio", "radio-group", "radio-button",
    "checkbox", "checkbox-group", "switch", "select", "option", "option-group",
    "cascader", "cascader-panel", "slider", "time-picker", "time-select", "date-picker",
    "upload", "rate", "color-picker", "transfer", "autocomplete",
    # Data
    "table", "table-column", "tag", "progress", "tree", "pagination", "badge", "avatar",
    "calendar", "card", "carousel", "carousel-item", "collapse", "collapse-item",
    "timeline", "timeline-item", "divider", "image", "empty", "skeleton", "result",
    "statistic", "descriptions", "descriptions-item",
    # Navigation
    "menu", "submenu", "menu-item", "menu-item-group", "tabs", "tab-pane", "breadcrumb",
    "breadcrumb-item", "dropdown", "dropdown-menu", "dropdown-item", "steps", "step",
    "page-header", "backtop", "anchor", "anchor-link",
    # Feedback
    "dialog", "alert", "drawer", "popover", "tooltip", "popconfirm", "loading"
  )

  # Auto-generate each tag function
  for (tag in el_tag_names) {
    # convert tag name to valid R function name (replace - with _)
    fun_name <- gsub("-", "_", tag)
    el[[fun_name]] <- eval(bquote(
      function(...) {
        htmltools::tag(.(paste0("el-", tag)), list(...))
      }
    ))
    # Add roxygen2-style comment as attribute for documentation tools (optional)
    attr(el[[fun_name]], "comment") <- paste0("Create a pure <el-", tag, "> tag. See Element UI docs for usage.")
  }

  # Special case: icon (for compatibility with your el_icon.R)
  el$icon <- function(name, ...) {
    htmltools::tags$i(class = paste0("el-icon-", name), ...)
  }
  el
})



