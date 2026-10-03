# Backtop

A button to back to top.

## Basic Usage

Scroll down to see the bottom-right button.

``` r

tagList("Scroll down to see the bottom-right button.",
        el_backtop(right = 100, bottom = 100))
```

Scroll down to see the bottom-right button.

## Customizations

Display area is 40px \* 40px.

``` r

tagList("Scroll down to see the bottom-right button.",
  el_backtop(bottom = 100, content = tags$div(style = paste(
    "height: 100%; width: 100%; background-color: var(--el-bg-color-overlay);",
    "box-shadow: var(--el-box-shadow-lighter); text-align: center; line-height: 40px;",
    "color: #1989fa"), "UP")))
```

Scroll down to see the bottom-right button.

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `target` | `target` | the target to trigger scroll. | [^1] |  | — |
| `visibility-height` | `visibility_height` | the button will not show until the scroll height reaches this value. | [^2] |  | 200 |
| `right` | `right` | right distance. | [^3] |  | 40 |
| `bottom` | `bottom` | bottom distance. | [^4] |  | 40 |

### Events

| Element | In R               | Description          |
|---------|--------------------|----------------------|
| `click` | `input$<id>_click` | triggers when click. |

### Slots

| Element   | In R            | Description                |
|-----------|-----------------|----------------------------|
| `default` | default content | customize default content. |

[^1]: string

[^2]: number

[^3]: number

[^4]: number
