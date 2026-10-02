# Update Element UI Date Picker

Server-side update for
[`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md).
Supports updating value, disabled state, type, clearable, readonly, and
placeholder text.

## Usage

``` r
update_el_date_picker(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  type = NULL,
  clearable = NULL,
  readonly = NULL,
  placeholder = NULL,
  label = NULL,
  error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Date picker ID (un-namespaced).

- value:

  New picker value (string or two-element vector for range types).

- disabled:

  New disabled state.

- type:

  New picker type.

- clearable:

  New clearable state.

- readonly:

  New readonly state.

- placeholder:

  New placeholder text (non-range types).

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
    update_el_date_picker(session, "when", value = "2026-06-01")
  })
}
```
