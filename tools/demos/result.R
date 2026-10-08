## basic-usage
#| shot_expect = "document.querySelectorAll('.el-result .el-button').length === 5"
tip <- function(
  icon,
  title,
  sub_title = "Please follow the instructions",
  ...
) {
  el_col(
    sm = 12,
    lg = 6,
    xl = 4,
    el_result(
      paste0("res_", icon),
      icon = icon,
      title = title,
      sub_title = sub_title,
      el_button(label = "Back", type = "primary"),
      ...
    )
  )
}
el_row(
  tip("primary", "Primary Tip"),
  tip("success", "Success Tip"),
  tip("warning", "Warning Tip"),
  tip("error", "Error Tip"),
  tip(
    "info",
    "Info Tip",
    sub_title = NULL,
    slots = list(`sub-title` = tags$p("Using slot as subtitle"))
  )
)

## customized-content
#| shot_expect = "document.querySelector('.el-result .el-image img')"
el_result(
  "res_404",
  title = "404",
  sub_title = "Sorry, request error",
  el_button(label = "Back", type = "primary"),
  slots = list(
    icon = el_image(
      src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
    )
  )
)
