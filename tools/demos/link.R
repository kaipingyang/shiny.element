## basic
tags$div(style = "display: flex; gap: 16px",
  el_link("default", href = "https://element-plus.org", target = "_blank"),
  lapply(c("primary", "success", "warning", "danger", "info"), function(t) el_link(t, type = t)))

## disabled
tags$div(style = "display: flex; gap: 16px",
  lapply(c("default", "primary", "success", "warning", "danger", "info"), function(t)
    el_link(t, type = t, disabled = TRUE)))

## underline
tags$div(style = "display: flex; gap: 16px",
  el_link("default"), el_link("always", underline = "always"),
  el_link("hover", underline = "hover"), el_link("never", underline = "never"))

## with-icon
tags$div(style = "display: flex; gap: 16px",
  el_link("Edit", icon = "Edit"),
  el_link(tagList("Check", el_icon("View", class = "el-icon--right"))))
