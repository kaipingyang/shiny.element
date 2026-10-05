# Update an Element Plus Timeline

Update an Element Plus Timeline

## Usage

``` r
update_el_timeline(
  session = shiny::getDefaultReactiveDomain(),
  id,
  items = NULL,
  reverse = NULL,
  mode = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Timeline ID (un-namespaced).

- items:

  Replacement entries, in the same shape
  [`el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline.md)
  takes.

- reverse:

  New ordering.

- mode:

  Relative position of timeline and content. Element Plus's `mode`
  ('start' \| 'alternate' \| 'alternate-reverse' \| 'end').

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/el_timeline.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # Append an entry to a growing log
  observeEvent(input$refresh, {
    log_entries(c(
      log_entries(),
      list(list(content = "Refreshed", timestamp = format(Sys.time(), "%H:%M")))
    ))
    update_el_timeline(session, "log", items = log_entries())
  })
}
```
