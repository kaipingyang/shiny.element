# Send queued updates now

Updates and method calls –
[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md),
[`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md),
every `update_el_*()` and
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md)
– are sent as Shiny's own `update*Input()` are: with the flush, once the
observer that made them, and the rest of the flush, is done. An update
made before a long computation in the same observer therefore shows
after it. `flush_vue()` sends them at once: wrapped around the updates,
it runs them and sends what is queued; called alone, it sends what is
queued so far.

## Usage

``` r
flush_vue(expr = NULL, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- expr:

  Code making updates, run before they are sent.

- session:

  Shiny session; the current one by default.

## Value

The value of `expr`, invisibly.

## Details

Often there is a better way: a long computation in an
[shiny::ExtendedTask](https://rdrr.io/pkg/shiny/man/ExtendedTask.html)
leaves the observer at once, and the update goes with that flush. A
component library may send some updates at once by their nature – a
progress bar, as
[`shiny::withProgress()`](https://rdrr.io/pkg/shiny/man/withProgress.html)
does.

Only the components' messages are sent: outputs are still calculated
with the flush, as Shiny does.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$run, {
    flush_vue({
      update_el_table(session, "tbl", loading = TRUE)
    })
    result <- slow_query()
    update_el_table(session, "tbl", data = result, loading = FALSE)
  })
}
```
