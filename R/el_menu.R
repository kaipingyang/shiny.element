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
    icon <- if (!is.null(item$icon)) .el_vue_icon(item$icon)
    # `title` is Element's own word for it -- the slot is named title -- and
    # an item given one rendered as a blank entry, with nothing logged.
    text <- if (!is.null(item$label)) item$label else item$title
    if (is.null(text) && is.null(icon)) {
      stop(
        sprintf(
          "menu item %s has neither a `label` nor an `icon`.",
          if (is.null(item$index)) "(no index)" else dQuote(item$index, FALSE)
        ),
        call. = FALSE
      )
    }
    label <- htmltools::tags$span(text)

    if (isTRUE(item$group)) {
      # A titled group of items; it takes no index and cannot be selected.
      htmltools::tag(
        "el-menu-item-group",
        c(
          list(title = if (!is.null(item$title)) item$title else text),
          .el_menu_nodes(item$children)
        )
      )
    } else if (length(item$children)) {
      # Element puts a submenu's own label in a named slot, not its body.
      title <- .el_slot("title", icon, label)
      attrs <- c(
        list(index = item$index),
        .el_menu_item_props(
          item,
          c(
            "disabled",
            "popper_class",
            "popper_style",
            "show_timeout",
            "hide_timeout",
            "teleported",
            "popper_offset",
            "expand_close_icon",
            "expand_open_icon",
            "collapse_close_icon",
            "collapse_open_icon"
          )
        )
      )
      htmltools::tag(
        "el-sub-menu",
        c(attrs, list(title), .el_menu_nodes(item$children))
      )
    } else {
      attrs <- c(
        list(index = item$index),
        .el_menu_item_props(item, c("disabled", "route")),
        # Element's own per-item click, alongside the menu's select
        list(
          "@click" = sprintf(
            "elMenuItemClick(%s)",
            jsonlite::toJSON(item$index, auto_unbox = TRUE)
          )
        )
      )
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
    if (is.null(v)) {
      next
    }
    out[[paste0(":", gsub("_", "-", f))]] <- jsonlite::toJSON(
      v,
      auto_unbox = TRUE
    )
  }
  out
}

`%||%` <- function(a, b) if (is.null(a)) b else a


