## basic
el_row(
  el_col(span = 6, el_statistic(title = "Daily active users", value = 268500)),
  el_col(
    span = 6,
    el_statistic(
      value = 138,
      slots = list(
        title = tags$div(
          style = "display: inline-flex; align-items: center",
          "Ratio of men to women ",
          el_icon("Warning", size = "12px")
        ),
        suffix = "/100"
      )
    )
  ),
  el_col(span = 6, el_statistic(title = "Total Transactions", value = 172000)),
  el_col(
    span = 6,
    el_statistic(
      title = "Feedback number",
      value = 562,
      slots = list(suffix = el_icon("ChatLineRound"))
    )
  )
)

## countdown
#' `input$<id>_finish` fires at zero. Reset sets the second one's `value`
#' again, with `update_el_countdown()`.
#| shot_js = "document.querySelector('#cd_reset button').click()"
#| shot_expect = "/^4[78]:/.test(document.querySelectorAll('.el-statistic__number')[1].innerText.trim())"
next_month <- as.POSIXct(
  format(seq(Sys.Date(), by = "month", length.out = 2)[2], "%Y-%m-01")
)
col <- function(...) {
  el_col(
    xs = 24,
    sm = 12,
    md = 8,
    style = "text-align: center; margin-bottom: 16px",
    ...
  )
}
ui <- el_page(
  el_row(
    gutter = 16,
    col(el_countdown(
      "cd_grab",
      title = "Start to grab",
      value = Sys.time() + 60 * 60 * 7
    )),
    col(
      el_countdown(
        "cd_vip",
        title = "Remaining VIP time",
        format = "HH:mm:ss",
        value = Sys.time() + 60 * 60 * 24 * 2 - 60 * 60
      ),
      tags$div(
        style = "margin-top: 8px",
        el_button("cd_reset", "Reset", type = "primary")
      )
    ),
    col(
      el_countdown(
        "cd_month",
        format = "DD [days] HH:mm:ss",
        value = next_month,
        slots = list(
          title = tags$div(
            style = "display: inline-flex; align-items: center",
            el_icon("Calendar", size = 12, style = "margin-right: 4px"),
            "Still to go until next month"
          )
        )
      ),
      tags$div(style = "margin-top: 8px", format(next_month, "%Y-%m-%d"))
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$cd_reset, {
    update_el_countdown(
      session,
      "cd_vip",
      value = Sys.time() + 60 * 60 * 24 * 2
    )
  })
}
shinyApp(ui, server)

## card
card <- function(title, value, delta, up) {
  el_col(
    span = 8,
    tags$div(
      style = paste(
        "height: 100%; padding: 16px; border-radius: 4px; background: var(--el-bg-color-overlay)"
      ),
      el_statistic(title = title, value = value),
      tags$div(
        style = "font-size: 12px; color: var(--el-text-color-regular); margin-top: 16px",
        "than yesterday ",
        tags$span(
          style = sprintf(
            "color: var(--el-color-%s)",
            if (up) "success" else "error"
          ),
          delta,
          el_icon(if (up) "CaretTop" else "CaretBottom")
        )
      )
    )
  )
}
el_row(
  gutter = 16,
  card("Daily active users", 98500, "24%", TRUE),
  card("Monthly Active Users", 693700, "12%", FALSE),
  card("New transactions today", 72000, "16%", TRUE)
)
