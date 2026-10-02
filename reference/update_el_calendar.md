# Update Element UI Calendar Component

Send a message to update the calendar value, range, first day of week,
or slot.

## Usage

``` r
update_el_calendar(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  range = NULL,
  first_day_of_week = NULL,
  label = NULL,
  error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component id

- value:

  New value (Date/string/number)

- range:

  New range (c("YYYY-MM-DD", "YYYY-MM-DD"))

- first_day_of_week:

  New first day of week (1~7)

- label:

  New label text, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).
  Only a component built with a `label` has one to change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

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
