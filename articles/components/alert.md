# Alert

Displays important alert messages. `input$<id>_close` fires when the
user closes one;
[`update_el_alert()`](https://kaipingyang.github.io/shiny.element/reference/update_el_alert.md)
changes it.

## Basic usage

``` r

el_alert("a1", title = "success alert", type = "success")
el_alert("a2", title = "info alert", type = "info")
el_alert("a3", title = "warning alert", type = "warning")
el_alert("a4", title = "error alert", type = "error")
```

## Theme

``` r

el_alert("d1", title = "success alert", type = "success", effect = "dark")
el_alert("d2", title = "info alert", type = "info", effect = "dark")
el_alert("d3", title = "warning alert", type = "warning", effect = "dark")
el_alert("d4", title = "error alert", type = "error", effect = "dark")
```

## Customizable close button

``` r

el_alert("c1", title = "unclosable alert", type = "success", closable = FALSE)
el_alert("c2", title = "customized close-text", type = "info", close_text = "Gotcha")
el_alert("c3", title = "alert with callback", type = "warning")
```

## With icon

``` r

el_alert("i1", title = "success alert", type = "success", show_icon = TRUE)
el_alert("i2", title = "info alert", type = "info", show_icon = TRUE)
el_alert("i3", title = "warning alert", type = "warning", show_icon = TRUE)
el_alert("i4", title = "error alert", type = "error", show_icon = TRUE)
```

## Centered text

``` r

el_alert("ct1", title = "success alert", type = "success", center = TRUE, show_icon = TRUE)
el_alert("ct2", title = "error alert", type = "error", center = TRUE, show_icon = TRUE)
```

## With description

``` r

el_alert("de", title = "with description", type = "success",
         description = "This is a description.")
```

## With icon and description

``` r

el_alert("b1", title = "success alert", type = "success", show_icon = TRUE,
         description = "more text description")
el_alert("b2", title = "error alert", type = "error", show_icon = TRUE,
         description = "more text description")
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | `title` | title | string | — | — |
| `type` | `type` | Component type | string | success/warning/info/error | info |
| `description` | `description` | Descriptive text. Can also be passed with the default slot | string | — | — |
| `closable` | `closable` | If closable or not | boolean | — | true |
| `center` | `center` | Whether to center the text | boolean | — | false |
| `close-text` | `close_text` | Customized close button text | string | — | — |
| `show-icon` | `show_icon` | If a type icon is displayed | boolean | — | false |
| `effect` | `effect` | Choose theme | string | light/dark | light |

### Slot

| Element | In R                     | Description                |
|---------|--------------------------|----------------------------|
| `title` | `slots = list(title = )` | content of the Alert title |

### Events

| Element | In R | Description |
|----|----|----|
| `close` | one of the component’s inputs – see its reference page | fires when alert is closed |
