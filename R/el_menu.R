#' Build the nested tags inside an `el-menu`
#'
#' Menus nest arbitrarily deep, so the tree is generated in R rather than with
#' `v-for`: a template can only repeat one level, and a menu's shape is fixed
#' at render time anyway.
#'
#' @param items A list of item descriptions, see [el_menu()].
#' @return A list of tags.
#' @keywords internal
.el_menu_nodes <- function(items) {
  lapply(items, function(item) {
    icon  <- if (!is.null(item$icon)) htmltools::tags$i(class = item$icon)
    # `title` is Element's own word for it -- the slot is named title -- and
    # an item given one rendered as a blank entry, with nothing logged.
    text <- if (!is.null(item$label)) item$label else item$title
    if (is.null(text) && is.null(icon)) {
      stop(sprintf("menu item %s has neither a `label` nor an `icon`.",
                   if (is.null(item$index)) "(no index)" else dQuote(item$index, FALSE)),
           call. = FALSE)
    }
    label <- htmltools::tags$span(text)

    if (isTRUE(item$group)) {
      # A titled group of items; it takes no index and cannot be selected.
      htmltools::tag("el-menu-item-group", c(
        list(title = if (!is.null(item$title)) item$title else text),
        .el_menu_nodes(item$children)
      ))

    } else if (length(item$children)) {
      # Element puts a submenu's own label in a named slot, not its body.
      title <- htmltools::tag("template", list(slot = "title", icon, label))
      attrs <- c(list(index = item$index), .el_menu_item_props(item, c(
        "disabled", "popper_class", "show_timeout", "hide_timeout",
        "popper_append_to_body")))
      htmltools::tag("el-submenu", c(attrs, list(title),
                                     .el_menu_nodes(item$children)))

    } else {
      attrs <- c(list(index = item$index), .el_menu_item_props(item, c("disabled", "route")),
                 # Element's own per-item click, alongside the menu's select
                 list("@click" = sprintf("elMenuItemClick(%s)",
                                         jsonlite::toJSON(item$index, auto_unbox = TRUE))))
      htmltools::tag("el-menu-item", c(attrs, list(icon, label)))
    }
  })
}

#' Bind the per-item props a menu item or submenu was given
#'
#' @param item One item description.
#' @param fields The snake_case fields to look for.
#' @return A list of `:kebab-case` bindings, one per field present.
#' @keywords internal
.el_menu_item_props <- function(item, fields) {
  out <- list()
  for (f in fields) {
    v <- item[[f]] %||% item[[.el_camel_case(f)]]
    if (is.null(v)) next
    out[[paste0(":", gsub("_", "-", f))]] <- jsonlite::toJSON(v, auto_unbox = TRUE)
  }
  out
}

`%||%` <- function(a, b) if (is.null(a)) b else a


