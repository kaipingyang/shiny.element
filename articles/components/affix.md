# Affix

Fix the element to a specific visible area.

## Basic Usage

Affix is fixed at the top of the page by default.

You can set `offset` attribute to change the offset top，the default
value is 0.

``` r

el_affix(
  offset = 120,
  el_button("affix_top", "Offset top 120px", type = "primary")
)
```

## Target Container

You can set `target` attribute to keep the affix in the container at all
times. It will be hidden if out of range.

Please notice that the container avoid having scrollbar.

``` r

tags$div(
  class = "affix-container",
  style = "height: 400px; background: var(--el-color-primary-light-9)",
  el_affix(
    target = ".affix-container",
    offset = 80,
    el_button("affix_target", "Target container", type = "primary")
  )
)
```

## Fixed Position

The affix component provides two fixed positions: `top` and `bottom`.

You can set `position` attribute to change the fixed position, the
default value is `top`.

``` r

el_affix(
  position = "bottom",
  offset = 20,
  el_button("affix_bottom", "Offset bottom 20px", type = "primary")
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `offset` | `offset` | offset distance | [^1] |  | 0 |
| `position` | `position` | position of affix | [^2]`'top' \\| 'bottom'` |  | top |
| `target` | `target` | target container (CSS selector) | [^3] |  | — |
| `z-index` | `z_index` | `z-index` of affix | [^4] |  | 100 |
| `teleported` | `teleported` | whether affix element is teleported, if `true` it will be teleported to where `append-to` sets | [^5] |  | false |
| `append-to` | `append_to` | which element the affix element appends to | [^6] / [^7] |  | body |

### Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>_change` | triggers when fixed state changed |
| `scroll` | `input$<id>_scroll`, with `events = "scroll"` | triggers when scrolling |

### Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Exposes

| Element | In R | Description |
|----|----|----|
| `update` | `call_el(session, id, "update")` | update affix state manually |
| `updateRoot` | `call_el(session, id, "updateRoot")` | update rootRect info |

[^1]: number

[^2]: enum

[^3]: string

[^4]: number

[^5]: boolean

[^6]: CSSSelector

[^7]: HTMLElement
