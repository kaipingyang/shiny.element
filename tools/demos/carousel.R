## basic
slides <- function(n) {
  lapply(seq_len(n), function(i) el_carousel_item(tags$h3(i)))
}
tagList(
  tags$span(
    class = "demonstration",
    "Switch when indicator is hovered (default)"
  ),
  el_carousel("car1", height = "150px", items = slides(4)),
  tags$span(class = "demonstration", "Switch when indicator is clicked"),
  el_carousel("car2", trigger = "click", height = "150px", items = slides(4))
)

## motion-blur
slides <- function(n) {
  lapply(seq_len(n), function(i) el_carousel_item(tags$h3(i)))
}
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

## indicator
el_carousel(
  "car_ind",
  indicator_position = "outside",
  items = lapply(1:4, function(i) el_carousel_item(tags$h3(i)))
)

## arrows
el_carousel(
  "car_arrow",
  interval = 5000,
  arrow = "always",
  items = lapply(1:4, function(i) el_carousel_item(tags$h3(i)))
)

## auto-height
#' `height = "auto"` takes each slide's own height.
el_carousel(
  "car_auto",
  height = "auto",
  items = lapply(c(100, 200, 300), function(h) {
    el_carousel_item(tags$h3(
      style = sprintf("height: %dpx", h),
      sprintf("height %dpx", h)
    ))
  })
)

## card
el_carousel(
  "car_card",
  interval = 4000,
  type = "card",
  height = "200px",
  items = lapply(1:6, function(i) el_carousel_item(tags$h3(i)))
)

## vertical
slides <- function(n) {
  lapply(seq_len(n), function(i) el_carousel_item(tags$h3(i)))
}
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
