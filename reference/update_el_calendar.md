# Update Element Plus Calendar Component

Server-side update for
[`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md):
the selected day, the range, or any other of its arguments.

## Usage

``` r
update_el_calendar(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  range = NULL,
  label = NULL,
  error = NULL,
  ...
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component id

- value:

  New value (Date/string/number)

- range:

  New range (c("YYYY-MM-DD", "YYYY-MM-DD"))

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- ...:

  Any other argument of
  [`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md),
  by its name: `controller_type = "select"`, `formatter = JS(...)`.
  `NULL` returns it to Element's default.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_calendar(session, "cal", value = "2026-06-01")
  })
  update_el_calendar(session, "cal", controller_type = "select")
}
```
