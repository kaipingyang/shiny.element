## enter-date
#' The radio buttons resize both pickers with `update_el_date_picker(size
#' =)`.
#| shot_js = "document.querySelectorAll('#dp_size .el-radio-button')[0].click()"
#| shot_expect = "document.querySelectorAll('.demo-date-picker .el-input--large').length === 2"
ui <- el_page(
  tags$style(
    ".demo-date-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-date-picker .block { padding: 1.5rem 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-date-picker .block:last-child { border-right: none; }
     .demo-date-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  el_radio_group(
    "dp_size",
    choices = c("large", "default", "small"),
    selected = "default",
    button = TRUE
  ),
  tags$div(
    class = "demo-date-picker",
    tags$div(
      class = "block",
      tags$span(class = "demonstration", "Default"),
      el_date_picker("dp_default", placeholder = "Pick a day")
    ),
    tags$div(
      class = "block",
      tags$span(class = "demonstration", "Picker with quick options"),
      el_date_picker(
        "dp_quick",
        placeholder = "Pick a day",
        shortcuts = list(
          list(text = "Today", value = JS("new Date()")),
          list(
            text = "Yesterday",
            value = JS(
              "function() { var d = new Date(); d.setTime(d.getTime() - 3600 * 1000 * 24); return d; }"
            )
          ),
          list(
            text = "A week ago",
            value = JS(
              "function() { var d = new Date(); d.setTime(d.getTime() - 3600 * 1000 * 24 * 7); return d; }"
            )
          )
        ),
        disabled_date = JS(
          "function(time) { return time.getTime() > Date.now(); }"
        )
      )
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$dp_size, ignoreInit = TRUE, {
    for (id in c("dp_default", "dp_quick")) {
      update_el_date_picker(session, id, size = input$dp_size)
    }
  })
}
shinyApp(ui, server)

## other-measurements
pick <- function(id, type, placeholder, format = NULL) {
  tags$div(
    style = "margin-bottom: 12px",
    tags$div(type),
    el_date_picker(id, type = type, placeholder = placeholder, format = format)
  )
}
tagList(
  pick("dp_week", "week", "Pick a week", format = "[Week] ww"),
  pick("dp_month", "month", "Pick a month"),
  pick("dp_year", "year", "Pick a year"),
  pick("dp_years", "years", "Pick years"),
  pick("dp_months", "months", "Pick months"),
  pick("dp_dates", "dates", "Pick one or more dates")
)

## date-range
#' The radio buttons resize both pickers with `update_el_date_picker(size
#' =)`.
#| shot_js = c("document.querySelectorAll('#dp_range_size .el-radio-button')[2].click()", "document.querySelectorAll('#dp_range_quick input')[0].focus()")
#| shot_sel = ".el-picker__popper"
#| shot_expect = c("document.querySelectorAll('.demo-date-picker .el-range-editor--small').length === 2", "Array.from(document.querySelectorAll('.el-picker__popper')).filter(function(x) { return x.offsetParent; })[0].querySelectorAll('.el-picker-panel__shortcut').length === 3")
ui <- el_page(
  tags$style(
    ".demo-date-picker { display: flex; width: 100%; flex-wrap: wrap; }
     .demo-date-picker .block { padding: 1.5rem 0; text-align: center;
       border-right: solid 1px var(--el-border-color); flex: 1; min-width: 300px; }
     .demo-date-picker .block:last-child { border-right: none; }
     .demo-date-picker .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }"
  ),
  el_radio_group(
    "dp_range_size",
    choices = c("large", "default", "small"),
    selected = "default",
    button = TRUE
  ),
  tags$div(
    class = "demo-date-picker",
    tags$div(
      class = "block",
      tags$span(class = "demonstration", "Default"),
      el_date_picker(
        "dp_range",
        type = "daterange",
        range_separator = "To",
        start_placeholder = "Start date",
        end_placeholder = "End date"
      )
    ),
    tags$div(
      class = "block",
      tags$span(class = "demonstration", "With quick options"),
      el_date_picker(
        "dp_range_quick",
        type = "daterange",
        unlink_panels = TRUE,
        range_separator = "To",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        shortcuts = list(
          list(
            text = "Last week",
            value = JS(
              "function() { var e = new Date(), s = new Date(); s.setTime(s.getTime() - 3600 * 1000 * 24 * 7); return [s, e]; }"
            )
          ),
          list(
            text = "Last month",
            value = JS(
              "function() { var e = new Date(), s = new Date(); s.setMonth(s.getMonth() - 1); return [s, e]; }"
            )
          ),
          list(
            text = "Last 3 months",
            value = JS(
              "function() { var e = new Date(), s = new Date(); s.setMonth(s.getMonth() - 3); return [s, e]; }"
            )
          )
        )
      )
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$dp_range_size, ignoreInit = TRUE, {
    for (id in c("dp_range", "dp_range_quick")) {
      update_el_date_picker(session, id, size = input$dp_range_size)
    }
  })
}
shinyApp(ui, server)

## month-range
el_date_picker(
  "dp_mrange",
  type = "monthrange",
  range_separator = "To",
  start_placeholder = "Start month",
  end_placeholder = "End month"
)

## year-range
el_date_picker(
  "dp_yrange",
  type = "yearrange",
  range_separator = "To",
  start_placeholder = "Start Year",
  end_placeholder = "End Year"
)

## quarter-range
el_date_picker(
  "dp_qrange",
  type = "quarterrange",
  range_separator = "To",
  start_placeholder = "Start quarter",
  end_placeholder = "End quarter"
)

## single-panel
el_date_picker(
  "dp_single",
  type = "daterange",
  single_panel = TRUE,
  start_placeholder = "Start date",
  end_placeholder = "End date"
)

## default-value
tagList(
  el_date_picker(
    "dp_dv1",
    type = "date",
    placeholder = "Pick a date",
    default_value = "2010-10-01"
  ),
  el_date_picker(
    "dp_dv2",
    type = "daterange",
    start_placeholder = "Start Date",
    end_placeholder = "End Date",
    default_value = c("2010-09-01", "2010-10-01")
  )
)

## date-formats
#' `value_format` is the value reported to Shiny; `format` what the input
#' shows. Both in day.js's tokens.
tagList(
  tags$div("Emits Date object"),
  el_date_picker("dp_fmt1", value = "2021-10-29", format = "YYYY/MM/DD"),
  tags$div("Use value-format"),
  el_date_picker(
    "dp_fmt2",
    value = "2021-10-29",
    format = "YYYY/MM/DD",
    value_format = "x"
  )
)

## default-time
el_date_picker(
  "dp_dt",
  type = "daterange",
  start_placeholder = "Start date",
  end_placeholder = "End date",
  default_time = list(
    JS("new Date(2000, 1, 1, 12, 0, 0)"),
    JS("new Date(2000, 2, 1, 8, 0, 0)")
  )
)

## custom-prefix-icon
el_date_picker(
  "dp_prefix",
  placeholder = "Pick a day",
  prefix_icon = "Calendar"
)

## custom-content
el_date_picker(
  "dp_cell",
  placeholder = "Pick a day",
  slots = list(
    default = template(
      htmltools::HTML(
        "<div class=\"cell\" :class=\"{ current: cell.isCurrent }\"><span class=\"cell__text\">{{ cell.text }}</span></div>"
      ),
      scope = "cell"
    )
  )
)

## custom-icon
#' The panel's arrows are slots: `prev-month`, `next-month`, `prev-year`,
#' `next-year`.
#| shot_js = "document.querySelectorAll('#dp_icon_range input')[0].focus()"
#| shot_sel = ".el-picker__popper"
#| shot_expect = "document.querySelectorAll('.el-picker__popper .d-arrow-left [data-el-icon=Back]').length >= 2"
arrows <- function(months = TRUE) {
  c(
    if (months) {
      list(
        `prev-month` = el_icon("CaretLeft"),
        `next-month` = el_icon("CaretRight")
      )
    },
    list(`prev-year` = el_icon("Back"), `next-year` = el_icon("Right"))
  )
}
block <- function(title, picker) {
  tags$div(class = "block", tags$div(class = "demonstration", title), picker)
}
tagList(
  tags$style(
    ".demo-date-picker-icon { display: grid; width: 100%;
       grid-template-columns: repeat(2, 1fr); }
     .demo-date-picker-icon .block { padding: 1.5rem 1rem; text-align: center;
       display: flex; flex-direction: column; align-items: center;
       border-right: solid 1px var(--el-border-color);
       border-bottom: solid 1px var(--el-border-color); }
     .demo-date-picker-icon .block:nth-child(2n) { border-right: none; }
     .demo-date-picker-icon .block:nth-child(5) { grid-column: span 2;
       border-right: none; border-bottom: none; }
     .demo-date-picker-icon .block .el-date-editor { width: 100%; max-width: 360px; }
     .demo-date-picker-icon .demonstration { color: var(--el-text-color-secondary);
       font-size: 14px; margin-bottom: 1rem; }"
  ),
  tags$div(
    class = "demo-date-picker-icon",
    block(
      "date",
      el_date_picker(
        "dp_icon_date",
        placeholder = "Pick a day",
        format = "YYYY/MM/DD",
        value_format = "YYYY-MM-DD",
        slots = arrows()
      )
    ),
    block(
      "date range",
      el_date_picker(
        "dp_icon_range",
        type = "daterange",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        format = "YYYY/MM/DD",
        value_format = "YYYY-MM-DD",
        unlink_panels = TRUE,
        slots = arrows()
      )
    ),
    block(
      "month range",
      el_date_picker(
        "dp_icon_month",
        type = "monthrange",
        start_placeholder = "Start date",
        end_placeholder = "End date",
        format = "YYYY/MM/DD",
        value_format = "YYYY-MM-DD",
        unlink_panels = TRUE,
        slots = arrows()
      )
    ),
    block(
      "year range",
      el_date_picker(
        "dp_icon_year",
        type = "yearrange",
        range_separator = "To",
        start_placeholder = "Start Year",
        end_placeholder = "End Year",
        slots = arrows(FALSE)
      )
    ),
    block(
      "quarter range",
      el_date_picker(
        "dp_icon_quarter",
        type = "quarterrange",
        range_separator = "To",
        start_placeholder = "Start quarter",
        end_placeholder = "End quarter",
        slots = arrows(FALSE)
      )
    )
  )
)
