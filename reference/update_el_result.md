# Update Element Plus Result

Server-side update for
[`el_result()`](https://kaipingyang.github.io/shiny.element/reference/el_result.md).

## Usage

``` r
update_el_result(
  session = shiny::getDefaultReactiveDomain(),
  id,
  icon = NULL,
  title = NULL,
  sub_title = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- icon, title, sub_title:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$submit, {
    ok <- tryCatch({ save(); TRUE }, error = function(e) FALSE)
    update_el_result(session, "outcome",
                     icon = if (ok) "success" else "error",
                     title = if (ok) "Saved" else "Could not save")
  })
}
```
