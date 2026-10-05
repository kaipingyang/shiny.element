# Update Element Plus Breadcrumb

Server-side update for
[`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md).

## Usage

``` r
update_el_breadcrumb(
  session = shiny::getDefaultReactiveDomain(),
  id,
  items = NULL,
  separator = NULL,
  separator_icon = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Breadcrumb ID (un-namespaced).

- items, separator:

  New values; `NULL` leaves one unchanged.

- separator_icon:

  Icon component of icon separator. Element Plus's `separator-icon`
  (string / Component). An icon's name, such as `"Search"`.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_breadcrumb()`](https://kaipingyang.github.io/shiny.element/reference/el_breadcrumb.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$open_detail, {
    update_el_breadcrumb(
      session,
      "trail",
      items = list(
        list(label = "Home"),
        list(label = "Detail")
      )
    )
  })
}
```
