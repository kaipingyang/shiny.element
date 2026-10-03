## placement
#| shot_js = "document.querySelector('#shot button').click()", shot_sel = ".el-popper", shot_wait = 1
places <- c("top-start", "top", "top-end", "left", "right", "bottom-start", "bottom", "bottom-end")
tags$div(style = "padding: 60px 100px; display: flex; flex-wrap: wrap; gap: 12px", lapply(places, function(p)
  el_popconfirm(paste0("pc_", gsub("-", "_", p)), reference = el_button(paste0("pcb_", gsub("-", "_", p)), p),
                title = paste(p, "prompts info"), placement = p)))

## basic-usage
#| shot_js = "document.querySelector('#shot button').click()", shot_sel = ".el-popper", shot_wait = 1
el_popconfirm("del", reference = el_button("del_btn", "Delete"),
              title = "Are you sure to delete this?")

## customize
#| shot_js = "document.querySelector('#shot button').click()", shot_sel = ".el-popper", shot_wait = 1
el_popconfirm("good", reference = el_button("go", "Delete"), title = "Are you sure to delete this?",
              confirm_button_text = "OK", cancel_button_text = "No, Thanks",
              icon = "InfoFilled", icon_color = "#626AEF", width = "220px")

## trigger-event
#' Confirming and cancelling are inputs: `input$<id>_confirm`,
#' `input$<id>_cancel`.
#| shot_js = "document.querySelector('#shot button').click()", shot_sel = ".el-popper", shot_wait = 1
el_popconfirm("ev", reference = el_button("ev_btn", "Delete"), title = "Are you sure to delete this?",
              confirm_button_text = "Yes", cancel_button_text = "No")
