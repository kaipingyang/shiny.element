## date-and-time
#| shot_js = "document.querySelector('#dtp2 input').focus()"
#| shot_sel = ".el-picker__popper"
#| shot_expect = "Array.from(document.querySelectorAll('.el-picker__popper')).filter(function(x) { return x.offsetParent; })[0].querySelectorAll('.el-picker-panel__shortcut').length === 3"
block <- function(title, picker) {
  tags$div(class = "block", tags$span(class = "demonstration", title), picker)
}
tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block(
      "Default",
      el_date_picker(
        "dtp1",
        type = "datetime",
        placeholder = "Select date and time"
      )
    ),
    block(
      "With shortcuts",
      el_date_picker(
        "dtp2",
        type = "datetime",
        placeholder = "Select date and time",
        shortcuts = list(
          list(text = "Today", value = JS("new Date()")),
          list(
            text = "Yesterday",
            value = JS(
              "function() { var d = new Date(); d.setDate(d.getDate() - 1); return d; }"
            )
          ),
          list(
            text = "A week ago",
            value = JS(
              "function() { var d = new Date(); d.setDate(d.getDate() - 7); return d; }"
            )
          )
        )
      )
    ),
    block(
      "With default time",
      el_date_picker(
        "dtp3",
        type = "datetime",
        placeholder = "Select date and time",
        default_time = JS("new Date(2000, 1, 1, 12, 0, 0)")
      )
    )
  )
)

## date-and-time-formats
#' What each picker reports is `input$<id>`: in the format `value_format`
#' names, `"x"` a timestamp. `format` is what the box shows.
#| shot_js = c("document.querySelector('#dtp_fmt3 input').focus()", "var p = Array.from(document.querySelectorAll('.el-picker__popper')).filter(function(x) { return x.offsetParent; })[0]; p.querySelector('.el-date-table td.available').click(); p.querySelector('.el-picker-panel__footer .is-plain').click()")
#| shot_expect = c("/^Value: \\d{13}$/.test(document.querySelector('#dtp_fmt3_value').innerText)", "/^\\d{4}\\/\\d\\d\\/\\d\\d \\d\\d:\\d\\d:\\d\\d$/.test(document.querySelector('#dtp_fmt3 input').value)")
block <- function(title, id, ...) {
  tags$div(
    class = "block",
    tags$span(class = "demonstration", title),
    tags$div(class = "demonstration", textOutput(paste0(id, "_value"))),
    el_date_picker(id, type = "datetime", placeholder = "Pick a Date", ...)
  )
}
ui <- el_page(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block("Default value format", "dtp_fmt1", format = "YYYY/MM/DD HH:mm:ss"),
    block(
      "Use value-format",
      "dtp_fmt2",
      format = "YYYY/MM/DD hh:mm:ss",
      value_format = "YYYY-MM-DD h:m:s a"
    ),
    block(
      "Timestamp",
      "dtp_fmt3",
      format = "YYYY/MM/DD hh:mm:ss",
      value_format = "x"
    )
  )
)
server <- function(input, output, session) {
  for (id in c("dtp_fmt1", "dtp_fmt2", "dtp_fmt3")) {
    local({
      id <- id
      output[[paste0(id, "_value")]] <- renderText({
        paste("Value:", format(input[[id]], scientific = FALSE))
      })
    })
  }
}
shinyApp(ui, server)

## date-and-time-formats-panel
#| shot_js = "document.querySelector('#dtp_fmt_range input').focus()"
#| shot_sel = ".el-picker__popper"
tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap;
       justify-content: space-around; align-items: stretch; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       min-width: 300px; flex: 1; }
     .demo-datetime-picker .line { width: 1px; background-color: var(--el-border-color); }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_fmt_panel",
        type = "datetime",
        placeholder = "Pick a Date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "MMM DD, YYYY",
        time_format = "HH:mm"
      )
    ),
    tags$div(class = "line"),
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_fmt_range",
        type = "datetimerange",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "YYYY/MM/DD ddd",
        time_format = "A hh:mm:ss"
      )
    )
  )
)

