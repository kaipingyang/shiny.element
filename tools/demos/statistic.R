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
#' `input$<id>_finish` fires at zero.
el_row(
  el_col(
    span = 8,
    el_countdown(title = "Start to grab", value = Sys.time() + 1000)
  ),
  el_col(
    span = 8,
    el_countdown(
      title = "Remaining VIP time",
      format = "HH:mm:ss",
      value = Sys.time() + 60 * 60 * 24 * 2
    )
  ),
  el_col(
    span = 8,
    el_countdown(
      format = "DD [days] HH:mm:ss",
      value = Sys.time() + 60 * 60 * 24 * 7,
      slots = list(title = "Next month")
    )
  )
)

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
