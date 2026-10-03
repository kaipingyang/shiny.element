## date-and-time
tagList(
  tags$div("Default"),
  el_date_picker(
    "dtp1",
    type = "datetime",
    placeholder = "Select date and time"
  ),
  tags$div("With shortcuts"),
  el_date_picker(
    "dtp2",
    type = "datetime",
    placeholder = "Select date and time",
    shortcuts = list(list(text = "Today", value = JS("new Date()")))
  ),
  tags$div("With default time"),
  el_date_picker(
    "dtp3",
    type = "datetime",
    placeholder = "Select date and time",
    default_time = JS("new Date(2000, 1, 1, 12, 0, 0)")
  )
)

## date-and-time-formats
el_date_picker(
  "dtp_fmt",
  type = "datetime",
  placeholder = "Pick a Date",
  format = "YYYY/MM/DD hh:mm:ss",
  date_format = "YYYY/MM/DD ddd",
  time_format = "A hh:mm:ss"
)

## date-and-time-formats-panel
el_date_picker(
  "dtp_fmt_panel",
  type = "datetime",
  placeholder = "Pick a Date",
  date_format = "YYYY/MM/DD",
  time_format = "hh:mm:ss"
)

## date-and-time-range
el_date_picker(
  "dtp_range",
  type = "datetimerange",
  range_separator = "To",
  start_placeholder = "Start date",
  end_placeholder = "End date"
)

## single-panel
el_date_picker(
  "dtp_single",
  type = "datetimerange",
  single_panel = TRUE,
  start_placeholder = "Start date",
  end_placeholder = "End date"
)

## default-time
el_date_picker(
  "dtp_dt",
  type = "datetimerange",
  start_placeholder = "Start Date",
  end_placeholder = "End Date",
  default_time = list(
    JS("new Date(2000, 1, 1, 0, 0, 0)"),
    JS("new Date(2000, 2, 1, 23, 59, 59)")
  )
)

## custom-icon
el_date_picker(
  "dtp_icons",
  type = "datetime",
  placeholder = "Pick a Date",
  slots = list(
    `prev-month` = el_icon("CaretLeft"),
    `next-month` = el_icon("CaretRight")
  )
)
