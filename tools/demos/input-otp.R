## basic
el_input_otp("otp")

## custom-length
el_input_otp("otp_len", length = 4)

## types
tags$div(style = "display: grid; gap: 16px",
  el_input_otp("otp_o", type = "outlined"), el_input_otp("otp_f", type = "filled"),
  el_input_otp("otp_u", type = "underlined"))

## sizes
tags$div(style = "display: grid; gap: 16px",
  el_input_otp("otp_l", size = "large"), el_input_otp("otp_d"), el_input_otp("otp_s", size = "small"))

## disabled
el_input_otp("otp_dis", value = "123456", disabled = TRUE)

## mask
el_input_otp("otp_mask", mask = TRUE)

## separator
el_input_otp("otp_sep", separator = "-")

## validator
#' `validator`, a `JS()` function, decides which characters each field takes.
el_input_otp("otp_val", validator = JS("function(char) { return /^[0-9]$/.test(char); }"))
