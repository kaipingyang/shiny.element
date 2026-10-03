# Image

Besides the native features of img, support lazy load, custom
placeholder and load failure, etc.

## Basic Usage

Indicate how the image should be resized to fit its container by `fit`,
same as native
[object-fit](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit).

``` r

url <- "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
tags$div(style = "display: flex; gap: 20px",
  lapply(c("fill", "contain", "cover", "none", "scale-down"), function(f)
    tags$div(style = "text-align: center", tags$div(class = "demonstration", f),
             el_image(src = url, fit = f, alt = f, width = "100px"))))
```

fill

contain

cover

none

scale-down

## Placeholder

Custom placeholder content when image hasn’t loaded yet by
`slot = placeholder`

``` r

src <- "https://cube.elemecdn.com/6/94/4d3ea53c084bad6931a56d5158a48jpeg.jpeg"
tags$div(style = "display: flex; gap: 40px",
  tags$div(tags$div(class = "demonstration", "Default"), el_image(src = src, alt = "Default")),
  tags$div(tags$div(class = "demonstration", "Custom"), el_image(src = src, alt = "Custom",
    slots = list(placeholder = tags$div(class = "image-slot", "Loading", tags$span(class = "dot", "..."))))))
```

Default

Custom

## Load Failed

Custom failed content when error occurs to image load by `slot = error`
and `slot = viewer-error`.

``` r

tags$div(style = "display: flex; gap: 8px",
  el_image(alt = "Default"),
  el_image(alt = "Custom", slots = list(error = tags$div(class = "image-slot", el_icon("Picture")))))
```

## Lazy Load

> **Tip**
>
> Native `loading` has been supported since 2.2.3, you can use
> `loading = "lazy"` to replace `lazy = true`.
>
> If the current browser supports native lazy loading, the native lazy
> loading will be used first, otherwise will be implemented through
> scroll.

Use lazy load by `lazy = true`. Image will load until scroll into view
when set. You can indicate scroll container that adds scroll listener to
by `scroll-container`. If undefined, will be the nearest parent
container whose overflow property is auto or scroll.

``` r

urls <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg", "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg",
  "9/bb/e27858e973f5d7d3904835f46abbdjpeg.jpeg"))
tags$div(style = "height: 400px; overflow-y: auto",
  lapply(urls, function(u) el_image(src = u, lazy = TRUE, alt = "lazy")))
```

## Image Preview

allow big image preview by setting `previewSrcList` prop. You can
initialize the position of the first picture previewed by
`initial-index`. The default initial position is 0.

``` r

url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
src_list <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg", "0/6f/e35ff375812e6b0020b6b4e8f9583jpeg.jpeg"))
el_image(src = url, alt = "preview", fit = "cover", width = "100px", zoom_rate = 1.2,
         max_scale = 7, min_scale = 0.2, preview_src_list = src_list, initial_index = 1)
```

## Manually Open Preview

