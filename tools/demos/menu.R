## basic
items <- list(
  list(index = "1", label = "Processing Center"),
  list(index = "2", title = "Workspace", children = list(
    list(index = "2-1", label = "item one"), list(index = "2-2", label = "item two"),
    list(index = "2-3", label = "item three"),
    list(index = "2-4", title = "item four", children = list(
      list(index = "2-4-1", label = "item one"), list(index = "2-4-2", label = "item two"))))),
  list(index = "3", label = "Info", disabled = TRUE),
  list(index = "4", label = "Orders"))
tagList(
  el_menu("top_menu", active = "1", mode = "horizontal", ellipsis = FALSE, items = items),
  tags$div(style = "height: 20px"),
  el_menu("top_menu_dark", active = "1", mode = "horizontal", ellipsis = FALSE,
          background_color = "#545c64", text_color = "#fff", active_text_color = "#ffd04b", items = items))

## left-and-right
el_menu("lr_menu", active = "1", mode = "horizontal", ellipsis = FALSE, items = list(
  list(index = "0", label = "LOGO"),
  list(index = "1", label = "Processing Center"),
  list(index = "2", title = "Workspace", children = list(list(index = "2-1", label = "item one")))))

## vertical
items <- list(
  list(index = "1", title = "Navigator One", icon = "Location", children = list(
    list(group = TRUE, title = "Group One", children = list(
      list(index = "1-1", label = "item one"), list(index = "1-2", label = "item two"))),
    list(group = TRUE, title = "Group Two", children = list(list(index = "1-3", label = "item three"))),
    list(index = "1-4", title = "item four", children = list(list(index = "1-4-1", label = "item one"))))),
  list(index = "2", label = "Navigator Two", icon = "Menu"),
  list(index = "3", label = "Navigator Three", icon = "Document", disabled = TRUE),
  list(index = "4", label = "Navigator Four", icon = "Setting"))
el_row(
  el_col(span = 12, tags$h5("Default colors"), el_menu("v_menu", active = "2", items = items)),
  el_col(span = 12, tags$h5("Custom colors"), el_menu("v_menu_dark", active = "2", items = items,
    background_color = "#545c64", text_color = "#fff", active_text_color = "#ffd04b")))

## collapse
el_menu("col_menu", active = "2", collapse = TRUE, items = list(
  list(index = "1", title = "Navigator One", icon = "Location", children = list(
    list(index = "1-1", label = "item one"), list(index = "1-2", label = "item two"))),
  list(index = "2", label = "Navigator Two", icon = "Menu"),
  list(index = "3", label = "Navigator Three", icon = "Document"),
  list(index = "4", label = "Navigator Four", icon = "Setting")))

## popper-offset
el_menu("off_menu", mode = "horizontal", popper_offset = 16, ellipsis = FALSE, items = list(
  list(index = "1", label = "Processing Center"),
  list(index = "2", title = "Workspace", popper_offset = 8, children = list(
    list(index = "2-1", label = "item one"), list(index = "2-2", label = "item two")))))
