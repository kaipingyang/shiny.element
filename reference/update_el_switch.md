# Update Element Plus Switch

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
  inactive_color = NULL,
  label = NULL,
  error = NULL
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

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

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
    update_el_switch(session, "live", value = TRUE)
  })
}
```
