# Update Element UI Input

Server-side update for
[`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md).
Sends a custom message to update named fields on the Vue instance.

## Usage

``` r
update_el_input(
  session,
  id,
  value = NULL,
  placeholder = NULL,
  disabled = NULL,
  readonly = NULL,
  type = NULL,
  size = NULL,
  clearable = NULL,
  show_password = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Input ID (un-namespaced).

- value:

  New value string.

- placeholder:

  New placeholder text.

- disabled:

  New disabled state.

- readonly:

  New readonly state.

- type:

  New input type.

- size:

  New input size.

- clearable:

  New clearable state.

- show_password:

  New show-password toggle state.
