# Image

Besides the native features of an img, lazy loading, a custom
placeholder and failed content, and a full-screen preview.

## Basic usage

`fit` is how the image fits its box, as CSS `object-fit`.

``` r

fits <- c("fill", "contain", "cover", "none", "scale-down")
tags$div(style = "display: flex; gap: 20px", lapply(fits, function(f) tags$div(
  style = "text-align: center; font-size: 13px; color: #8492a6",
  tags$div(f), el_image(paste0("img_", gsub("-", "_", f)), src = "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg", fit = f,
                        width = "100px"))))
```

fill

contain

cover

none

scale-down

## Placeholder

``` r

el_image("ph", src = "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg", width = "200px",
         slots = list(placeholder = tags$div("Loading", tags$span(class = "dot", "..."))))
```

## Load failed

``` r

el_image("broken", src = "no-such-image.png", width = "200px",
         slots = list(error = tags$div(style = "display: flex; justify-content: center; align-items: center; height: 120px; background: #f5f7fa; color: #909399",
                                       el_icon("picture-outline"))))
```

## Lazy load

``` r

tags$div(id = "pics", style = "height: 300px; overflow-y: auto", lapply(1:6, function(i)
  el_image(paste0("lazy", i), src = "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg", lazy = TRUE, scroll_container = "#pics", width = "100%")))
```

## Image preview

``` r

el_image("pre", src = "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg", width = "100px", preview_src_list = c(
  "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg", "https://fuss10.elemecdn.com/8/27/f01c15bb73e1ef3793e64e6b7bbccjpeg.jpeg"))
```

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `src` | `src` | Image source, same as native | string | — | \- |
| `fit` | `fit` | Indicate how the image should be resized to fit its container, same as [object-fit](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit) | string | fill / contain / cover / none / scale-down | \- |
| `alt` | `alt` | Native alt | string | \- | \- |
| `referrer-policy` | `referrer_policy` | Native referrerPolicy | string | \- | \- |
| `lazy` | `lazy` | Whether to use lazy load | boolean | — | false |
| `scroll-container` | `scroll_container` | The container to add scroll listener when using lazy load | string / HTMLElement | — | The nearest parent container whose overflow property is auto or scroll |
| `preview-src-list` | `preview_src_list` | allow big image preview | Array | — | \- |
| `z-index` | `z_index` | set image preview z-index | Number | — | 2000 |
| `initial-index` | `initial_index` | set image preview array index | Number | — | \- |

### Events

| Element | In R               | Description          |
|---------|--------------------|----------------------|
| `load`  | `input$<id>_load`  | Same as native load  |
| `error` | `input$<id>_error` | Same as native error |

### Slots

| Element | In R | Description |
|----|----|----|
| `placeholder` | `slots = list(placeholder = )` | Triggers when image load |
| `error` | `slots = list(error = )` | Triggers when image load failed |
