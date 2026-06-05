# Update Element UI Date Picker

Server-side update for
[`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md).
Supports updating value, disabled state, type, clearable, readonly, and
placeholder text.

## Usage

``` r
update_el_date_picker(
  session,
  id,
  value = NULL,
  disabled = NULL,
  type = NULL,
  clearable = NULL,
  readonly = NULL,
  placeholder = NULL
)
```

## Arguments

- session:

  Shiny session object.

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
