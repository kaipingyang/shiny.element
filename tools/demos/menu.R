## basic
items <- list(
  el_menu_item("Processing Center", "1"),
  el_sub_menu(
    "Workspace",
    "2",
    el_menu_item("item one", "2-1"),
    el_menu_item("item two", "2-2"),
    el_menu_item("item three", "2-3"),
    el_sub_menu(
      "item four",
      "2-4",
      el_menu_item("item one", "2-4-1"),
      el_menu_item("item two", "2-4-2")
    )
  ),
  el_menu_item("Info", "3", disabled = TRUE),
  el_menu_item("Orders", "4")
)
tagList(
  el_menu(
    "top_menu",
    active = "1",
    mode = "horizontal",
    ellipsis = FALSE,
    items = items
  ),
  tags$div(style = "height: 20px"),
  el_menu(
    "top_menu_dark",
    active = "1",
    mode = "horizontal",
    ellipsis = FALSE,
    background_color = "#545c64",
    text_color = "#fff",
    active_text_color = "#ffd04b",
    items = items
  )
)

## left-and-right
el_menu(
  "lr_menu",
  active = "1",
  mode = "horizontal",
  ellipsis = FALSE,
  items = list(
    el_menu_item("LOGO", "0"),
    el_menu_item("Processing Center", "1"),
    el_sub_menu("Workspace", "2", el_menu_item("item one", "2-1"))
  )
)

## vertical
items <- list(
  el_sub_menu(
    "Navigator One",
    "1",
    el_menu_item_group(
      "Group One",
      el_menu_item("item one", "1-1"),
      el_menu_item("item two", "1-2")
    ),
    el_menu_item_group("Group Two", el_menu_item("item three", "1-3")),
    el_sub_menu("item four", "1-4", el_menu_item("item one", "1-4-1")),
    icon = "Location"
  ),
  el_menu_item("Navigator Two", "2", icon = "Menu"),
  el_menu_item("Navigator Three", "3", icon = "Document", disabled = TRUE),
  el_menu_item("Navigator Four", "4", icon = "Setting")
)
el_row(
  el_col(
    span = 12,
    tags$h5("Default colors"),
    el_menu("v_menu", active = "2", items = items)
  ),
  el_col(
    span = 12,
    tags$h5("Custom colors"),
    el_menu(
      "v_menu_dark",
      active = "2",
      items = items,
      background_color = "#545c64",
      text_color = "#fff",
      active_text_color = "#ffd04b"
    )
  )
)

## collapse
el_menu(
  "col_menu",
  active = "2",
  collapse = TRUE,
  items = list(
    el_sub_menu(
      "Navigator One",
      "1",
      el_menu_item("item one", "1-1"),
      el_menu_item("item two", "1-2"),
      icon = "Location"
    ),
    el_menu_item("Navigator Two", "2", icon = "Menu"),
    el_menu_item("Navigator Three", "3", icon = "Document"),
    el_menu_item("Navigator Four", "4", icon = "Setting")
  )
)

## popper-offset
el_menu(
  "off_menu",
  mode = "horizontal",
  popper_offset = 16,
  ellipsis = FALSE,
  items = list(
    el_menu_item("Processing Center", "1"),
    el_sub_menu(
      "Workspace",
      "2",
      el_menu_item("item one", "2-1"),
      el_menu_item("item two", "2-2"),
      popper_offset = 8
    )
  )
)
