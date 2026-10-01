# Update Element UI Image

Server-side update for
[`el_image()`](https://kaipingyang.github.io/shiny.element/reference/el_image.md).

## Usage

``` r
update_el_image(
  session = shiny::getDefaultReactiveDomain(),
  id,
  src = NULL,
  fit = NULL,
  preview_src_list = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Image ID (un-namespaced).

- src, fit, preview_src_list:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$next_photo, {
    update_el_image(session, "photo", src = photo_url())
  })
}
```
