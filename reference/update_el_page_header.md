# Update Element UI Page Header

Server-side update for
[`el_page_header()`](https://kaipingyang.github.io/shiny.element/reference/el_page_header.md).

## Usage

``` r
update_el_page_header(session, id, title = NULL, content = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  Header ID (un-namespaced).

- title, content:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$row_click, {
    update_el_page_header(session, "hdr", content = selected_name())
  })
}
```
