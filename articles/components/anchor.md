# Anchor

Through the anchor point, you can quickly find the position of the
information content on the current page.

## Basic Usage

The most basic usage

The links point at this page’s own sections.

``` r

el_anchor("toc", offset = 70, links = list(
  list(title = "Basic Usage", href = "#basic-usage"),
  list(title = "Horizontal Mode", href = "#horizontal-mode"),
  list(title = "Scroll Container", href = "#scroll-container"),
  list(title = "Anchor API", href = "#api", children = list(
    list(title = "Anchor Attributes", href = "#anchor-attributes"),
    list(title = "Anchor Events", href = "#anchor-events")))))
```

## Horizontal Mode

Horizontally aligned anchors

> **Tip**
>
> Horizontal Mode does not support `sub-link` slots

``` r

el_anchor("toc_h", offset = 70, direction = "horizontal", links = list(
  list(title = "Basic Usage", href = "#basic-usage"),
  list(title = "Horizontal Mode", href = "#horizontal-mode"),
  list(title = "Scroll Container", href = "#scroll-container")))
```

## Scroll Container

Custom scroll area, use `offset` props can set anchor scroll offset,
listen the `link-click` event and prevents browser default behavior then
it will not change history.

``` r

part <- function(id, colour) tags$div(id = id,
  style = sprintf("height: 300px; background: %s; margin-top: 30px", colour), id)
el_row(
  el_col(span = 18, tags$div(id = "anchor-scroller", style = "height: 300px; overflow-y: auto",
    part("part1", "rgba(255, 0, 0, 0.02)"), part("part2", "rgba(0, 255, 0, 0.02)"),
    part("part3", "rgba(0, 0, 255, 0.02)"))),
  el_col(span = 6, el_anchor("toc_s", container = "#anchor-scroller", links = list(
    list(title = "part1", href = "#part1"), list(title = "part2", href = "#part2"),
    list(title = "part3", href = "#part3")))))
```

part1

part2

part3

## Anchor link change

Listening for anchor link change

The current link is `input$<id>`, as the page scrolls.

``` r

el_anchor("toc_change", offset = 70, links = list(
  list(title = "Basic Usage", href = "#basic-usage"),
  list(title = "Horizontal Mode", href = "#horizontal-mode"),
  list(title = "Scroll Container", href = "#scroll-container")))
```

## Underline type

set `type="underline"` change to underline type

``` r

el_anchor("toc_u", type = "underline", offset = 70, links = list(
  list(title = "Basic Usage", href = "#basic-usage"),
  list(title = "Horizontal Mode", href = "#horizontal-mode"),
  list(title = "Scroll Container", href = "#scroll-container")))
```

## Affix Mode

Use the affix component to fix the anchor point within the page.

``` r

el_affix(offset = 60,
  el_anchor("toc_a", offset = 70, width = "300px", links = list(
    list(title = "Basic Usage", href = "#basic-usage"),
    list(title = "Horizontal Mode", href = "#horizontal-mode"),
    list(title = "Scroll Container", href = "#scroll-container"))))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Anchor Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `container` | `container` | Scroll container. | `string` \\ | `HTMLElement` \\ | `Window` |
| `offset` | `offset` | Set the offset of the anchor scroll. | `number` |  | 0 |
| `bound` | `bound` | The offset of the element starting to trigger the anchor. | `number` |  | 15 |
| `duration` | `duration` | Set the scroll duration of the container, in milliseconds. | `number` |  | 300 |
| `marker` | `marker` | Whether to show the marker. | [^1] |  | true |
| `type` | `type` | Set Anchor type. | [^2]`'default' \\| 'underline'` |  | `default` |
| `direction` | `direction` | Set Anchor direction. | [^3]`'vertical' \\| 'horizontal'` |  | `vertical` |
| `select-scroll-top` | `select_scroll_top` | Scroll whether link is selected at the top | [^4] |  | false |

### Anchor Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | Callback when the step changes |
| `click` | `input$<id>_click` | Triggered when the user clicks on the link |

### Anchor Exposes

| Element | In R | Description |
|----|----|----|
| `scrollTo` | `el_call(session, id, "scrollTo")` | Manually scroll to the specific position. |

### Anchor Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | AnchorLink component list |

### AnchorLink Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | field `title` of each of `links` | The text content of the anchor link. | `string` |  | — |
| `href` | field `href` of each of `links` | The address of the anchor link. | `string` |  | — |

### AnchorLink Slots

| Element    | In R                        | Description                     |
|------------|-----------------------------|---------------------------------|
| `default`  | default content             | The content of the anchor link. |
| `sub-link` | `slots = list(sub-link = )` | Slots for child links.          |

[^1]: boolean

[^2]: enum

[^3]: enum

[^4]: boolean
