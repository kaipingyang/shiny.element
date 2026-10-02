# Switch

Switch is used for switching between two opposing states; `input$<id>`
is `TRUE` or `FALSE`, or the values given.

## Basic usage

``` r

el_switch("s1", value = TRUE)
el_switch("s2", value = TRUE, active_color = "#13ce66", inactive_color = "#ff4949")
```

## Text description

``` r

el_switch("bill", value = TRUE, active_text = "Pay by month", inactive_text = "Pay by year")
```

## Extended value types

`active_value` and `inactive_value` take numbers or text; `input$<id>`
reports them.

``` r

el_switch("level", value = "100", active_color = "#13ce66", inactive_color = "#ff4949",
          active_value = "100", inactive_value = "0")
```

## Disabled

``` r

el_switch("d1", value = TRUE, disabled = TRUE)
el_switch("d2", value = FALSE, disabled = TRUE)
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | boolean / string / number | — | — |
| `disabled` | `disabled` | whether Switch is disabled | boolean | — | false |
| `width` | `width` | width of Switch | number | — | 40 |
| `active-icon-class` | `active_icon_class` | class name of the icon displayed when in `on` state, overrides `active-text` | string | — | — |
| `inactive-icon-class` | `inactive_icon_class` | class name of the icon displayed when in `off` state, overrides `inactive-text` | string | — | — |
| `active-text` | `active_text` | text displayed when in `on` state | string | — | — |
| `inactive-text` | `inactive_text` | text displayed when in `off` state | string | — | — |
| `active-value` | `active_value` | switch value when in `on` state | boolean / string / number | — | true |
| `inactive-value` | `inactive_value` | switch value when in `off` state | boolean / string / number | — | false |
| `active-color` | `active_color` | background color when in `on` state | string | — | \#409EFF |
| `inactive-color` | `inactive_color` | background color when in `off` state | string | — | \#C0CCDA |
| `name` | `name` | input name of Switch | string | — | — |
| `validate-event` | `validate_event` | whether to trigger form validation | boolean | \- | true |

### Events

| Element  | In R                    | Description                 |
|----------|-------------------------|-----------------------------|
| `change` | `input$<id>`, the value | triggers when value changes |

### Methods

| Element | In R                            | Description                |
|---------|---------------------------------|----------------------------|
| `focus` | `el_call(session, id, "focus")` | focus the Switch component |
