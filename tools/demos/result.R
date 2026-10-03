## basic-usage
el_row(
  el_col(span = 6, el_result(icon = "success", title = "Success Tip",
    sub_title = "Please follow the instructions", el_button("res1", "Back", type = "primary"))),
  el_col(span = 6, el_result(icon = "warning", title = "Warning Tip",
    sub_title = "Please follow the instructions", el_button("res2", "Back", type = "primary"))),
  el_col(span = 6, el_result(icon = "error", title = "Error Tip",
    sub_title = "Please follow the instructions", el_button("res3", "Back", type = "primary"))),
  el_col(span = 6, el_result(icon = "info", title = "Info Tip",
    sub_title = "Please follow the instructions", el_button("res4", "Back", type = "primary"))))

## customized-content
el_result(title = "404", sub_title = "Sorry, request error",
  slots = list(icon = tags$img(src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png",
                               alt = "A hamburger")),
  el_button("res_back", "Back", type = "primary"))
