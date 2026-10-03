# Badge

A number or status mark on buttons and icons.

## Basic Usage

Displays the amount of new messages.

The amount is defined with value which accepts Number or String.

``` r

item <- function(...) tags$span(style = "margin-right: 40px", ...)
tagList(
  item(el_badge(value = 12, el_button("bd1", "comments"))),
  item(el_badge(value = 3, el_button("bd2", "replies"))),
  item(el_badge(value = 1, type = "primary", el_button("bd3", "comments"))),
  item(el_badge(value = 2, type = "warning", el_button("bd4", "replies"))),
  item(el_badge(value = 1, color = "green", el_button("bd5", "custom background"))))
```

¹²

³

¹

²

¹

## Max Value

You can customize the max value.

The max value is defined by property max which is a Number. Note that it
only works when value is also a Number.

``` r

tagList(
  tags$span(style = "margin-right: 40px", el_badge(value = 200, max = 99, el_button("bm1", "comments"))),
  el_badge(value = 100, max = 10, el_button("bm2", "replies")))
```

⁹⁹⁺

¹⁰⁺

## Customizations

Displays text content other than numbers. Or you can use the `content`
slot to customize content.

When value is a String, it can display customized text. Or use the
`content` slot.

``` r

tagList(
  tags$span(style = "margin-right: 40px", el_badge(value = "new", el_button("bc1", "comments"))),
  el_badge(value = "hot", el_button("bc2", "replies")))
```

^(new)

^(hot)

## Red Dot

Use a red dot to mark content that needs to be noticed.

Use the attribute `is-dot`. It is a Boolean.

``` r

tagList(
  tags$span(style = "margin-right: 40px", el_badge(is_dot = TRUE, "query")),
  el_badge(is_dot = TRUE, el_button("bdot", NULL, icon = "Share", type = "primary")))
```

query

## Offset

Set offset of the badge dot, the format is \[left, top\], which
represents the offset of the status dot from the left and top of the
default position.

``` r

el_badge(value = 1, offset = c(10, 5), el_button("boff", "offset"))
```

¹

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | display value. | [^1] / [^2] |  | ’’ |
| `max` | `max` | maximum value, shows `{max}+` when exceeded. Only works if value is a number. | [^3] |  | 99 |
| `is-dot` | `is_dot` | if a little dot is displayed. | [^4] |  | false |
| `hidden` | `hidden` | hidden badge. | [^5] |  | false |
| `type` | `type` | badge type. | [^6]`'primary' \\| 'success' \\| 'warning' \\| 'danger' \\| 'info'` |  | danger |
| `show-zero` | `show_zero` | Whether to show badge when value is zero. | [^7] |  | true |
| `color` | `color` | background color of the dot | [^8] |  |  |
| `offset` | `offset` | offset of badge | [^9]`[number, number]` |  | \[0, 0\] |
| `badge-style` | `badge_style` | custom style of badge | [^10]`CSSProperties` |  | — |
| `badge-class` | `badge_class` | custom class of badge | [^11] |  | — |

### Slots

| Element   | In R                       | Description               |
|-----------|----------------------------|---------------------------|
| `default` | default content            | customize default content |
| `content` | `slots = list(content = )` | customize badge content   |

[^1]: string

[^2]: number

[^3]: number

[^4]: boolean

[^5]: boolean

[^6]: enum

[^7]: boolean

[^8]: string

[^9]: array

[^10]: object

[^11]: string
