# Update Element UI Input

Server-side update for
[`el_input()`](https://kaipingyang.github.io/shiny.element/reference/el_input.md).
Sends a custom message to update named fields on the Vue instance.

## Usage

``` r
update_el_input(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  placeholder = NULL,
  disabled = NULL,
  readonly = NULL,
  type = NULL,
  size = NULL,
  clearable = NULL,
  show_password = NULL,
  label = NULL,
  error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

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
    update_el_input(session, "name", value = "Ada")
  })
}
```
