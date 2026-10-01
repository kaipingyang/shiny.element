# Update Element UI Alert

Server-side update for
[`el_alert()`](https://kaipingyang.github.io/shiny.element/reference/el_alert.md).

## Usage

``` r
update_el_alert(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  type = NULL,
  description = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Alert ID (un-namespaced).

- title:

  New title text.

- type:

  New alert type.

- description:

  New description text. Use `NULL` to leave unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_alert(session, "hint", title = "Saved", type = "success")
  })
}
```
