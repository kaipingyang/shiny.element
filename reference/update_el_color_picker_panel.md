# Update Element Plus Color Picker Panel

Server-side update for
[`el_color_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_color_picker_panel.md).

## Usage

``` r
update_el_color_picker_panel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- value, disabled:

  New values; `NULL` leaves one unchanged.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component; `""` clears it.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_color_picker_panel(session, "x", value = NULL))
}
```
