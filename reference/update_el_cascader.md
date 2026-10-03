# Update Element Plus Cascader

Update Element Plus Cascader

## Usage

``` r
update_el_cascader(
  session = shiny::getDefaultReactiveDomain(),
  id,
  options = NULL,
  value = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Cascader ID

- options:

  New cascader options

- value:

  New selected value

- placeholder:

  New placeholder text

- clearable:

  Whether clearable

- filterable:

  Whether filterable

- disabled:

  Whether disabled

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
    update_el_cascader(session, "region", value = list("zj", "hz"))
  })
}
```
