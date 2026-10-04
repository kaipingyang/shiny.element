# Dropdown

Toggleable menu for displaying lists of links and actions.

## Basic usage

Hover on the dropdown menu to unfold it for more actions.

The triggering element is rendered by the default `slot`, and the
dropdown part is rendered by the `slot` named `dropdown`. By default,
dropdown list shows when you hover on the triggering element without
having to click it.

``` r

items <- list(
  list(command = "a", label = "Action 1"),
  list(command = "b", label = "Action 2"),
  list(command = "c", label = "Action 3"),
  list(command = "d", label = "Action 4", disabled = TRUE),
  list(command = "e", label = "Action 5", divided = TRUE)
)
el_dropdown("dd", trigger_label = "Dropdown List", items = items)
```

## Placement

Support 6 placements.

Set `placement` property to make dropdown appear in different locations.

``` r

items <- list(
  list(command = "1", label = "The Action 1st"),
  list(command = "2", label = "The Action 2nd"),
  list(command = "3", label = "The Action 3rd")
)
tags$div(
  style = "display: flex; flex-wrap: wrap; gap: 16px",
  lapply(
    c("top-start", "top", "top-end", "bottom-start", "bottom", "bottom-end"),
    function(p) {
      el_dropdown(
        paste0("dd_", p),
        placement = p,
        items = items,
        trigger_label = el_button(paste0("ddb_", p), p)
      )
    }
  )
)
```

## Triggering element

Use the button to trigger the dropdown list.

Use `split-button` to split the triggering element into a button group
with the left button being a normal button and right one the actual
triggering target. If you wanna insert a separator line between item
three and item four, just add the `divided` attribute to item four.

``` r

items <- list(
  list(command = "a", label = "Action 1"),
  list(command = "b", label = "Action 2"),
  list(command = "c", label = "Action 3")
)
tags$div(
  style = "display: flex; gap: 16px",
  el_dropdown(
    "dd_btn",
    items = items,
    trigger_label = el_button(
      "dd_btn_t",
      "Dropdown List",
      type = "primary",
      icon = "ArrowDown"
    )
  ),
  el_dropdown(
    "dd_split",
    items = items,
    split_button = TRUE,
    type = "primary",
    trigger_label = "Dropdown List"
  )
)
```

## How to trigger

Click the triggering element or hover on it.

Use the attribute `trigger`. By default, it is `hover`.

``` r

items <- list(
  list(command = "a", label = "Action 1", icon = "Plus"),
  list(command = "b", label = "Action 2", icon = "CirclePlusFilled"),
  list(command = "c", label = "Action 3", icon = "CirclePlus")
)
tags$div(
  style = "display: flex; gap: 40px",
  tagList(
    tags$div("hover to trigger"),
    el_dropdown("dd_hover", items = items, trigger_label = "Dropdown List")
  ),
  tagList(
    tags$div("click to trigger"),
    el_dropdown(
      "dd_click",
      items = items,
      trigger = "click",
      trigger_label = "Dropdown List"
    )
  ),
  tagList(
    tags$div("right click to trigger"),
    el_dropdown(
      "dd_ctx",
      items = items,
      trigger = "contextmenu",
      trigger_label = "Dropdown List"
    )
  )
)
```

hover to trigger

click to trigger

right click to trigger

## Menu hiding behavior

Use `hide-on-click` to define if menu closes on clicking.

By default menu will close when you click on menu items, and it can be
turned off by setting hide-on-click to false.

``` r

el_dropdown(
  "dd_keep",
  hide_on_click = FALSE,
  trigger_label = "Dropdown List",
  items = list(
    list(command = "a", label = "Action 1"),
    list(command = "b", label = "Action 2"),
    list(command = "c", label = "Action 3")
  )
)
```

## Command event

Clicking each dropdown item fires an event whose parameter is assigned
by each item.

The item clicked is `input$<id>`, its `command`.

``` r

el_dropdown(
  "dd_cmd",
  trigger_label = "Dropdown List",
  items = list(
    list(command = "a", label = "Action 1"),
    list(command = "b", label = "Action 2"),
    list(command = "c", label = "Action 3")
  )
)
```

## Dropdown methods

