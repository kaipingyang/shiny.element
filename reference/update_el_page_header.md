# Update Element Plus Page Header

Server-side update for
[`el_page_header()`](https://kaipingyang.github.io/shiny.element/reference/el_page_header.md).

## Usage

``` r
update_el_page_header(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  content = NULL,
  icon = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Header ID (un-namespaced).

- title, content:

  New values; `NULL` leaves one unchanged.

- icon:

  Icon component of page header. Element Plus's `icon` (string /
  Component). An icon's name, such as `"Search"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_page_header()`](https://kaipingyang.github.io/shiny.element/reference/el_page_header.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$row_click, {
    update_el_page_header(session, "hdr", content = selected_name())
  })
}
```
