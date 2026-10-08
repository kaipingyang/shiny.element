# The parts of a component that Element writes as child tags -- a tab pane,
# a collapse item, a step, a menu item, a table column -- written in R as
# bslib writes nav_panel() and accordion_panel(): a function each, its
# arguments the child's own attributes. What each returns is a list, the
# item the parent's argument takes (`el_tabs(tabs =)`), so the same items go
# to update_el_*() and the parent still renders them from its data.

#' An item, as a constructor returns it
#'
#' @param kind The constructor's name, `"el_tab_pane"`.
#' @param fields Named list; `NULL` fields are left out.
#' @return The list, of class `kind` and `el_item`.
#' @keywords internal
.el_item <- function(kind, fields) {
  fields <- fields[!vapply(fields, is.null, logical(1))]
  structure(fields, class = c(kind, "el_item", "list"))
}

#' @export
print.el_item <- function(x, ...) {
  cat("<", class(x)[[1]], ">\n", sep = "")
  utils::str(unclass(x), give.attr = FALSE, no.list = TRUE)
  invisible(x)
}

#' Content given as `...`: one tag or text as it is, several as a tagList
#' @noRd
.el_item_content <- function(...) {
  content <- list(...)
  if (!length(content)) {
    return(NULL)
  }
  if (length(content) == 1L) content[[1]] else htmltools::tagList(content)
}

#' A tab of [el_tabs()]
#'
#' Element Plus's `el-tab-pane`, for `el_tabs(tabs =)` and
#' [update_el_tabs()]: `el_tabs("t", tabs = list(el_tab_pane("One", ...),
#' el_tab_pane("Two", ...)))`.
#'
#' @param label Title of the tab.
#' @param ... The tab's content: tags, text, this package's components.
#' @param name The tab's value, `input$<id>` while it is selected. Defaults to
#'   `label`.
#' @param disabled Whether the tab is disabled.
#' @param closable Whether this tab can be closed, when the tabs' own
#'   `closable` is off.
#' @param lazy Render the content only when the tab is first selected. Its
#'   components do not exist, and report nothing, until then.
#' @return A tab, for `el_tabs(tabs =)`.
#' @family items
#' @examples
#' el_tabs(
#'   "t",
#'   tabs = list(
#'     el_tab_pane("User", "User settings"),
#'     el_tab_pane("Config", el_switch("dark"), lazy = TRUE)
#'   )
#' )
#' @export
el_tab_pane <- function(
  label,
  ...,
  name = label,
  disabled = NULL,
  closable = NULL,
  lazy = NULL
) {
  .el_item(
    "el_tab_pane",
    list(
      name = name,
      label = label,
      content = .el_item_content(...),
      disabled = disabled,
      closable = closable,
      lazy = lazy
    )
  )
}

#' A panel of [el_collapse()]
#'
#' Element Plus's `el-collapse-item`, for `el_collapse(items =)`.
#'
#' @param title Title of the panel.
#' @param ... The panel's content.
#' @param name The panel's value, reported in `input$<id>` while it is open.
#'   Defaults to `title`.
#' @param icon The expand icon, by name (Element's default `"ArrowRight"`),
#'   or a tag.
#' @param disabled Whether the panel is disabled.
#' @return A panel, for `el_collapse(items =)`.
#' @family items
#' @examples
#' el_collapse(
#'   "c",
#'   items = list(
#'     el_collapse_item("Consistency", "Consistent with real life."),
#'     el_collapse_item("Feedback", "Operation feedback.", disabled = TRUE)
#'   )
#' )
#' @export
el_collapse_item <- function(
  title,
  ...,
  name = title,
  icon = NULL,
  disabled = NULL
) {
  .el_item(
    "el_collapse_item",
    list(
      name = name,
      title = title,
      content = .el_item_content(...),
      icon = icon,
      disabled = disabled
    )
  )
}