You can open or close the dropdown menu by manually use `handleOpen` or
`handleClose`

`call_el(session, "dd_m", "handleOpen")` opens it from the server;
`"handleClose"` closes it.

``` r

el_dropdown(
  "dd_m",
  trigger = "contextmenu",
  trigger_label = "Dropdown List",
  items = list(
    list(command = "a", label = "Action 1"),
    list(command = "b", label = "Action 2")
  )
)
```

## Sizes

Besides default size, Dropdown component provides three additional sizes
for you to choose among different scenarios.

Use attribute `size` to set additional sizes with `large`, `default` or
`small`.

``` r

items <- list(
  list(command = "a", label = "Action 1"),
  list(command = "b", label = "Action 2")
)
tags$div(
  style = "display: flex; gap: 16px",
  lapply(c("large", "default", "small"), function(s) {
    el_dropdown(
      paste0("dd_s_", s),
      size = s,
      split_button = TRUE,
      type = "primary",
      trigger_label = s,
      items = items
    )
  })
)
```

## Virtual triggering

Sometimes we want to render the dropdown on some other trigger element,
we can separate the trigger and the content.

`virtual_ref` is a CSS selector for the element the menu opens from,
here a card: right-click it. Upstream also moves the menu to the
pointer, from its own script; here it opens at the card’s corner.

``` r

tagList(
  tags$div(
    id = "ctx-card",
    el_card(
      tags$div(
        style = "height: 160px; display: flex; align-items: center;
          justify-content: center",
        "Right click"
      )
    )
  ),
  el_dropdown(
    "vdd",
    virtual_ref = "#ctx-card .el-card",
    trigger = "contextmenu",
    placement = "bottom-start",
    show_arrow = FALSE,
    items = list(
      list(command = "a1", label = "Action 1", icon = "Plus"),
      list(command = "a2", label = "Action 2", icon = "CirclePlusFilled"),
      list(command = "a3", label = "Action 3", icon = "CirclePlus"),
      list(command = "a4", label = "Action 4", icon = "Check"),
      list(command = "a5", label = "Action 5", icon = "CircleCheck")
    )
  )
)
```

Right click

## API

Element Plus’s tables, and beside each entry where it is in R.

