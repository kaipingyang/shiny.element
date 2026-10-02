# Collapse

Use Collapse to store contents. `items` is a list of
`list(name =, title =, content =)`; `input$<id>` the names open. The
panels hold any Shiny UI, components included.

## Basic usage

``` r

el_collapse("basic", value = "1", items = list(
  list(name = "1", title = "Consistency", content = "Consistent with real life: in line with the process and logic of real life."),
  list(name = "2", title = "Feedback", content = "Operation feedback: enable the users to clearly perceive their operations."),
  list(name = "3", title = "Efficiency", content = "Simplify the process: keep operating process simple and intuitive."),
  list(name = "4", title = "Controllability", content = "Decision making: giving advices about operations is acceptable.")))
```

Consistency

Consistent with real life: in line with the process and logic of real
life.

Feedback

Operation feedback: enable the users to clearly perceive their
operations.

Efficiency

Simplify the process: keep operating process simple and intuitive.

Controllability

Decision making: giving advices about operations is acceptable.

## Accordion

Only one panel open at a time.

``` r

el_collapse("acc", accordion = TRUE, value = "1", items = list(
  list(name = "1", title = "Consistency", content = "In line with the process and logic of real life."),
  list(name = "2", title = "Feedback", content = "Enable the users to clearly perceive their operations."),
  list(name = "3", title = "Efficiency", content = "Keep operating process simple and intuitive.")))
```

Consistency

In line with the process and logic of real life.

Feedback

Enable the users to clearly perceive their operations.

Efficiency

Keep operating process simple and intuitive.

## Custom title

A `title` may be markup.

``` r

el_collapse("cus", items = list(
  list(name = "1", title = tagList("Consistency ", el_icon("info")), content = "In line with real life."),
  list(name = "2", title = "Feedback", content = "Clearly perceive operations.")))
```

Consistency

In line with real life.

Feedback

Clearly perceive operations.

## API

### Collapse Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | currently active panel | string (accordion mode) / array (non-accordion mode) | — | — |
| `accordion` | `accordion` | whether to activate accordion mode | boolean | — | false |

### Collapse Events

| Element  | In R                    | Description                        |
|----------|-------------------------|------------------------------------|
| `change` | `input$<id>`, the value | triggers when active panels change |

### Collapse Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `name` | item field `name` | unique identification of the panel | string/number | — | — |
| `title` | item field `title` | title of the panel | string | — | — |
| `disabled` | item field `disabled` | disable the collapse item | boolean | — | — |
