# Update Element UI Tabs

Server-side update for
[`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md).

## Usage

``` r
update_el_tabs(session, id, selected = NULL)
```

## Arguments

- session:

  Shiny session object.

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
