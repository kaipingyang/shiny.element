# Update Element UI Button

Server-side update for
[`el_button()`](https://kaipingyang.github.io/shiny.element/reference/el_button.md).
Supports all visual states including `size`, `plain`, `round`, and
`loading`.

## Usage

``` r
update_el_button(
  session,
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

  Shiny session object.

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
