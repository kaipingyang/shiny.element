# Update Element UI Select

Server-side update for
[`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md).
Sends a custom message to update reactive fields on the underlying Vue
instance.

## Usage

``` r
update_el_select(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL,
  choices = NULL,
  disabled = NULL,
  placeholder = NULL,
  clearable = NULL,
  filterable = NULL,
  multiple_limit = NULL,
  loading = NULL,
  loading_text = NULL,
  no_match_text = NULL,
  no_data_text = NULL,
  value = NULL,
  options = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Select input ID (un-namespaced).

- selected, value:

  New selected value(s). `selected` is Shiny's name, `value` Element's;
  give either.

- choices, options:

  New choices, in any form
  [`el_select()`](https://kaipingyang.github.io/shiny.element/reference/el_select.md)
  takes. `choices` is Shiny's name, `options` Element's; give either.

- disabled, placeholder, clearable, filterable, multiple_limit:

  New values for these props.

- loading, loading_text, no_match_text, no_data_text:

  The remote-search state: show the spinner while options are fetched,
  and the messages for no match and no data.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_select(session, "city", selected = "sh")
  })
}
```
