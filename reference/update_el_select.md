# Update Element UI Select

Server-side update for
[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md).
Sends a custom message to update reactive fields on the underlying Vue
instance.

## Usage

``` r
update_el_select(
  session,
  id,
  value = NULL,
  options = NULL,
  disabled = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Select input ID (un-namespaced).

- value:

  New selected value (string or character vector).

- options:

  New choices: named character vector or
  `list(list(value=, label=), ...)`.

- disabled:

  New disabled state.

- placeholder:

  New placeholder text.

- clearable:

  New clearable state.

- filterable:

  New filterable state.
