# Update Element Plus Descriptions

Server-side update for
[`el_descriptions()`](https://kaipingyang.github.io/shiny.element/reference/el_descriptions.md).
The items themselves are markup, so replace them by re-rendering; this
changes the settings around them.

## Usage

``` r
update_el_descriptions(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  extra = NULL,
  column = NULL,
  direction = NULL,
  border = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- title, extra, column, direction, border:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$narrow, {
    update_el_descriptions(session, "user", column = 1)
  })
}
```
