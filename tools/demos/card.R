## basic
el_card(
  header = tags$div(class = "card-header", tags$span("Card name")),
  footer = "Footer content",
  width = "480px",
  lapply(1:4, function(o) tags$p(class = "text item", paste("List item", o)))
)

## simple
el_card(
  width = "480px",
  lapply(1:4, function(o) tags$p(class = "text item", paste("List item", o)))
)

## with-images
el_card(
  header = "Yummy hamburger",
  width = "480px",
  tags$img(
    src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png",
    alt = "A hamburger",
    style = "width: 100%"
  )
)

## shadow
tags$div(
  style = "display: flex; flex-wrap: wrap; gap: 16px",
  el_card("Always", shadow = "always", width = "480px"),
  el_card("Hover", shadow = "hover", width = "480px"),
  el_card("Never", shadow = "never", width = "480px")
)
