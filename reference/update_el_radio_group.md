# Update Element UI Radio Group

Server-side update for
[`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md).
Sends a custom message to update reactive fields on the underlying Vue
instance.

## Usage

``` r
update_el_radio_group(
  session,
  id,
  value = NULL,
  options = NULL,
  disabled = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Radio group input ID (un-namespaced).

- value:

  New selected value.

- options:

  New choices: named character vector or
  `list(list(value=, label=), ...)`.

- disabled:

  New disabled state.
