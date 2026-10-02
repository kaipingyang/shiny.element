# Element UI Image

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
  referrer_policy = NULL,
  initial_index = NULL,
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

- referrer_policy:

  Value of the image's `referrerPolicy` attribute.

- initial_index:

  Which image of `preview_src_list` the preview opens on, 0-based.

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
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :referrer-policy="referrerPolicy === null ? undefined : referrerPolicy" :initial-index="initialIndex === null ? undefined : initialIndex" @load="elEmitLoad" @error="elEmitError" style="width: 200px"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"https://example.org/a.png","fit":null,"alt":null,"lazy":null,"scrollContainer":null,"previewSrcList":null,"zIndex":null,"referrerPolicy":null,"initialIndex":null},"methods":{"elEmitLoad":"function() { window.shinyVue.emit('photo', 'load', arguments); }","elEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitLoad","options.methods.elEmitError"]}</script>
#> </div>
el_image("photo", src = "a.png", fit = "cover", lazy = TRUE)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :referrer-policy="referrerPolicy === null ? undefined : referrerPolicy" :initial-index="initialIndex === null ? undefined : initialIndex" @load="elEmitLoad" @error="elEmitError"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"a.png","fit":"cover","alt":null,"lazy":true,"scrollContainer":null,"previewSrcList":null,"zIndex":null,"referrerPolicy":null,"initialIndex":null},"methods":{"elEmitLoad":"function() { window.shinyVue.emit('photo', 'load', arguments); }","elEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitLoad","options.methods.elEmitError"]}</script>
#> </div>

# Click to open a gallery
el_image("photo",
  src = "a.png",
  preview_src_list = c("a.png", "b.png", "c.png")
)
#> <div id="photo" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="photo_container" style="display: contents">
#>   <el-image :src="src === null ? undefined : src" :fit="fit === null ? undefined : fit" :alt="alt === null ? undefined : alt" :lazy="lazy === null ? undefined : lazy" :scroll-container="scrollContainer === null ? undefined : scrollContainer" :preview-src-list="previewSrcList === null ? undefined : previewSrcList" :z-index="zIndex === null ? undefined : zIndex" :referrer-policy="referrerPolicy === null ? undefined : referrerPolicy" :initial-index="initialIndex === null ? undefined : initialIndex" @load="elEmitLoad" @error="elEmitError"></el-image>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"src":"a.png","fit":null,"alt":null,"lazy":null,"scrollContainer":null,"previewSrcList":["a.png","b.png","c.png"],"zIndex":null,"referrerPolicy":null,"initialIndex":null},"methods":{"elEmitLoad":"function() { window.shinyVue.emit('photo', 'load', arguments); }","elEmitError":"function() { window.shinyVue.emit('photo', 'error', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitLoad","options.methods.elEmitError"]}</script>
#> </div>
```
