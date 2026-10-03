# Menu

Menu that provides navigation for your website.

If you want to override the default height of el-menu, you can use the
following CSS:

## Top bar

Top bar Menu can be used in a variety of scenarios.

By default Menu is vertical, but you can change it to horizontal by
setting the mode prop to ‘horizontal’. In addition, you can use the
sub-menu component to create a second level menu. Menu provides
`background-color`, `text-color` and `active-text-color` to customize
the colors.

``` r

items <- list(
  list(index = "1", label = "Processing Center"),
  list(
    index = "2",
    title = "Workspace",
    children = list(
      list(index = "2-1", label = "item one"),
      list(index = "2-2", label = "item two"),
      list(index = "2-3", label = "item three"),
      list(
        index = "2-4",
        title = "item four",
        children = list(
          list(index = "2-4-1", label = "item one"),
          list(index = "2-4-2", label = "item two")
        )
      )
    )
  ),
  list(index = "3", label = "Info", disabled = TRUE),
  list(index = "4", label = "Orders")
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
```

## Left And Right

You can make the menu items to the left or right.

``` r

el_menu(
  "lr_menu",
  active = "1",
  mode = "horizontal",
  ellipsis = FALSE,
  items = list(
    list(index = "0", label = "LOGO"),
    list(index = "1", label = "Processing Center"),
    list(
      index = "2",
      title = "Workspace",
      children = list(list(index = "2-1", label = "item one"))
    )
  )
)
```

## Side bar

Vertical Menu with sub-menus.

You can use the el-menu-item-group component to create a menu group, and
the name of the group is determined by the title prop or a named slot.

``` r

items <- list(
  list(
    index = "1",
    title = "Navigator One",
    icon = "Location",
    children = list(
      list(
        group = TRUE,
        title = "Group One",
        children = list(
          list(index = "1-1", label = "item one"),
          list(index = "1-2", label = "item two")
        )
      ),
      list(
        group = TRUE,
        title = "Group Two",
        children = list(list(index = "1-3", label = "item three"))
      ),
      list(
        index = "1-4",
        title = "item four",
        children = list(list(index = "1-4-1", label = "item one"))
      )
    )
  ),
  list(index = "2", label = "Navigator Two", icon = "Menu"),
  list(
    index = "3",
    label = "Navigator Three",
    icon = "Document",
    disabled = TRUE
  ),
  list(index = "4", label = "Navigator Four", icon = "Setting")
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
```

##### Default colors

##### Custom colors

## Collapse

Vertical Menu could be collapsed.

``` r

el_menu(
  "col_menu",
  active = "2",
  collapse = TRUE,
  items = list(
    list(
      index = "1",
      title = "Navigator One",
      icon = "Location",
      children = list(
        list(index = "1-1", label = "item one"),
        list(index = "1-2", label = "item two")
      )
    ),
    list(index = "2", label = "Navigator Two", icon = "Menu"),
    list(index = "3", label = "Navigator Three", icon = "Document"),
    list(index = "4", label = "Navigator Four", icon = "Setting")
  )
)
```

## Popper Offset

Submenu with popperOffset will override Menu’s `popper-offset`.

