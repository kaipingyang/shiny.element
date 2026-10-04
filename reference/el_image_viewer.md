# Element Plus Image Viewer

A full-screen viewer for a list of images, with zoom and rotation.

## Usage

``` r
el_image_viewer(
  id = NULL,
  url_list = NULL,
  visible = FALSE,
  z_index = NULL,
  initial_index = NULL,
  infinite = NULL,
  hide_on_click_modal = NULL,
  teleported = NULL,
  zoom_rate = NULL,
  scale = NULL,
  min_scale = NULL,
  max_scale = NULL,
  close_on_press_escape = NULL,
  show_progress = NULL,
  width = NULL,
  slots = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- url_list:

  Preview link list. Element Plus's `url-list` (`string[]`).

- visible:

  Whether it starts open. Open and close it later with
  [`update_el_image_viewer()`](https://kaipingyang.github.io/shiny.element/reference/update_el_image_viewer.md).

- z_index:

  Preview backdrop z-index. Element Plus's `z-index` (number / string).

- initial_index:

  The initial preview image index, less than or equal to the length of
  `url-list`. Element Plus's `initial-index` (number).

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

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `progress`, `toolbar`,
  `viewer-error`. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_close` – as it closes.

- `input$<id>_error` – Element Plus's `error` event.

- `input$<id>_switch` – Element Plus's `switch` event.

- `input$<id>_rotate` – Element Plus's `rotate` event.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`setActiveItem()`.
