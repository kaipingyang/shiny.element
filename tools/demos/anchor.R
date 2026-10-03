## basic
#' The links point at this page's own sections.
el_anchor(
  "toc",
  offset = 70,
  links = list(
    list(title = "Basic Usage", href = "#basic-usage"),
    list(title = "Horizontal Mode", href = "#horizontal-mode"),
    list(title = "Scroll Container", href = "#scroll-container"),
    list(
      title = "Anchor API",
      href = "#api",
      children = list(
        list(title = "Anchor Attributes", href = "#anchor-attributes"),
        list(title = "Anchor Events", href = "#anchor-events")
      )
    )
  )
)

## horizontal
el_anchor(
  "toc_h",
  offset = 70,
  direction = "horizontal",
  links = list(
    list(title = "Basic Usage", href = "#basic-usage"),
    list(title = "Horizontal Mode", href = "#horizontal-mode"),
    list(title = "Scroll Container", href = "#scroll-container")
  )
)

## scroll
part <- function(id, colour) {
  tags$div(
    id = id,
    style = sprintf("height: 300px; background: %s; margin-top: 30px", colour),
    id
  )
}
el_row(
  el_col(
    span = 18,
    tags$div(
      id = "anchor-scroller",
      style = "height: 300px; overflow-y: auto",
      part("part1", "rgba(255, 0, 0, 0.02)"),
      part("part2", "rgba(0, 255, 0, 0.02)"),
      part("part3", "rgba(0, 0, 255, 0.02)")
    )
  ),
  el_col(
    span = 6,
    el_anchor(
      "toc_s",
      container = "#anchor-scroller",
      links = list(
        list(title = "part1", href = "#part1"),
        list(title = "part2", href = "#part2"),
        list(title = "part3", href = "#part3")
      )
    )
  )
)

## change
#' The current link is `input$<id>`, as the page scrolls.
el_anchor(
  "toc_change",
  offset = 70,
  links = list(
    list(title = "Basic Usage", href = "#basic-usage"),
    list(title = "Horizontal Mode", href = "#horizontal-mode"),
    list(title = "Scroll Container", href = "#scroll-container")
  )
)

## underline
el_anchor(
  "toc_u",
  type = "underline",
  offset = 70,
  links = list(
    list(title = "Basic Usage", href = "#basic-usage"),
    list(title = "Horizontal Mode", href = "#horizontal-mode"),
    list(title = "Scroll Container", href = "#scroll-container")
  )
)

## affix
el_affix(
  offset = 60,
  el_anchor(
    "toc_a",
    offset = 70,
    width = "300px",
    links = list(
      list(title = "Basic Usage", href = "#basic-usage"),
      list(title = "Horizontal Mode", href = "#horizontal-mode"),
      list(title = "Scroll Container", href = "#scroll-container")
    )
  )
)
