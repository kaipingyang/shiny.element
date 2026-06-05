# Update one or more fields of a Vue component instance by id (namespaced)

Update one or more fields of a Vue component instance by id (namespaced)

## Usage

``` r
update_vue_component(session, id, ...)
```

## Arguments

- session:

  Shiny session object

- id:

  Vue component id (string)

- ...:

  Named fields and values to update

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
