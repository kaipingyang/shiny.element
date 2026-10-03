# Update Element Plus Tag

Server-side update for
[`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md).

## Usage

``` r
update_el_tag(
  session = shiny::getDefaultReactiveDomain(),
  id,
  label = NULL,
  type = NULL,
  closable = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Tag ID (un-namespaced).

- label:

  New label text.

- type:

  New colour type.

- closable:

  New closable state.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_tag(session, "status", label = "done", type = "success")
  })
}
```
