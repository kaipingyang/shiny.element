## basic
tagList(
  el_switch("sw1", value = TRUE),
  el_switch(
    "sw2",
    value = TRUE,
    active_color = "#13ce66",
    inactive_color = "#ff4949"
  )
)

## sizes
tags$div(
  style = "display: flex; gap: 16px; align-items: center",
  el_switch(
    "sw_l",
    value = TRUE,
    size = "large",
    active_text = "Open",
    inactive_text = "Close"
  ),
  el_switch(
    "sw_d",
    value = TRUE,
    active_text = "Open",
    inactive_text = "Close"
  ),
  el_switch(
    "sw_s",
    value = TRUE,
    size = "small",
    active_text = "Open",
    inactive_text = "Close"
  )
)

## text-description
tags$div(
  style = "display: grid; gap: 12px",
  el_switch(
    "sw_t1",
    value = TRUE,
    active_text = "Pay by month",
    inactive_text = "Pay by year"
  ),
  el_switch(
    "sw_t2",
    value = TRUE,
    inline_prompt = TRUE,
    active_text = "Y",
    inactive_text = "N"
  ),
  el_switch(
    "sw_t3",
    value = TRUE,
    inline_prompt = TRUE,
    active_text = "是",
    inactive_text = "否"
  )
)

## custom-icons
tags$div(
  style = "display: flex; gap: 16px",
  el_switch(
    "sw_i1",
    value = TRUE,
    active_icon = "Check",
    inactive_icon = "Close"
  ),
  el_switch(
    "sw_i2",
    value = TRUE,
    inline_prompt = TRUE,
    active_icon = "Check",
    inactive_icon = "Close"
  )
)

## extended-value-types
el_switch(
  "sw_ext",
  value = "100",
  active_value = "100",
  inactive_value = "0",
  active_color = "#13ce66",
  inactive_color = "#ff4949"
)

## disabled
tagList(
  el_switch("sw_dis1", value = TRUE, disabled = TRUE),
  el_switch("sw_dis2", disabled = TRUE)
)

## loading
tagList(
  el_switch("sw_ld1", value = TRUE, loading = TRUE),
  el_switch("sw_ld2", loading = TRUE)
)

## prevent-switching
#' `before_change`, a `JS()` function, may hold the switch -- return `false`,
#' or a promise.
el_switch(
  "sw_guard",
  before_change = JS(
    "function() { return new Promise(function(r) { setTimeout(function() { r(true); }, 1000); }); }"
  )
)

## custom-action-icon
tags$div(
  style = "display: flex; gap: 16px",
  el_switch(
    "sw_ai1",
    value = TRUE,
    active_action_icon = "View",
    inactive_action_icon = "Hide"
  )
)

## custom-action-slot
el_switch(
  "sw_slot",
  value = TRUE,
  slots = list(
    `active-action` = tags$span(class = "custom-active-action", "T"),
    `inactive-action` = tags$span(class = "custom-inactive-action", "F")
  )
)
