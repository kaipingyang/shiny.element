## basic
item <- function(...) tags$span(style = "margin-right: 40px", ...)
tagList(
  item(el_badge(value = 12, el_button("bd1", "comments"))),
  item(el_badge(value = 3, el_button("bd2", "replies"))),
  item(el_badge(value = 1, type = "primary", el_button("bd3", "comments"))),
  item(el_badge(value = 2, type = "warning", el_button("bd4", "replies"))),
  item(el_badge(value = 1, color = "green", el_button("bd5", "custom background"))))

## max
tagList(
  tags$span(style = "margin-right: 40px", el_badge(value = 200, max = 99, el_button("bm1", "comments"))),
  el_badge(value = 100, max = 10, el_button("bm2", "replies")))

## customize
tagList(
  tags$span(style = "margin-right: 40px", el_badge(value = "new", el_button("bc1", "comments"))),
  el_badge(value = "hot", el_button("bc2", "replies")))

## dot
tagList(
  tags$span(style = "margin-right: 40px", el_badge(is_dot = TRUE, "query")),
  el_badge(is_dot = TRUE, el_button("bdot", NULL, icon = "Share", type = "primary")))

## offset
el_badge(value = 1, offset = c(10, 5), el_button("boff", "offset"))