#' An entry of [el_timeline()]
#'
#' Element Plus's `el-timeline-item`, for `el_timeline(items =)`.
#'
#' @param content The entry's text (markup with `el_timeline(html = TRUE)`).
#' @param timestamp Timestamp text.
#' @param hide_timestamp Whether to hide the timestamp. By default it is
#'   hidden when there is none.
#' @param center Whether to centre the node vertically.
#' @param placement Where the timestamp goes: `"bottom"` (Element's default)
#'   or `"top"`.
#' @param type Node type: `"primary"`, `"success"`, `"warning"`, `"danger"`
#'   or `"info"`.
#' @param color Background colour of the node.
#' @param size Node size: `"normal"` or `"large"`.
#' @param icon Icon of the node, by name.
#' @param hollow Whether the node is hollow.
#' @return An entry, for `el_timeline(items =)`.
#' @family items
#' @examples
#' el_timeline(
#'   "tl",
#'   items = list(
#'     el_timeline_item("Event start", timestamp = "2018-04-15"),
#'     el_timeline_item("Approved", timestamp = "2018-04-13", type = "success")
#'   )
#' )
#' @export
el_timeline_item <- function(
  content,
  timestamp = NULL,
  hide_timestamp = NULL,
  center = NULL,
  placement = NULL,
  type = NULL,
  color = NULL,
  size = NULL,
  icon = NULL,
  hollow = NULL
) {
  .el_check_choices("el_timeline_item", environment())
  .el_item(
    "el_timeline_item",
    list(
      content = content,
      timestamp = timestamp,
      hide_timestamp = hide_timestamp,
      center = center,
      placement = placement,
      type = type,
      color = color,
      size = size,
      icon = icon,
      hollow = hollow
    )
  )
}

#' A field of [el_descriptions()]
#'
#' Element Plus's `el-descriptions-item`, for `el_descriptions(items =)`.
#'
#' @param label Label text, or markup for the item's label slot.
#' @param ... The field's content: text, tags, this package's components.
#' @param span Number of columns the field spans.
#' @param rowspan Number of rows the field spans.
#' @param width Column width; the widest in a column wins. Without a border
#'   it includes the label.
#' @param min_width Minimum column width; columns with `width` keep it, the
#'   others share the rest in proportion.
#' @param label_width Width of the label, over the descriptions' own.
#' @param align Content alignment: `"left"`, `"center"` or `"right"`.
#' @param label_align Label alignment, `align`'s when not given.
#' @param class_name Class of the content cell.
#' @param label_class_name Class of the label cell.
#' @return A field, for `el_descriptions(items =)`.
#' @family items
#' @examples
#' el_descriptions(
#'   "d",
#'   items = list(
#'     el_descriptions_item("Username", "kooriookami"),
#'     el_descriptions_item("Address", "No.1188, Wuzhong Avenue", span = 2)
#'   )
#' )
#' @export
el_descriptions_item <- function(
  label,
  ...,
  span = NULL,
  rowspan = NULL,
  width = NULL,
  min_width = NULL,
  label_width = NULL,
  align = NULL,
  label_align = NULL,
  class_name = NULL,
  label_class_name = NULL
) {
  .el_check_choices("el_descriptions_item", environment())
  .el_item(
    "el_descriptions_item",
    list(
      label = label,
      content = .el_item_content(...) %||% "",
      span = span,
      rowspan = rowspan,
      width = width,
      min_width = min_width,
      label_width = label_width,
      align = align,
      label_align = label_align,
      class_name = class_name,
      label_class_name = label_class_name
    )
  )
}

#' A slide of [el_carousel()]
#'
#' Element Plus's `el-carousel-item`, for `el_carousel(items =)`.
#'
#' @param ... The slide's content.
#' @param name The slide's value, `input$<id>` while it is showing.
#' @param label Text of the slide's indicator.
#' @param style,class The slide's own inline style and classes -- a height
#'   of its own in a carousel of `height = "auto"`, as upstream's example
#'   sets it.
#' @return A slide, for `el_carousel(items =)`.
#' @family items
#' @examples
#' el_carousel(
#'   "car",
#'   items = list(
#'     el_carousel_item(htmltools::tags$h3("1"), name = "first"),
#'     el_carousel_item(htmltools::tags$h3("2"), name = "second")
#'   )
#' )
#' @export
el_carousel_item <- function(
  ...,
  name = NULL,
  label = NULL,
  style = NULL,
  class = NULL
) {
  .el_item(
    "el_carousel_item",
    list(
      content = .el_item_content(...),
      name = name,
      label = label,
      style = style,
      class = class
    )
  )
}

