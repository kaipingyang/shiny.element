# Update Element UI Color Picker

Server-side update for
[`el_color_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker.md).

## Usage

``` r
update_el_color_picker(session, id, value = NULL, disabled = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Color picker ID (un-namespaced).

- value:

  New colour string.

- disabled:

  New disabled state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_color_picker(session, "shade", value = "#67C23A")
  })
}
```
