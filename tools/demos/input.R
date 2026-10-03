## basic
el_input("in_basic", placeholder = "Please input", width = "240px")

## disabled
el_input(
  "in_dis",
  placeholder = "Please input",
  disabled = TRUE,
  width = "240px"
)

## clearable
el_input(
  "in_clear",
  placeholder = "Please input",
  clearable = TRUE,
  width = "240px"
)

## clear-icon
el_input(
  "in_clear_icon",
  placeholder = "Please input",
  clearable = TRUE,
  clear_icon = "CloseBold",
  width = "240px"
)

## formatter
#' `formatter` shows the value its way; `parser` reads it back.
el_input(
  "in_fmt",
  placeholder = "Please input",
  width = "240px",
  formatter = JS(
    "function(value) { return `$ ${value}`.replace(/\\B(?=(\\d{3})+(?!\\d))/g, ','); }"
  ),
  parser = JS("function(value) { return value.replace(/\\$\\s?|(,*)/g, ''); }")
)

## password
el_input(
  "in_pass",
  type = "password",
  placeholder = "Please input password",
  show_password = TRUE,
  width = "240px"
)

## with-icon
tags$div(
  style = "display: flex; gap: 16px",
  el_input(
    "in_suffix",
    placeholder = "Pick a date",
    suffix_icon = "Calendar",
    width = "240px"
  ),
  el_input(
    "in_prefix",
    placeholder = "Type something",
    prefix_icon = "Search",
    width = "240px"
  )
)

## textarea
el_input(
  "in_area",
  type = "textarea",
  rows = 2,
  placeholder = "Please input",
  width = "240px"
)

## auto-sizing-textarea
tagList(
  el_input(
    "in_auto1",
    type = "textarea",
    autosize = TRUE,
    placeholder = "Please input",
    width = "240px"
  ),
  tags$div(style = "margin: 20px 0"),
  el_input(
    "in_auto2",
    type = "textarea",
    autosize = list(minRows = 2, maxRows = 4),
    placeholder = "Please input",
    width = "240px"
  )
)

## mixed-input
tags$div(
  style = "display: grid; gap: 16px; max-width: 600px",
  el_input(
    "in_pre",
    placeholder = "Please input",
    slots = list(prepend = "Http://")
  ),
  el_input(
    "in_app",
    placeholder = "Please input",
    slots = list(append = ".com")
  ),
  el_input(
    "in_both",
    placeholder = "Please input",
    slots = list(
      prepend = "Http://",
      append = el_button("in_search", NULL, icon = "Search")
    )
  )
)

## various-size
tags$div(
  style = "display: flex; gap: 16px",
  el_input(
    "in_l",
    size = "large",
    placeholder = "Please Input",
    width = "240px"
  ),
  el_input("in_d", placeholder = "Please Input", width = "240px"),
  el_input(
    "in_s",
    size = "small",
    placeholder = "Please Input",
    width = "240px"
  )
)

## length-limiting
tagList(
  el_input(
    "in_lim",
    maxlength = 10,
    show_word_limit = TRUE,
    placeholder = "Please input",
    width = "240px"
  ),
  tags$div(style = "margin: 20px 0"),
  el_input(
    "in_lim_area",
    type = "textarea",
    maxlength = 30,
    show_word_limit = TRUE,
    placeholder = "Please input"
  )
)

## count-graphemes
#' `count_graphemes` counts as a reader would: an emoji is one character.
el_input(
  "in_graph",
  maxlength = 10,
  show_word_limit = TRUE,
  width = "240px",
  value = "\U0001F468‍\U0001F469‍\U0001F467",
  count_graphemes = JS(
    "function(value) { return [...new Intl.Segmenter().segment(value)].length; }"
  )
)
