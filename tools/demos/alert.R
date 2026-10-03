## basic
types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t)))

## theme
types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     effect = "dark")))

## close-button
#' Closing reports `input$<id>_close`, where Element Plus's demo raises a
#' browser alert.
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  el_alert(title = "Unclosable alert", type = "success", closable = FALSE),
  el_alert(title = "Customized close text", type = "info", close_text = "Gotcha"),
  el_alert("alert_cb", title = "Alert with callback", type = "warning"))

## icon
types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     show_icon = TRUE)),
  el_alert(title = "Error alert with custom icon", type = "error", show_icon = TRUE,
           slots = list(icon = el_icon("Bell"))))

## center
types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     center = TRUE, show_icon = TRUE)))

## description
tags$div(style = "max-width: 600px",
  el_alert(title = "With description", type = "success", description = "This is a description."))

## icon-description
types <- c("primary", "success", "info", "warning", "error")
tags$div(style = "max-width: 600px; display: grid; gap: 20px",
  lapply(types, function(t) el_alert(title = paste(tools::toTitleCase(t), "alert"), type = t,
                                     description = "More text description", show_icon = TRUE)))
