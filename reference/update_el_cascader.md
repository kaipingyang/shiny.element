# Update Element UI Cascader

Update Element UI Cascader

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
  disabled = NULL
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
