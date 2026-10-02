# Radio

Single selection among multiple options. Element’s radios share a
`v-model`; here they are always a group,
[`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md),
which reports the chosen value as `input$<id>` – as
[`radioButtons()`](https://rdrr.io/pkg/shiny/man/radioButtons.html)
does.

## Basic usage

``` r

el_radio_group("pick", choices = c("Option A" = "1", "Option B" = "2"), selected = "1")
```

## Disabled

A choice can be disabled on its own, or the whole group.

``` r

el_radio_group("one", selected = "a", choices = list(
  list(value = "a", label = "Option A", disabled = TRUE),
  list(value = "b", label = "Option B")))
el_radio_group("all", choices = c("Option A" = "a", "Option B" = "b"), disabled = TRUE)
```

## Radio button group

Mutually exclusive options, laid out together.

``` r

el_radio_group("opt", choices = c("Option A" = 3, "Option B" = 6, "Option C" = 9), selected = 3)
```

## Button style

`button = TRUE` draws the choices as joined buttons; `size` sets their
size.

``` r

cities <- c("New York", "Washington", "Los Angeles", "Chicago")
tagList(
  tags$div(style = "margin-bottom: 12px", el_radio_group("b1", choices = cities, selected = "New York", button = TRUE)),
  tags$div(style = "margin-bottom: 12px", el_radio_group("b2", choices = cities, selected = "New York", button = TRUE, size = "medium")),
  tags$div(style = "margin-bottom: 12px", el_radio_group("b3", selected = "New York", button = TRUE, size = "small",
    choices = list(list(value = "New York", label = "New York"),
                   list(value = "Washington", label = "Washington", disabled = TRUE),
                   list(value = "Los Angeles", label = "Los Angeles"),
                   list(value = "Chicago", label = "Chicago")))),
  el_radio_group("b4", choices = cities, selected = "New York", button = TRUE, size = "mini", disabled = TRUE))
```

## With borders

`border` is set on each choice, as Element sets it on each radio.

``` r

el_radio_group("bd", selected = "1", choices = list(
  list(value = "1", label = "Option A", border = TRUE),
  list(value = "2", label = "Option B", border = TRUE)))
```

## API

### Radio Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | string / number / boolean | — | — |
| `label` | `label` | the value of Radio | string / number / boolean | — | — |
| `disabled` | `disabled` | whether Radio is disabled | boolean | — | false |
| `border` | field `border` of each of `choices` | whether to add a border around Radio | boolean | — | false |
| `size` | `size` | size of the Radio, only works when `border` is true | string | medium / small / mini | — |
| `name` | field `name` of each of `choices` | native ‘name’ attribute | string | — | — |

### Radio Events

| Element  | In R                    | Description                           |
|----------|-------------------------|---------------------------------------|
| `change` | `input$<id>`, the value | triggers when the bound value changes |

### Radio-group Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `selected (or value)` | binding value | string / number / boolean | — | — |
| `size` | `size` | the size of radio buttons or bordered radios | string | medium / small / mini | — |
| `disabled` | `disabled` | whether the nesting radios are disabled | boolean | — | false |
| `text-color` | `text_color` | font color when button is active | string | — | \#ffffff |
| `fill` | `fill` | border and background color when button is active | string | — | \#409EFF |

### Radio-group Events

| Element  | In R                    | Description                           |
|----------|-------------------------|---------------------------------------|
| `change` | `input$<id>`, the value | triggers when the bound value changes |

### Radio-button Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `label` | `label` | the value of radio | string / number | — | — |
| `disabled` | `disabled` | whether radio is disabled | boolean | — | false |
| `name` | field `name` of each of `choices` | native ‘name’ attribute | string | — | — |
