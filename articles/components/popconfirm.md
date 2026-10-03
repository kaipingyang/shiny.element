# Popconfirm

A simple confirmation dialog of an element click action.

## Placement

popconfirm has 9 placements.

Use attribute `title` to set the display content when click the
reference element. The attribute `placement` determines the position of
the popconfirm. Its value is `[orientation]-[alignment]` with four
orientations `top`, `left`, `right`, `bottom` and three alignments
`start`, `end`, `null`, and the default alignment is null. Take
`placement="left-end"` for example, popconfirm will display on the left
of the element which you are hovering and the bottom of the popconfirm
aligns with the bottom of the element.

``` r

places <- c("top-start", "top", "top-end", "left", "right", "bottom-start", "bottom", "bottom-end")
tags$div(style = "padding: 60px 100px; display: flex; flex-wrap: wrap; gap: 12px", lapply(places, function(p)
  el_popconfirm(paste0("pc_", gsub("-", "_", p)), reference = el_button(paste0("pcb_", gsub("-", "_", p)), p),
                title = paste(p, "prompts info"), placement = p)))
```

## Basic usage

Popconfirm is similar to Popover. So for some duplicated attributes,
please refer to the documentation of Popover.

Only `title` attribute is available in Popconfirm, `content` will be
ignored.

``` r

el_popconfirm("del", reference = el_button("del_btn", "Delete"),
              title = "Are you sure to delete this?")
```

## Customize

You can customize Popconfirm like:

``` r

el_popconfirm("good", reference = el_button("go", "Delete"), title = "Are you sure to delete this?",
              confirm_button_text = "OK", cancel_button_text = "No, Thanks",
              icon = "InfoFilled", icon_color = "#626AEF", width = "220px")
```

## Trigger event

Click the button to trigger the event

Confirming and cancelling are inputs: `input$<id>_confirm`,
`input$<id>_cancel`.

``` r

el_popconfirm("ev", reference = el_button("ev_btn", "Delete"), title = "Are you sure to delete this?",
              confirm_button_text = "Yes", cancel_button_text = "No")
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | `title` | Title | [^1] |  | — |
| `effect` | `effect` | Tooltip theme, built-in theme: `dark` / `light` | [^2]`'dark' \\| 'light'` / [^3] |  | light |
| `confirm-button-text` | `confirm_button_text` | Confirm button text | [^4] |  | — |
| `cancel-button-text` | `cancel_button_text` | Cancel button text | [^5] |  | — |
| `confirm-button-type` | `confirm_button_type` | Confirm button type | [^6]`'primary' \\| 'success' \\| 'warning' \\| 'danger' \\| 'info' \\| 'text'` |  | primary |
| `cancel-button-type` | `cancel_button_type` | Cancel button type | [^7]`'primary' \\| 'success' \\| 'warning' \\| 'danger' \\| 'info' \\| 'text'` |  | text |
| `icon` | `icon` | Icon Component | [^8] / [^9] |  | QuestionFilled |
| `icon-color` | `icon_color` | Icon color | [^10] |  | \#f90 |
| `hide-icon` | `hide_icon` | is hide Icon | [^11] |  | false |
| `hide-after` | `hide_after` | delay of disappear, in millisecond | [^12] |  | 200 |
| `teleported` | `teleported` | whether popconfirm is teleported to the body | [^13] |  | true |
| `persistent` | `persistent` | when popconfirm inactive and `persistent` is `false` , popconfirm will be destroyed | [^14] |  | false |
| `width` | `width` | popconfirm width, min width 150px | [^15] / [^16] |  | 150 |

### Events

| Element | In R | Description |
|----|----|----|
| `confirm` | one of the component’s inputs – see its reference page | triggers when click confirm button |
| `cancel` | one of the component’s inputs – see its reference page | triggers when click cancel button |

### Slots

| Element | In R | Description |
|----|----|----|
| `reference` | `slots = list(reference = )` | HTML element that triggers Popconfirm |
| `actions` | `slots = list(actions = )` | content of the Popconfirm footer |

### Exposes

| Element | In R                           | Description     |
|---------|--------------------------------|-----------------|
| `hide`  | `el_call(session, id, "hide")` | hide popconfirm |

[^1]: string

[^2]: enum

[^3]: string

[^4]: string

[^5]: string

[^6]: enum

[^7]: enum

[^8]: string

[^9]: Component

[^10]: string

[^11]: boolean

[^12]: number

[^13]: boolean

[^14]: boolean

[^15]: string

[^16]: number
