# Alert

Displays important alert messages.

## Basic Usage

Alert components are non-overlay elements in the page that does not
disappear automatically.

Alert provides 5 types of themes defined by `type`, whose default value
is `info`. `primary` has been added in 2.9.11.

``` r

types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t)))
```

## Theme

Alert provide two different themes, `light` and `dark`.

Set `effect` to change theme, default is `light`.

``` r

types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     effect = "dark")))
```

## Customizable Close Button

Customize the close button as texts or other symbols.

Alert allows you to configure if it’s closable. The close button text
and closing callbacks are also customizable. `closable` attribute
decides if the component can be closed or not. It accepts `boolean`, and
the default is `true`. You can set `close-text` attribute to replace the
default cross symbol as the close button. Be careful that `close-text`
must be a string. `close` event fires when the component is closed.

Closing reports `input$<id>_close`, where Element Plus’s demo raises a
browser alert.

``` r

tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  el_alert(title = "Unclosable alert", type = "success", closable = FALSE),
  el_alert(title = "Customized close text", type = "info", close_text = "Gotcha"),
  el_alert("alert_cb", title = "Alert with callback", type = "warning"))
```

## With Icon

Displaying an icon improves readability.

Setting the `show-icon` attribute displays an icon that corresponds with
the current Alert type. Or use the `icon` slot to customize icon.

``` r

types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     show_icon = TRUE)),
  el_alert(title = "Error alert with custom icon", type = "error", show_icon = TRUE,
           slots = list(icon = el_icon("Bell"))))
```

## Centered Text

Use the `center` attribute to center the text.

``` r

types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     center = TRUE, show_icon = TRUE)))
```

## With Description

Description includes a message with more detailed information.

Besides the required `title` attribute, you can add a `description`
attribute to help you describe the alert with more details. Description
can only store text string, and it will word wrap automatically.

``` r

tags$div(style = "max-width: 600px",
  el_alert(title = "With description", type = "success", description = "This is a description."))
```

## With Icon and Description

At last, this is an example with both icon and description.

``` r

types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     description = "More text description", show_icon = TRUE)))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | `title` | alert title. | [^1] |  | — |
| `type` | `type` | alert type. | [^2]`'primary' (2.9.11) \\| 'success' \\| 'warning' \\| 'info' \\| 'error'` |  | info |
| `description` | `description` | descriptive text. | [^3] |  | — |
| `closable` | `closable` | whether alert can be dismissed. | [^4] |  | true |
| `center` | `center` | whether content is placed in the center. | [^5] |  | false |
| `close-text` | `close_text` | customized close button text. | [^6] |  | — |
| `show-icon` | `show_icon` | whether a type icon is displayed. | [^7] |  | false |
| `effect` | `effect` | theme style. | [^8]`'light' \\| 'dark'` |  | light |

### Events

| Element | In R | Description |
|----|----|----|
| `close` | one of the component’s inputs – see its reference page | trigger when alert is closed. |

### Slots

| Element   | In R                     | Description                       |
|-----------|--------------------------|-----------------------------------|
| `default` | default content          | content of the alert description. |
| `title`   | `slots = list(title = )` | content of the alert title.       |
| `icon`    | `slots = list(icon = )`  | content of the alert icon.        |

[^1]: string

[^2]: enum

[^3]: string

[^4]: boolean

[^5]: boolean

[^6]: string

[^7]: boolean

[^8]: enum
