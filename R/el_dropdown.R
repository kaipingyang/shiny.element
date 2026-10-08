#' Element Plus Dropdown Menu
#'
#' A dropdown menu triggered by hover or click. Each menu item fires a
#' command that is reported as a Shiny input.
#'
#' @param id Dropdown ID. Auto-generated UUID if `NULL`.
#' @param trigger_label The dropdown's trigger. Text gets a down arrow after
#'   it; a tag -- an icon, an avatar -- is used as it is. Default
#'   `"Dropdown"`.
#' @param items A list of menu entries, each an [el_dropdown_item()] -- or a
#'   named list with the same fields:
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
#' @param size Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or the page.
#' @param split_button Whether to render as a split button (main + dropdown
#'   arrow). Default `FALSE`.
#' @param hide_on_click Whether to close the menu after an item is clicked.
#'   Default `TRUE`.
#' @param placement Dropdown placement: `"bottom-end"` (default), `"bottom"`,
#'   `"bottom-start"`, `"top"`, `"top-start"`, `"top-end"`.
#' @param disabled Whether the entire dropdown is disabled. Default `FALSE`.
#' @param append_to Which element the dropdown CONTENT appends to. Element
#'   Plus's `append-to` (CSSSelector / HTMLElement).
#' @param button_props Props for the button component, refer to Button
#'   Attributes. Element Plus's `button-props` (object).
#' @param effect Tooltip theme, built-in theme: `dark` / `light`. Element
#'   Plus's `effect` ('dark' | 'light' / string).
#' @param max_height The max height of menu. Element Plus's `max-height`
#'   (string / number).
#' @param persistent When dropdown inactive and `persistent` is `false` ,
#'   dropdown menu will be destroyed. Element Plus's `persistent` (boolean).
#' @param popper_class Custom class name for Dropdown's dropdown. Element
#'   Plus's `popper-class` (string / object).
#' @param popper_options Popper.js parameters. Element Plus's `popper-options`
#'   (object).
#' @param popper_style Custom style for Dropdown's dropdown. Element Plus's
#'   `popper-style` (string / object).
#' @param role The ARIA role attribute for the dropdown menu. Depending on the
#'   use case, you may want to change this to 'navigation'. Element Plus's
#'   `role` (enum).
#' @param show_arrow Whether the tooltip content has an arrow. Element Plus's
#'   `show-arrow` (boolean).
#' @param teleported Whether the dropdown popup is teleported to the body.
#'   Element Plus's `teleported` (boolean).
#' @param trigger_keys Specify which keys on the keyboard can trigger when
#'   pressed. Element Plus's `trigger-keys` (`string[]`).
#' @param virtual_ref A CSS selector, `"#help-icon"`, for an element elsewhere
#'   on the page that the dropdown is attached to, in place of a trigger of its
#'   own. Element Plus's `virtual-ref` takes the element itself; the selector
#'   is looked up in the browser.
#' @param virtual_triggering Whether virtual triggering is enabled. Element
#'   Plus's `virtual-triggering` (boolean); `TRUE` when `virtual_ref` is
#'   given.
#' @param session In `el_dropdown()`, deprecated: inside a module, wrap `id` in
#'   `ns()`, as for any Shiny input; a session given here namespaces `id`
#'   once more, with a warning. In `update_el_dropdown()`, the Shiny session, the
#'   current one by default, as for [shiny::updateTextInput()].
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
#' - `input$<id>` -- the `command` of the item clicked. It is an event, so
#'   choosing the same item twice runs an `observeEvent()` twice.
#' - `input$<id>_count` -- the number of items clicked.
#'
#' @examples
#' el_dropdown(
#'   "dd1",
#'   "Actions",
#'   items = list(
#'     list(command = "edit", label = "Edit", icon = "el-icon-edit"),
#'     list(command = "copy", label = "Copy", icon = "el-icon-document"),
#'     list(
#'       command = "delete",
#'       label = "Delete",
#'       icon = "el-icon-delete",
#'       divided = TRUE
#'     )
#'   )
#' )
#' @export
el_dropdown <- function(
  id = NULL,
  trigger_label = "Dropdown",
  items = list(),
  trigger = "hover",
  type = NULL,
  size = NULL,
  split_button = FALSE,
  hide_on_click = TRUE,
  placement = "bottom-end",
  disabled = FALSE,
  show_timeout = NULL,
  hide_timeout = NULL,
  tabindex = NULL,
  append_to = NULL,
  button_props = NULL,
  effect = NULL,
  max_height = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_options = NULL,
  popper_style = NULL,
  role = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
) {
  .el_check_items(items, "items", c("command", "label"))
  .el_check_choices("el_dropdown", environment())
  if (is.null(id)) {
    id <- .el_auto_id("el_dropdown")
  }
  ns_id <- .el_ui_id(id, session)

  # Build el-dropdown-item tags
  item_tags <- lapply(items, function(item) {
    cmd <- item$command
    lbl <- if (!is.null(item$label)) item$label else as.character(cmd)
    i_attrs <- list(":command" = jsonlite::toJSON(cmd, auto_unbox = TRUE))
    if (isTRUE(item$disabled)) {
      i_attrs[[":disabled"]] <- "true"
    }
    if (isTRUE(item$divided)) {
      i_attrs[[":divided"]] <- "true"
    }
    # An icon by name is the item's prop; a tag fills its icon slot
    icon_slot <- NULL
    if (is.character(item$icon)) {
      i_attrs[["icon"]] <- .el_icon_name(item$icon)
    } else if (!is.null(item$icon)) {
      icon_slot <- .el_slot("icon", item$icon)
    }

    htmltools::tag("el-dropdown-item", c(i_attrs, list(lbl, icon_slot)))
  })

  menu_tag <- .el_slot(
    "dropdown",
    htmltools::tag("el-dropdown-menu", item_tags)
  )

  # A component as the trigger -- el_button() -- is folded into the
  # dropdown's own Vue instance; nested whole, its host would land inside
  # the template and break it
  inner <- if (is.character(trigger_label)) {
    .el_absorb(NULL)
  } else {
    .el_absorb(trigger_label)
  }
  dd_attrs <- list(
    ":trigger" = "trigger",
    ":hide-on-click" = "hideOnClick",
    ":placement" = "placement",
    ":disabled" = "disabled",
    ":split-button" = "splitButton",
    "@command" = "handleCommand"
  )
  dd_attrs[[":type"]] <- .el_optional_bind("type")
  dd_attrs[[":size"]] <- .el_optional_bind("size")
  dd_attrs[[":show-timeout"]] <- .el_optional_bind("showTimeout")
  dd_attrs[[":hide-timeout"]] <- .el_optional_bind("hideTimeout")
  dd_attrs[[":tabindex"]] <- .el_optional_bind("tabindex")

  # Forwarded to input$<id>_<event>; see .el_event_bindings().
  events <- .el_event_bindings(
    ns_id,
    c(
      "click",
      "visible-change"
    )
  )
  dd_attrs <- c(dd_attrs, events$attrs)
  vue_data <- list(
    trigger = trigger,
    hideOnClick = hide_on_click,
    placement = placement,
    disabled = disabled,
    splitButton = split_button,
    count = 0L
  )
  vue_data$type <- .el_or_na(type)
  vue_data$size <- .el_or_na(size)
  vue_data$showTimeout <- .el_or_na(show_timeout)
  vue_data$hideTimeout <- .el_or_na(hide_timeout)
  vue_data$tabindex <- .el_or_na(tabindex)
  own <- list(
    markup = NULL,
    data = vue_data,
    methods = c(
      events$methods,
      list(
        handleCommand = JS(sprintf(
          "function(cmd) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s', cmd, {priority: 'event'}); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('%s_count', this.count); }",
          ns_id,
          ns_id
        ))
      )
    ),
    watch = list(),
    computed = list(),
    mounted = NULL,
    dependencies = list()
  )
  merged <- .el_absorb_merge(own, inner)
  if (!is.character(trigger_label) && !is.null(trigger_label)) {
    # the merge may have renamed the trigger's fields
    trigger_label <- merged$markups[[2]]
  }

  # Trigger slot content
  trigger_content <- if (!is.null(virtual_ref) && missing(trigger_label)) {
    # attached to an element elsewhere on the page: no trigger of its own
    NULL
  } else if (isTRUE(split_button)) {
    # split button — label is the main button text
    trigger_label
  } else if (is.character(trigger_label)) {
    shiny::tags$span(
      class = "el-dropdown-link",
      trigger_label,
      htmltools::HTML(
        '<el-icon class="el-icon--right"><arrow-down /></el-icon>'
      )
    )
  } else if (inherits(trigger_label, "shiny.tag")) {
    # A tag is the trigger as given -- a button, an icon, an avatar -- with
    # no arrow added, as Element's own examples write it: Element puts its
    # focus and aria attributes on it
    trigger_label
  } else {
    # Element's trigger is one element
    shiny::tags$span(class = "el-dropdown-link", trigger_label)
  }

  el_widget(
    props = .el_props(list(
      append_to = append_to,
      button_props = button_props,
      effect = effect,
      max_height = max_height,
      persistent = persistent,
      popper_class = popper_class,
      popper_options = popper_options,
      popper_style = popper_style,
      role = role,
      show_arrow = show_arrow,
      teleported = teleported,
      trigger_keys = trigger_keys,
      virtual_ref = virtual_ref,
      virtual_triggering = virtual_triggering
    )),
    id = ns_id,
    markup = htmltools::tag(
      "el-dropdown",
      c(dd_attrs, list(trigger_content, menu_tag))
    ),
    data = merged$data,
    absorbed = merged$absorbed,
    methods = merged$methods,
    watch = merged$watch,
    computed = merged$computed,
    mounted = merged$mounted,
    dependency = merged$dependencies,
    width = width,
    slots = slots
  )
}


