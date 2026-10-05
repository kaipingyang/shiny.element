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
  initial_index = NULL,
  z_index = NULL,
  infinite = NULL,
  hide_on_click_modal = NULL,
  teleported = NULL,
  zoom_rate = NULL,
  scale = NULL,
  min_scale = NULL,
  max_scale = NULL,
  close_on_press_escape = NULL,
  show_progress = NULL
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

- z_index:

  Preview backdrop z-index. Element Plus's `z-index` (number / string).

- infinite:

  Whether preview is infinite. Element Plus's `infinite` (boolean).

- hide_on_click_modal:

  Whether user can emit close event when clicking backdrop. Element
  Plus's `hide-on-click-modal` (boolean).

- teleported:

  Whether to append image itself to body. A nested parent element
  attribute transform should have this attribute set to `true`. Element
  Plus's `teleported` (boolean).

- zoom_rate:

  The zoom rate of the image viewer zoom event. Element Plus's
  `zoom-rate` (number).

- scale:

  The preview image scale. Element Plus's `scale` (number).

- min_scale:

  The min scale of the image viewer zoom event. Element Plus's
  `min-scale` (number).

- max_scale:

  The max scale of the image viewer zoom event. Element Plus's
  `max-scale` (number).

- close_on_press_escape:

  Whether the image-viewer can be closed by pressing ESC. Element Plus's
  `close-on-press-escape` (boolean).

- show_progress:

  Whether to display the preview image progress content. Element Plus's
  `show-progress` (boolean).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_image_viewer()`](https://kaipingyang.github.io/shiny.element/reference/el_image_viewer.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

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
