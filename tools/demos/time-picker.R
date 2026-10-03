## basic
tagList(
  el_time_picker("t1", placeholder = "Arbitrary time"),
  el_time_picker("t2", arrow_control = TRUE, placeholder = "Arbitrary time")
)

## basic-range
#' `disabled_hours`, `disabled_minutes` and `disabled_seconds` limit what can
#' be picked -- here, 17:30 to 18:30.
el_time_picker(
  "lim",
  value = "18:30:00",
  placeholder = "Arbitrary time",
  disabled_hours = JS(
    "function() { var r = []; for (var h = 0; h < 24; h++) if (h < 17 || h > 18) r.push(h); return r; }"
  ),
  disabled_minutes = JS(
    "function(h) { var r = []; for (var m = 0; m < 60; m++) if ((h === 17 && m < 30) || (h === 18 && m > 30)) r.push(m); return r; }"
  )
)

## range
tagList(
  el_time_picker(
    "r1",
    is_range = TRUE,
    value = c("08:40:00", "09:40:00"),
    range_separator = "To",
    start_placeholder = "Start time",
    end_placeholder = "End time"
  ),
  el_time_picker(
    "r2",
    is_range = TRUE,
    arrow_control = TRUE,
    value = c("08:40:00", "09:40:00"),
    range_separator = "To",
    start_placeholder = "Start time",
    end_placeholder = "End time"
  )
)
