# Update Element UI Cascader Panel

Server-side update for
[`el_cascader_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_cascader_panel.md).

## Usage

``` r
update_el_cascader_panel(session, id, value = NULL, options = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Panel ID (un-namespaced).

- value, options:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, update_el_cascader_panel(session, "where", value = list()))
}
```
