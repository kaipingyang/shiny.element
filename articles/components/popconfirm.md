# Popconfirm

A simple confirmation of a click. `input$<id>_confirm` and
`input$<id>_cancel` report the answer.

## Basic usage

``` r

el_popconfirm("del", reference = el_button("del_btn", "Delete"),
              title = "Are you sure to delete this?")
```

## Customise

``` r

el_popconfirm("good", reference = el_button("go", "Delete"), title = "Are you sure to delete this?",
              confirm_button_text = "OK", cancel_button_text = "No, Thanks",
              icon = "el-icon-info", icon_color = "red")
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | `title` | Title | String | — | — |
| `confirm-button-text` | `confirm_button_text` | Confirm button text | String | — | — |
| `cancel-button-text` | `cancel_button_text` | Cancel button text | String | — | — |
| `confirm-button-type` | `confirm_button_type` | Confirm button type | String | — | Primary |
| `cancel-button-type` | `cancel_button_type` | Cancel button type | String | — | Text |
| `icon` | `icon` | Icon | String | — | el-icon-question |
| `icon-color` | `icon_color` | Icon color | String | — | \#f90 |
| `hide-icon` | `hide_icon` | is hide Icon | Boolean | — | false |

### Slot

| Element | In R | Description |
|----|----|----|
| `reference` | `slots = list(reference = )` | HTML element that triggers Popconfirm |

### Events

| Element | In R | Description |
|----|----|----|
| `confirm` | one of the component’s inputs – see its reference page | triggers when click confirm button |
| `cancel` | one of the component’s inputs – see its reference page | triggers when click cancel button |
