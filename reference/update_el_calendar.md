# Update Element UI Calendar Component

Send a message to update the calendar value, range, first day of week,
or slot.

## Usage

``` r
update_el_calendar(
  session,
  id,
  value = NULL,
  range = NULL,
  first_day_of_week = NULL
)
```

## Arguments

- session:

  Shiny session

- id:

  Component id

- value:

  New value (Date/string/number)

- range:

  New range (c("YYYY-MM-DD", "YYYY-MM-DD"))

- first_day_of_week:

  New first day of week (1~7)

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_calendar(session, "cal", value = "2026-06-01")
  })
}
```
