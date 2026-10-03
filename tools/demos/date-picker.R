## enter-date
el_row(
  el_col(
    span = 12,
    tags$div("Default"),
    el_date_picker("dp_default", placeholder = "Pick a day")
  ),
  el_col(
    span = 12,
    tags$div("Picker with quick options"),
    el_date_picker(
      "dp_quick",
      placeholder = "Pick a day",
      shortcuts = list(
        list(text = "Today", value = JS("new Date()")),
        list(
          text = "Yesterday",
          value = JS(
            "(function() { var d = new Date(); d.setDate(d.getDate() - 1); return d; })()"
          )
        ),
        list(
          text = "A week ago",
          value = JS(
            "(function() { var d = new Date(); d.setDate(d.getDate() - 7); return d; })()"
          )
        )
      ),
      disabled_date = JS(
        "function(time) { return time.getTime() > Date.now(); }"
      )
    )
  )
)

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
tagList(
  el_date_picker(
    "dp_range",
    type = "daterange",
    range_separator = "To",
    start_placeholder = "Start date",
    end_placeholder = "End date"
  ),
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
          "(function() { var e = new Date(), s = new Date(); s.setTime(s.getTime() - 3600 * 1000 * 24 * 7); return [s, e]; })()"
        )
      ),
      list(
        text = "Last month",
        value = JS(
          "(function() { var e = new Date(), s = new Date(); s.setMonth(s.getMonth() - 1); return [s, e]; })()"
        )
      )
    )
  )
)

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
el_date_picker(
  "dp_icons",
  placeholder = "Pick a day",
  slots = list(
    `prev-month` = el_icon("CaretLeft"),
    `next-month` = el_icon("CaretRight"),
    `prev-year` = el_icon("DArrowLeft"),
    `next-year` = el_icon("DArrowRight")
  )
)
