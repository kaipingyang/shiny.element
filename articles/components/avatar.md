# Avatar

Avatars represent people or objects, with images, icons or characters.

## Basic

`shape` and `size` – `"large"`, `"medium"`, `"small"` or a number of
pixels.

``` r

url <- "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
tags$div(style = "display: flex; gap: 20px; align-items: center",
  lapply(list(50, "large", "medium", "small"), function(s)
    el_avatar(paste0("c_", s), src = url, size = s)),
  lapply(list(50, "large", "medium", "small"), function(s)
    el_avatar(paste0("q_", s), src = url, size = s, shape = "square")))
```

## Types

``` r

el_avatar("icon", icon = "el-icon-user-solid")
el_avatar("img", src = "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png")
el_avatar("text", content = "user")
```

## Fallback when the image fails

``` r

el_avatar("fail", size = 60, src = "https://empty", slots = list(
  default = tags$img(src = "https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png", alt = "Fallback")))
```

## How the image fits its container

``` r

tags$div(style = "display: flex; gap: 30px", lapply(c("fill", "contain", "cover", "none", "scale-down"), function(f)
  tags$div(style = "text-align: center", tags$div(f),
    el_avatar(paste0("fit_", gsub("-", "_", f)), shape = "square", size = 100, fit = f,
              src = "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"))))
```

fill

contain

cover

none

scale-down

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `icon` | `icon` | set representation type to Icon, more info on Icon Component | string |  |  |
| `size` | `size` | set avatar size | number/string | number / large / medium / small | large |
| `shape` | `shape` | set avatar shape | string | circle / square | circle |
| `src` | `src` | the address of the image for an image avatar | string |  |  |
| `srcSet` | `src_set` | A list of one or more strings separated by commas indicating a set of possible image sources for the user agent to use | string |  |  |
| `alt` | `alt` | This attribute defines an alternative text description of the image | string |  |  |
| `fit` | `fit` | set how the image fit its container for an image avatar | string | fill / contain / cover / none / scale-down | cover |

### Events

| Element | In R | Description |
|----|----|----|
| `error` | `input$<id>_error` | handler when img load error, return false to prevent default fallback behavior |

### Slot

| Element   | In R            | Description              |
|-----------|-----------------|--------------------------|
| `default` | default content | customize avatar content |
