#' Element UI tags, for markup inside a component
#'
#' A tag generator for every Element tag, as `tags$p` is for HTML:
#' `el$button(type = "primary", "Go")` writes `<el-button type="primary">`.
#' Nothing more -- no Vue instance, no Shiny input, no id.
#'
#' An `<el-*>` tag becomes an Element component only when a Vue instance
#' compiles it, so these belong where one already does:
#'
#' * the `markup` of [el_widget()], when building a component of your own;
#' * a [template()] or a component's `slots`;
#' * a table column's `cell` in [el_table()];
#' * the trigger of a wrapper -- [el_tooltip()], [el_popover()],
#'   [el_popconfirm()].
#'
#' Anywhere else -- the top level of a page, or inside the markup-only
#' containers ([el_tabs()], [el_collapse()], [el_dialog()], [el_drawer()],
#' [el_row()], [el_container()]) -- nothing compiles them and they show as
#' bare text; the browser console says so. There, use the component
#' functions: [el_button()], [el_tag()] and the rest.
#'
#' Mounting a Vue instance over such markup automatically is deliberately not
#' done: it would rebuild every component and Shiny input inside it, leaving
#' them on screen but disconnected from the server.
#'
#' @examples
#' names(el)
#'
#' # As a wrapper's trigger, compiled by the tooltip's own instance
#' el_tooltip("hint", el$button(type = "primary", "Hover me"), content = "Help")
#'
#' # In a table cell, once per row
#' el_table("tasks", data = data.frame(task = c("Draft", "Review"), done = c(TRUE, FALSE)),
#'   columns = list(
#'     list(prop = "task", label = "Task"),
#'     list(label = "State", cell = el$tag(
#'       ":type" = "scope.row.done ? 'success' : 'info'",
#'       "{{ scope.row.done ? 'done' : 'open' }}"))))
#'
#' # As the markup of a component of your own
#' el_widget("me", markup = el$avatar(":size" = "size", "{{ initials }}"),
#'           data = list(size = 48, initials = "KY"))
#' @return A named list of tag-generating functions, one per Element UI tag.
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
    "statistic", "descriptions", "descriptions-item", "skeleton-item",
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