#' A step of [el_steps()]
#'
#' Element Plus's `el-step`, for `el_steps(steps =)`.
#'
#' @param title Step title: text, or markup for the step's title slot.
#' @param description Step description: text, or markup.
#' @param icon The step's icon, by name, or markup.
#' @param status The step's status, set by the steps when not given: `""`,
#'   `"wait"`, `"process"`, `"finish"`, `"error"` or `"success"`.
#' @return A step, for `el_steps(steps =)`.
#' @family items
#' @examples
#' el_steps(
#'   "s",
#'   steps = list(
#'     el_step("Step 1", "Some description"),
#'     el_step("Step 2", icon = "Upload"),
#'     el_step("Step 3", status = "error")
#'   ),
#'   active = 1
#' )
#' @export
el_step <- function(
  title = NULL,
  description = NULL,
  icon = NULL,
  status = NULL
) {
  .el_check_choices("el_step", environment())
  .el_item(
    "el_step",
    list(title = title, description = description, icon = icon, status = status)
  )
}

#' A step of [el_breadcrumb()]
#'
#' Element Plus's `el-breadcrumb-item`, for `el_breadcrumb(items =)`.
#'
#' @param label The step's text.
#' @param to Where the step links to; the last step usually has none.
#' @param replace Navigate without leaving a history record.
#' @return A step, for `el_breadcrumb(items =)`.
#' @family items
#' @examples
#' el_breadcrumb(
#'   "bc",
#'   items = list(
#'     el_breadcrumb_item("Home", to = "/"),
#'     el_breadcrumb_item("Promotion list")
#'   )
#' )
#' @export
el_breadcrumb_item <- function(label, to = NULL, replace = NULL) {
  .el_item(
    "el_breadcrumb_item",
    list(label = label, to = to, replace = replace)
  )
}

#' An entry of [el_dropdown()]'s menu
#'
#' Element Plus's `el-dropdown-item`, for `el_dropdown(items =)`.
#'
#' @param command The value `input$<id>` takes when the entry is clicked.
#' @param label The entry's text. Defaults to `command`.
#' @param icon The entry's icon, by name.
#' @param disabled Whether the entry is disabled.
#' @param divided Whether a divider is drawn above the entry.
#' @return An entry, for `el_dropdown(items =)`.
#' @family items
#' @examples
#' el_dropdown(
#'   "dd",
#'   "Dropdown List",
#'   items = list(
#'     el_dropdown_item("apple", "Apple"),
#'     el_dropdown_item("pear", "Pear", disabled = TRUE),
#'     el_dropdown_item("plum", "Plum", divided = TRUE)
#'   )
#' )
#' @export
el_dropdown_item <- function(
  command,
  label = command,
  icon = NULL,
  disabled = NULL,
  divided = NULL
) {
  .el_item(
    "el_dropdown_item",
    list(
      command = command,
      label = label,
      icon = icon,
      disabled = disabled,
      divided = divided
    )
  )
}

#' A step of [el_tour()]
#'
#' Element Plus's `el-tour-step`, for `el_tour(steps =)`.
#'
#' @param target The element the step points at, as a CSS selector. `NULL`
#'   shows the step in the middle of the screen.
#' @param title,description The step's title and text.
#' @param header Markup in place of the title.
#' @param show_arrow Whether to show the arrow.
#' @param placement Where the card goes, relative to the target: `"top"`,
#'   `"bottom"` (Element's default), `"left"`, `"right"`, each also with
#'   `"-start"` or `"-end"`.
#' @param content_style Style of the content, a list of CSS properties.
#' @param mask Whether to mask the page, or the mask's `list(style =, color
#'   =)`.
#' @param type `"default"` or `"primary"`: the card's colours.
#' @param next_button_props,prev_button_props The Next and Previous buttons'
#'   properties: `list(children = "Go on")`.
#' @param scroll_into_view_options Whether to scroll the target into view,
#'   or the options for `scrollIntoView()`.
#' @param show_close Whether to show a close button.
#' @param close_icon The close button's icon, by name.
#' @return A step, for `el_tour(steps =)`.
#' @family items
#' @examples
#' el_tour(
#'   "tour",
#'   steps = list(
#'     el_tour_step("#upload", "Upload File", "Put your files here."),
#'     el_tour_step(title = "Done", description = "That is all.")
#'   )
#' )
#' @export
el_tour_step <- function(
  target = NULL,
  title = NULL,
  description = NULL,
  header = NULL,
  show_arrow = NULL,
  placement = NULL,
  content_style = NULL,
  mask = NULL,
  type = NULL,
  next_button_props = NULL,
  prev_button_props = NULL,
  scroll_into_view_options = NULL,
  show_close = NULL,
  close_icon = NULL
) {
  .el_check_choices("el_tour_step", environment())
  .el_item(
    "el_tour_step",
    list(
      target = target,
      title = title,
      description = description,
      header = header,
      show_arrow = show_arrow,
      placement = placement,
      content_style = content_style,
      mask = mask,
      type = type,
      next_button_props = next_button_props,
      prev_button_props = prev_button_props,
      scroll_into_view_options = scroll_into_view_options,
      show_close = show_close,
      close_icon = close_icon
    )
  )
}

