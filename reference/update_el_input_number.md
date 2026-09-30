# Update Element UI Input Number

Server-side update for
[`el_input_number()`](https://kaipingyang.github.io/shiny.element/reference/el_input_number.md).

## Usage

``` r
update_el_input_number(
  session,
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Input ID (un-namespaced).

- value:

  New numeric value.

- min:

  New minimum.

- max:

  New maximum.

- disabled:

  New disabled state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_input_number(session, "age", value = 42)
  })
}
```
