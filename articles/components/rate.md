# Rate

Used for rating; `input$<id>` is the score.

## Basic usage

`colors` colours the levels – three, or a list keyed by the thresholds.

``` r

el_rate("r1", value = 3)
el_rate("r2", value = 4, colors = c("#99A9BF", "#F7BA2A", "#FF9900"))
```

## With text

``` r

el_rate("rt", value = 3, show_text = TRUE,
        texts = c("oops", "disappointed", "normal", "good", "great"))
```

## More icons

``` r

el_rate("ri", value = 3, icon_classes = c("el-icon-sunny", "el-icon-cloudy", "el-icon-heavy-rain"),
        void_icon_class = "el-icon-moon-night", colors = c("#99A9BF", "#F7BA2A", "#FF9900"))
```

## Read-only

``` r

el_rate("ro", value = 3.7, disabled = TRUE, show_score = TRUE, text_color = "#ff9900",
        score_template = "{value} points")
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | number | — | 0 |
| `max` | `max` | max rating score | number | — | 5 |
| `disabled` | `disabled` | whether Rate is read-only | boolean | — | false |
| `allow-half` | `allow_half` | whether picking half start is allowed | boolean | — | false |
| `low-threshold` | `low_threshold` | threshold value between low and medium level. The value itself will be included in low level | number | — | 2 |
| `high-threshold` | `high_threshold` | threshold value between medium and high level. The value itself will be included in high level | number | — | 4 |
| `colors` | `colors` | colors for icons. If array, it should have 3 elements, each of which corresponds with a score level, else if object, the key should be threshold value between two levels, and the value should be corresponding color | array/object | — | \[‘#F7BA2A’, ‘#F7BA2A’, ‘#F7BA2A’\] |
| `void-color` | `void_color` | color of unselected icons | string | — | \#C6D1DE |
| `disabled-void-color` | `disabled_void_color` | color of unselected read-only icons | string | — | \#EFF2F7 |
| `icon-classes` | `icon_classes` | class names of icons. If array, ot should have 3 elements, each of which corresponds with a score level, else if object, the key should be threshold value between two levels, and the value should be corresponding icon class | array/object | — | \[‘el-icon-star-on’, ‘el-icon-star-on’,‘el-icon-star-on’\] |
| `void-icon-class` | `void_icon_class` | class name of unselected icons | string | — | el-icon-star-off |
| `disabled-void-icon-class` | `disabled_void_icon_class` | class name of unselected read-only icons | string | — | el-icon-star-on |
| `show-text` | `show_text` | whether to display texts | boolean | — | false |
| `show-score` | `show_score` | whether to display current score. show-score and show-text cannot be true at the same time | boolean | — | false |
| `text-color` | `text_color` | color of texts | string | — | \#1F2D3D |
| `texts` | `texts` | text array | array | — | \[‘极差’, ‘失望’, ‘一般’, ‘满意’, ‘惊喜’\] |
| `score-template` | `score_template` | score template | string | — | {value} |

### Events

| Element  | In R                    | Description                         |
|----------|-------------------------|-------------------------------------|
| `change` | `input$<id>`, the value | Triggers when rate value is changed |
