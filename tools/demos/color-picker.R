## basic
tagList(
  tags$div(
    tags$span("With default value"),
    el_color_picker("cp1", value = "#409EFF")
  ),
  tags$div(tags$span("With no default value"), el_color_picker("cp2"))
)

## alpha
el_color_picker(
  "cp_alpha",
  value = "rgba(19, 206, 102, 0.8)",
  show_alpha = TRUE
)

## predefined-color
el_color_picker(
  "cp_pre",
  value = "rgba(255, 69, 0, 0.68)",
  show_alpha = TRUE,
  predefine = c(
    "#ff4500",
    "#ff8c00",
    "#ffd700",
    "#90ee90",
    "#00ced1",
    "#1e90ff",
    "#c71585",
    "rgba(255, 69, 0, 0.68)",
    "rgb(255, 120, 0)",
    "hsv(51, 100, 98)"
  )
)

## sizes
tagList(
  el_color_picker("cp_l", value = "#409EFF", size = "large"),
  el_color_picker("cp_d", value = "#409EFF"),
  el_color_picker("cp_s", value = "#409EFF", size = "small")
)
