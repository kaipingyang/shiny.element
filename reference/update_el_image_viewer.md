# Update Element Plus Image Viewer

Open or close an
[`el_image_viewer()`](https://kaipingyang.github.io/shiny.element/reference/el_image_viewer.md),
or give it other images.

## Usage

``` r
update_el_image_viewer(
  session = shiny::getDefaultReactiveDomain(),
  id,
  visible = NULL,
  url_list = NULL,
  initial_index = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Viewer ID (un-namespaced).

- visible, url_list, initial_index:

  New values; `NULL` leaves one unchanged.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$show,
    update_el_image_viewer(session, "photos", visible = TRUE)
  )
}
```
