# Collapse

Use Collapse to store contents.

## Basic usage

You can expand multiple panels

``` r

panels <- list(
  list(name = "1", title = "Consistency", tags$div("Consistent with real life: in line with the process and logic of real life, and comply with languages and habits that the users are used to;")),
  list(name = "2", title = "Feedback", tags$div("Operation feedback: enable the users to clearly perceive their operations by style updates and interactive effects;")),
  list(name = "3", title = "Efficiency", tags$div("Simplify the process: keep operating process simple and intuitive;")),
  list(name = "4", title = "Controllability", tags$div("Decision making: giving advices about operations is acceptable, but do not make decisions for the users;")))
el_collapse("coll", items = panels, value = "1")
```

Consistency

Feedback

Efficiency

Controllability

## Accordion

In accordion mode, only one panel can be expanded at once

Activate accordion mode using the `accordion` attribute.

``` r

el_collapse("coll_acc", value = "1", accordion = TRUE, items = list(
  list(name = "1", title = "Consistency", tags$div("Consistent with real life.")),
  list(name = "2", title = "Feedback", tags$div("Operation feedback.")),
  list(name = "3", title = "Efficiency", tags$div("Simplify the process.")),
  list(name = "4", title = "Controllability", tags$div("Decision making."))))
```

Consistency

Feedback

Efficiency

Controllability

## Custom title

Besides using the `title` attribute, you can customize panel title with
named slots, which makes adding custom content, e.g. icons, possible.

> **Tip**
>
> Starting from version 2.9.10, the `title` slot provides an `isActive`
> property that indicates whether the current collapse item is active.

A title may be markup: an icon beside the text.

``` r

el_collapse("coll_title", accordion = TRUE, items = list(
  list(name = "1", title = tags$span("Consistency ", el_icon("InfoFilled", class = "header-icon")),
       tags$div("Consistent with real life.")),
  list(name = "2", title = "Feedback", tags$div("Operation feedback."))))
```

Consistency

Feedback

## Custom icon

Besides using the `icon` attribute, you can customize icon of panel item
with named slots, which makes adding custom content.

``` r

el_collapse("coll_icon", value = "1", items = list(
  list(name = "1", title = "Consistency", icon = "CaretRight", tags$div("Consistent with real life.")),
  list(name = "2", title = "Feedback", icon = "ArrowRightBold", tags$div("Operation feedback."))))
```

Consistency

Feedback

## Custom icon position

using the `expand-icon-position` attribute, you can customize icon
position.

``` r

el_collapse("coll_pos", expand_icon_position = "left", items = list(
  list(name = "1", title = "Consistency", tags$div("Consistent with real life.")),
  list(name = "2", title = "Feedback", tags$div("Operation feedback."))))
```

Consistency

Feedback

## Prevent collapsing

set the `before-collapse` property, If `false` is returned or a
`Promise` is returned and then is rejected, will stop collapsing.

`before_collapse` may hold a panel as it is: return `false`, or a
promise.

``` r

el_collapse("coll_guard", before_collapse = JS("function(name) { return confirm('Toggle ' + name + '?'); }"),
  items = list(list(name = "1", title = "Consistency", tags$div("Consistent with real life.")),
               list(name = "2", title = "Feedback", tags$div("Operation feedback."))))
```

Consistency

Feedback

## API

Element Plus’s tables, and beside each entry where it is in R.

### Collapse Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | currently active panel, the type is `string` in accordion mode, otherwise it is `array` | [^1] / [^2] |  | \[\] |
| `accordion` | `accordion` | whether to activate accordion mode | [^3] |  | false |
| `expand-icon-position` | `expand_icon_position` | set expand icon position | [^4]`'left' \\| 'right'` |  | right |
| `before-collapse` | `before_collapse` | before-collapse hook before the collapse state changes. If `false` is returned or a `Promise` is returned and then is rejected, will stop collapsing | [^5]`() => Promise<boolean> \\| boolean` |  | — |

### Collapse Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when active panels change, the parameter type is `string` in accordion mode, otherwise it is `array` |

### Collapse Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Collapse Exposes

| Element | In R | Description |
|----|----|----|
| `setActiveNames` | `el_call(session, id, "setActiveNames")` | set active panel names |

### Collapse Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | item field `title` | title of the panel | [^6] |  | ’’ |
| `icon` | item field `icon` | icon of the collapse item | [^7] / [^8] |  | ArrowRight |
| `disabled` | item field `disabled` | disable the collapse item | [^9] |  | false |

### Collapse Item Slot

| Element   | In R                     | Description                    |
|-----------|--------------------------|--------------------------------|
| `default` | default content          | content of Collapse Item       |
| `title`   | `slots = list(title = )` | content of Collapse Item title |
| `icon`    | `slots = list(icon = )`  | content of Collapse Item icon  |

[^1]: string

[^2]: array

[^3]: boolean

[^4]: enum

[^5]: Function

[^6]: string

[^7]: string

[^8]: Component

[^9]: boolean
