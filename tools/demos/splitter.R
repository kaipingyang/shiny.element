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
#' The switch makes the panels collapsible or not, each by its own id with
#' `update_el_splitter_panel()` -- the inner splitter's too.
#| shot_js = c("window.icons = document.querySelectorAll('.el-splitter-bar__collapse-icon').length", "document.querySelector('#spl_collapsible .el-switch').click()")
#| shot_expect = c("window.icons > 0", "document.querySelectorAll('.el-splitter-bar__collapse-icon').length === 0")
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
collapsible <- c("spl_p1", "spl_p2", "spl_p4", "spl_p4a", "spl_p4b")
ui <- el_page(
  tags$div(
    style = "margin-bottom: 8px",
    el_switch(
      "spl_collapsible",
      value = TRUE,
      active_text = "enable",
      inactive_text = "disable",
      inline_prompt = TRUE
    )
  ),
  tags$div(
    style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
    el_splitter(
      el_splitter_panel(id = "spl_p1", collapsible = TRUE, min = 50, panel(1)),
      el_splitter_panel(id = "spl_p2", collapsible = TRUE, panel(2)),
      el_splitter_panel(panel(3)),
      el_splitter_panel(
        id = "spl_p4",
        collapsible = TRUE,
        el_splitter(
          layout = "vertical",
          el_splitter_panel(id = "spl_p4a", collapsible = TRUE, panel(4)),
          el_splitter_panel(id = "spl_p4b", collapsible = TRUE, panel(5))
        )
      )
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$spl_collapsible, ignoreInit = TRUE, {
    for (id in collapsible) {
      update_el_splitter_panel(session, id, collapsible = input$spl_collapsible)
    }
  })
}
shinyApp(ui, server)

## disableDrag
#' The switch lets the middle panel be dragged or not, with
#' `update_el_splitter_panel(resizable =)`.
#| shot_js = c("window.locked = document.querySelectorAll('.el-splitter-bar__dragger.is-disabled').length", "document.querySelector('#spl_resizable .el-switch').click()")
#| shot_expect = c("window.locked === 2", "document.querySelectorAll('.el-splitter-bar__dragger.is-disabled').length === 0", "document.querySelector('#spl_drag').innerText === 'drag enable'")
panel <- function(x) {
  tags$div(
    style = "display: flex; align-items: center; justify-content: center; height: 100%",
    x
  )
}
ui <- el_page(
  tags$div(
    style = "margin-bottom: 8px",
    el_switch(
      "spl_resizable",
      value = FALSE,
      active_text = "enable",
      inactive_text = "disable",
      inline_prompt = TRUE
    )
  ),
  tags$div(
    style = "height: 250px; box-shadow: var(--el-border-color-light) 0px 0px 10px",
    el_splitter(
      el_splitter_panel(panel(1)),
      el_splitter_panel(
        id = "spl_middle",
        resizable = FALSE,
        panel(uiOutput("spl_drag"))
      ),
      el_splitter_panel(panel(3))
    )
  )
)
server <- function(input, output, session) {
  output$spl_drag <- renderUI({
    paste("drag", if (isTRUE(input$spl_resizable)) "enable" else "disable")
  })
  observeEvent(input$spl_resizable, ignoreInit = TRUE, {
    update_el_splitter_panel(
      session,
      "spl_middle",
      resizable = input$spl_resizable
    )
  })
}
shinyApp(ui, server)

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
