# Checkbox

A group of options for multiple choices.
[`el_checkbox()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox.md)
is one box, `TRUE` or `FALSE`, as
[`checkboxInput()`](https://rdrr.io/pkg/shiny/man/checkboxInput.html);
[`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md)
reports the values ticked, as
[`checkboxGroupInput()`](https://rdrr.io/pkg/shiny/man/checkboxGroupInput.html).

## Basic usage

``` r

el_checkbox("option", "Option", value = TRUE)
```

## Disabled state

``` r

el_checkbox("d1", "Option", disabled = TRUE)
el_checkbox("d2", "Option", value = TRUE, disabled = TRUE)
```

## Checkbox group

``` r

el_checkbox_group("list", selected = c("selected and disabled", "Option A"), choices = list(
  list(value = "Option A", label = "Option A"), list(value = "Option B", label = "Option B"),
  list(value = "Option C", label = "Option C"),
  list(value = "disabled", label = "disabled", disabled = TRUE),
  list(value = "selected and disabled", label = "selected and disabled", disabled = TRUE)))
```

## Indeterminate

The “check all” box above a group: half-ticked while some are, kept in
step from the server.

``` r

cities <- c("Shanghai", "Beijing", "Guangzhou", "Shenzhen")

ui <- el_page(
  el_checkbox("all", "Check all", indeterminate = TRUE),
  tags$div(style = "margin: 15px 0"),
  el_checkbox_group("cities", choices = cities, selected = cities[1:2])
)

server <- function(input, output, session) {
  observeEvent(input$all, {
    update_el_checkbox_group(id = "cities", selected = if (isTRUE(input$all)) cities else character(0))
  }, ignoreInit = TRUE)
  observeEvent(input$cities, {
    n <- length(input$cities)
    update_el_checkbox(id = "all", value = n == length(cities),
                       indeterminate = n > 0 && n < length(cities))
  }, ignoreNULL = FALSE)
}

shinyApp(ui, server)
```

![The indeterminate example,
running](../../shots/checkbox-indeterminate.png)

## Minimum / maximum items checked

``` r

el_checkbox_group("limited", choices = c("Shanghai", "Beijing", "Guangzhou", "Shenzhen"),
                  selected = c("Shanghai", "Beijing"), min = 1, max = 2)
```

## Button style

``` r

cities <- c("Shanghai", "Beijing", "Guangzhou", "Shenzhen")
tagList(lapply(c("default", "medium", "small", "mini"), function(s)
  tags$div(style = "margin-bottom: 12px", el_checkbox_group(paste0("cb_", s), choices = cities,
    selected = "Shanghai", button = TRUE, size = if (s != "default") s))))
```

## With borders

``` r

el_checkbox("b1", "Option1", value = TRUE, border = TRUE)
el_checkbox("b2", "Option2", border = TRUE)
el_checkbox_group("b3", selected = "Option1", choices = list(
  list(value = "Option1", label = "Option1", border = TRUE),
  list(value = "Option2", label = "Option2", border = TRUE, disabled = TRUE)))
```

## API

### Checkbox Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `el_checkbox(value =)` | binding value | string / number / boolean | — | — |
| `label` | `el_checkbox(label =)` | value of the Checkbox when used inside a `checkbox-group` | string / number / boolean | — | — |
| `true-label` | `el_checkbox(true_label =)` | value of the Checkbox if it’s checked | string / number | — | — |
| `false-label` | `el_checkbox(false_label =)` | value of the Checkbox if it’s not checked | string / number | — | — |
| `disabled` | `el_checkbox(disabled =)` | whether the Checkbox is disabled | boolean | — | false |
| `border` | `el_checkbox(border =)` | whether to add a border around Checkbox | boolean | — | false |
| `size` | `el_checkbox(size =)` | size of the Checkbox, only works when `border` is true | string | medium / small / mini | — |
| `name` | `el_checkbox(name =)` | native ‘name’ attribute | string | — | — |
| `checked` | `el_checkbox(checked =)` | if the Checkbox is checked | boolean | — | false |
| `indeterminate` | `el_checkbox(indeterminate =)` | same as `indeterminate` in native checkbox | boolean | — | false |

### Checkbox Events

| Element  | In R                    | Description                             |
|----------|-------------------------|-----------------------------------------|
| `change` | `input$<id>`, the value | triggers when the binding value changes |

### Checkbox-group Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `selected (or value)` | binding value | array | — | — |
| `size` | `el_checkbox(size =)` | size of checkbox buttons or bordered checkboxes | string | medium / small / mini | — |
| `disabled` | `el_checkbox(disabled =)` | whether the nesting checkboxes are disabled | boolean | — | false |
| `min` | `el_checkbox_group(min =)` | minimum number of checkbox checked | number | — | — |
| `max` | `el_checkbox_group(max =)` | maximum number of checkbox checked | number | — | — |
| `text-color` | `el_checkbox_group(text_color =)` | font color when button is active | string | — | \#ffffff |
| `fill` | `el_checkbox_group(fill =)` | border and background color when button is active | string | — | \#409EFF |

### Checkbox-group Events

| Element  | In R                    | Description                             |
|----------|-------------------------|-----------------------------------------|
| `change` | `input$<id>`, the value | triggers when the binding value changes |

### Checkbox-button Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `label` | `el_checkbox(label =)` | value of the checkbox when used inside a `checkbox-group` | string / number / boolean | — | — |
| `true-label` | `el_checkbox(true_label =)` | value of the checkbox if it’s checked | string / number | — | — |
| `false-label` | `el_checkbox(false_label =)` | value of the checkbox if it’s not checked | string / number | — | — |
| `disabled` | `el_checkbox(disabled =)` | whether the checkbox is disabled | boolean | — | false |
| `name` | `el_checkbox(name =)` | native ‘name’ attribute | string | — | — |
| `checked` | `el_checkbox(checked =)` | if the checkbox is checked | boolean | — | false |
