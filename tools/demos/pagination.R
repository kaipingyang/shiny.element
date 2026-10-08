## basic-usage
tagList(
  tags$div(
    tags$div(style = "margin-bottom: 16px", "When you have few pages"),
    el_pagination("pg1", layout = "prev, pager, next", total = 50)
  ),
  tags$div(
    style = "margin-top: 10px",
    tags$div(style = "margin-bottom: 16px", "When you have more than 7 pages"),
    el_pagination("pg2", layout = "prev, pager, next", total = 1000)
  )
)

## number-of-pagers
el_pagination(
  "pg_pagers",
  page_size = 20,
  pager_count = 11,
  layout = "prev, pager, next",
  total = 1000
)

## background-color
el_pagination(
  "pg_bg",
  background = TRUE,
  layout = "prev, pager, next",
  total = 1000
)

## small-pagination
tagList(
  el_pagination(
    "pg_s1",
    size = "small",
    layout = "prev, pager, next",
    total = 50
  ),
  tags$div(
    style = "margin-top: 16px",
    el_pagination(
      "pg_s2",
      size = "small",
      background = TRUE,
      layout = "prev, pager, next",
      total = 50
    )
  )
)

## auto-hide-pagination
#' The switch sets `hide_on_single_page` with `update_el_pagination()`.
#| shot_js = "document.querySelector('#pg_hide_on .el-switch').click()"
#| shot_expect = "!document.querySelector('#pg_hide .el-pagination')"
ui <- el_page(
  el_switch("pg_hide_on", value = FALSE),
  tags$hr(style = "margin: 16px 0"),
  el_pagination(
    "pg_hide",
    hide_on_single_page = FALSE,
    total = 5,
    layout = "prev, pager, next"
  )
)
server <- function(input, output, session) {
  observeEvent(input$pg_hide_on, ignoreInit = TRUE, {
    update_el_pagination(
      session,
      "pg_hide",
      hide_on_single_page = input$pg_hide_on
    )
  })
}
shinyApp(ui, server)

## more-elements
#' The controls set every pagination's `size`, `background` and `disabled`
#' with `update_el_pagination()`.
#| shot_js = c("document.querySelectorAll('#pg_size .el-radio-button')[1].click()", "document.querySelector('#pg_background .el-switch').click()")
#| shot_expect = c("document.querySelectorAll('.el-pagination--large').length === 4", "document.querySelectorAll('.el-pagination.is-background').length === 4")
ids <- c("pg_m1", "pg_m2", "pg_m3", "pg_m4")
block <- function(title, ...) {
  tags$div(
    class = "demo-pagination-block",
    tags$div(class = "demonstration", title),
    el_pagination(...)
  )
}
ui <- el_page(
  tags$style(
    ".demo-pagination-block + .demo-pagination-block { margin-top: 10px; }
     .demo-pagination-block .demonstration { margin-bottom: 16px; }"
  ),
  tags$div(
    style = "display: flex; align-items: center; gap: 16px; margin-bottom: 16px",
    el_radio_group(
      "pg_size",
      choices = c("default", "large", "small"),
      selected = "default",
      button = TRUE
    ),
    tags$div("background: ", el_switch("pg_background", value = FALSE)),
    tags$div("disabled: ", el_switch("pg_disabled", value = FALSE))
  ),
  tags$hr(style = "margin: 16px 0"),
  block(
    "Total item count",
    "pg_m1",
    current_page = 5,
    page_size = 100,
    layout = "total, prev, pager, next",
    total = 1000
  ),
  block(
    "Change page size",
    "pg_m2",
    current_page = 5,
    page_size = 100,
    page_sizes = c(100, 200, 300, 400),
    layout = "sizes, prev, pager, next",
    total = 1000
  ),
  block(
    "Jump to",
    "pg_m3",
    current_page = 5,
    page_size = 100,
    layout = "prev, pager, next, jumper",
    total = 1000
  ),
  block(
    "All combined",
    "pg_m4",
    current_page = 4,
    page_size = 100,
    page_sizes = c(100, 200, 300, 400),
    layout = "total, sizes, prev, pager, next, jumper",
    total = 400
  )
)
server <- function(input, output, session) {
  observe({
    for (id in ids) {
      update_el_pagination(
        session,
        id,
        size = input$pg_size,
        background = isTRUE(input$pg_background),
        disabled = isTRUE(input$pg_disabled)
      )
    }
  })
}
shinyApp(ui, server)
