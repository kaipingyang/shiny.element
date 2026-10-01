# Update one or more fields of a Vue component instance by id (namespaced)

Update one or more fields of a Vue component instance by id (namespaced)

## Usage

``` r
update_vue_component(session = shiny::getDefaultReactiveDomain(), id, ...)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Vue component id (string)

- ...:

  Named fields and values to update

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
# In a Shiny server function:
# Update the 'value' field of a calendar component
update_vue_component(session, "my_calendar", value = format(Sys.Date(), "%Y-%m-%d"))

# Update multiple fields at once
update_vue_component(session, "my_calendar", value = "2025-12-31", first_day_of_week = 3)
} # }
```
