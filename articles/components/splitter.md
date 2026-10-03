# Splitter

Divide the area horizontally or vertically, and freely drag to adjust
the size of each area.

## Basic usage

The most basic usage, if no default size is passed, it will be
automatically divided equally.

``` r

panel <- function(x) tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%", x)
tags$div(style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(el_splitter_panel(size = "30%", panel(1)), el_splitter_panel(panel(2))))
```

## Vertical

Use vertical orientation.

``` r

panel <- function(x) tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%", x)
tags$div(style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(layout = "vertical", el_splitter_panel(panel(1)), el_splitter_panel(panel(2))))
```

## Collapsible

Configuring `collapsible` provides quick shrinking capability. You can
use the `min` property to prevent expanding through dragging after
collapsing.

``` r

panel <- function(x) tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%", x)
tags$div(style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(el_splitter_panel(collapsible = TRUE, min = 50, panel(1)),
              el_splitter_panel(collapsible = TRUE, panel(2)),
              el_splitter_panel(panel(3))))
```

## Disable drag

When either panel disables `resizable`, dragging will be disabled.

``` r

panel <- function(x) tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%", x)
tags$div(style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(el_splitter_panel(resizable = FALSE, panel(1)), el_splitter_panel(panel(2))))
```

## Panel size

`v-model:size` can get the panel size.

Dragging reports `input$<id>_resize_start`, `_resize` and `_resize_end`.

``` r

panel <- function(x) tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%", x)
tags$div(style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(id = "split_size", el_splitter_panel(size = "200px", panel(1)), el_splitter_panel(panel(2))))
```

## Lazy

When `lazy` is enabled, the panel size will not update in real time
during dragging, but only after the drag ends.

``` r

panel <- function(x) tags$div(style = "display: flex; align-items: center; justify-content: center; height: 100%", x)
tags$div(style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(lazy = TRUE, el_splitter_panel(panel(1)), el_splitter_panel(panel(2))))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Splitter Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `layout` | `el_splitter(layout =)` | Layout direction of the splitter | [^1]`'horizontal' \\| 'vertical'` |  | horizontal |
| `lazy` | `el_splitter(lazy =)` | Whether to enable lazy mode | [^2] |  | false |

### Splitter Events

| Element | In R | Description |
|----|----|----|
| `resize-start` | `input$<id>_resize_start` | Triggered when starting to resize a panel, `index` is the drag bar index |
| `resize` | `input$<id>_resize` | Triggered while resizing a panel, `index` is the drag bar index |
| `resize-end` | `input$<id>_resize_end` | Triggered when panel resizing ends, `index` is the drag bar index |
| `collapse` | `input$<id>_collapse` | Triggered when a panel is collapsed, `index` is the drag bar index |

### SplitterPanel Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `size` | `el_splitter_panel(size =)` | Size of the panel (in pixels or percentage) | [^3] / [^4] |  | \- |
| `min` | `el_splitter_panel(min =)` | Minimum size of the panel (in pixels or percentage) | [^5] / [^6] |  | \- |
| `max` | `el_splitter_panel(max =)` | Maximum size of the panel (in pixels or percentage) | [^7] / [^8] |  | \- |
| `resizable` | `el_splitter_panel(resizable =)` | Whether the panel can be resized | [^9] |  | true |
| `collapsible` | `el_splitter_panel(collapsible =)` | Whether the panel can be collapsed | [^10] |  | false |

### SplitterPanel Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | Default content of the panel |
| `start-collapsible` | `slots = list(start-collapsible = )` | Custom content for the start collapsible button |
| `end-collapsible` | `slots = list(end-collapsible = )` | Custom content for the end collapsible button |

[^1]: enum

[^2]: boolean

[^3]: string

[^4]: number

[^5]: string

[^6]: number

[^7]: string

[^8]: number

[^9]: boolean

[^10]: boolean
