## basic
tagList("Scroll down to see the bottom-right button.",
        el_backtop(right = 100, bottom = 100))

## custom
tagList("Scroll down to see the bottom-right button.",
  el_backtop(bottom = 100, content = tags$div(style = paste(
    "height: 100%; width: 100%; background-color: var(--el-bg-color-overlay);",
    "box-shadow: var(--el-box-shadow-lighter); text-align: center; line-height: 40px;",
    "color: #1989fa"), "UP")))
