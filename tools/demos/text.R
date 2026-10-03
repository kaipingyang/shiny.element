## basic
el_space(lapply(c("default", "primary", "success", "info", "warning", "danger"), function(t)
  el_text(tools::toTitleCase(t), type = if (t != "default") t)))

## sizes
el_space(el_text("Large", size = "large"), el_text("Default"), el_text("Small", size = "small"))

## truncated
tagList(
  tags$div(el_text("Self element set width 150px", truncated = TRUE, width = "150px")),
  tags$div(style = "width: 150px", el_text("Squeezed by parent element", truncated = TRUE)),
  tags$div(el_text(HTML("The -webkit-line-clamp CSS property<br>allows limiting of the contents of<br>",
                        "a block to the specified number of lines."), line_clamp = 2)))

## override
#' `tag` draws the text as another element.
el_space(direction = "vertical",
  el_text("span"),
  el_text("This is a paragraph.", tag = "p"),
  el_text("Bold", tag = "b"),
  el_text("Italic", tag = "i"),
  el_text("This is ", el_text("subscript", tag = "sub", size = "small")),
  el_text("This is ", el_text("superscript", tag = "sup", size = "small")),
  el_text("Inserted", tag = "ins"),
  el_text("Deleted", tag = "del"),
  el_text("Marked", tag = "mark"))

## mixed
tagList(
  tags$p(el_text(el_icon("ElementPlus"), " Element-Plus")),
  tags$p(el_text("Rate"), el_rate("txt_rate")),
  tags$p(el_text("This is text mixed icon ", el_icon("Bell"), " and component"),
         el_button("txt_btn", "Button")))
