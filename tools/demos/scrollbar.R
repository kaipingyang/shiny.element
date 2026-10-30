## basic-usage
item <- function(i) {
  tags$p(
    class = "scrollbar-demo-item",
    style = paste(
      "display: flex; align-items: center; justify-content: center; height: 50px; margin: 10px;",
      "text-align: center; border-radius: 4px; background: var(--el-color-primary-light-9);",
      "color: var(--el-color-primary)"
    ),
    i
  )
}
el_scrollbar(height = "400px", lapply(1:20, item))

## horizontal-scroll
item <- function(i) {
  tags$p(
    style = paste(
      "flex-shrink: 0; display: flex; align-items: center; justify-content: center; width: 100px;",
      "height: 50px; margin: 10px; border-radius: 4px; background: var(--el-color-danger-light-9);",
      "color: var(--el-color-danger)"
    ),
    i
  )
}
el_scrollbar(tags$div(style = "display: flex", lapply(1:50, item)))

## max-height
#' The buttons add and delete items: the scrollbar appears once they pass
#' `max_height`. The count is a store's field, and a `vue_app()` inside
#' draws the items from it, as upstream's `v-for`.
#| shot_js = c("document.querySelectorAll('button')[0].click()", "document.querySelectorAll('button')[0].click()", "document.querySelectorAll('button')[0].click()", "document.querySelectorAll('button')[0].click()", "document.querySelectorAll('button')[0].click()")
#| shot_expect = c("document.querySelectorAll('.scrollbar-demo-item').length === 8", "document.querySelector('.el-scrollbar__wrap').clientHeight === 400")
tags$style(
  ".scrollbar-demo-item { display: flex; align-items: center;
     justify-content: center; height: 50px; margin: 10px; text-align: center;
     border-radius: 4px; background: var(--el-color-primary-light-9);
     color: var(--el-color-primary); }"
)
vue_store("sb_items", state = list(count = 3))
el_button("sb_add", "Add Item", on = list(click = "$vueStore.sb_items.count++"))
el_button(
  "sb_delete",
  "Delete Item",
  on = list(
    click = "$vueStore.sb_items.count = Math.max(0, $vueStore.sb_items.count - 1)"
  )
)
el_scrollbar(
  max_height = "400px",
  vue_app(
    "sb_list",
    tags$div(
      tags$p(
        class = "scrollbar-demo-item",
        `v-for` = "i in $vueStore.sb_items.count",
        `:key` = "i",
        "{{ i }}"
      )
    )
  )
)

## manual-scroll
#' The slider scrolls the area, calling its `setScrollTop()` in the browser
#' through `$find(id)`, and follows it back: the area's `scroll` sets a
#' store the slider's value is bound to, [v_model()]. Twenty items of 60px
#' and a margin make 1210px, 830px more than the 380px shown.
#| shot_js = "var s = shinyVue.useStore('sb_pos'); shinyVue.findComponent('sb').setScrollTop(300);"
#| shot_wait = 2
#| shot_expect = c("Math.abs(document.querySelector('#sb .el-scrollbar__wrap').scrollTop - 300) < 2", "shinyVue.useStore('sb_pos').top === 300")
tags$style(
  ".scrollbar-demo-item { display: flex; align-items: center;
     justify-content: center; height: 50px; margin: 10px; text-align: center;
     border-radius: 4px; background: var(--el-color-primary-light-9);
     color: var(--el-color-primary); }
   .el-slider { margin-top: 20px; }"
)
vue_store("sb_pos", state = list(top = 0))
el_scrollbar(
  id = "sb",
  height = "400px",
  always = TRUE,
  on = list(
    scroll = v_on("$vueStore.sb_pos.top = Math.round($event.scrollTop)")
  ),
  tags$div(lapply(1:20, function(i) tags$p(class = "scrollbar-demo-item", i)))
)
el_slider(
  "sb_slider",
  value = v_model("$vueStore.sb_pos.top"),
  max = 830,
  format_tooltip = JS("function(value) { return value + ' px'; }"),
  on = list(input = v_on("$find('sb').setScrollTop($event)"))
)

## infinite-scroll
#' Reaching an end is `input$<id>_end_reached`: `"bottom"`, `"top"`, ...
item <- function(i) {
  tags$p(
    style = paste(
      "display: flex; align-items: center; justify-content: center; height: 50px; margin: 10px;",
      "border-radius: 4px; background: var(--el-color-primary-light-9); color: var(--el-color-primary)"
    ),
    i
  )
}
el_scrollbar(id = "sb_more", height = "400px", lapply(1:30, item))
