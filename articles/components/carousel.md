# Carousel

Loop a series of images or texts in a limited space. `input$<id>` is the
slide showing, 0-based, and `input$<id>_name` its name;
`update_el_carousel(active =)` moves it.

## Basic usage

``` r

slides <- lapply(1:4, function(i) list(name = paste0("s", i), content = tags$h3(i)))
el_carousel("c1", height = "150px", items = slides)
el_carousel("c2", height = "150px", trigger = "click", items = slides)
```

## Indicators

``` r

el_carousel("ind", height = "150px", indicator_position = "outside",
            items = lapply(1:4, function(i) list(name = paste0("s", i), content = tags$h3(i))))
```

## Arrows

``` r

el_carousel("arr", height = "150px", interval = 5000, arrow = "always",
            items = lapply(1:4, function(i) list(name = paste0("s", i), content = tags$h3(i))))
```

## Card mode

``` r

el_carousel("cards", height = "200px", type = "card", interval = 4000,
            items = lapply(1:6, function(i) list(name = paste0("s", i), content = tags$h3(i))))
```

## Vertical

``` r

el_carousel("vert", height = "200px", direction = "vertical", autoplay = FALSE,
            items = lapply(1:3, function(i) list(name = paste0("s", i), content = tags$h3(i))))
```

## API

### Carousel Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `height` | `height` | height of the carousel | string | — | — |
| `initial-index` | `initial_index` | index of the initially active slide (starting from 0) | number | — | 0 |
| `trigger` | `trigger` | how indicators are triggered | string | hover/click | hover |
| `autoplay` | `autoplay` | whether automatically loop the slides | boolean | — | true |
| `interval` | `interval` | interval of the auto loop, in milliseconds | number | — | 3000 |
| `indicator-position` | `indicator_position` | position of the indicators | string | outside/none | — |
| `arrow` | `arrow` | when arrows are shown | string | always/hover/never | hover |
| `type` | `type` | type of the Carousel | string | card | — |
| `loop` | `loop` | display the items in loop | boolean | \- | true |
| `direction` | `direction` | display direction | string | horizontal/vertical | horizontal |

### Carousel Events

| Element  | In R                    | Description                             |
|----------|-------------------------|-----------------------------------------|
| `change` | `input$<id>`, the value | triggers when the active slide switches |

### Carousel Methods

| Element | In R | Description |
|----|----|----|
| `setActiveItem` | `el_call(session, id, "setActiveItem")` | manually switch slide |
| `prev` | `el_call(session, id, "prev")` | switch to the previous slide |
| [`next`](https://rdrr.io/r/base/Control.html) | `el_call(session, id, "next")` | switch to the next slide |

### Carousel-Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `name` | item field `name` | name of the item, can be used in `setActiveItem` | string | — | — |
| `label` | item field `label` | text content for the corresponding indicator | string | — | — |
