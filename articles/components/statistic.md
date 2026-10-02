# Statistic

Highlight a number or a group of them – an amount, a ranking – or count
down to a time.

## Basic usage

``` r

el_row(
  el_col(span = 6, el_statistic("s1", value = 268500, title = "Growth of users", group_separator = ",")),
  el_col(span = 6, el_statistic("s2", value = 138, title = "Male to female ratio",
         slots = list(suffix = tags$span("/100")))),
  el_col(span = 6, el_statistic("s3", value = 1318.25, title = "Revenue", prefix = "$",
         precision = 2, group_separator = ",")))
```

## Count down

`time_indices = TRUE` counts down to `value`, a time;
`input$<id>_finish` fires when it gets there.

``` r

el_statistic("sale", title = "Remaining time of the sale", time_indices = TRUE,
             value = Sys.time() + 3600 * 5, format = "HH:mm:ss")
el_statistic("days", title = "Days until the year ends", time_indices = TRUE,
             value = as.POSIXct(paste0(format(Sys.Date(), "%Y"), "-12-31 23:59:59")),
             format = "DD [days] HH:mm:ss")
```

## API

### Statistic Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | Numerical content | string \\ | number | \- |
| `decimal-separator` | `decimal_separator` | Setting the decimal point | string | \- | . |
| `formatter` | `formatter` | Custom numerical presentation | v-slot \\ | ({value}) =\> VNode | \- |
| `group-separator` | `group_separator` | Sets the thousandth identifier | string | \- | , |
| `precision` | `precision` | numerical precision | number | \- | \- |
| `prefix` | `prefix` | Sets the prefix of a number | string \\ | v-slot | \- |
| `suffix` | `suffix` | Sets the suffix of a number | string \\ | v-slot | \- |
| `title` | `title` | Numeric titles | string \\ | v-slot | \- |
| `value-style` | `value_style` | Styles numeric values | style | \- | \- |
| `rate` | `rate` | Set the ratio | number | \- | 1000 |

### Statistic Slots

| Element     | In R                         | Description                 |
|-------------|------------------------------|-----------------------------|
| `prefix`    | `slots = list(prefix = )`    | Numeric prefix              |
| `suffix`    | `slots = list(suffix = )`    | Suffixes for numeric values |
| `formatter` | `slots = list(formatter = )` | Numerical content           |
| `title`     | `slots = list(title = )`     | Numeric titles              |

### Statistic.Countdown Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `time-indices` | `time_indices` | Whether to enable the countdown function | boolean | true\\ | false |
| `value` | `value` | Required value, enter the bound value | string | — | — |
| `format` | `format` | Formatting the countdown display | string | — | ‘HH:mm:ss’ |

### Statistic.Countdown Events

| Element  | In R                | Description                                |
|----------|---------------------|--------------------------------------------|
| `change` | `input$<id>_change` | Enable in the ‘countdown’ function         |
| `finish` | `input$<id>_finish` | Launched after the ‘countdown’ is complete |

### Statistic Methods

| Element   | In R                              | Description         |
|-----------|-----------------------------------|---------------------|
| `suspend` | `el_call(session, id, "suspend")` | Pause the countdown |