#' Element Plus Menu
#'
#' A navigation menu, vertical or horizontal, with submenus nested to any
#' depth.
#'
#' @param id Menu ID (auto-generated if NULL).
#' @param items A list of items, each an [el_menu_item()], [el_sub_menu()] or
#'   [el_menu_item_group()] -- or a list with `index` (the value
#'   reported when selected), `label` (or `title`, Element's name for it),
#'   and optionally `icon` (an icon's name, such as `"House"`), `disabled`,
#'   `route` (for `router = TRUE`), or `children` for a submenu. A submenu
#'   may also carry Element Plus's sub-menu props: `popper_class`,
#'   `popper_style`, `show_timeout`, `hide_timeout`, `teleported`,
#'   `popper_offset`, and its expand and collapse icons
#'   (`expand_close_icon`, `expand_open_icon`, `collapse_close_icon`,
#'   `collapse_open_icon`). An item with `group = TRUE` becomes a titled
#'   group of its `children` rather than a submenu.
#'
#'   Clicking an item reports `input$<id>` (the index selected) and
#'   `input$<id>_item_click` (the index clicked).
#' @param default_active Index of the initially selected item: Element Plus's
#'   `default-active`. In `update_el_menu()`, the item to select.
#' @param mode `"vertical"` (default) or `"horizontal"`.
#' @param collapse Collapse to icons only. Vertical menus only.
#' @param unique_opened Keep only one submenu open at a time.
#' @param background_color,text_color,active_text_color Menu colours.
#' @param close_on_click_outside Optional, whether menu is collapsed when
#'   clicking outside. Element Plus's `close-on-click-outside` (boolean).
#' @param ellipsis Whether the menu is ellipsis (available only in horizontal
#'   mode). Element Plus's `ellipsis` (boolean).
#' @param ellipsis_icon Custom ellipsis icon (available only in horizontal
#'   mode and ellipsis is true). Element Plus's `ellipsis-icon` (string /
#'   Component). An icon's name, such as `"Search"`.
#' @param hide_timeout Control timeout for all menus before hiding. Element
#'   Plus's `hide-timeout` (number).
#' @param persistent When menu inactive and `persistent` is `false` , dropdown
#'   menu will be destroyed. Element Plus's `persistent` (boolean).
#' @param popper_class Custom class name for all popup menus and titles'
#'   tooltips. Element Plus's `popper-class` (string).
#' @param popper_effect Tooltip theme, built-in theme: `dark` / `light` when
#'   menu is collapsed. Element Plus's `popper-effect` ('dark' | 'light' /
#'   string).
#' @param popper_offset Offset of the popper (effective for all submenus).
#'   Element Plus's `popper-offset` (number).
#' @param popper_style Custom style for all popup menus and titles' tooltips.
#'   Element Plus's `popper-style` (string / object).
#' @param show_timeout Control timeout for all menus before showing. Element
#'   Plus's `show-timeout` (number).
#' @param session In `el_menu()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_menu()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
#' @param default_openeds Character vector of sub-menu indexes open at start.
#' @param menu_trigger How a horizontal sub-menu opens: `"hover"` (default) or `"click"`.
#' @param collapse_transition Whether to animate collapsing. Default `TRUE`.
#' @param router Whether to use vue-router mode, taking each index as a path.
#' @param class,style Extra classes and inline style on the menu, as
#'   Element passes them to its root: Element's examples style theirs by a
#'   class of their own.
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @param slots Named list of Element slot contents, such as
#'   `list(title = shiny::tags$b("Bold"))`. A shiny.element component
#'   given here is absorbed rather than nested. For a scoped slot, write
#'   the template with [template()].
#'
#' @template events
#' @template on
#' @section Shiny inputs:
#' `r .el_events_md("el_menu")`
#'
#' @section Element methods:
#' Callable with [call_el()]:
#'
#' - `close()` -- Close a specific sub-menu
#' - `open()` -- Open a specific sub-menu
#'
#' @return A Shiny UI element.
#' @export
#' @examples
#' el_menu(
#'   id = "nav",
#'   default_active = "home",
#'   items = list(
#'     list(index = "home", label = "Home", icon = "House"),
#'     list(
#'       index = "products",
#'       label = "Products",
#'       icon = "Goods",
#'       children = list(
#'         list(index = "products-all", label = "All"),
#'         list(index = "products-new", label = "New")
#'       )
#'     ),
#'     list(index = "help", label = "Help", disabled = TRUE)
#'   )
#' )
#'
#' # Horizontal, as a top bar
#' el_menu(
#'   id = "topnav",
#'   mode = "horizontal",
#'   default_active = "a",
#'   items = list(
#'     list(index = "a", label = "One"),
#'     list(index = "b", label = "Two")
#'   )
#' )
el_menu <- function(
  id = NULL,
  items = list(),
  default_active = NULL,
  mode = "vertical",
  collapse = FALSE,
  unique_opened = FALSE,
  background_color = NULL,
  text_color = NULL,
  active_text_color = NULL,
  default_openeds = NULL,
  menu_trigger = NULL,
  collapse_transition = NULL,
  router = NULL,
  close_on_click_outside = NULL,
  ellipsis = NULL,
  ellipsis_icon = NULL,
  hide_timeout = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_effect = NULL,
  popper_offset = NULL,
  popper_style = NULL,
  show_timeout = NULL,
  class = NULL,
  style = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
) {
  .el_check_items(items, "items", c("index", "label"))
  .el_check_choices("el_menu", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_menu")
  }
  ns_id <- .el_ui_id(id, session)
  default_active <- shiny::restoreInput(ns_id, default_active)

  menu_attrs <- list(
    ":default-active" = "active",
    ":mode" = "mode",
    ":collapse" = "collapse",
    ":unique-opened" = "uniqueOpened",
    ":background-color" = .el_optional_bind("backgroundColor"),
    ":text-color" = .el_optional_bind("textColor"),
    ":active-text-color" = .el_optional_bind("activeTextColor"),
    "@select" = "handleSelect"
  )

  menu_attrs[[":default-openeds"]] <- .el_optional_bind("defaultOpeneds")

  menu_attrs[[":menu-trigger"]] <- .el_optional_bind("menuTrigger")

  menu_attrs[[":collapse-transition"]] <- .el_optional_bind(
    "collapseTransition"
  )

  menu_attrs[[":router"]] <- .el_optional_bind("router")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().

  events <- .el_event_bindings(
    ns_id,
    "el_menu",
    events,
    on = on,
    shapes = list(
      "open" = "function(index, path) { return {index: index, path: path}; }",
      "close" = "function(index, path) { return {index: index, path: path}; }"
    )
  )

  menu_attrs <- c(menu_attrs, events$attrs)

  vue_data <- list(
    active = if (is.null(default_active)) "" else default_active,
    mode = mode,
    collapse = collapse,
    uniqueOpened = unique_opened,
    backgroundColor = if (is.null(background_color)) NA else background_color,
    textColor = if (is.null(text_color)) NA else text_color,
    activeTextColor = if (is.null(active_text_color)) NA else active_text_color,
    path = list()
  )

  vue_data$defaultOpeneds <- .el_or_na(default_openeds)

  vue_data$menuTrigger <- .el_or_na(menu_trigger)

  vue_data$collapseTransition <- .el_or_na(collapse_transition)

  vue_data$router <- .el_or_na(router)

  el_widget(
    props = .el_props(list(
      close_on_click_outside = close_on_click_outside,
      ellipsis = ellipsis,
      ellipsis_icon = .el_icon_name(ellipsis_icon),
      hide_timeout = hide_timeout,
      persistent = persistent,
      popper_class = popper_class,
      popper_effect = popper_effect,
      popper_offset = popper_offset,
      popper_style = popper_style,
      show_timeout = show_timeout
    )),
    id = ns_id,
    markup = htmltools::tag(
      "el-menu",
      c(menu_attrs, list(class = class, style = style), .el_menu_nodes(items))
    ),
    data = vue_data,
    methods = c(
      events$methods,
      list(
        # Element's menu-item click: input$<id>_item_click, the index clicked.
        # select covers most uses; this fires for a disabled-select menu too.
        elMenuItemClick = JS(sprintf(
          "function(index) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_item_click', index, {priority: 'event'}); }",
          ns_id
        )),
        handleSelect = JS(sprintf(
          paste0(
            "function(index, indexPath) { var self = this; ",
            "self.active = index; self.path = indexPath; ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%1$s', index); ",
            "window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%1$s_path', indexPath); }"
          ),
          ns_id
        ))
      )
    ),
    # Nothing active is reported as NULL rather than Element's "", so that an
    # observeEvent(input$<id>) does not fire on load for a menu with no
    # current item.
    mounted = .el_mounted_init(stats::setNames(
      c("active || null", "path"),
      paste0(ns_id, c("", "_path"))
    )),
    width = width,
    slots = slots
  )
}

