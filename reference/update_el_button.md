# Update Element UI Button

Server-side update for
[`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md).
Supports all visual states including `size`, `plain`, `round`, and
`loading`.

## Usage

``` r
update_el_button(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  type = NULL,
  size = NULL,
  plain = NULL,
  round = NULL,
  loading = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Button ID (un-namespaced).

- label:

  New label text.

- type:

  New button type.

- size:

  New button size.

- plain:

  New plain state.

- round:

  New round state.

- loading:

  New loading state.

- disabled:

  New disabled state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_button(session, "save", loading = TRUE)
  })
}
```
