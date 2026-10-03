## basic-usage
tags$div(
  style = "display: flex; gap: 40px",
  tags$div(tags$div("Default"), el_rate("rate1")),
  tags$div(
    tags$div("Color for different levels"),
    el_rate("rate2", colors = c("#99A9BF", "#F7BA2A", "#FF9900"))
  )
)

## sizes
tags$div(
  style = "display: grid; gap: 8px",
  el_rate("rate_l", size = "large"),
  el_rate("rate_d"),
  el_rate("rate_s", size = "small")
)

## allow-half
el_rate("rate_half", allow_half = TRUE)

## text
el_rate(
  "rate_text",
  show_text = TRUE,
  texts = c("oops", "disappointed", "normal", "good", "great")
)

## clearable
el_rate("rate_clear", value = 3, clearable = TRUE)

## more-icons
el_rate(
  "rate_icons",
  icons = c("ChatRound", "ChatLineRound", "ChatDotRound"),
  void_icon = "ChatRound",
  colors = c("#409eff", "#67c23a", "#FF9900")
)

## readonly
el_rate(
  "rate_ro",
  value = 3.7,
  disabled = TRUE,
  show_score = TRUE,
  text_color = "#ff9900",
  score_template = "{value} points"
)
