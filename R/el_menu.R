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
    label <- htmltools::tags$span(item$label)

    if (isTRUE(item$group)) {
      # A titled group of items; it takes no index and cannot be selected.
      htmltools::tag("el-menu-item-group", c(
        list(title = if (!is.null(item$title)) item$title else item$label),
        .el_menu_nodes(item$children)
      ))

    } else if (length(item$children)) {
      # Element puts a submenu's own label in a named slot, not its body.
      title <- htmltools::tag("template", list(slot = "title", icon, label))
      htmltools::tag("el-submenu", c(
        list(index = item$index),
        list(title),
        .el_menu_nodes(item$children)
      ))

    } else {
      attrs <- list(index = item$index)
      if (isTRUE(item$disabled)) attrs$disabled <- NA
      htmltools::tag("el-menu-item", c(attrs, list(icon, label)))
    }
  })
}

#' Element UI Menu
#'
#' A navigation menu, vertical or horizontal, with submenus nested to any
#' depth.
#'
#' @param id Menu ID (auto-generated if NULL).
#' @param items A list of items. Each is a list with `index` (the value
#'   reported when selected), `label`, and optionally `icon` (an Element icon
#'   class such as `"el-icon-house"`), `disabled`, or `children` for a
#'   submenu. An item with `group = TRUE` becomes a titled group of its
#'   `children` rather than a submenu.
#' @param active Index of the initially selected item.
#' @param mode `"vertical"` (default) or `"horizontal"`.
#' @param collapse Collapse to icons only. Vertical menus only.
#' @param unique_opened Keep only one submenu open at a time.
#' @param background_color,text_color,active_text_color Menu colours.
#' @param session Shiny session for module support.
#' @param default_openeds Character vector of sub-menu indexes open at start.
#' @param menu_trigger How a horizontal sub-menu opens: `"hover"` (default) or `"click"`.
#' @param collapse_transition Whether to animate collapsing. Default `TRUE`.
#' @param router Whether to use vue-router mode, taking each index as a path.
#'
#' @section Server inputs:
#' `input$<id>` holds the selected item's `index`, reported on load and on
#' every selection. `input$<id>_path` holds the full path of indexes down to
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
                    session = shiny::getDefaultReactiveDomain()) {
  if (is.null(id)) id <- paste0("el_menu_", uuid::UUIDgenerate())
  ns_id        <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

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

  component_ui <- shiny::tagList(
    shiny::tags$div(
      id = container_id, style = .el_host_style(),
      htmltools::tag("el-menu", c(menu_attrs, .el_menu_nodes(items)))
    ),
    vueR::vue(
      elementId = ns_id, width = 0, height = 0,
      list(
        el   = paste0("#", container_id),
        data = vue_data,
        methods = c(events$methods, list(
          handleSelect = htmlwidgets::JS(sprintf(
            paste0(
              "function(index, indexPath) { var self = this; ",
              "self.active = index; self.path = indexPath; ",
              "Shiny.setInputValue('%1$s', index); ",
              "Shiny.setInputValue('%1$s_path', indexPath); }"
            ), ns_id
          ))
        )),
        mounted = .el_mounted_init(stats::setNames(
          c("active", "path"), paste0(ns_id, c("", "_path"))
        ))
      )
    )
  )

  htmltools::attachDependencies(component_ui, el_menu_handler_dependency())
}

#' Update an Element UI Menu
#'
#' @param session Shiny session object.
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
update_el_menu <- function(session, id, active = NULL, collapse = NULL) {
  msg <- list(id = session$ns(id))
  if (!is.null(active))   msg$active   <- active
  if (!is.null(collapse)) msg$collapse <- collapse
  session$sendCustomMessage("updateElMenu", msg)
  invisible(NULL)
}
