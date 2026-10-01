# Update the entire data object of a Vue component instance by id (namespaced)

Update the entire data object of a Vue component instance by id
(namespaced)

## Usage

``` r
update_vue_data(session = shiny::getDefaultReactiveDomain(), id, data)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Vue component id (string)

- data:

  Named list representing the full Vue data object

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
# In a Shiny server function:
# Replace the data object of a calendar component
update_vue_data(session, "my_calendar", list(
  value = "2025-12-31",
  first_day_of_week = 3
))
} # }
```
