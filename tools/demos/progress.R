## linear-progress-bar
tags$div(
  style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("pr1", percentage = 50),
  el_progress(
    "pr2",
    percentage = 100,
    format = JS("function(p) { return p === 100 ? 'Full' : p + '%'; }")
  ),
  el_progress("pr3", percentage = 100, status = "success"),
  el_progress("pr4", percentage = 100, status = "warning"),
  el_progress("pr5", percentage = 50, status = "exception")
)

## internal-percentage
tags$div(
  style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("pri1", percentage = 70, text_inside = TRUE, stroke_width = 26),
  el_progress(
    "pri2",
    percentage = 100,
    text_inside = TRUE,
    stroke_width = 24,
    status = "success"
  ),
  el_progress(
    "pri3",
    percentage = 80,
    text_inside = TRUE,
    stroke_width = 22,
    status = "warning"
  ),
  el_progress(
    "pri4",
    percentage = 50,
    text_inside = TRUE,
    stroke_width = 20,
    status = "exception"
  )
)

## custom-color
#' The buttons step every bar by ten: the bars' `percentage` is a store's
#' field, [v_bind()], which the buttons change in the browser.
#| shot_js = c("document.querySelectorAll('.demo-progress .el-button')[1].click()", "document.querySelectorAll('.demo-progress .el-button')[1].click()")
#| shot_expect = "document.querySelectorAll('.el-progress__text')[0].innerText.trim() === '40%'"
colors <- list(
  list(color = "#f56c6c", percentage = 20),
  list(color = "#e6a23c", percentage = 40),
  list(color = "#5cb87a", percentage = 60),
  list(color = "#1989fa", percentage = 80),
  list(color = "#6f7ad3", percentage = 100)
)
ids <- c("prc1", "prc2", "prc3", "prc4")
vue_store("prc", state = list(p = 20))
tags$style(
  ".demo-progress .el-progress--line { margin-bottom: 15px; max-width: 600px; }"
)
tags$div(
  class = "demo-progress",
  el_progress(
    "prc1",
    percentage = v_bind("$vueStore.prc.p"),
    color = "#409eff"
  ),
  el_progress(
    "prc2",
    percentage = v_bind("$vueStore.prc.p"),
    color = JS(
      "function(p) { return p < 30 ? '#909399' : p < 70 ? '#e6a23c' : '#67c23a'; }"
    )
  ),
  el_progress("prc3", percentage = v_bind("$vueStore.prc.p"), color = colors),
  el_progress("prc4", percentage = v_bind("$vueStore.prc.p"), color = colors),
  tags$div(
    el_button_group(
      el_button(
        "prc_minus",
        label = NULL,
        icon = "Minus",
        on = list(click = "$vueStore.prc.p = Math.max(0, $vueStore.prc.p - 10)")
      ),
      el_button(
        "prc_plus",
        label = NULL,
        icon = "Plus",
        on = list(
          click = "$vueStore.prc.p = Math.min(100, $vueStore.prc.p + 10)"
        )
      )
    )
  )
)

## circular-progress-bar
tags$div(
  style = "display: flex; gap: 20px",
  el_progress("prcl1", type = "circle", percentage = 0),
  el_progress("prcl2", type = "circle", percentage = 25),
  el_progress("prcl3", type = "circle", percentage = 100, status = "success"),
  el_progress("prcl4", type = "circle", percentage = 70, status = "warning"),
  el_progress("prcl5", type = "circle", percentage = 50, status = "exception")
)

