# Update Element Plus Tabs

Server-side update for
[`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md).

## Usage

``` r
update_el_tabs(
  session = shiny::getDefaultReactiveDomain(),
  id,
  selected = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tabs ID (un-namespaced).

- selected:

  Name of the tab to select.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tabs(session, "section", selected = "data")
  })
}
```
