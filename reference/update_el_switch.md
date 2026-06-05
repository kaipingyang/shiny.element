# Update Element UI Switch

Server-side update for
[`el_switch()`](https://kaipingyang.github.io/shiny.element/reference/el_switch.md).
Pass only the fields to change; `NULL` fields are excluded from the
update message.

## Usage

``` r
update_el_switch(
  session,
  id,
  value = NULL,
  disabled = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Switch ID (un-namespaced).

- value:

  New switch value.

- disabled:

  New disabled state.

- active_text:

  New active text.

- inactive_text:

  New inactive text.

- active_color:

  New active background color.

- inactive_color:

  New inactive background color.
