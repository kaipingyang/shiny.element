## basic-usage
item <- function(i) {
  tags$p(
    class = "scrollbar-demo-item",
    style = paste(
      "display: flex; align-items: center; justify-content: center; height: 50px; margin: 10px;",
      "text-align: center; border-radius: 4px; background: var(--el-color-primary-light-9);",
      "color: var(--el-color-primary)"
    ),
    i
  )
}
el_scrollbar(height = "400px", lapply(1:20, item))

## horizontal-scroll
item <- function(i) {
  tags$p(
    style = paste(
      "flex-shrink: 0; display: flex; align-items: center; justify-content: center; width: 100px;",
      "height: 50px; margin: 10px; border-radius: 4px; background: var(--el-color-danger-light-9);",
      "color: var(--el-color-danger)"
    ),
    i
  )
}
el_scrollbar(tags$div(style = "display: flex", lapply(1:50, item)))

## max-height
item <- function(i) {
  tags$p(
    style = paste(
      "display: flex; align-items: center; justify-content: center; height: 50px; margin: 10px;",
      "border-radius: 4px; background: var(--el-color-primary-light-9); color: var(--el-color-primary)"
    ),
    i
  )
}
el_scrollbar(max_height = "400px", lapply(1:3, item))

## manual-scroll
#' `el_call(session, "sb", "setScrollTop", list(200))` scrolls it from the
#' server; `input$<id>_scroll` reports where it is.
item <- function(i) {
  tags$p(
    style = paste(
      "display: flex; align-items: center; justify-content: center; height: 50px; margin: 10px;",
      "border-radius: 4px; background: var(--el-color-primary-light-9); color: var(--el-color-primary)"
    ),
    i
  )
}
el_scrollbar(id = "sb", height = "400px", always = TRUE, lapply(1:20, item))

## infinite-scroll
#' Reaching an end is `input$<id>_end_reached`: `"bottom"`, `"top"`, ...
item <- function(i) {
  tags$p(
    style = paste(
      "display: flex; align-items: center; justify-content: center; height: 50px; margin: 10px;",
      "border-radius: 4px; background: var(--el-color-primary-light-9); color: var(--el-color-primary)"
    ),
    i
  )
}
el_scrollbar(id = "sb_more", height = "400px", lapply(1:30, item))
