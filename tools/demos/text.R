## basic
tags$div(lapply(
  c("default", "primary", "success", "info", "warning", "danger"),
  function(t) {
    tags$span(
      style = "margin: 0 4px",
      el_text(tools::toTitleCase(t), type = if (t != "default") t)
    )
  }
))

## sizes
tags$div(
  tags$span(style = "margin: 0 4px", el_text("Large", size = "large")),
  tags$span(style = "margin: 0 4px", el_text("Default")),
  tags$span(style = "margin: 0 4px", el_text("Small", size = "small"))
)

## truncated
tagList(
  tags$div(el_text(
    "Self element set width 150px",
    truncated = TRUE,
    width = "150px"
  )),
  tags$div(
    style = "width: 150px",
    el_text("Squeezed by parent element", truncated = TRUE)
  ),
  tags$div(el_text(
    HTML(
      "The -webkit-line-clamp CSS property<br>allows limiting of the contents of<br>",
      "a block to the specified number of lines."
    ),
    line_clamp = 2
  ))
)

## override
#' `tag` draws the text as another element.
el_space(
  direction = "vertical",
  el_text("span"),
  el_text("This is a paragraph.", tag = "p"),
  el_text("Bold", tag = "b"),
  el_text("Italic", tag = "i"),
  el_text("This is ", el_text("subscript", tag = "sub", size = "small")),
  el_text("This is ", el_text("superscript", tag = "sup", size = "small")),
  el_text("Inserted", tag = "ins"),
  el_text("Deleted", tag = "del"),
  el_text("Marked", tag = "mark")
)

## mixed
#| shot_expect = "document.querySelectorAll('.el-space .el-text .el-button').length === 1"
el_space(
  direction = "vertical",
  el_text(el_icon("ElementPlus"), " Element-Plus"),
  el_row(
    el_text("Rate"),
    tags$span(style = "margin-left: 4px", el_rate("txt_rate"))
  ),
  el_text(
    "This is text mixed icon ",
    el_icon("Bell"),
    " and component ",
    el_button("txt_btn", "Button")
  )
)