## date-and-time-range
#| shot_js = "document.querySelector('#dtp_range_quick input').focus()"
#| shot_sel = ".el-picker__popper"
#| shot_expect = "document.querySelector('#dtp_range input').value === '2000-11-10 10:10:00'"
block <- function(title, picker) {
  tags$div(class = "block", tags$span(class = "demonstration", title), picker)
}
range_back <- function(text, step) {
  list(
    text = text,
    value = JS(sprintf(
      "function() { var e = new Date(), s = new Date(); %s; return [s, e]; }",
      step
    ))
  )
}
tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block(
      "Default",
      el_date_picker(
        "dtp_range",
        type = "datetimerange",
        value = c("2000-11-10 10:10:00", "2000-11-11 10:10:00"),
        range_separator = "To",
        start_placeholder = "Start date",
        end_placeholder = "End date"
      )
    ),
    block(
      "With shortcuts",
      el_date_picker(
        "dtp_range_quick",
        type = "datetimerange",
        range_separator = "To",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        shortcuts = list(
          range_back("Last week", "s.setDate(s.getDate() - 7)"),
          range_back("Last month", "s.setMonth(s.getMonth() - 1)"),
          range_back("Last 3 months", "s.setMonth(s.getMonth() - 3)")
        )
      )
    )
  )
)

## single-panel
#| shot_js = "document.querySelector('#dtp_single input').focus()"
#| shot_sel = ".el-picker__popper"
tags$div(
  style = "padding: 30px 0; text-align: center",
  tags$span(
    style = "display: block; margin-bottom: 20px; color: var(--el-text-color-secondary); font-size: 14px",
    "single-panel"
  ),
  el_date_picker("dtp_single", type = "datetimerange", single_panel = TRUE)
)

## default-time
#| shot_js = c("document.querySelector('#dtp_dt2 input').focus()", "var p = Array.from(document.querySelectorAll('.el-picker__popper')).filter(function(x) { return x.offsetParent; })[0]; p.querySelectorAll('.el-date-table td.available')[2].click()", "var p = Array.from(document.querySelectorAll('.el-picker__popper')).filter(function(x) { return x.offsetParent; })[0]; p.querySelectorAll('.el-date-table td.available')[4].click()", "var p = Array.from(document.querySelectorAll('.el-picker__popper')).filter(function(x) { return x.offsetParent; })[0]; p.querySelector('.el-picker-panel__footer .is-plain').click()")
#| shot_expect = "/12:00:00.*08:00:00/.test(Array.from(document.querySelectorAll('#dtp_dt2 input')).map(function(i) { return i.value; }).join(' '))"
block <- function(title, picker) {
  tags$div(class = "block", tags$span(class = "demonstration", title), picker)
}
tagList(
  tags$style(
    ".demo-datetime-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-datetime-picker .block { padding: 30px 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-datetime-picker .block:last-child { border-right: none; }
     .demo-datetime-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  tags$div(
    class = "demo-datetime-picker",
    block(
      "Start and end date time 12:00:00",
      el_date_picker(
        "dtp_dt1",
        type = "datetimerange",
        start_placeholder = "Start Date",
        end_placeholder = "End Date",
        default_time = JS("new Date(2000, 1, 1, 12, 0, 0)")
      )
    ),
    block(
      "Start date time 12:00:00, end date time 08:00:00",
      el_date_picker(
        "dtp_dt2",
        type = "datetimerange",
        start_placeholder = "Start Date",
        end_placeholder = "End Date",
        default_time = list(
          JS("new Date(2000, 1, 1, 12, 0, 0)"),
          JS("new Date(2000, 2, 1, 8, 0, 0)")
        )
      )
    )
  )
)

## custom-icon
#| shot_js = "document.querySelector('#dtp_icons_range input').focus()"
#| shot_sel = ".el-picker__popper"
#| shot_expect = "document.querySelectorAll('.el-picker__popper [data-el-icon=Back]').length >= 2"
arrows <- list(
  `prev-month` = el_icon("CaretLeft"),
  `next-month` = el_icon("CaretRight"),
  `prev-year` = el_icon("Back"),
  `next-year` = el_icon("Right")
)
tagList(
  tags$style(
    ".demo-datetime-picker-icon { display: flex; width: 100%; flex-wrap: wrap;
       justify-content: space-around; align-items: stretch; }
     .demo-datetime-picker-icon .block { padding: 30px 0; text-align: center;
       min-width: 300px; flex: 1; }
     .demo-datetime-picker-icon .line { width: 1px; background-color: var(--el-border-color); }"
  ),
  tags$div(
    class = "demo-datetime-picker-icon",
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_icons",
        type = "datetime",
        placeholder = "Pick a Date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "MMM DD, YYYY",
        time_format = "HH:mm",
        slots = arrows
      )
    ),
    tags$div(class = "line"),
    tags$div(
      class = "block",
      el_date_picker(
        "dtp_icons_range",
        type = "datetimerange",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        format = "YYYY-MM-DD HH:mm:ss",
        date_format = "YYYY/MM/DD ddd",
        time_format = "A hh:mm:ss",
        unlink_panels = TRUE,
        slots = arrows
      )
    )
  )
)