#' Element UI Menu
#'
#' A navigation menu, vertical or horizontal, with submenus nested to any
#' depth.
#'
#' @param id Menu ID (auto-generated if NULL).
#' @param items A list of items. Each is a list with `index` (the value
#'   reported when selected), `label` (or `title`, Element's name for it),
#'   and optionally `icon` (an Element icon
#'   class such as `"el-icon-house"`), `disabled`, `route` (for
#'   `router = TRUE`), or `children` for a submenu. A submenu may also carry
#'   `popper_class`, `show_timeout`, `hide_timeout` and
#'   `popper_append_to_body`. An item with `group = TRUE` becomes a titled
#'   group of its `children` rather than a submenu.
#'
#'   Clicking an item reports `input$<id>` (the index selected) and
#'   `input$<id>_item_click` (the index clicked).
#' @param active Index of the initially selected item.
#' @param mode `"vertical"` (default) or `"horizontal"`.
#' @param collapse Collapse to icons only. Vertical menus only.
#' @param unique_opened Keep only one submenu open at a time.
#' @param background_color,text_color,active_text_color Menu colours.
#' @param session Deprecated. Inside a module, wrap `id` in `ns()`, as for
#'   any Shiny input; a session given here namespaces `id` once more, with
#'   a warning.
#' @param default_openeds Character vector of sub-menu indexes open at start.
#' @param menu_trigger How a horizontal sub-menu opens: `"hover"` (default) or `"click"`.
#' @param collapse_transition Whether to animate collapsing. Default `TRUE`.
#' @param router Whether to use vue-router mode, taking each index as a path.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @section Server inputs:
#' `input$<id>` holds the selected item's `index`, reported on load and on
#' every selection -- `NULL` while no item is active. `input$<id>_path` holds
#' the full path of indexes down to
#' it, so a nested item can be told apart from a top-level one with the same
#' index.
#'
#' @section Element methods:
#' Callable with [el_call()]:
#'
#' - `close()` -- Close a specific sub-menu
#' - `open()` -- Open a specific sub-menu
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_menu(
#'   id = "nav",
#'   active = "home",
#'   items = list(
#'     list(index = "home", label = "Home", icon = "el-icon-house"),
#'     list(index = "products", label = "Products", icon = "el-icon-goods",
#'          children = list(
#'            list(index = "products-all", label = "All"),
#'            list(index = "products-new", label = "New")
#'          )),
#'     list(index = "help", label = "Help", disabled = TRUE)
#'   )
#' )
#'
#' # Horizontal, as a top bar
#' el_menu(id = "topnav", mode = "horizontal", active = "a",
#'         items = list(list(index = "a", label = "One"),
#'                      list(index = "b", label = "Two")))
el_menu <- function(id = NULL,
                    items = list(),
                    active = NULL,
                    mode = "vertical",
                    collapse = FALSE,
                    unique_opened = FALSE,
                    background_color = NULL,
                    text_color = NULL,
                    active_text_color = NULL,
                    default_openeds = NULL,
                    menu_trigger = NULL,
                    collapse_transition = NULL,
                    router  = NULL,
                    width   = NULL,
                    slots   = NULL,
                    session = NULL) {
  .el_check_choices("el_menu", environment())
  if (is.null(id)) id <- paste0("el_menu_", uuid::UUIDgenerate())
  ns_id        <- .el_ui_id(id, session)
  container_id <- paste0(ns_id, "_container")
  active       <- shiny::restoreInput(ns_id, active)

  menu_attrs <- list(
    ":default-active"    = "active",
    ":mode"              = "mode",
    ":collapse"          = "collapse",
    ":unique-opened"     = "uniqueOpened",
    ":background-color"  = .el_optional_bind("backgroundColor"),
    ":text-color"        = .el_optional_bind("textColor"),
    ":active-text-color" = .el_optional_bind("activeTextColor"),
    "@select"            = "handleSelect"
  )

  menu_attrs[[":default-openeds"]] <- .el_optional_bind("defaultOpeneds")

  menu_attrs[[":menu-trigger"]] <- .el_optional_bind("menuTrigger")

  menu_attrs[[":collapse-transition"]] <- .el_optional_bind("collapseTransition")

  menu_attrs[[":router"]] <- .el_optional_bind("router")


  # Forwarded to input$<id>_<event>; see .el_event_bindings().

  events <- .el_event_bindings(ns_id, c(

    "open",

    "close"

  ),
    shapes = list(
    "open"  = "function(index, path) { return {index: index, path: path}; }",
    "close" = "function(index, path) { return {index: index, path: path}; }"
  ))

  menu_attrs <- c(menu_attrs, events$attrs)

  vue_data <- list(
    active          = if (is.null(active)) "" else active,
    mode            = mode,
    collapse        = collapse,
    uniqueOpened    = unique_opened,
    backgroundColor = if (is.null(background_color)) NA else background_color,
    textColor       = if (is.null(text_color)) NA else text_color,
    activeTextColor = if (is.null(active_text_color)) NA else active_text_color,
    path            = list()
  )

  vue_data$defaultOpeneds <- .el_or_na(default_openeds)

  vue_data$menuTrigger <- .el_or_na(menu_trigger)

  vue_data$collapseTransition <- .el_or_na(collapse_transition)

  vue_data$router <- .el_or_na(router)

  el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-menu", c(menu_attrs, .el_menu_nodes(items))),
    data = vue_data,
    methods = c(events$methods, list(
      # Element's menu-item click: input$<id>_item_click, the index clicked.
      # select covers most uses; this fires for a disabled-select menu too.
      elMenuItemClick = htmlwidgets::JS(sprintf(
        "function(index) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_item_click', index, {priority: 'event'}); }",
        ns_id
      )),
      handleSelect = htmlwidgets::JS(sprintf(
        paste0(
          "function(index, indexPath) { var self = this; ",
          "self.active = index; self.path = indexPath; ",
          "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%1$s', index); ",
          "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%1$s_path', indexPath); }"
        ), ns_id
      ))
    )),
    # Nothing active is reported as NULL rather than Element's "", so that an
    # observeEvent(input$<id>) does not fire on load for a menu with no
    # current item.
    mounted = .el_mounted_init(stats::setNames(
      c("active || null", "path"), paste0(ns_id, c("", "_path"))
    )),
    width      = width,
    slots      = slots
  )
}

#' Update an Element UI Menu
#'
#' @param session Shiny session; the current one by default, as for
#'   [shiny::updateTextInput()].
#' @param id Menu ID (un-namespaced).
#' @param active Index of the item to select.
#' @param collapse New collapsed state.
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_menu(session, "nav", active = "data")
#'   })
#' }
#' @export
update_el_menu <- function(session = shiny::getDefaultReactiveDomain(), id, active = NULL, collapse = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(active))   msg$active   <- active
  if (!is.null(collapse)) msg$collapse <- collapse
  .el_send_update(session, msg)
  invisible(NULL)
}
