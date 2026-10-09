# Element Plus Image

An image with a fit mode, optional lazy loading, and an optional
full-screen preview.

## Usage

``` r
el_image(
  id = NULL,
  src = NULL,
  fit = NULL,
  alt = NULL,
  lazy = NULL,
  scroll_container = NULL,
  preview_src_list = NULL,
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
  zoom_rate = NULL,
  width = NULL,
  class = NULL,
  style = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

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

- id:

  Image ID. Auto-generated if `NULL`.

- src:

  Image URL.

- fit:

  How the image fills its box: `"fill"`, `"contain"`, `"cover"`,
  `"none"` or `"scale-down"`.

- alt:

  Alternative text.

- lazy:

  Whether to load the image only once it scrolls into view.

- scroll_container:

  CSS selector of the scrolling element to watch when `lazy = TRUE`.
  `NULL` watches the nearest scrollable parent.

- preview_src_list:

  Character vector of image URLs to show in a full-screen preview when
  the image is clicked.

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

- width:

  Component width, as a CSS unit.

- class, style:

  Extra classes and inline style on the image's box, as Element passes
  them through: `style = "width: 100px; height: 100px"` gives `fit` a
  box to fit the picture to.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
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

  In `el_image()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_image()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>_load` | `events = "load"` | same as native load. |
| `input$<id>_error` | unasked | same as native error. |
| `input$<id>_close` | `events = "close"` | trigger when clicking on close button or when hide-on-click-modal enabled clicking on backdrop. |
| `input$<id>_show` | `events = "show"` | trigger when the viewer displays |
| `input$<id>_switch` | `events = "switch"` | trigger when switching images. |

The same list as `el_events("el_image")`, which says how an event's
arguments travel.

## Updating from the server

Server-side update for `el_image()`.

Every other argument of `el_image()` that can change once it is drawn is
an argument here too, under the same name. One left `NULL` stays as it
is; `NA` returns it to Element's default.

`update_el_image()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_image("photo", src = "https://example.org/a.png", width = 200)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :initial-index="initialIndex === null ? undefined : initialIndex" @error="svEmitError" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :crossorigin="crossorigin === null ? undefined : crossorigin" :hide-on-click-modal="hideOnClickModal === null ? undefined : hideOnClickModal" :infinite="infinite === null ? undefined : infinite" :loading="loading === null ? undefined : loading" :max-scale="maxScale === null ? undefined : maxScale" :min-scale="minScale === null ? undefined : minScale" :preview-teleported="previewTeleported === null ? undefined : previewTeleported" :referrerpolicy="referrerpolicy === null ? undefined : referrerpolicy" :scale="scale === null ? undefined : scale" :show-progress="showProgress === null ? undefined : showProgress" :zoom-rate="zoomRate === null ? undefined : zoomRate" style="width: 200px"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"https://example.org/a.png","fit":null,"alt":null,"lazy":null,"scrollContainer":null,"previewSrcList":null,"zIndex":null,"initialIndex":null,"closeOnPressEscape":null,"crossorigin":null,"hideOnClickModal":null,"infinite":null,"loading":null,"maxScale":null,"minScale":null,"previewTeleported":null,"referrerpolicy":null,"scale":null,"showProgress":null,"zoomRate":null},"methods":{"svEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitError"]}</script>
#> </div>
el_image("photo", src = "a.png", fit = "cover", lazy = TRUE)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :initial-index="initialIndex === null ? undefined : initialIndex" @error="svEmitError" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :crossorigin="crossorigin === null ? undefined : crossorigin" :hide-on-click-modal="hideOnClickModal === null ? undefined : hideOnClickModal" :infinite="infinite === null ? undefined : infinite" :loading="loading === null ? undefined : loading" :max-scale="maxScale === null ? undefined : maxScale" :min-scale="minScale === null ? undefined : minScale" :preview-teleported="previewTeleported === null ? undefined : previewTeleported" :referrerpolicy="referrerpolicy === null ? undefined : referrerpolicy" :scale="scale === null ? undefined : scale" :show-progress="showProgress === null ? undefined : showProgress" :zoom-rate="zoomRate === null ? undefined : zoomRate"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"a.png","fit":"cover","alt":null,"lazy":true,"scrollContainer":null,"previewSrcList":null,"zIndex":null,"initialIndex":null,"closeOnPressEscape":null,"crossorigin":null,"hideOnClickModal":null,"infinite":null,"loading":null,"maxScale":null,"minScale":null,"previewTeleported":null,"referrerpolicy":null,"scale":null,"showProgress":null,"zoomRate":null},"methods":{"svEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitError"]}</script>
#> </div>

# Click to open a gallery
el_image(
  "photo",
  src = "a.png",
  preview_src_list = c("a.png", "b.png", "c.png")
)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :initial-index="initialIndex === null ? undefined : initialIndex" @error="svEmitError" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :crossorigin="crossorigin === null ? undefined : crossorigin" :hide-on-click-modal="hideOnClickModal === null ? undefined : hideOnClickModal" :infinite="infinite === null ? undefined : infinite" :loading="loading === null ? undefined : loading" :max-scale="maxScale === null ? undefined : maxScale" :min-scale="minScale === null ? undefined : minScale" :preview-teleported="previewTeleported === null ? undefined : previewTeleported" :referrerpolicy="referrerpolicy === null ? undefined : referrerpolicy" :scale="scale === null ? undefined : scale" :show-progress="showProgress === null ? undefined : showProgress" :zoom-rate="zoomRate === null ? undefined : zoomRate"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"a.png","fit":null,"alt":null,"lazy":null,"scrollContainer":null,"previewSrcList":["a.png","b.png","c.png"],"zIndex":null,"initialIndex":null,"closeOnPressEscape":null,"crossorigin":null,"hideOnClickModal":null,"infinite":null,"loading":null,"maxScale":null,"minScale":null,"previewTeleported":null,"referrerpolicy":null,"scale":null,"showProgress":null,"zoomRate":null},"methods":{"svEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.svEmitError"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$next_photo, {
    update_el_image(session, "photo", src = photo_url())
  })
}
```