`el_call(session, "pic", "showPreview")` opens the preview from the
server;
[`el_image_viewer()`](https://kaipingyang.github.io/shiny.element/reference/el_image_viewer.md)
is the viewer alone, opened with
[`update_el_image_viewer()`](https://kaipingyang.github.io/shiny.element/reference/update_el_image_viewer.md).

``` r

url <- "https://fuss10.elemecdn.com/a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg"
tagList(
  el_image("pic", src = url, alt = "preview", width = "100px", preview_src_list = list(url)),
  el_image_viewer("viewer", url_list = c(url)))
```

## Custom Toolbar

Custom toolbar content by `toolbar` slot, starting from version 2.9.7,
the slot has a new `setActiveItem` function, which can be switched
according to the index.

``` r

src_list <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg"))
el_image(src = src_list[1], alt = "preview", fit = "cover", width = "100px",
  preview_src_list = src_list, show_progress = TRUE,
  slots = list(toolbar = template(htmltools::HTML(paste0(
    "<el-icon @click=\"prev\"><Back /></el-icon>",
    "<el-icon @click=\"next\"><Right /></el-icon>",
    "<el-icon @click=\"setActiveItem(0)\"><DArrowLeft /></el-icon>",
    "<el-icon @click=\"actions('zoomOut')\"><ZoomOut /></el-icon>",
    "<el-icon @click=\"actions('zoomIn')\"><ZoomIn /></el-icon>")),
    slot = "toolbar", scope = "{ actions, prev, next, setActiveItem }")))
```

## Custom progress

By setting the `show-progress` prop to control whether to display
progress when previewing an image. After version 2.9.8, the progress
content will be displayed as long as the `progress` slot is used.

``` r

src_list <- paste0("https://fuss10.elemecdn.com/", c("a/3f/3302e58f9a181d2509f3dc0fa68b0jpeg.jpeg",
  "1/34/19aa98b1fcb2781c4fba33d850549jpeg.jpeg"))
el_image(src = src_list[1], alt = "preview", fit = "cover", width = "100px",
  preview_src_list = src_list,
  slots = list(progress = template(htmltools::HTML(
    "<span>{{ activeIndex + 1 }} / {{ total }}</span>"),
    slot = "progress", scope = "{ activeIndex, total }")))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Image Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `src` | `el_image(src =)` | image source, same as native. | [^1] |  | ’’ |
| `fit` | `el_image(fit =)` | indicate how the image should be resized to fit its container, same as [object-fit](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit). | [^2]`'' \\| 'fill' \\| 'contain' \\| 'cover' \\| 'none' \\| 'scale-down'` |  | ’’ |
| `hide-on-click-modal` | `el_image(hide_on_click_modal =)` | when enabling preview, use this flag to control whether clicking on backdrop can exit preview mode. | [^3] |  | false |
| `loading` | `el_image(loading =)` | Indicates how the browser should load the image, same as [native](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img#attr-loading). | [^4]`'eager' \\| 'lazy'` |  | — |
| `lazy` | `el_image(lazy =)` | whether to use lazy load. | [^5] |  | false |
| `scroll-container` | `el_image(scroll_container =)` | the container to add scroll listener when using lazy load. By default, the container to add scroll listener when using lazy load. | [^6] / [^7]`HTMLElement` |  | — |
| `alt` | `el_image(alt =)` | native attribute `alt`. | [^8] |  | — |
| `referrerpolicy` | `el_image(referrerpolicy =)` | native attribute [referrerPolicy](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/referrerPolicy). | [^9] |  | — |
| `crossorigin` | `el_image(crossorigin =)` | native attribute [crossorigin](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/crossorigin). | [^10]`'' \\| 'anonymous' \\| 'use-credentials'` |  | — |
| `preview-src-list` | `el_image(preview_src_list =)` | allow big image preview. | [^11]`string[]` |  | \[\] |
| `z-index` | `el_image(z_index =)` | set image preview z-index. | [^12] |  | — |
| `initial-index` | `el_image(initial_index =)` | initial preview image index, less than the length of `url-list`. | [^13] |  | 0 |
| `close-on-press-escape` | `el_image(close_on_press_escape =)` | whether the image-viewer can be closed by pressing ESC. | [^14] |  | true |
| `preview-teleported` | `el_image(preview_teleported =)` | whether to append image-viewer to body. A nested parent element attribute transform should have this attribute set to `true`. | [^15] |  | false |
| `infinite` | `el_image(infinite =)` | whether the viewer preview is infinite. | [^16] |  | true |
| `zoom-rate` | `el_image(zoom_rate =)` | the zoom rate of the image viewer zoom event. | [^17] |  | 1.2 |
| `scale` | `el_image(scale =)` | the preview image scale. | [^18] |  | 1 |
| `min-scale` | `el_image(min_scale =)` | the min scale of the image viewer zoom event. | [^19] |  | 0.2 |
| `max-scale` | `el_image(max_scale =)` | the max scale of the image viewer zoom event. | [^20] |  | 7 |
| `show-progress` | `el_image(show_progress =)` | whether to display the preview image progress content. | [^21] |  | false |

### Image Events

| Element | In R | Description |
|----|----|----|
| `load` | `input$<id>_load` | same as native load. |
| `error` | `input$<id>_error` | same as native error. |
| `switch` | `input$<id>_switch` | trigger when switching images. |
| `close` | `input$<id>_close` | trigger when clicking on close button or when `hide-on-click-modal` enabled clicking on backdrop. |
| `show` | `input$<id>_show` | trigger when the viewer displays |

### Image Slots

| Element | In R | Description |
|----|----|----|
| `placeholder` | `slots = list(placeholder = )` | custom placeholder content when image hasn’t loaded yet. |
| `error` | `slots = list(error = )` | custom image load failed content. |
| `viewer` | `slots = list(viewer = )` | custom content when image preview. |

### Image Exposes

| Element | In R | Description |
|----|----|----|
| `showPreview` | `el_call(session, id, "showPreview")` | manually open preview big image |

### Image Viewer Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `url-list` | `el_image_viewer(url_list =)` | preview link list. | [^22]`string[]` |  | \[\] |
| `z-index` | `el_image(z_index =)` | preview backdrop z-index. | [^23] / [^24] |  | — |
| `initial-index` | `el_image(initial_index =)` | the initial preview image index, less than or equal to the length of `url-list`. | [^25] |  | 0 |
| `infinite` | `el_image(infinite =)` | whether preview is infinite. | [^26] |  | true |
| `hide-on-click-modal` | `el_image(hide_on_click_modal =)` | whether user can emit close event when clicking backdrop. | [^27] |  | false |
| `teleported` | `el_image_viewer(teleported =)` | whether to append image itself to body. A nested parent element attribute transform should have this attribute set to `true`. | [^28] |  | false |
| `zoom-rate` | `el_image(zoom_rate =)` | the zoom rate of the image viewer zoom event. | [^29] |  | 1.2 |
| `scale` | `el_image(scale =)` | the preview image scale. | [^30] |  | 1 |
| `min-scale` | `el_image(min_scale =)` | the min scale of the image viewer zoom event. | [^31] |  | 0.2 |
| `max-scale` | `el_image(max_scale =)` | the max scale of the image viewer zoom event. | [^32] |  | 7 |
| `close-on-press-escape` | `el_image(close_on_press_escape =)` | whether the image-viewer can be closed by pressing ESC. | [^33] |  | true |
| `show-progress` | `el_image(show_progress =)` | whether to display the preview image progress content | [^34] |  | false |

### Image Viewer Events

| Element | In R | Description |
|----|----|----|
| `close` | `input$<id>_close` | trigger when clicking on close button or when `hide-on-click-modal` enabled clicking on backdrop. |
| `error` | `input$<id>_error` | same as native error. |
| `switch` | `input$<id>_switch` | trigger when switching images. |
| `rotate` | `input$<id>_rotate` | trigger when rotating images. |

### Image Viewer Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | custom content |
| `progress` | `slots = list(progress = )` | custom progress content (Priority is higher than `show-progress` prop) |
| `toolbar` | `slots = list(toolbar = )` | custom toolbar content |
| `viewer-error` | `slots = list(viewer-error = )` | custom image load failed content. |

### Image Viewer Exposes

| Element | In R | Description |
|----|----|----|
| `setActiveItem` | `el_call(session, id, "setActiveItem")` | manually switch image |

[^1]: string

[^2]: enum

[^3]: boolean

[^4]: enum

[^5]: boolean

[^6]: string

[^7]: object

[^8]: string

[^9]: string

[^10]: enum

[^11]: array

[^12]: number

[^13]: number

[^14]: boolean

[^15]: boolean

[^16]: boolean

[^17]: number

[^18]: number

[^19]: number

[^20]: number

[^21]: boolean

[^22]: array

[^23]: number

[^24]: string

[^25]: number

[^26]: boolean

[^27]: boolean

[^28]: boolean

[^29]: number

[^30]: number

[^31]: number

[^32]: number

[^33]: boolean

[^34]: boolean
