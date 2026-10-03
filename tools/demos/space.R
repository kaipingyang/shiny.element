## basic
card <- function(i) {
  el_card(
    width = "250px",
    header = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$span("Card name"),
      el_button(paste0("sp_op", i), "Operation button", text = TRUE)
    ),
    lapply(1:4, function(o) tags$div(paste("List item", o)))
  )
}
el_space(wrap = TRUE, lapply(1:3, card))

## vertical-layout
card <- function(i) {
  el_card(
    width = "250px",
    header = "Card name",
    lapply(1:2, function(o) tags$div(paste("List item", o)))
  )
}
el_space(direction = "vertical", lapply(1:2, card))

## control-size
card <- function(i) {
  el_card(width = "250px", header = "Card name", tags$div("List item"))
}
el_space(
  direction = "vertical",
  alignment = "start",
  size = 30,
  el_space(size = "large", lapply(1:2, card))
)

## customized-size
card <- function(i) {
  el_card(width = "250px", header = "Card name", tags$div("List item"))
}
el_space(wrap = TRUE, size = 20, lapply(1:2, card))

## auto-wrapping
el_space(
  wrap = TRUE,
  lapply(1:20, function(i) {
    el_button(paste0("sp_w", i), "Text button", text = TRUE)
  })
)

## literal-type-spacer
el_space(
  size = 10,
  spacer = "|",
  el_button("sp_l1", "button 1"),
  el_button("sp_l2", "button 2")
)

## vnode-type-spacer
#' A spacer can be a VNode too, built in the browser from `JS()` code.
el_space(
  size = 10,
  spacer = JS("Vue.h(ElementPlus.ElDivider, { direction: 'vertical' })"),
  el_button("sp_v1", "button 1"),
  el_button("sp_v2", "button 2")
)

## alignment
tags$div(
  style = "width: 240px; margin-bottom: 8px; padding: 8px; border: 1px solid var(--el-border-color)",
  el_space(
    "string",
    el_button("sp_a", "button"),
    el_card(header = "header", "body")
  )
)

## fill
el_space(
  fill = TRUE,
  wrap = TRUE,
  lapply(1:3, function(i) el_card(header = "Card name", "List item"))
)

## fill-ratio
el_space(
  fill = TRUE,
  fill_ratio = 30,
  wrap = TRUE,
  lapply(1:5, function(i) el_card(header = "Card name", "List item"))
)