## dashboard-progress-bar
#' The buttons step the first dial through a store; the second goes round
#' on its own, a setup store counting every half second, as upstream's
#' `setInterval()`.
#| shot_js = "document.querySelectorAll('.demo-progress .el-button')[1].click()"
#| shot_expect = "document.querySelectorAll('.el-progress__text')[0].innerText.trim() === '20%'"
colors <- list(
  list(color = "#f56c6c", percentage = 20),
  list(color = "#e6a23c", percentage = 40),
  list(color = "#5cb87a", percentage = 60),
  list(color = "#1989fa", percentage = 80),
  list(color = "#6f7ad3", percentage = 100)
)
vue_store("prd", state = list(p = 10))
vue_store(
  "going",
  setup = JS(
    "function() {
      var p = Vue.ref(0);
      setInterval(function() { p.value = p.value % 100 + 10; }, 500);
      return { p: p };
    }"
  )
)
tags$div(
  class = "demo-progress",
  el_progress(
    "prd1",
    type = "dashboard",
    percentage = v_bind("$vueStore.prd.p"),
    color = colors
  ),
  el_progress(
    "prd2",
    type = "dashboard",
    percentage = v_bind("$vueStore.going.p"),
    color = colors
  ),
  tags$div(
    el_button_group(
      el_button(
        "prd_minus",
        label = NULL,
        icon = "Minus",
        on = list(click = "$vueStore.prd.p = Math.max(0, $vueStore.prd.p - 10)")
      ),
      el_button(
        "prd_plus",
        label = NULL,
        icon = "Plus",
        on = list(
          click = "$vueStore.prd.p = Math.min(100, $vueStore.prd.p + 10)"
        )
      )
    )
  )
)

## customized-content
tags$div(
  style = "display: flex; gap: 20px; align-items: center",
  el_progress(
    "prx1",
    percentage = 50,
    slots = list(default = el_button("prx_b", "Content", text = TRUE))
  ),
  el_progress(
    "prx2",
    type = "circle",
    percentage = 50,
    slots = list(
      default = template(
        htmltools::HTML(
          "<span class=\"percentage-value\">{{ percentage }}%</span><span class=\"percentage-label\">Progressing</span>"
        ),
        scope = "{ percentage }"
      )
    )
  )
)

## indeterminate-progress
tags$div(
  style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("prin1", percentage = 50, indeterminate = TRUE),
  el_progress(
    "prin2",
    percentage = 100,
    format = JS("function() { return 'Full'; }"),
    indeterminate = TRUE
  ),
  el_progress(
    "prin3",
    percentage = 100,
    status = "success",
    indeterminate = TRUE,
    duration = 5
  )
)

## striped-progress
#' The buttons step the last bar by ten, and its stripes' `duration` with
#' it: a store's field and a getter of it, [v_bind()].
#| shot_js = "document.querySelectorAll('.demo-progress .el-button')[0].click()"
#| shot_expect = "document.querySelectorAll('.el-progress-bar__inner')[3].style.width === '60%'"
vue_store(
  "prs",
  state = list(p = 70),
  getters = list(duration = JS("function(s) { return Math.floor(s.p / 10); }"))
)
tags$style(
  ".demo-progress .el-progress--line { margin-bottom: 15px; max-width: 600px; }"
)
tags$div(
  class = "demo-progress",
  el_progress("prs1", percentage = 50, stroke_width = 15, striped = TRUE),
  el_progress(
    "prs2",
    percentage = 30,
    stroke_width = 15,
    status = "warning",
    striped = TRUE,
    striped_flow = TRUE
  ),
  el_progress(
    "prs3",
    percentage = 100,
    stroke_width = 15,
    status = "success",
    striped = TRUE,
    striped_flow = TRUE,
    duration = 10
  ),
  el_progress(
    "prs4",
    percentage = v_bind("$vueStore.prs.p"),
    stroke_width = 15,
    status = "exception",
    striped = TRUE,
    striped_flow = TRUE,
    duration = v_bind("$vueStore.prs.duration")
  ),
  el_button_group(
    el_button(
      "prs_minus",
      label = NULL,
      icon = "Minus",
      on = list(click = "$vueStore.prs.p = Math.max(0, $vueStore.prs.p - 10)")
    ),
    el_button(
      "prs_plus",
      label = NULL,
      icon = "Plus",
      on = list(click = "$vueStore.prs.p = Math.min(100, $vueStore.prs.p + 10)")
    )
  )
)