#' A link of [el_anchor()]
#'
#' Element Plus's `el-anchor-link`, for `el_anchor(links =)`.
#'
#' @param title The link's text.
#' @param href Where it points: `"#section"`.
#' @param ... Links one level down, each an `el_anchor_link()`.
#' @return A link, for `el_anchor(links =)`.
#' @family items
#' @examples
#' el_anchor(
#'   "an",
#'   links = list(
#'     el_anchor_link("Basic Usage", "#basic-usage"),
#'     el_anchor_link(
#'       "API",
#'       "#api",
#'       el_anchor_link("Attributes", "#attributes"),
#'       el_anchor_link("Events", "#events")
#'     )
#'   )
#' )
#' @export
el_anchor_link <- function(title, href, ...) {
  children <- list(...)
  .el_item(
    "el_anchor_link",
    list(
      title = title,
      href = href,
      children = if (length(children)) children
    )
  )
}

#' Items of [el_menu()]: an entry, a submenu, a group
#'
#' Element Plus's `el-menu-item`, `el-sub-menu` and `el-menu-item-group`,
#' for `el_menu(items =)`. A submenu and a group hold items of their own in
#' `...`, nested to any depth.
#'
#' @param label The text shown.
#' @param index The item's value, `input$<id>` when it is selected.
#' @param icon An icon, by name: `"House"`.
#' @param route Where the item goes, with `el_menu(router = TRUE)`.
#' @param disabled Whether the item or submenu is disabled.
#' @param ... The submenu's or the group's items.
#' @param popper_class,popper_style Class and style of the submenu's popup.
#' @param show_timeout,hide_timeout Delay before the submenu opens and
#'   closes, in milliseconds; the menu's by default.
#' @param teleported Whether the popup is appended to `<body>`: by default
#'   for a top-level submenu, not for others.
#' @param popper_offset Offset of the popup, over the menu's.
#' @param expand_close_icon,expand_open_icon Icons of the submenu when the
#'   menu is expanded, closed and open; give both.
#' @param collapse_close_icon,collapse_open_icon The same when the menu is
#'   collapsed.
#' @param title The group's title.
#' @return An item, for `el_menu(items =)`.
#' @family items
#' @examples
#' el_menu(
#'   "m",
#'   items = list(
#'     el_menu_item("Processing Center", "1"),
#'     el_sub_menu(
#'       "Workspace",
#'       "2",
#'       el_menu_item("item one", "2-1"),
#'       el_menu_item_group("Group", el_menu_item("item two", "2-2"))
#'     ),
#'     el_menu_item("Info", "3", disabled = TRUE)
#'   ),
#'   mode = "horizontal"
#' )
#' @export
el_menu_item <- function(
  label,
  index,
  icon = NULL,
  route = NULL,
  disabled = NULL
) {
  .el_item(
    "el_menu_item",
    list(
      index = index,
      label = label,
      icon = icon,
      route = route,
      disabled = disabled
    )
  )
}

