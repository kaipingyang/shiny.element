# Update Element Plus Image

Server-side update for
[`el_image()`](https://kaipingyang.github.io/shiny.element/reference/el_image.md).

## Usage

``` r
update_el_image(
  session = shiny::getDefaultReactiveDomain(),
  id,
  src = NULL,
  fit = NULL,
  preview_src_list = NULL,
  alt = NULL,
  lazy = NULL,
  scroll_container = NULL,
  z_index = NULL,
  initial_index = NULL,
  close_on_press_escape = NULL,
  crossorigin = NULL,
  hide_on_click_modal = NULL,
  infinite = NULL,
  loading = NULL,
  max_scale = NULL,
  min_scale = NULL,
  preview_teleported = NULL,
  referrerpolicy = NULL,
  scale = NULL,
  show_progress = NULL,
  zoom_rate = NULL
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

- alt:

  Alternative text.

- lazy:

  Whether to load the image only once it scrolls into view.

- scroll_container:

  CSS selector of the scrolling element to watch when `lazy = TRUE`.
  `NULL` watches the nearest scrollable parent.

- z_index:

  Stacking order of the preview. Default `2000`.

- initial_index:

  Which image of `preview_src_list` the preview opens on, 0-based.

- close_on_press_escape:

  Whether the image-viewer can be closed by pressing ESC. Element Plus's
  `close-on-press-escape` (boolean).

- crossorigin:

  Native attribute crossorigin. Element Plus's `crossorigin` (” \|
  'anonymous' \| 'use-credentials').

- hide_on_click_modal:

  When enabling preview, use this flag to control whether clicking on
  backdrop can exit preview mode. Element Plus's `hide-on-click-modal`
  (boolean).

- infinite:

  Whether the viewer preview is infinite. Element Plus's `infinite`
  (boolean).

- loading:

  Indicates how the browser should load the image, same as native.
  Element Plus's `loading` ('eager' \| 'lazy').

- max_scale:

  The max scale of the image viewer zoom event. Element Plus's
  `max-scale` (number).

- min_scale:

  The min scale of the image viewer zoom event. Element Plus's
  `min-scale` (number).

- preview_teleported:

  Whether to append image-viewer to body. A nested parent element
  attribute transform should have this attribute set to `true`. Element
  Plus's `preview-teleported` (boolean).

- referrerpolicy:

  Native attribute referrerPolicy. Element Plus's `referrerpolicy`
  (string).

- scale:

  The preview image scale. Element Plus's `scale` (number).

- show_progress:

  Whether to display the preview image progress content. Element Plus's
  `show-progress` (boolean).

- zoom_rate:

  The zoom rate of the image viewer zoom event. Element Plus's
  `zoom-rate` (number).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_image()`](https://kaipingyang.github.io/shiny.element/reference/el_image.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$next_photo, {
    update_el_image(session, "photo", src = photo_url())
  })
}
```
