# Rate

Used for rating

## Basic usage

Rate divides rating scores into several levels and these levels can be
distinguished by using different background colors. By default
background colors are the same, but you can assign them an array with
three element to reflect three levels using the `colors` attribute, and
their two thresholds can be defined by `low-threshold` and
`high-threshold`, or you can assign them with a object which key is the
threshold between two levels and value is the corresponding color.

``` r

tags$div(
  style = "display: flex; gap: 40px",
  tags$div(tags$div("Default"), el_rate("rate1")),
  tags$div(
    tags$div("Color for different levels"),
    el_rate("rate2", colors = c("#99A9BF", "#F7BA2A", "#FF9900"))
  )
)
```

Default

Color for different levels

## Sizes

``` r

tags$div(
  style = "display: grid; gap: 8px",
  el_rate("rate_l", size = "large"),
  el_rate("rate_d"),
  el_rate("rate_s", size = "small")
)
```

## With allow-half

Add attribute `allow-half` Half star allowed

``` r

el_rate("rate_half", allow_half = TRUE)
```

## With text

Using text to indicate rating score

Add attribute `show-text` to display text at the right of Rate. You can
assign texts for different scores using `texts`. `texts` is an array
whose length should be equal to the max score `max`.

``` r

el_rate(
  "rate_text",
  show_text = TRUE,
  texts = c("oops", "disappointed", "normal", "good", "great")
)
```

## Clearable

You can reset the value to `0` when you click at the same value again.

``` r

el_rate("rate_clear", value = 3, clearable = TRUE)
```

## More icons

You can use different icons to distinguish different rate components.

You can customize icons by passing `icons` an array with three elements
or a object which key is the threshold between two levels and value is
the corresponding icon. In this example, we also use `void-icon` to set
the icon if it is unselected.

``` r

el_rate(
  "rate_icons",
  icons = c("ChatRound", "ChatLineRound", "ChatDotRound"),
  void_icon = "ChatRound",
  colors = c("#409eff", "#67c23a", "#FF9900")
)
```

## Read-only

Read-only Rate is for displaying rating score. Half star is supported.

Use attribute `disabled` to make the component read-only. Add
`show-score` to display the rating score at the right side.
Additionally, you can use attribute `score-template` to provide a score
template. It must contain `{value}`, and `{value}` will be replaced with
the rating score.

``` r

el_rate(
  "rate_ro",
  value = 3.7,
  disabled = TRUE,
  show_score = TRUE,
  text_color = "#ff9900",
  score_template = "{value} points"
)
```

## Custom styles

Now you can set custom style for rate component. Use `css/scss` language
to change the global or local color. We set some global color variables:
`--el-rate-void-color`, `--el-rate-fill-color`,
`--el-rate-disabled-void-color`, `--el-rate-text-color`. You can use
like:
`:root { --el-rate-void-color: red; --el-rate-fill-color: blue; }`.

### Default Variables

| Variable                     | Default Color                |
|------------------------------|------------------------------|
| –el-rate-void-color          | var(–el-border-color-darker) |
| –el-rate-fill-color          | \#f7ba2a                     |
| –el-rate-disabled-void-color | var(–el-fill-color)          |
| –el-rate-text-color          | var(–el-text-color-primary)  |

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `value`; `input$<id>` | binding value | [^1] |  | 0 |
| `max` | `max` | max rating score | [^2] |  | 5 |
| `size` | `size` | size of Rate | [^3]`'large' \\| 'default' \\| 'small'` |  | — |
| `disabled` | `disabled` | whether Rate is read-only | [^4] |  | false |
| `allow-half` | `allow_half` | whether picking half start is allowed | [^5] |  | false |
| `low-threshold` | `low_threshold` | threshold value between low and medium level. The value itself will be included in low level | [^6] |  | 2 |
| `high-threshold` | `high_threshold` | threshold value between medium and high level. The value itself will be included in high level | [^7] |  | 4 |
| `colors` | `colors` | colors for icons. If array, it should have 3 elements, each of which corresponds with a score level, else if object, the key should be threshold value between two levels, and the value should be corresponding color | [^8]`string[]` / [^9]`Record<number, string>` |  | \[‘#f7ba2a’, ‘#f7ba2a’, ‘#f7ba2a’\] |
| `void-color` | `void_color` | color of unselected icons | [^10] |  | \#c6d1de |
| `disabled-void-color` | `disabled_void_color` | color of unselected read-only icons | [^11] |  | \#eff2f7 |
| `icons` | `icons` | icon components. If array, it should have 3 elements, each of which corresponds with a score level, else if object, the key should be threshold value between two levels, and the value should be corresponding icon component | [^12]`string[] \\| Component[]` / [^13]`Record<number, string \\| Component>` |  | \[StarFilled, StarFilled, StarFilled\] |
| `void-icon` | `void_icon` | component of unselected icons | [^14] / [^15] |  | Star |
| `disabled-void-icon` | `disabled_void_icon` | component of unselected read-only icons | [^16] / [^17] |  | StarFilled |
| `show-text` | `show_text` | whether to display texts | [^18] |  | false |
| `show-score` | `show_score` | whether to display current score. show-score and show-text cannot be true at the same time | [^19] |  | false |
| `text-color` | `text_color` | color of texts | [^20] |  | ’’ |
| `texts` | `texts` | text array | [^21]`string[]` |  | \[‘Extremely bad’, ‘Disappointed’, ‘Fair’, ‘Satisfied’, ‘Surprise’\] |
| `score-template` | `score_template` | score template | [^22] |  | {value} |
| `clearable` | `clearable` | whether value can be reset to `0` | [^23] |  | false |
| `id` | `id`, the Shiny input’s | native `id` attribute | [^24] |  | — |
| `aria-label` | `aria_label` | same as `aria-label` in Rate | [^25] |  | — |
| `label` | `label` | same as `aria-label` in Rate | [^26] |  | — |

### Events

| Element  | In R                    | Description                         |
|----------|-------------------------|-------------------------------------|
| `change` | `input$<id>`, the value | Triggers when rate value is changed |

### Exposes

| Element | In R | Description |
|----|----|----|
| `setCurrentValue` | `el_call(session, id, "setCurrentValue")` | set current value |
| `resetCurrentValue` | `el_call(session, id, "resetCurrentValue")` | reset current value |

[^1]: number

[^2]: number

[^3]: enum

[^4]: boolean

[^5]: boolean

[^6]: number

[^7]: number

[^8]: array

[^9]: object

[^10]: string

[^11]: string

[^12]: array

[^13]: object

[^14]: string

[^15]: Component

[^16]: string

[^17]: Component

[^18]: boolean

[^19]: boolean

[^20]: string

[^21]: array

[^22]: string

[^23]: boolean

[^24]: string

[^25]: string

[^26]: string