#' @rdname el_menu_item
#' @export
el_sub_menu <- function(
  label,
  index,
  ...,
  icon = NULL,
  disabled = NULL,
  popper_class = NULL,
  popper_style = NULL,
  show_timeout = NULL,
  hide_timeout = NULL,
  teleported = NULL,
  popper_offset = NULL,
  expand_close_icon = NULL,
  expand_open_icon = NULL,
  collapse_close_icon = NULL,
  collapse_open_icon = NULL
) {
  children <- list(...)
  if (!length(children)) {
    stop(
      "A submenu needs items: `el_sub_menu(label, index, ...)`.",
      call. = FALSE
    )
  }
  .el_item(
    "el_sub_menu",
    list(
      index = index,
      label = label,
      icon = icon,
      children = children,
      disabled = disabled,
      popper_class = popper_class,
      popper_style = popper_style,
      show_timeout = show_timeout,
      hide_timeout = hide_timeout,
      teleported = teleported,
      popper_offset = popper_offset,
      expand_close_icon = expand_close_icon,
      expand_open_icon = expand_open_icon,
      collapse_close_icon = collapse_close_icon,
      collapse_open_icon = collapse_open_icon
    )
  )
}

#' @rdname el_menu_item
#' @export
el_menu_item_group <- function(title, ...) {
  .el_item(
    "el_menu_item_group",
    list(title = title, group = TRUE, children = list(...))
  )
}

#' A choice of a select, a radio group, a checkbox group
#'
#' Element Plus's `el-option` and `el-option-group`, for the `choices` of
#' [el_select()] and the other choice components -- where a named vector
#' cannot say that one choice is disabled, or that choices come in groups.
#'
#' @param label The text shown.
#' @param value The value reported when it is chosen. Defaults to `label`.
#' @param disabled Whether it can be chosen; for a group, whether any of its
#'   choices can.
#' @param ... The group's choices, each an `el_option()`.
#' @return A choice, or a group of them, for `choices =`.
#' @family items
#' @examples
#' el_select(
#'   "city",
#'   choices = list(
#'     el_option_group(
#'       "Popular cities",
#'       el_option("Shanghai"),
#'       el_option("Beijing", disabled = TRUE)
#'     ),
#'     el_option_group("City name", el_option("Chengdu"), el_option("Dalian"))
#'   )
#' )
#' @export
el_option <- function(label, value = label, disabled = NULL) {
  .el_item(
    "el_option",
    list(value = value, label = label, disabled = disabled)
  )
}

#' @rdname el_option
#' @export
el_option_group <- function(label, ..., disabled = NULL) {
  .el_item(
    "el_option_group",
    list(label = label, options = list(...), disabled = disabled)
  )
}

