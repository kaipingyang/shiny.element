# Update Element Plus Radio Group

Server-side update for
[`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md).
Sends a custom message to update reactive fields on the underlying Vue
instance.

## Usage

``` r
update_el_radio_group(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  value = NULL,
  options = NULL,
  label = NULL,
  error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Radio group input ID (un-namespaced).

- selected, value:

  New selected value. `selected` is Shiny's name, `value` Element's;
  give either.

- choices, options:

  New choices, as for
  [`el_radio_group()`](https://kaipingyang.github.io/shiny.element/reference/el_radio_group.md).
  `choices` is Shiny's name, `options` Element's; give either.

- disabled:

  New disabled state.

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
    update_el_radio_group(session, "plan", selected = "pro")
  })
}
```
