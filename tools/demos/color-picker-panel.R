## basic
el_color_picker_panel("cpp", value = "#409EFF")

## alpha
el_color_picker_panel("cpp_alpha", value = "rgba(19, 206, 102, 0.8)", show_alpha = TRUE)

## predefined-color
el_color_picker_panel("cpp_pre", value = "#ff4500", predefine = c(
  "#ff4500", "#ff8c00", "#ffd700", "#90ee90", "#00ced1", "#1e90ff", "#c71585"))

## border
el_color_picker_panel("cpp_border", value = "#409EFF", border = FALSE)

## disabled
el_color_picker_panel("cpp_dis", value = "#409EFF", disabled = TRUE)
