# Update Element UI Tag

Server-side update for
[`el_tag()`](https://kaipingyang.github.io/shiny.element/reference/el_tag.md).

## Usage

``` r
update_el_tag(session, id, label = NULL, type = NULL, closable = NULL)
```

## Arguments

- session:

  Shiny session object.

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