### Dropdown Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `type` | `type` | menu button type, refer to `Button` Component, only works when `split-button` is true | [^1]`'' \\| 'default' \\| 'primary' \\| 'success' \\| 'warning' \\| 'info' \\| 'danger' \\| 'text' (deprecated)` |  | ’’ |
| `size` | `size` | menu size, also works on the split button | [^2]`'' \\| 'large' \\| 'default' \\| 'small'` |  | ’’ |
| `button-props` | `button_props` | props for the button component, refer to [Button Attributes](https://kaipingyang.github.io/shiny.element/articles/components/button.html#button-attributes) | [^3] |  | — |
| `max-height` | `max_height` | the max height of menu | [^4] / [^5] |  | ’’ |
| `split-button` | `split_button` | whether a button group is displayed | [^6] |  | false |
| `disabled` | `disabled` | whether to disable | [^7] |  | false |
| `placement` | `placement` | placement of pop menu | [^8]`'top' \\| 'top-start' \\| 'top-end' \\| 'bottom' \\| 'bottom-start' \\| 'bottom-end'` |  | bottom |
| `effect` | `effect` | Tooltip theme, built-in theme: `dark` / `light` | [^9]`'dark' \\| 'light'` / [^10] |  | light |
| `trigger` | `trigger` | how to trigger | [^11]`'click' \\| 'hover' \\| 'contextmenu'` / [^12]`Array<'click' \\| 'hover' \\| 'contextmenu'>` |  | hover |
| `trigger-keys` | `trigger_keys` | specify which keys on the keyboard can trigger when pressed | [^13]`string[]` |  | `['Enter', 'Space', 'ArrowDown', 'NumpadEnter']` |
| `virtual-triggering` | `virtual_triggering` | indicates whether virtual triggering is enabled | [^14] |  | — |
| `virtual-ref` | `virtual_ref` | indicates the reference element to which the dropdown is attached | [^15] |  | — |
| `hide-on-click` | `hide_on_click` | whether to hide menu after clicking menu-item | [^16] |  | true |
| `show-arrow` | `show_arrow` | whether the tooltip content has an arrow | [^17] |  | true |
| `show-timeout` | `show_timeout` | delay time before show a dropdown (only works when trigger is `hover`) | [^18] |  | 150 |
| `hide-timeout` | `hide_timeout` | delay time before hide a dropdown (only works when trigger is `hover`) | [^19] |  | 150 |
| `role` | `role` | the ARIA role attribute for the dropdown menu. Depending on the use case, you may want to change this to ‘navigation’ | [^20]`'dialog' \\| 'grid' \\| 'group' \\| 'listbox' \\| 'menu' \\| 'navigation' \\| 'tooltip' \\| 'tree'` |  | menu |
| `tabindex` | `tabindex` | [tabindex](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/tabindex) of Dropdown | [^21] / [^22] |  | 0 |
| `popper-class` | `popper_class` | custom class name for Dropdown’s dropdown | [^23] / [^24] |  | ’’ |
| `popper-style` | `popper_style` | custom style for Dropdown’s dropdown | [^25] / [^26] |  | — |
| `popper-options` | `popper_options` | [popper.js](https://popper.js.org/docs/v2/) parameters | [^27] |  | `{modifiers: [{name: 'computeStyles',options: {gpuAcceleration: false}}]}` |
| `teleported` | `teleported` | whether the dropdown popup is teleported to the body | [^28] |  | true |
| `append-to` | `append_to` | which element the dropdown CONTENT appends to | [^29] / [^30] |  | — |
| `persistent` | `persistent` | when dropdown inactive and `persistent` is `false` , dropdown menu will be destroyed | [^31] |  | true |

### Dropdown Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | content of Dropdown. Notice: Must be a valid html dom element (ex. `<span>, <button> etc.`) or `el-component`, to attach the trigger listener |
| `dropdown` | `slots = list(dropdown = )` | content of the Dropdown Menu, usually a `<el-dropdown-menu>` element |

### Dropdown Events

| Element | In R | Description |
|----|----|----|
| `click` | `input$<id>_click` | if `split-button` is `true`, triggers when left button is clicked |
| `command` | one of the component’s inputs – see its reference page | triggers when a dropdown item is clicked, the parameters is the command dispatched from the dropdown item |
| `visible-change` | `input$<id>_visible_change` | triggers when the dropdown appears/disappears, the param is true when it appears, and false otherwise |

### Dropdown Exposes

| Element | In R | Description |
|----|----|----|
| `handleOpen` | `el_call(session, id, "handleOpen")` | open the dropdown menu |
| `handleClose` | `el_call(session, id, "handleClose")` | close the dropdown menu |

### Dropdown-Menu Slots

| Element   | In R            | Description              |
|-----------|-----------------|--------------------------|
| `default` | default content | content of Dropdown Menu |

### Dropdown-Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `command` | item field `command` | a command to be dispatched to Dropdown’s `command` callback | [^32] / [^33] / [^34] |  | — |
| `disabled` | `disabled` | whether the item is disabled | [^35] |  | false |
| `divided` | item field `divided` | whether a divider is displayed | [^36] |  | false |
| `icon` | item field `icon` | custom icon | [^37] / [^38] |  | — |

### Dropdown-Item Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | customize of Dropdown Item |
| `icon` | `slots = list(icon = )` | custom icon, it will override the icon prop |

[^1]: enum

[^2]: enum

[^3]: object

[^4]: string

[^5]: number

[^6]: boolean

[^7]: boolean

[^8]: enum

[^9]: enum

[^10]: string

[^11]: enum

[^12]: array

[^13]: array

[^14]: boolean

[^15]: HTMLElement

[^16]: boolean

[^17]: boolean

[^18]: number

[^19]: number

[^20]: enum

[^21]: number

[^22]: string

[^23]: string

[^24]: object

[^25]: string

[^26]: object

[^27]: object

[^28]: boolean

[^29]: CSSSelector

[^30]: HTMLElement

[^31]: boolean

[^32]: string

[^33]: number

[^34]: object

[^35]: boolean

[^36]: boolean

[^37]: string

[^38]: Component
