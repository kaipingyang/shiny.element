## basic
el_affix(offset = 120, el_button("affix_top", "Offset top 120px", type = "primary"))

## target
tags$div(class = "affix-container", style = "height: 400px; background: var(--el-color-primary-light-9)",
  el_affix(target = ".affix-container", offset = 80,
           el_button("affix_target", "Target container", type = "primary")))

## fixed
el_affix(position = "bottom", offset = 20,
         el_button("affix_bottom", "Offset bottom 20px", type = "primary"))