#' @rdname el_dropdown
#' @section Updating from the server:
#' Server-side update for [el_dropdown()].
#'
#' Every other argument of [el_dropdown()] that can change once it is
#' drawn is an argument here too, under the same name. One left `NULL`
#' stays as it is; `NA` returns it to Element's default.
#'
#' `update_el_dropdown()` is called for its side effect and returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_dropdown(session, "actions", disabled = TRUE)
#'   })
#' }
#' @export
update_el_dropdown <- function(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  trigger = NULL,
  type = NULL,
  size = NULL,
  split_button = NULL,
  hide_on_click = NULL,
  placement = NULL,
  show_timeout = NULL,
  hide_timeout = NULL,
  tabindex = NULL,
  append_to = NULL,
  button_props = NULL,
  effect = NULL,
  max_height = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_options = NULL,
  popper_style = NULL,
  role = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL
) {
  .el_check_session(session)
  ns_id <- session$ns(id)
  msg <- list(id = ns_id)
  if (!is.null(disabled)) {
    msg$disabled <- disabled
  }
  msg <- c(
    msg,
    .el_update_props(
      "el_dropdown",
      Filter(
        Negate(is.null),
        list(
          trigger = trigger,
          type = type,
          size = size,
          split_button = split_button,
          hide_on_click = hide_on_click,
          placement = placement,
          show_timeout = show_timeout,
          hide_timeout = hide_timeout,
          tabindex = tabindex,
          append_to = append_to,
          button_props = button_props,
          effect = effect,
          max_height = max_height,
          persistent = persistent,
          popper_class = popper_class,
          popper_options = popper_options,
          popper_style = popper_style,
          role = role,
          show_arrow = show_arrow,
          teleported = teleported,
          trigger_keys = trigger_keys,
          virtual_ref = virtual_ref,
          virtual_triggering = virtual_triggering
        )
      )
    )
  )
  .el_send_update(session, msg)
  invisible(NULL)
}
