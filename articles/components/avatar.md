# Avatar

Avatars can be used to represent people or objects. It supports images,
Icons, or characters.

## Basic Usage

Use `shape` and `size` prop to set avatar’s shape and size.

``` r

circle <- "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"
square <- "https://cube.elemecdn.com/9/c2/f0ee8a3c7c9638a54940382568c9dpng.png"
row <- function(...) tags$div(style = "display: flex; gap: 20px; align-items: center", ...)
el_row(
  el_col(span = 12, tags$div("circle"), row(
    el_avatar(src = circle, size = 50),
    lapply(c("small", "default", "large"), function(s) el_avatar(src = circle, size = s)))),
  el_col(span = 12, tags$div("square"), row(
    el_avatar(src = square, size = 50, shape = "square"),
    lapply(c("small", "default", "large"), function(s)
      el_avatar(src = square, size = s, shape = "square")))))
```

circle

square

## Types

It supports images, Icons, or characters.

``` r

tags$div(style = "display: flex; gap: 20px",
  el_avatar(icon = "UserFilled"),
  el_avatar(src = "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"),
  el_avatar(content = "user"))
```

## Fallback

fallback when image load error.

What the avatar shows when its image fails to load is its content.

``` r

el_avatar(src = "https://empty", size = 60, content = tags$img(
  src = "https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png", alt = "Fallback"))
```

## Fit Container

Set how the image fit its container for an image avatar, same as
[object-fit](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit).

``` r

url <- "https://fuss10.elemecdn.com/e/5d/4a731a90594a4af544c0c25941171jpeg.jpeg"
tags$div(style = "display: flex; gap: 20px",
  lapply(c("fill", "contain", "cover", "none", "scale-down"), function(f)
    tags$div(style = "text-align: center", tags$div(f),
             el_avatar(src = url, size = 100, shape = "square", fit = f))))
```

fill

contain

cover

none

scale-down

## Avatar Group

Displayed as a avatar group.

Use tag `<el-avatar-group>` to group your avatars.

``` r

url <- "https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png"
five <- function() lapply(1:5, function(i) el_avatar(src = url))
tagList(
  tags$p("default"), el_avatar_group(five()),
  tags$p("use collapse-avatars"), el_avatar_group(five(), collapse_avatars = TRUE),
  tags$p("use collapse-class and collapse-style"),
  el_avatar_group(five(), collapse_avatars = TRUE, collapse_class = "my-collapse-avatar",
                  collapse_style = list("background-color" = "#d9ecff")))
```

default

use collapse-avatars

use collapse-class and collapse-style

## API

Element Plus’s tables, and beside each entry where it is in R.

### Avatar Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `icon` | `el_avatar(icon =)` | representation type to icon, more info on icon component. | [^1] / [^2] |  | — |
| `size` | `el_avatar(size =)` | avatar size. | [^3] / [^4]`'large' \\| 'default' \\| 'small'` |  | — |
| `shape` | `el_avatar(shape =)` | avatar shape. | [^5]`'circle' \\| 'square'` |  | — |
| `src` | `el_avatar(src =)` | the source of the image for an image avatar. | `string` |  | — |
| `src-set` | `el_avatar(src_set =)` | native attribute `srcset` of image avatar. | `string` |  | — |
| `alt` | `el_avatar(alt =)` | native attribute `alt` of image avatar. | `string` |  | — |
| `fit` | `el_avatar(fit =)` | set how the image fit its container for an image avatar. | [^6]`'fill' \\| 'contain' \\| 'cover' \\| 'none' \\| 'scale-down'` |  | cover |

### Avatar Events

| Element | In R               | Description                    |
|---------|--------------------|--------------------------------|
| `error` | `input$<id>_error` | trigger when image load error. |

### Avatar Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize avatar content. |

### AvatarGroup Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `size` | `el_avatar(size =)` | control the size of avatars in this avatar-group | [^7] / [^8]`'large' \\| 'default' \\| 'small'` |  | — |
| `shape` | `el_avatar(shape =)` | control the shape of avatars in this avatar-group | [^9]`'circle' \\| 'square'` |  | — |
| `collapse-avatars` | `el_avatar_group(collapse_avatars =)` | whether to collapse avatars | [^10] |  | false |
| `collapse-avatars-tooltip` | `el_avatar_group(collapse_avatars_tooltip =)` | whether show all collapsed avatars when mouse hover text of the collapse-avatar. To use this, `collapse-avatars` must be true | [^11] |  | false |
| `max-collapse-avatars` | `el_avatar_group(max_collapse_avatars =)` | the max avatars number to be shown. To use this, `collapse-avatars` must be true | [^12] |  | 1 |
| `effect` | `el_avatar_group(effect =)` | tooltip theme, built-in theme: `dark` / `light` | [^13]`'dark' \\| 'light'` / [^14] |  | light |
| `placement` | `el_avatar_group(placement =)` | placement of tooltip | [^15]`'top' \\| 'top-start' \\| 'top-end' \\| 'bottom' \\| 'bottom-start' \\| 'bottom-end' \\| 'left' \\| 'left-start' \\| 'left-end' \\| 'right' \\| 'right-start' \\| 'right-end'` |  | top |
| `popper-class` | `el_avatar_group(popper_class =)` | custom class name for tooltip | [^16] |  | ’’ |
| `popper-style` | `el_avatar_group(popper_style =)` | custom style for tooltip | [^17] / [^18] |  | — |
| `collapse-class` | `el_avatar_group(collapse_class =)` | custom class name for the collapse-avatar | [^19] |  | ’’ |
| `collapse-style` | `el_avatar_group(collapse_style =)` | custom style for the collapse-avatar | [^20] / [^21] |  | — |

[^1]: string

[^2]: Component

[^3]: number

[^4]: enum

[^5]: enum

[^6]: enum

[^7]: number

[^8]: enum

[^9]: enum

[^10]: boolean

[^11]: boolean

[^12]: number

[^13]: enum

[^14]: string

[^15]: enum

[^16]: string

[^17]: string

[^18]: object

[^19]: string

[^20]: string

[^21]: object
