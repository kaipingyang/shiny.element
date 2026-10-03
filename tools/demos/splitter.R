## basic
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
tags$div(
  style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(
    el_splitter_panel(size = "30%", panel(1)),
    el_splitter_panel(panel(2))
  )
)

## vertical
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
tags$div(
  style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(
    layout = "vertical",
    el_splitter_panel(panel(1)),
    el_splitter_panel(panel(2))
  )
)

## collapsible
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
tags$div(
  style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(
    el_splitter_panel(collapsible = TRUE, min = 50, panel(1)),
    el_splitter_panel(collapsible = TRUE, panel(2)),
    el_splitter_panel(panel(3))
  )
)

## disableDrag
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
tags$div(
  style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(
    el_splitter_panel(resizable = FALSE, panel(1)),
    el_splitter_panel(panel(2))
  )
)

## size
#' Dragging reports `input$<id>_resize_start`, `_resize` and `_resize_end`.
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
tags$div(
  style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(
    id = "split_size",
    el_splitter_panel(size = "200px", panel(1)),
    el_splitter_panel(panel(2))
  )
)

## lazy
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
tags$div(
  style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
  el_splitter(
    lazy = TRUE,
    el_splitter_panel(panel(1)),
    el_splitter_panel(panel(2))
  )
)
