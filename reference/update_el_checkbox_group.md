# Update Element UI Checkbox Group

Server-side update for
[`el_checkbox_group()`](https://kaipingyang.github.io/shiny.element/reference/el_checkbox_group.md).
Pass only the fields to change; `NULL` fields are excluded from the
update message.

## Usage

``` r
update_el_checkbox_group(
  session,
  id,
  value = NULL,
  options = NULL,
  disabled = NULL,
  min = NULL,
  max = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Checkbox group ID (un-namespaced).

- value:

  New character vector of selected values.

- options:

  New choices list (same format as the `choices` argument).

- disabled:

  New disabled state.

- min:

  New minimum checked count.

- max:

  New maximum checked count.
