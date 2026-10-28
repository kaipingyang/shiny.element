## basic
el_color_picker_panel("cpp", value = "#409EFF")

## alpha
el_color_picker_panel(
  "cpp_alpha",
  value = "rgba(19, 206, 102, 0.8)",
  show_alpha = TRUE
)

## predefined-color
el_color_picker_panel(
  "cpp_pre",
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
    "hsv(51, 100, 98)",
    "hsva(120, 40, 94, 0.5)",
    "hsl(181, 100%, 37%)",
    "hsla(209, 100%, 56%, 0.73)",
    "#c7158577"
  )
)

## border
#' `border = FALSE`: the panel on its own, and inside a card. The divider turns horizontal when the
#' two no longer fit side by side, as upstream's does with VueUse's
#' `useElementSize()`: the example is a [vue_app()] measuring its own box.
vue_app(
  "cpp_border_demo",
  tags$div(
    ref = "containerRef",
    tags$div(style = "text-align: center", "No border:"),
    el$divider(),
    tags$div(
      style = "display: flex; flex-wrap: wrap; gap: 16px; justify-content: center",
      tags$div(
        style = "padding: 20px",
        el_color_picker_panel("cpp_border1", value = "#409EFF", border = FALSE)
      ),
      el$divider(
        style = "height: auto",
        `:direction` = "isNarrow ? 'horizontal' : 'vertical'"
      ),
      el_card(el_color_picker_panel(
        "cpp_border2",
        value = "#409EFF",
        border = FALSE
      ))
    )
  ),
  setup = JS(
    "function() {",
    "  var containerRef = Vue.ref(null);",
    "  var size = VueUse.useElementSize(containerRef);",
    "  var isNarrow = Vue.computed(function() { return size.width.value < 815; });",
    "  return { containerRef: containerRef, isNarrow: isNarrow };",
    "}"
  ),
  use = "shinyElement.plugin",
  dependencies = vueuse_dependency()
)

## disabled
el_color_picker_panel(
  "cpp_dis",
  value = "#ff6900",
  disabled = TRUE,
  show_alpha = TRUE,
  predefine = c(
    "#ff4500",
    "#ff8c00",
    "#ffd700",
    "#90ee90",
    "#00ced1",
    "#1e90ff",
    "#c71585"
  )
)