#' A column of [el_table()]
#'
#' Element Plus's `el-table-column`, for `el_table(columns =)` and
#' [update_el_table()]. A column with columns of its own in `...` is a group
#' header, nested as deep as you like.
#'
#' @param prop The field of each row the column shows.
#' @param label The column's title.
#' @param ... Columns under this one, each an `el_table_column()`: the column
#'   is then a group header, `el_table_column(label = "Info", el_table_column(
#'   "name", "Name"), ...)`.
#' @param cell A template for each cell, drawn once per row: tags or a
#'   string, with `scope.row`, `scope.column` and `scope.$index` in reach and
#'   raw Element tags (`el$tag()`) working. A button in it reports with
#'   `rowAction('edit', scope)`; see [el_table()].
#' @param editable Whether the column's cells are edited in place, and
#'   with what: `TRUE` or `"input"` for text, `"number"`, `"select"` or
#'   `"date"` -- Element's input, input-number, select and date picker. A
#'   double click opens the editor; Enter or leaving it commits, Escape
#'   abandons, Tab commits and moves to the next editable cell. Each edit
#'   is shown at once, applied to the server's copy of the data
#'   ([el_table_data()]) and reported as `input$<id>_cell_edit`; see
#'   [el_table()]. Not with `cell`.
#' @param editor The editor's props, under Element's names in snake_case:
#'   `list(min = 0, precision = 2)` for a number, `list(choices = c("a",
#'   "b"))` for a select, `list(placeholder = "...")`.
#' @param header A template for the header cell, as `cell` is for the
#'   others: a search box, a button.
#' @param header_html Markup for the header cell, inserted as it is: pass
#'   only what you control.
#' @param filter_icon The filter's icon, by name.
#' @param type `"selection"` (a checkbox), `"index"` (row numbers) or
#'   `"expand"` (an arrow opening the row to its `cell`); Element's default
#'   is `"default"`.
#' @param index For `type = "index"`, a number to start from or a [JS()]
#'   function of the row's index.
#' @param column_key The column's key, which `filter-change` names.
#' @param width,min_width The column's width; `min_width` columns share what
#'   `width` columns leave, in proportion.
#' @param fixed Fix the column at the `"left"` (or `TRUE`) or the `"right"`.
#' @param render_header A [JS()] render function for the header.
#' @param sortable Whether the column sorts; `"custom"` sorts on the server,
#'   through the table's `sort-change` input.
#' @param sort_method A [JS()] comparison function.
#' @param sort_by The field, fields or [JS()] function to sort by.
#' @param sort_orders The orders a click cycles through: `list("ascending",
#'   "descending", NULL)`.
#' @param resizable Whether the column can be resized, with `border = TRUE`.
#' @param formatter A [JS()] function formatting the cell.
#' @param show_overflow_tooltip Hide overflowing content behind a tooltip;
#'   `TRUE`, or the tooltip's options.
#' @param align,header_align Alignment of the cells and of the header:
#'   `"left"`, `"center"` or `"right"`.
#' @param class_name,label_class_name Class of the cells and of the header.
#' @param selectable For `type = "selection"`, a [JS()] function deciding
#'   whether a row can be ticked.
#' @param reserve_selection For `type = "selection"`, keep ticks when the
#'   data changes; needs the table's `row_key`.
#' @param filters The filter's choices: `list(list(text =, value =), ...)`.
#' @param filter_placement Where the filter's dropdown opens.
#' @param filter_class_name Class of the filter's dropdown.
#' @param filter_multiple Whether several filter choices can be ticked.
#' @param filter_method A [JS()] function `(value, row, column)` keeping a
#'   row.
#' @param filtered_value The filter's ticked values.
#' @param tooltip_formatter A [JS()] function of `{row, column, cellValue}`
#'   for the overflow tooltip's content.
#' @return A column, for `el_table(columns =)`.
#' @family items
#' @examples
#' el_table(
#'   "t",
#'   data = data.frame(date = "2016-05-03", name = "Tom", city = "LA"),
#'   columns = list(
#'     el_table_column("date", "Date", width = 150, sortable = TRUE),
#'     el_table_column(
#'       label = "Delivery Info",
#'       el_table_column("name", "Name"),
#'       el_table_column("city", "City")
#'     )
#'   )
#' )
#' @export
el_table_column <- function(
  prop = NULL,
  label = NULL,
  ...,
  cell = NULL,
  editable = NULL,
  editor = NULL,
  header = NULL,
  header_html = NULL,
  filter_icon = NULL,
  type = NULL,
  index = NULL,
  column_key = NULL,
  width = NULL,
  min_width = NULL,
  fixed = NULL,
  render_header = NULL,
  sortable = NULL,
  sort_method = NULL,
  sort_by = NULL,
  sort_orders = NULL,
  resizable = NULL,
  formatter = NULL,
  show_overflow_tooltip = NULL,
  align = NULL,
  header_align = NULL,
  class_name = NULL,
  label_class_name = NULL,
  selectable = NULL,
  reserve_selection = NULL,
  filters = NULL,
  filter_placement = NULL,
  filter_class_name = NULL,
  filter_multiple = NULL,
  filter_method = NULL,
  filtered_value = NULL,
  tooltip_formatter = NULL
) {
  .el_check_choices("el_table_column", environment())
  children <- list(...)
  # A group written el_table_column(label = "Info", el_table_column(...)):
  # R hands the first child column to `prop`, the next to `label`
  is_column <- function(x) inherits(x, "el_table_column")
  if (is_column(label)) {
    children <- c(list(label), children)
    label <- NULL
  }
  if (is_column(prop)) {
    children <- c(list(prop), children)
    prop <- NULL
  }
  .el_item(
    "el_table_column",
    list(
      prop = prop,
      label = label,
      children = if (length(children)) children,
      cell = cell,
      editable = editable,
      editor = editor,
      header = header,
      header_html = header_html,
      filter_icon = filter_icon,
      type = type,
      index = index,
      column_key = column_key,
      width = width,
      min_width = min_width,
      fixed = fixed,
      render_header = render_header,
      sortable = sortable,
      sort_method = sort_method,
      sort_by = sort_by,
      sort_orders = sort_orders,
      resizable = resizable,
      formatter = formatter,
      show_overflow_tooltip = show_overflow_tooltip,
      align = align,
      header_align = header_align,
      class_name = class_name,
      label_class_name = label_class_name,
      selectable = selectable,
      reserve_selection = reserve_selection,
      filters = filters,
      filter_placement = filter_placement,
      filter_class_name = filter_class_name,
      filter_multiple = filter_multiple,
      filter_method = filter_method,
      filtered_value = filtered_value,
      tooltip_formatter = tooltip_formatter
    )
  )
}

