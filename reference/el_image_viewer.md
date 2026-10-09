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
  slots = NULL,
  events = NULL,
  on = NULL
)

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

- id:

  Component ID. Auto-generated if `NULL`.

- url_list:

  Preview link list. Element Plus's `url-list` (`string[]`).

- visible:

  Whether it starts open. Open and close it later with
  `update_el_image_viewer()`.

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

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|                     |                     |                                |
|---------------------|---------------------|--------------------------------|
| Input               | Reported            | Value                          |
| `input$<id>_close`  | unasked             | fires as it closes             |
| `input$<id>_error`  | unasked             | same as native error.          |
| `input$<id>_switch` | `events = "switch"` | trigger when switching images. |
| `input$<id>_rotate` | `events = "rotate"` | trigger when rotating images.  |

The same list as `el_events("el_image_viewer")`, which says how an
event's arguments travel.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`setActiveItem()`.

## Updating from the server

Open or close an `el_image_viewer()`, or give it other images.

Every other argument of `el_image_viewer()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_image_viewer()` is called for its side effect and returns
`NULL` invisibly.

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