``` r

el_menu(
  "off_menu",
  mode = "horizontal",
  popper_offset = 16,
  ellipsis = FALSE,
  items = list(
    list(index = "1", label = "Processing Center"),
    list(
      index = "2",
      title = "Workspace",
      popper_offset = 8,
      children = list(
        list(index = "2-1", label = "item one"),
        list(index = "2-2", label = "item two")
      )
    )
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Menu Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `mode` | `mode` | menu display mode | [^1]`'horizontal' \\| 'vertical'` |  | vertical |
| `collapse` | `collapse` | whether the menu is collapsed (available only in vertical mode) | [^2] |  | false |
| `ellipsis` | `ellipsis` | whether the menu is ellipsis (available only in horizontal mode) | [^3] |  | true |
| `ellipsis-icon` | `ellipsis_icon` | custom ellipsis icon (available only in horizontal mode and ellipsis is true) | [^4] / [^5] |  | — |
| `popper-offset` | `popper_offset` | offset of the popper (effective for all submenus) | [^6] |  | 6 |
| `default-active` | `active` | index of active menu on page load | [^7] |  | ’’ |
| `default-openeds` | `default_openeds` | array that contains indexes of currently active sub-menus | [^8]`string[]` |  | \[\] |
| `unique-opened` | `unique_opened` | whether only one sub-menu can be active | [^9] |  | false |
| `menu-trigger` | `menu_trigger` | how sub-menus are triggered, only works when `mode` is ‘horizontal’ | [^10]`'hover' \\| 'click'` |  | hover |
| `router` | `router` | whether `vue-router` mode is activated. If true, index will be used as ‘path’ to activate the route action. Use with `default-active` to set the active item on load. | [^11] |  | false |
| `collapse-transition` | `collapse_transition` | whether to enable the collapse transition | [^12] |  | true |
| `popper-effect` | `popper_effect` | Tooltip theme, built-in theme: `dark` / `light` when menu is collapsed | [^13]`'dark' \\| 'light'` / [^14] |  | dark |
| `close-on-click-outside` | `close_on_click_outside` | optional, whether menu is collapsed when clicking outside | [^15] |  | false |
| `popper-class` | `popper_class` | custom class name for all popup menus and titles’ tooltips | [^16] |  | — |
| `popper-style` | `popper_style` | custom style for all popup menus and titles’ tooltips | [^17] / [^18] |  | — |
| `show-timeout` | `show_timeout` | control timeout for all menus before showing | [^19] |  | 300 |
| `hide-timeout` | `hide_timeout` | control timeout for all menus before hiding | [^20] |  | 300 |
| `background-color` | `background_color` | background color of Menu (hex format) (use `--el-menu-bg-color` in a style class instead) | [^21] |  | \#ffffff |
| `text-color` | `text_color` | text color of Menu (hex format) ( use `--el-menu-text-color` in a style class instead) | [^22] |  | \#303133 |
| `active-text-color` | `active_text_color` | text color of currently active menu item (hex format) ( use `--el-menu-active-color` in a style class instead) | [^23] |  | \#409eff |
| `persistent` | `persistent` | when menu inactive and `persistent` is `false` , dropdown menu will be destroyed | [^24] |  | true |

### Menu Events

| Element | In R | Description |
|----|----|----|
| `select` | one of the component’s inputs – see its reference page | callback function when menu is activated |
| `open` | `input$<id>_open` | callback function when sub-menu expands |
| `close` | `input$<id>_close` | callback function when sub-menu collapses |

### Menu Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Menu Exposes

| Element | In R | Description |
|----|----|----|
| `open` | `el_call(session, id, "open")` | open a specific sub-menu, the param is index of the sub-menu to open |
| `close` | `el_call(session, id, "close")` | close a specific sub-menu, the param is index of the sub-menu to close |
| `handleResize` | `el_call(session, id, "handleResize")` | manually trigger menu width recalculation |
| `updateActiveIndex` | `el_call(session, id, "updateActiveIndex")` | set index of active menu |

### SubMenu Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `index` | field `index` of each of `items` | unique identification | [^25] |  | — |
| `popper-class` | `popper_class` | custom class name for the popup menu | [^26] |  | — |
| `popper-style` | `popper_style` | custom style for the popup menu | [^27] / [^28] |  | — |
| `show-timeout` | `show_timeout` | timeout before showing a sub-menu(inherit `show-timeout` of the menu by default.) | [^29] |  | — |
| `hide-timeout` | `hide_timeout` | timeout before hiding a sub-menu(inherit `hide-timeout` of the menu by default.) | [^30] |  | — |
| `disabled` | field `disabled` of each of `items` | whether the sub-menu is disabled | [^31] |  | false |
| `teleported` | field `teleported` of each of `items` | whether popup menu is teleported to the body, the default is true for the level one SubMenu, false for other SubMenus | [^32] |  | undefined |
| `popper-offset` | `popper_offset` | offset of the popper (overrides the `popper` of menu) | [^33] |  | — |
| `expand-close-icon` | field `expand_close_icon` of each of `items` | Icon when menu are expanded and submenu are closed, `expand-close-icon` and `expand-open-icon` need to be passed together to take effect | [^34] / [^35] |  | — |
| `expand-open-icon` | field `expand_open_icon` of each of `items` | Icon when menu are expanded and submenu are opened, `expand-open-icon` and `expand-close-icon` need to be passed together to take effect | [^36] / [^37] |  | — |
| `collapse-close-icon` | field `collapse_close_icon` of each of `items` | Icon when menu are collapsed and submenu are closed, `collapse-close-icon` and `collapse-open-icon` need to be passed together to take effect | [^38] / [^39] |  | — |
| `collapse-open-icon` | field `collapse_open_icon` of each of `items` | Icon when menu are collapsed and submenu are opened, `collapse-open-icon` and `collapse-close-icon` need to be passed together to take effect | [^40] / [^41] |  | — |

### SubMenu Slots

| Element   | In R                     | Description               |
|-----------|--------------------------|---------------------------|
| `default` | default content          | customize default content |
| `title`   | `slots = list(title = )` | customize title content   |

### Menu-Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `index` | field `index` of each of `items` | unique identification | [^42] |  | — |
| `route` | field `route` of each of `items` | Vue Router Route Location Parameters | [^43] / [^44] |  | — |
| `disabled` | field `disabled` of each of `items` | whether disabled | [^45] |  | false |

### Menu-Item Events

| Element | In R | Description |
|----|----|----|
| `click` | one of the component’s inputs – see its reference page | callback function when menu-item is clicked, the param is menu-item instance |

### Menu-Item Slots

| Element   | In R                     | Description               |
|-----------|--------------------------|---------------------------|
| `default` | default content          | customize default content |
| `title`   | `slots = list(title = )` | customize title content   |

### Menu-Item-Group Attributes

| Element | In R                             | Description | Type  | Accepted | Default |
|---------|----------------------------------|-------------|-------|----------|---------|
| `title` | field `title` of each of `items` | group title | [^46] |          | —       |

### Menu-Item-Group Slots

| Element   | In R                     | Description               |
|-----------|--------------------------|---------------------------|
| `default` | default content          | customize default content |
| `title`   | `slots = list(title = )` | customize group title     |

[^1]: enum

[^2]: boolean

[^3]: boolean

[^4]: string

[^5]: Component

[^6]: number

[^7]: string

[^8]: array

[^9]: boolean

[^10]: enum

[^11]: boolean

[^12]: boolean

[^13]: enum

[^14]: string

[^15]: boolean

[^16]: string

[^17]: string

[^18]: object

[^19]: number

[^20]: number

[^21]: string

[^22]: string

[^23]: string

[^24]: boolean

[^25]: string

[^26]: string

[^27]: string

[^28]: object

[^29]: number

[^30]: number

[^31]: boolean

[^32]: boolean

[^33]: number

[^34]: string

[^35]: Component

[^36]: string

[^37]: Component

[^38]: string

[^39]: Component

[^40]: string

[^41]: Component

[^42]: string

[^43]: string

[^44]: object

[^45]: boolean

[^46]: string
