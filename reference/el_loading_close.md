# Close a loading mask

Closes the mask
[`el_loading()`](https://kaipingyang.github.io/shiny.element/reference/el_loading.md)
opened under this `id`. Closing one that is not open does nothing.

## Usage

``` r
el_loading_close(session, id = "default")
```

## Arguments

- session:

  Shiny session object.

- id:

  The `id` the mask was opened with.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$done, {
    el_loading_close(session, "fetching")
  })
}
```
