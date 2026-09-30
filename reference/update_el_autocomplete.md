# Update Element UI Autocomplete

Server-side update for
[`el_autocomplete()`](https://kaipingyang.github.io/shiny.element/reference/el_autocomplete.md).

## Usage

``` r
update_el_autocomplete(
  session,
  id,
  value = NULL,
  suggestions = NULL,
  placeholder = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Input ID (un-namespaced).

- value, suggestions, placeholder, disabled:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$country, {
    update_el_autocomplete(session, "city", suggestions = cities_of(input$country))
  })
}
```
