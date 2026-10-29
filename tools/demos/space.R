## basic
card <- function(i) {
  el_card(
    style = "width: 250px",
    header = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$span("Card name"),
      el_button(label = "Operation button", text = TRUE)
    ),
    lapply(1:4, function(o) tags$div(paste("List item", o)))
  )
}
el_space(wrap = TRUE, lapply(1:3, card))

## vertical-layout
card <- function(i) {
  el_card(
    style = "width: 250px",
    header = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$span("Card name"),
      el_button(label = "Operation button", text = TRUE)
    ),
    lapply(1:4, function(o) tags$div(paste("List item", o)))
  )
}
el_space(direction = "vertical", lapply(1:2, card))

## control-size
#' The radios set the inner space's `size`, which follows them in the
#' browser, [vue_bind()].
#| shot_js = "document.querySelectorAll('#sp_size .el-radio')[0].click()"
#| shot_expect = "document.querySelector('#sp_cards .el-space').style.gap === '16px'"
card <- function(i) {
  el_card(
    style = "width: 250px",
    header = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$span("Card name"),
      el_button(label = "Operation button", text = TRUE)
    ),
    lapply(1:4, function(o) tags$div(paste("List item", o)))
  )
}
tags$div(
  style = "display: flex; flex-direction: column; align-items: flex-start; gap: 30px",
  el_radio_group(
    "sp_size",
    choices = c(Large = "large", Default = "default", Small = "small"),
    selected = "default"
  ),
  el_space(
    id = "sp_cards",
    wrap = TRUE,
    size = vue_bind("$inputs.sp_size"),
    lapply(1:3, card)
  )
)

## customized-size
#' The slider sets the space's `size` in pixels.
#| shot_js = "Shiny.setInputValue('sp_px', 60)"
#| shot_expect = "document.querySelector('#sp_px_cards .el-space').style.gap === '60px'"
card <- function(i) {
  el_card(
    style = "width: 250px",
    header = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$span("Card name"),
      el_button(label = "Operation button", text = TRUE)
    ),
    lapply(1:4, function(o) tags$div(paste("List item", o)))
  )
}
el_slider("sp_px", value = 20)
el_space(
  id = "sp_px_cards",
  wrap = TRUE,
  size = vue_bind("$inputs.sp_px"),
  lapply(1:2, card)
)

## auto-wrapping
el_space(
  wrap = TRUE,
  lapply(1:20, function(i) {
    tags$div(el_button(label = "Text button", text = TRUE))
  })
)

## literal-type-spacer
el_space(
  size = 10,
  spacer = "|",
  lapply(1:2, function(i) tags$div(el_button(label = paste("button", i))))
)

## vnode-type-spacer
#' A spacer can be a VNode too, built in the browser from `JS()` code.
el_space(
  size = 10,
  spacer = JS("Vue.h(ElementPlus.ElDivider, { direction: 'vertical' })"),
  lapply(1:2, function(i) tags$div(el_button(label = paste("button", i))))
)

## alignment
box <- function(alignment = NULL) {
  tags$div(
    class = "alignment-container",
    el_space(
      alignment = alignment,
      "string",
      el_button(label = "button"),
      el_card(header = "header", "body")
    )
  )
}
tagList(
  tags$style(
    ".alignment-container { width: 240px; margin-bottom: 20px; padding: 8px;
       border: 1px solid var(--el-border-color); }"
  ),
  box(),
  box("flex-start"),
  box("flex-end")
)

## fill
#' The switch sets `fill`, which follows it in the browser, [vue_bind()].
#| shot_js = "document.querySelector('#sp_fill_on .el-switch').click()"
#| shot_expect = "!document.querySelector('#sp_fill .el-space').classList.contains('is-fill') && !document.querySelector('#sp_fill .el-space__item').style.flexGrow"
card <- function(i) {
  el_card(
    header = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$span("Card name"),
      el_button(label = "Operation button", text = TRUE)
    ),
    lapply(1:4, function(o) tags$div(paste("List item", o)))
  )
}
tags$div(
  style = "margin-bottom: 15px",
  "fill: ",
  el_switch("sp_fill_on", value = TRUE)
)
el_space(
  id = "sp_fill",
  fill = vue_bind("$inputs.sp_fill_on"),
  wrap = TRUE,
  lapply(1:3, card)
)

## fill-ratio
#' The radios set `direction`, the slider `fill_ratio`, each followed in
#' the browser, [vue_bind()].
#| shot_js = c("Shiny.setInputValue('sp_ratio', 50)", "document.querySelectorAll('#sp_dir .el-radio')[1].click()")
#| shot_expect = c("document.querySelector('#sp_ratio_cards .el-space').classList.contains('el-space--vertical')", "document.querySelector('#sp_ratio_cards .el-space__item').style.minWidth === '50%'")
card <- function(i) {
  el_card(
    header = tags$div(
      style = "display: flex; justify-content: space-between; align-items: center",
      tags$span("Card name"),
      el_button(label = "Operation button", text = TRUE)
    ),
    lapply(1:4, function(o) tags$div(paste("List item", o)))
  )
}
tags$div(
  style = "margin-bottom: 15px",
  "direction: ",
  el_radio_group(
    "sp_dir",
    choices = c("horizontal", "vertical"),
    selected = "horizontal"
  )
)
tags$div(
  style = "margin-bottom: 15px",
  "fillRatio:",
  el_slider("sp_ratio", value = 30)
)
el_space(
  id = "sp_ratio_cards",
  fill = TRUE,
  wrap = TRUE,
  fill_ratio = vue_bind("$inputs.sp_ratio"),
  direction = vue_bind("$inputs.sp_dir"),
  width = "100%",
  lapply(1:5, card)
)