#' A column of [el_table_v2()]
#'
#' A column definition for `el_table_v2(columns =)` and
#' [update_el_table_v2()], under Element Plus's own field names.
#'
#' @param key The column's unique key.
#' @param title The text of its header cell.
#' @param data_key The field of each row it shows. Defaults to `key`.
#' @param width The column's width, in pixels.
#' @param min_width,max_width Its bounds, in pixels.
#' @param align Alignment of its cells: `"left"`, `"center"` or `"right"`.
#' @param fixed Fix it at the `"left"` (or `TRUE`) or the `"right"`.
#' @param flex_grow,flex_shrink Flex grow and shrink, in a table that is not
#'   `fixed`.
#' @param sortable Whether it sorts; the sort is reported, the rows are
#'   yours to reorder.
#' @param hidden Whether it is hidden.
#' @param class,header_class Class of its cells and of its header cell.
#' @param style Style of its cells, a list of CSS properties.
#' @param cell_renderer,header_cell_renderer [JS()] functions drawing a cell
#'   and the header cell, returning Vue's `h()`.
#' @return A column, for `el_table_v2(columns =)`.
#' @family items
#' @examples
#' el_table_v2(
#'   "tv",
#'   data = data.frame(id = 1:3, name = c("a", "b", "c")),
#'   columns = list(
#'     el_table_v2_column("id", "Id", width = 80, fixed = "left"),
#'     el_table_v2_column("name", "Name", width = 200, sortable = TRUE)
#'   )
#' )
#' @export
el_table_v2_column <- function(
  key,
  title = NULL,
  data_key = key,
  width = 150,
  min_width = NULL,
  max_width = NULL,
  align = NULL,
  fixed = NULL,
  flex_grow = NULL,
  flex_shrink = NULL,
  sortable = NULL,
  hidden = NULL,
  class = NULL,
  header_class = NULL,
  style = NULL,
  cell_renderer = NULL,
  header_cell_renderer = NULL
) {
  .el_check_choices("el_table_v2_column", environment())
  .el_item(
    "el_table_v2_column",
    list(
      key = key,
      dataKey = data_key,
      title = title,
      width = width,
      minWidth = min_width,
      maxWidth = max_width,
      align = align,
      fixed = fixed,
      flexGrow = flex_grow,
      flexShrink = flex_shrink,
      sortable = sortable,
      hidden = hidden,
      class = class,
      headerClass = header_class,
      style = style,
      cellRenderer = cell_renderer,
      headerCellRenderer = header_cell_renderer
    )
  )
}

#' A placeholder shape of [el_skeleton()]'s template
#'
#' Element Plus's `el-skeleton-item`, for the `template` slot of
#' [el_skeleton()], which draws a custom placeholder while loading.
#'
#' @param variant The shape: `"p"`, `"text"` (Element's default), `"h1"`,
#'   `"h3"`, `"caption"`, `"button"`, `"image"`, `"circle"` or `"rect"`.
#' @param ... Attributes for the tag, such as `style`.
#' @return A tag.
#' @family items
#' @examples
#' el_skeleton(
#'   slots = list(
#'     template = htmltools::tagList(
#'       el_skeleton_item("image", style = "width: 240px; height: 240px"),
#'       el_skeleton_item("p", style = "width: 50%")
#'     )
#'   )
#' )
#' @export
el_skeleton_item <- function(variant = NULL, ...) {
  .el_check_choices("el_skeleton_item", environment())
  htmltools::tag("el-skeleton-item", c(list(variant = variant), list(...)))
}
