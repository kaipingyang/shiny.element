## basic
el_watermark(
  content = "Element Plus",
  font = list(color = "rgba(0, 0, 0, .15)"),
  tags$div(style = "height: 500px")
)

## multi-line
#' Several lines: `content` is a vector.
el_watermark(
  content = c("Element+", "Element Plus"),
  font = list(color = "rgba(0, 0, 0, .15)"),
  tags$div(style = "height: 500px")
)

## image
#' `image` draws a picture instead of text; `watermark_width` and `height`
#' size it (`width` is the box's).
el_watermark(
  watermark_width = 130,
  height = 30,
  image = "https://element-plus.org/images/element-plus-logo.svg",
  tags$div(style = "height: 500px")
)

## custom
#' Its settings from the controls: each control's value is a store's
#' field, [vue_bind()], and the watermark's `font` and `gap` getters built
#' from them, so it changes as they do, in the browser.
vue_store(
  "wm",
  state = list(
    content = "Element Plus",
    color = "rgba(0, 0, 0, 0.15)",
    size = 16,
    rotate = -22,
    gap = 100
  ),
  getters = list(
    font = JS("function(s) { return { fontSize: s.size, color: s.color }; }"),
    gaps = JS("function(s) { return [s.gap, s.gap]; }")
  )
)
el_row(
  el_col(
    span = 14,
    el_watermark(
      content = vue_bind("$store.wm.content"),
      rotate = vue_bind("$store.wm.rotate"),
      gap = vue_bind("$store.wm.gaps"),
      font = vue_bind("$store.wm.font"),
      tags$div(
        style = "padding: 40px 20px; height: 360px",
        tags$h1("Element Plus"),
        tags$h2("A Vue 3 based component library for designers and developers")
      )
    )
  ),
  el_col(
    span = 10,
    el_input(
      "content",
      label = "Content",
      value = vue_bind("$store.wm.content")
    ),
    el_color_picker(
      "color",
      label = "Color",
      value = vue_bind("$store.wm.color"),
      show_alpha = TRUE
    ),
    el_slider(
      "size",
      label = "FontSize",
      value = vue_bind("$store.wm.size"),
      min = 8,
      max = 40
    ),
    el_slider(
      "rotate",
      label = "Rotate",
      value = vue_bind("$store.wm.rotate"),
      min = -180,
      max = 180
    ),
    el_input_number("gap", label = "Gap", value = vue_bind("$store.wm.gap"))
  )
)
