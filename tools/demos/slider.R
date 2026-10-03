## basic-usage
tags$div(
  style = "max-width: 600px",
  tags$span("Default value"),
  el_slider("sl1", value = 0),
  tags$span("Customized initial value"),
  el_slider("sl2", value = 50),
  tags$span("Hide Tooltip"),
  el_slider("sl3", value = 36, show_tooltip = FALSE),
  tags$span("Format Tooltip"),
  el_slider(
    "sl4",
    value = 48,
    format_tooltip = JS("function(v) { return v / 100; }")
  ),
  tags$span("Disabled"),
  el_slider("sl5", value = 42, disabled = TRUE)
)

## discrete-values
tags$div(
  style = "max-width: 600px",
  tags$span("Breakpoints not displayed"),
  el_slider("sld1", value = 0, step = 10),
  tags$span("Breakpoints displayed"),
  el_slider("sld2", value = 0, step = 10, show_stops = TRUE)
)

## slider-with-input-box
el_slider("sl_input", value = 0, show_input = TRUE, width = "600px")

## sizes
tags$div(
  style = "max-width: 600px",
  el_slider("sls_l", value = 0, show_input = TRUE, size = "large"),
  el_slider("sls_d", value = 0, show_input = TRUE),
  el_slider("sls_s", value = 0, show_input = TRUE, size = "small")
)

## placement
tags$div(
  style = "max-width: 600px; padding-top: 40px",
  el_slider("slp1", value = 0, placement = "top"),
  el_slider("slp2", value = 0, placement = "bottom"),
  el_slider("slp3", value = 0, placement = "right"),
  el_slider("slp4", value = 0, placement = "left")
)

## range-selection
el_slider(
  "sl_range",
  value = c(4, 8),
  range = TRUE,
  show_stops = TRUE,
  max = 10,
  width = "600px"
)

## vertical-mode
el_slider("sl_vert", value = 0, vertical = TRUE, height = "200px")

## show-marks
el_slider(
  "sl_marks",
  value = c(30, 60),
  range = TRUE,
  width = "600px",
  marks = list(
    "0" = "0°C",
    "8" = "8°C",
    "37" = "37°C",
    "50" = list(style = list(color = "#1989FA"), label = "50%")
  )
)

## restrict-value
#' `min` and `max` bound what can be picked.
el_slider("sl_restrict", value = 20, min = 10, max = 80, width = "600px")
