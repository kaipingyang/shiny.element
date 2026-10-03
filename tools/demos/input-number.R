## basic
el_input_number("num", value = 1, min = 1, max = 10)

## disabled
el_input_number("num_dis", value = 1, disabled = TRUE)

## steps
el_input_number("num_step", value = 5, step = 2)

## step-strictly
el_input_number("num_strict", value = 2, step = 2, step_strictly = TRUE)

## precision
el_input_number("num_prec", value = 1, precision = 2, step = 0.1, max = 10)

## size
tags$div(
  style = "display: flex; gap: 16px",
  el_input_number("num_l", value = 1, size = "large"),
  el_input_number("num_d", value = 2),
  el_input_number("num_s", value = 3, size = "small")
)

## controlled
tags$div(
  style = "display: flex; gap: 16px",
  el_input_number(
    "num_ctl",
    value = 1,
    min = 1,
    max = 10,
    controls_position = "right",
    size = "large"
  ),
  el_input_number(
    "num_ctl2",
    value = 1,
    min = 1,
    max = 10,
    controls_position = "right"
  )
)

## custom
el_input_number(
  "num_custom",
  value = 1,
  min = 1,
  max = 10,
  slots = list(
    `decrease-icon` = el_icon("ArrowDown"),
    `increase-icon` = el_icon("ArrowUp")
  )
)

## with-prefix-suffix
tags$div(
  style = "display: grid; gap: 16px",
  el_input_number(
    "num_pre",
    value = 18,
    min = 1,
    max = 100,
    slots = list(prefix = "￥")
  ),
  el_input_number(
    "num_suf",
    value = 100,
    min = 1,
    max = 100,
    slots = list(suffix = "RMB")
  )
)

## formatter
el_input_number(
  "num_fmt",
  value = 1234.5,
  formatter = JS(
    "function(value) { return `$ ${value}`.replace(/\\B(?=(\\d{3})+(?!\\d))/g, ','); }"
  ),
  parser = JS("function(value) { return value.replace(/\\$\\s?|(,*)/g, ''); }")
)
