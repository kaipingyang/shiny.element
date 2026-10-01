# Update Element UI Switch

Server-side update for
[`el_switch()`](https://kaipingyang.github.io/shiny.element/reference/el_switch.md).
Pass only the fields to change; `NULL` fields are excluded from the
update message.

## Usage

``` r
update_el_switch(
  session = shiny::getDefaultReactiveDomain(),
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

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

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

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_switch(session, "live", value = TRUE)
  })
}
```
