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
  style = "display: flex; flex-wrap: wrap; align-items: center; gap: 16px",
  lapply(c("large", "default", "small"), function(size) {
    el_input_number(
      paste0("num_ctl_", size),
      value = 1,
      min = 1,
      max = 10,
      controls_position = "right",
      size = size
    )
  })
)

## custom
#| shot_expect = "document.querySelectorAll('.el-input-number [data-el-icon=Plus]').length === 1"
el_space(
  direction = "vertical",
  el_space(
    el_input_number("num_custom1", value = 1),
    el_input_number(
      "num_custom2",
      value = 1,
      slots = list(
        `decrease-icon` = el_icon("ArrowDown"),
        `increase-icon` = el_icon("ArrowUp")
      )
    )
  ),
  el_space(
    el_input_number("num_custom3", value = 1, controls_position = "right"),
    el_input_number(
      "num_custom4",
      value = 1,
      controls_position = "right",
      slots = list(
        `decrease-icon` = el_icon("Minus"),
        `increase-icon` = el_icon("Plus")
      )
    )
  )
)

## with-prefix-suffix
el_space(
  el_input_number(
    "num_pre",
    value = 1,
    min = 1,
    max = 10,
    slots = list(prefix = tags$span("￥"))
  ),
  el_input_number(
    "num_suf",
    value = 1,
    min = 1,
    max = 10,
    slots = list(suffix = tags$span("RMB"))
  )
)

## formatter
el_input_number(
  "num_fmt",
  value = 10000,
  formatter = JS(
    "function(value) { return `$ ${value}`.replace(/\\B(?=(\\d{3})+(?!\\d))/g, ','); }"
  ),
  parser = JS("function(value) { return value.replace(/\\$\\s?|(,*)/g, ''); }")
)
