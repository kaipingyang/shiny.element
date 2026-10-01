# Update Element UI Dialog

Server-side update for
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md).

## Usage

``` r
update_el_dialog(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visible = NULL,
  title = NULL,
  width = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Dialog ID (un-namespaced).

- visible:

  Open or close it.

- title:

  New header text.

- width:

  New width.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_dialog(session, "confirm", visible = TRUE)
  })
}
```
