## linear-progress-bar
tags$div(style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("pr1", percentage = 50), el_progress("pr2", percentage = 100, format = JS("function(p) { return p === 100 ? 'Full' : p + '%'; }")),
  el_progress("pr3", percentage = 100, status = "success"), el_progress("pr4", percentage = 100, status = "warning"),
  el_progress("pr5", percentage = 50, status = "exception"))

## internal-percentage
tags$div(style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("pri1", percentage = 70, text_inside = TRUE, stroke_width = 26),
  el_progress("pri2", percentage = 100, text_inside = TRUE, stroke_width = 24, status = "success"),
  el_progress("pri3", percentage = 80, text_inside = TRUE, stroke_width = 22, status = "warning"),
  el_progress("pri4", percentage = 50, text_inside = TRUE, stroke_width = 20, status = "exception"))

## custom-color
tags$div(style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("prc1", percentage = 20, color = "#409eff"),
  el_progress("prc2", percentage = 40, color = JS("function(p) { return p < 30 ? '#909399' : p < 70 ? '#e6a23c' : '#67c23a'; }")),
  el_progress("prc3", percentage = 60, color = list(list(color = "#f56c6c", percentage = 20),
    list(color = "#e6a23c", percentage = 40), list(color = "#5cb87a", percentage = 60),
    list(color = "#1989fa", percentage = 80), list(color = "#6f7ad3", percentage = 100))))

## circular-progress-bar
tags$div(style = "display: flex; gap: 20px",
  el_progress("prcl1", type = "circle", percentage = 0),
  el_progress("prcl2", type = "circle", percentage = 25),
  el_progress("prcl3", type = "circle", percentage = 100, status = "success"),
  el_progress("prcl4", type = "circle", percentage = 70, status = "warning"),
  el_progress("prcl5", type = "circle", percentage = 50, status = "exception"))

## dashboard-progress-bar
el_progress("prd", type = "dashboard", percentage = 70, color = list(
  list(color = "#f56c6c", percentage = 20), list(color = "#e6a23c", percentage = 40),
  list(color = "#5cb87a", percentage = 60), list(color = "#1989fa", percentage = 80),
  list(color = "#6f7ad3", percentage = 100)))

## customized-content
tags$div(style = "display: flex; gap: 20px; align-items: center",
  el_progress("prx1", percentage = 50, slots = list(default = el_button("prx_b", "Content", text = TRUE))),
  el_progress("prx2", type = "circle", percentage = 50, slots = list(default = template(htmltools::HTML(
    "<span class=\"percentage-value\">{{ percentage }}%</span><span class=\"percentage-label\">Progressing</span>"),
    scope = "{ percentage }"))))

## indeterminate-progress
tags$div(style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("prin1", percentage = 50, indeterminate = TRUE),
  el_progress("prin2", percentage = 100, format = JS("function() { return 'Full'; }"), indeterminate = TRUE),
  el_progress("prin3", percentage = 100, status = "success", indeterminate = TRUE, duration = 5))

## striped-progress
tags$div(style = "max-width: 600px; display: grid; gap: 15px",
  el_progress("prs1", percentage = 50, stroke_width = 15, striped = TRUE),
  el_progress("prs2", percentage = 30, stroke_width = 15, status = "warning", striped = TRUE, striped_flow = TRUE),
  el_progress("prs3", percentage = 100, stroke_width = 15, status = "success", striped = TRUE,
              striped_flow = TRUE, duration = 10))
