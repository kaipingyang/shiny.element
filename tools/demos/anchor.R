## basic
#' The links point at this page's own sections.
el_anchor(
  "toc",
  offset = 70,
  links = list(
    el_anchor_link("Basic Usage", "#basic-usage"),
    el_anchor_link("Horizontal Mode", "#horizontal-mode"),
    el_anchor_link("Scroll Container", "#scroll-container"),
    el_anchor_link(
      "Anchor API",
      "#api",
      el_anchor_link("Anchor Attributes", "#anchor-attributes"),
      el_anchor_link("Anchor Events", "#anchor-events")
    )
  )
)

## horizontal
el_anchor(
  "toc_h",
  offset = 70,
  direction = "horizontal",
  links = list(
    el_anchor_link("Basic Usage", "#basic-usage"),
    el_anchor_link("Horizontal Mode", "#horizontal-mode"),
    el_anchor_link("Scroll Container", "#scroll-container")
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
        el_anchor_link("part1", "#part1"),
        el_anchor_link("part2", "#part2"),
        el_anchor_link("part3", "#part3")
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
    el_anchor_link("Basic Usage", "#basic-usage"),
    el_anchor_link("Horizontal Mode", "#horizontal-mode"),
    el_anchor_link("Scroll Container", "#scroll-container")
  )
)

## underline
el_anchor(
  "toc_u",
  type = "underline",
  offset = 70,
  links = list(
    el_anchor_link("Basic Usage", "#basic-usage"),
    el_anchor_link("Horizontal Mode", "#horizontal-mode"),
    el_anchor_link("Scroll Container", "#scroll-container")
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
      el_anchor_link("Basic Usage", "#basic-usage"),
      el_anchor_link("Horizontal Mode", "#horizontal-mode"),
      el_anchor_link("Scroll Container", "#scroll-container")
    )
  )
)
