## basic-usage
tags$div(
  tags$span("I sit at a desk, wondering how to approach the vast ocean."),
  el_divider(),
  tags$span("I wonder how far the eyes can see, and how far the heart can feel."))

## custom-content
tags$div(
  tags$span("What you are you do not see, what you see is your shadow."),
  el_divider(content_position = "left", "Rabindranath Tagore"),
  tags$span("I cannot choose the best. The best chooses me."),
  el_divider(el_icon("StarFilled")),
  tags$span("My wishes are fools, they shout across thy song, my Master."),
  el_divider(content_position = "right", "Rabindranath Tagore"),
  tags$span("I cannot choose the best. The best chooses me."))

## line-dashed
tags$div(
  tags$span("What language is thine, O sea?"),
  el_divider(border_style = "dashed"),
  tags$span("The language of eternal question."),
  el_divider(border_style = "dotted"),
  tags$span("What language is thy answer, O sky?"),
  el_divider(direction = "vertical", border_style = "dashed"),
  tags$span("The language of eternal silence."))

## vertical-divider
tags$div(
  tags$span("Rain"), el_divider(direction = "vertical"),
  tags$span("Home"), el_divider(direction = "vertical", border_style = "dashed"),
  tags$span("Grass"))
