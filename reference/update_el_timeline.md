# Update an Element UI Timeline

Update an Element UI Timeline

## Usage

``` r
update_el_timeline(session, id, items = NULL, reverse = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Timeline ID (un-namespaced).

- items:

  Replacement entries, in the same shape
  [`el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline.md)
  takes.

- reverse:

  New ordering.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # Append an entry to a growing log
  observeEvent(input$refresh, {
    log_entries(c(log_entries(), list(list(content = "Refreshed",
                                           timestamp = format(Sys.time(), "%H:%M")))))
    update_el_timeline(session, "log", items = log_entries())
  })
}
```
