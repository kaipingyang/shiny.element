## basic
el_date_picker_panel("dpp", value = Sys.Date())

## border
el_date_picker_panel("dpp_border", value = Sys.Date(), border = FALSE)

## disabled
el_date_picker_panel("dpp_dis", value = Sys.Date(), disabled = TRUE)

## all-types
#' Every type the picker has, its panel open.
tags$div(style = "display: grid; gap: 16px",
  lapply(c("date", "week", "month", "year", "daterange", "monthrange"), function(t)
    tagList(tags$div(t), el_date_picker_panel(paste0("dpp_", t), type = t))))
