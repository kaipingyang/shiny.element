# Calendar

Display dates. `input$<id>` is the date picked.

## Basic

``` r

el_calendar("cal", value = "2026-03-15")
```

## Custom content

The `dateCell` slot, scoped with `date` and `data`, draws each day.

``` r

el_calendar("cus", value = "2026-03-15", slots = list(dateCell = template(
  htmltools::HTML(paste0(
    "<p :class=\"data.isSelected ? 'is-selected' : ''\">",
    "{{ data.day.split('-').slice(1).join('-') }} {{ data.isSelected ? '✔️' : '' }}</p>")),
  slot = "dateCell", scope = "{date, data}")))
```

## Range

`range`, two dates, shows the weeks between them.

``` r

el_calendar("rng", range = c("2026-03-04", "2026-03-24"))
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | binding value | Date/string/number | — | — |
| `range` | `range` | time range, including start time and end time. Start time must be start day of week, end time must be end day of week, the time span cannot exceed two months. | Array | — | — |
| `first-day-of-week` | `first_day_of_week` | first day of week | Number | 1 to 7 | 1 |

### dateCell Scoped Slot Parameters

| Element | In R | Description |
|----|----|----|
| `date` | `slots = list(date = )` | date the cell represents |
| `data` | `slots = list(data = )` | { type, isSelected, day}. The `type` property indicates which month the date belongs, optional values are `prev-month`, `current-month`, `next-month`. The `isSelected` property indicates whether the date is selected. The `day` property is the formatted date in the format yyyy-MM-dd |
