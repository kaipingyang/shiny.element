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
  slots = NULL,
  session = NULL
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

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_load` – fires when the image has loaded.

- `input$<id>_error` – fires when it fails to.

## Examples

``` r
el_image("photo", src = "https://example.org/a.png", width = 200)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :initial-index="initialIndex === null ? undefined : initialIndex" @load="elEmitLoad" @error="elEmitError" @close="elEmitClose" @show="elEmitShow" @switch="elEmitSwitch" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :crossorigin="crossorigin === null ? undefined : crossorigin" :hide-on-click-modal="hideOnClickModal === null ? undefined : hideOnClickModal" :infinite="infinite === null ? undefined : infinite" :loading="loading === null ? undefined : loading" :max-scale="maxScale === null ? undefined : maxScale" :min-scale="minScale === null ? undefined : minScale" :preview-teleported="previewTeleported === null ? undefined : previewTeleported" :referrerpolicy="referrerpolicy === null ? undefined : referrerpolicy" :scale="scale === null ? undefined : scale" :show-progress="showProgress === null ? undefined : showProgress" :zoom-rate="zoomRate === null ? undefined : zoomRate" style="width: 200px"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"https://example.org/a.png","fit":null,"alt":null,"lazy":null,"scrollContainer":null,"previewSrcList":null,"zIndex":null,"initialIndex":null,"closeOnPressEscape":null,"crossorigin":null,"hideOnClickModal":null,"infinite":null,"loading":null,"maxScale":null,"minScale":null,"previewTeleported":null,"referrerpolicy":null,"scale":null,"showProgress":null,"zoomRate":null},"methods":{"elEmitLoad":"function() { window.shinyVue.emit('photo', 'load', arguments); }","elEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }","elEmitClose":"function() { window.shinyVue.emit('photo', 'close', arguments); }","elEmitShow":"function() { window.shinyVue.emit('photo', 'show', arguments); }","elEmitSwitch":"function() { window.shinyVue.emit('photo', 'switch', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitLoad","options.methods.elEmitError","options.methods.elEmitClose","options.methods.elEmitShow","options.methods.elEmitSwitch"]}</script>
#> </div>
el_image("photo", src = "a.png", fit = "cover", lazy = TRUE)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :initial-index="initialIndex === null ? undefined : initialIndex" @load="elEmitLoad" @error="elEmitError" @close="elEmitClose" @show="elEmitShow" @switch="elEmitSwitch" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :crossorigin="crossorigin === null ? undefined : crossorigin" :hide-on-click-modal="hideOnClickModal === null ? undefined : hideOnClickModal" :infinite="infinite === null ? undefined : infinite" :loading="loading === null ? undefined : loading" :max-scale="maxScale === null ? undefined : maxScale" :min-scale="minScale === null ? undefined : minScale" :preview-teleported="previewTeleported === null ? undefined : previewTeleported" :referrerpolicy="referrerpolicy === null ? undefined : referrerpolicy" :scale="scale === null ? undefined : scale" :show-progress="showProgress === null ? undefined : showProgress" :zoom-rate="zoomRate === null ? undefined : zoomRate"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"a.png","fit":"cover","alt":null,"lazy":true,"scrollContainer":null,"previewSrcList":null,"zIndex":null,"initialIndex":null,"closeOnPressEscape":null,"crossorigin":null,"hideOnClickModal":null,"infinite":null,"loading":null,"maxScale":null,"minScale":null,"previewTeleported":null,"referrerpolicy":null,"scale":null,"showProgress":null,"zoomRate":null},"methods":{"elEmitLoad":"function() { window.shinyVue.emit('photo', 'load', arguments); }","elEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }","elEmitClose":"function() { window.shinyVue.emit('photo', 'close', arguments); }","elEmitShow":"function() { window.shinyVue.emit('photo', 'show', arguments); }","elEmitSwitch":"function() { window.shinyVue.emit('photo', 'switch', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitLoad","options.methods.elEmitError","options.methods.elEmitClose","options.methods.elEmitShow","options.methods.elEmitSwitch"]}</script>
#> </div>

# Click to open a gallery
el_image(
  "photo",
  src = "a.png",
  preview_src_list = c("a.png", "b.png", "c.png")
)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :initial-index="initialIndex === null ? undefined : initialIndex" @load="elEmitLoad" @error="elEmitError" @close="elEmitClose" @show="elEmitShow" @switch="elEmitSwitch" :close-on-press-escape="closeOnPressEscape === null ? undefined : closeOnPressEscape" :crossorigin="crossorigin === null ? undefined : crossorigin" :hide-on-click-modal="hideOnClickModal === null ? undefined : hideOnClickModal" :infinite="infinite === null ? undefined : infinite" :loading="loading === null ? undefined : loading" :max-scale="maxScale === null ? undefined : maxScale" :min-scale="minScale === null ? undefined : minScale" :preview-teleported="previewTeleported === null ? undefined : previewTeleported" :referrerpolicy="referrerpolicy === null ? undefined : referrerpolicy" :scale="scale === null ? undefined : scale" :show-progress="showProgress === null ? undefined : showProgress" :zoom-rate="zoomRate === null ? undefined : zoomRate"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"a.png","fit":null,"alt":null,"lazy":null,"scrollContainer":null,"previewSrcList":["a.png","b.png","c.png"],"zIndex":null,"initialIndex":null,"closeOnPressEscape":null,"crossorigin":null,"hideOnClickModal":null,"infinite":null,"loading":null,"maxScale":null,"minScale":null,"previewTeleported":null,"referrerpolicy":null,"scale":null,"showProgress":null,"zoomRate":null},"methods":{"elEmitLoad":"function() { window.shinyVue.emit('photo', 'load', arguments); }","elEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }","elEmitClose":"function() { window.shinyVue.emit('photo', 'close', arguments); }","elEmitShow":"function() { window.shinyVue.emit('photo', 'show', arguments); }","elEmitSwitch":"function() { window.shinyVue.emit('photo', 'switch', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitLoad","options.methods.elEmitError","options.methods.elEmitClose","options.methods.elEmitShow","options.methods.elEmitSwitch"]}</script>
#> </div>
```
