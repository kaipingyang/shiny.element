# Update Element UI Time Picker

Server-side update for
[`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md)
and
[`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md).

## Usage

``` r
update_el_time_picker(
  session,
  id,
  value = NULL,
  disabled = NULL,
  picker_options = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Picker ID (un-namespaced).

- value, disabled, picker_options:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_time_picker(session, "start", value = "09:00:00"))
}
```