#' @rdname el_menu
#' @section Updating from the server:
#' `update_el_menu()` changes the component from the server.
#'
#' Every other argument of [el_menu()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_menu()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_menu(session, "nav", default_active = "data")
#'   })
#' }
#' @export
update_el_menu <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  default_active = NULL,
  collapse = NULL,
  mode = NULL,
  unique_opened = NULL,
  background_color = NULL,
  text_color = NULL,
  active_text_color = NULL,
  menu_trigger = NULL,
  collapse_transition = NULL,
  router = NULL,
  close_on_click_outside = NULL,
  ellipsis = NULL,
  ellipsis_icon = NULL,
  hide_timeout = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_effect = NULL,
  popper_offset = NULL,
  popper_style = NULL,
  show_timeout = NULL
) {
  .el_check_session(session)
  msg <- list(id = session$ns(id))
  if (!is.null(default_active)) {
    msg$active <- default_active
  }
  if (!is.null(collapse)) {
    msg$collapse <- collapse
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_menu",
      Filter(
        Negate(is.null),
        list(
          mode = mode,
          unique_opened = unique_opened,
          background_color = background_color,
          text_color = text_color,
          active_text_color = active_text_color,
          menu_trigger = menu_trigger,
          collapse_transition = collapse_transition,
          router = router,
          close_on_click_outside = close_on_click_outside,
          ellipsis = ellipsis,
          ellipsis_icon = ellipsis_icon,
          hide_timeout = hide_timeout,
          persistent = persistent,
          popper_class = popper_class,
          popper_effect = popper_effect,
          popper_offset = popper_offset,
          popper_style = popper_style,
          show_timeout = show_timeout
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
