# Carousel

Loop a series of images or texts in a limited space

## Basic usage

Combine `el-carousel` with `el-carousel-item`, and you’ll get a
carousel. Content of each slide is completely customizable, and you just
need to place it inside `el-carousel-item` tag. By default the carousel
switches when mouse hovers over an indicator. Set `trigger` to `click`,
and the carousel switches only when an indicator is clicked.

``` r

slides <- function(n) lapply(seq_len(n), function(i) list(content = tags$h3(i)))
tagList(
  tags$span(
    class = "demonstration",
    "Switch when indicator is hovered (default)"
  ),
  el_carousel("car1", height = "150px", items = slides(4)),
  tags$span(class = "demonstration", "Switch when indicator is clicked"),
  el_carousel("car2", trigger = "click", height = "150px", items = slides(4))
)
```

Switch when indicator is hovered (default)

Switch when indicator is clicked

## Motion blur

Add motion blur to infuse dynamism and smoothness into the carousel.

Enabling motion blur enhances the dynamism and smoothness of the
carousel. By default, the `motion-blur` parameter is set to `false`,
activating this feature and providing a visually engaging experience.

``` r

slides <- function(n) lapply(seq_len(n), function(i) list(content = tags$h3(i)))
tagList(
  tags$span(class = "demonstration", "Motion blur the switch (default)"),
  el_carousel(
    "car_mb",
    height = "200px",
    motion_blur = TRUE,
    items = slides(4)
  ),
  tags$p(class = "demonstration", "Vertical effect"),
  el_carousel(
    "car_mbv",
    height = "200px",
    direction = "vertical",
    motion_blur = TRUE,
    autoplay = FALSE,
    items = slides(4)
  )
)
```

Motion blur the switch (default)

Vertical effect

## Indicators

Indicators can be displayed outside the carousel

The `indicator-position` attribute determines where the indicators are
located. By default they are inside the carousel, and setting
`indicator-position` to `outside` moves them outside; setting
`indicator-position` to `none` hides the indicators.

``` r

el_carousel(
  "car_ind",
  indicator_position = "outside",
  items = lapply(1:4, function(i) list(content = tags$h3(i)))
)
```

## Arrows

You can define when arrows are displayed

The `arrow` attribute determines when arrows are displayed. By default
they appear when mouse hovers over the carousel. Setting `arrow` to
`always` or `never` shows/hides the arrows permanently.

``` r

el_carousel(
  "car_arrow",
  interval = 5000,
  arrow = "always",
  items = lapply(1:4, function(i) list(content = tags$h3(i)))
)
```

## Auto height

When the `height` of `carousel` is set to `auto`, the `carousel` height
will be automatically set according to the height of the `carousel item`

`height = "auto"` takes each slide’s own height.

``` r

el_carousel(
  "car_auto",
  height = "auto",
  items = lapply(c(100, 200, 300), function(h) {
    list(
      content = tags$h3(
        style = sprintf("height: %dpx", h),
        sprintf("height %dpx", h)
      )
    )
  })
)
```

## Card mode

When a page is wide enough but has limited height, you can activate card
mode for carousels

Setting `type` to `card` activates the card mode. Apart from the
appearance, the biggest difference between card mode and common mode is
that clicking the slides at both sides directly switches the carousel in
card mode.

``` r

el_carousel(
  "car_card",
  interval = 4000,
  type = "card",
  height = "200px",
  items = lapply(1:6, function(i) list(content = tags$h3(i)))
)
```

## Vertical

By default, `direction` is `horizontal`. Let carousel be displayed in
the vertical direction by setting `direction` to `vertical`.

``` r

slides <- function(n) lapply(seq_len(n), function(i) list(content = tags$h3(i)))
tagList(
  tags$p(class = "demonstration", "normal vertical layout"),
  el_carousel(
    "car_v",
    height = "200px",
    direction = "vertical",
    autoplay = FALSE,
    items = slides(4)
  ),
  tags$p(class = "demonstration", "card vertical layout"),
  el_carousel(
    "car_vc",
    height = "400px",
    direction = "vertical",
    type = "card",
    autoplay = FALSE,
    items = slides(4)
  )
)
```

normal vertical layout

card vertical layout

## API

Element Plus’s tables, and beside each entry where it is in R.

### Carousel Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `height` | `height` | height of the carousel | [^1] |  | ’’ |
| `initial-index` | `initial_index` | index of the initially active slide (starting from 0) | [^2] |  | 0 |
| `trigger` | `trigger` | how indicators are triggered | [^3]`'hover' \\| 'click'` |  | hover |
| `autoplay` | `autoplay` | whether automatically loop the slides | [^4] |  | true |
| `interval` | `interval` | interval of the auto loop, in milliseconds | [^5] |  | 3000 |
| `indicator-position` | `indicator_position` | position of the indicators | [^6]`'' \\| 'none' \\| 'outside'` |  | ’’ |
| `arrow` | `arrow` | when arrows are shown | [^7]`'always' \\| 'hover' \\| 'never'` |  | hover |
| `type` | `type` | type of the Carousel | [^8]`'' \\| 'card'` |  | ’’ |
| `card-scale` | `card_scale` | when type is card, scaled size of secondary cards | [^9] |  | 0.83 |
| `loop` | `loop` | display the items in loop | [^10] |  | true |
| `direction` | `direction` | display direction | [^11]`'horizontal' \\| 'vertical'` |  | horizontal |
| `pause-on-hover` | `pause_on_hover` | pause autoplay when hover | [^12] |  | true |
| `motion-blur` | `motion_blur` | infuse dynamism and smoothness into the carousel | [^13] |  | false |

### Carousel Events

| Element | In R | Description |
|----|----|----|
| `change` | `input$<id>`, the value | triggers when the active slide switches, it has two parameters, the one is the index of the new active slide, and other is index of the old active slide |

### Carousel Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Carousel Exposes

| Element | In R | Description |
|----|----|----|
| `setActiveItem` | `call_el(session, id, "setActiveItem")` | manually switch slide, index of the slide to be switched to, starting from 0; or the `name` of corresponding `el-carousel-item` |
| `prev` | `call_el(session, id, "prev")` | switch to the previous slide |
| [`next`](https://rdrr.io/r/base/Control.html) | `call_el(session, id, "next")` | switch to the next slide |

### Carousel-Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `label` | item field `label` | text content for the corresponding indicator | [^14] / [^15] |  | ’’ |

### Carousel-Item Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

[^1]: string

[^2]: number

[^3]: enum

[^4]: boolean

[^5]: number

[^6]: enum

[^7]: enum

[^8]: enum

[^9]: number

[^10]: boolean

[^11]: enum

[^12]: boolean

[^13]: boolean

[^14]: string

[^15]: number
