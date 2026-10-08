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
tags$div(
  style = "display: flex; align-items: center; gap: 1em",
  el_input(
    "in_clear",
    placeholder = "Please input",
    clearable = TRUE,
    width = "240px"
  ),
  el_input(
    "in_clear_area",
    type = "textarea",
    placeholder = "Please input",
    clearable = TRUE,
    width = "240px"
  )
)

## clear-icon
#| shot_expect = "document.querySelectorAll('.el-textarea').length === 1"
tags$div(
  style = "display: flex; flex-direction: column; gap: 1em",
  el_input(
    "in_clear_icon",
    value = "Clear me",
    placeholder = "Custom clear icon",
    clearable = TRUE,
    clear_icon = "CloseBold"
  ),
  el_input(
    "in_clear_icon_area",
    type = "textarea",
    placeholder = "Custom clear icon",
    clearable = TRUE,
    clear_icon = "CloseBold"
  )
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
#' The `password-icon` slot's scope says whether the password shows.
#| shot_js = "document.querySelectorAll('.el-input__password')[1].click()"
#| shot_expect = c("document.querySelector('#in_pass_icon input').type === 'text'", "document.querySelector('#in_pass input').type === 'password'")
tags$div(
  style = "display: flex; align-items: center; gap: 1em",
  el_input(
    "in_pass",
    type = "password",
    value = "secret",
    placeholder = "Please input password",
    show_password = TRUE,
    width = "240px"
  ),
  el_input(
    "in_pass_icon",
    type = "password",
    value = "secret",
    placeholder = "Please input password",
    show_password = TRUE,
    width = "240px",
    slots = list(
      `password-icon` = template(
        slot = "password-icon",
        scope = "{ visible }",
        htmltools::HTML(paste0(
          "<el-icon :size=\"16\"><Unlock v-if=\"visible\" />",
          "<Lock v-else /></el-icon>"
        ))
      )
    )
  )
)

## with-icon
group <- function(label, ...) {
  tags$div(
    style = "margin-bottom: 1.5rem",
    tags$span(
      style = "display: block; margin-bottom: 1rem; color: var(--el-text-color-regular)",
      label
    ),
    tags$div(style = "display: flex; gap: 1rem; flex-wrap: wrap", ...)
  )
}
tags$div(
  group(
    "Using attributes",
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
  ),
  group(
    "Using slots",
    el_input(
      "in_suffix_slot",
      placeholder = "Pick a date",
      width = "240px",
      slots = list(suffix = el_icon("Calendar", class = "el-input__icon"))
    ),
    el_input(
      "in_prefix_slot",
      placeholder = "Type something",
      width = "240px",
      slots = list(prefix = el_icon("Search", class = "el-input__icon"))
    )
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
#' A select and a button go in the slots like text: they become part of the
#' input, and the select still reports as `input$in_kind`.
#| shot_expect = "document.querySelectorAll('.input-with-select .el-select').length === 2"
kind <- function(id) {
  el_select(
    id,
    choices = c(Restaurant = "1", "Order No." = "2", Tel = "3"),
    placeholder = "Select",
    width = "115px"
  )
}
tagList(
  tags$style(
    ".input-with-select .el-input-group__prepend {
       background-color: var(--el-fill-color-blank); }"
  ),
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
    tags$div(
      class = "input-with-select",
      el_input(
        "in_mixed",
        placeholder = "Please input",
        slots = list(
          prepend = kind("in_kind"),
          append = el_button(icon = "Search", label = NULL)
        )
      )
    ),
    tags$div(
      class = "input-with-select",
      el_input(
        "in_mixed2",
        placeholder = "Please input",
        slots = list(
          prepend = el_button(icon = "Search", label = NULL),
          append = kind("in_kind2")
        )
      )
    )
  )
)

## various-size
row <- function(...) {
  tags$div(
    style = "display: flex; gap: 16px; align-items: center; margin-bottom: 16px",
    lapply(c("large", "default", "small"), function(size) {
      el_input(placeholder = "Please Input", size = size, width = "240px", ...)
    })
  )
}
tagList(row(), row(suffix_icon = "Search"), row(prefix_icon = "Search"))

## length-limiting
#' `word_limit_position = "outside"` puts the count after the box.
tagList(
  tags$div(
    style = "display: flex; gap: 16px",
    el_input(
      "in_lim",
      maxlength = 10,
      show_word_limit = TRUE,
      placeholder = "Please input",
      width = "240px"
    ),
    el_input(
      "in_lim_out",
      maxlength = 10,
      show_word_limit = TRUE,
      word_limit_position = "outside",
      placeholder = "Please input",
      width = "240px"
    )
  ),
  tags$div(style = "margin: 20px 0"),
  tags$div(
    style = "display: flex; gap: 16px",
    el_input(
      "in_lim_area",
      type = "textarea",
      maxlength = 30,
      show_word_limit = TRUE,
      placeholder = "Please input",
      width = "240px"
    ),
    el_input(
      "in_lim_area_out",
      type = "textarea",
      maxlength = 30,
      show_word_limit = TRUE,
      word_limit_position = "outside",
      placeholder = "Please input",
      width = "240px"
    )
  )
)

## count-graphemes
#' `count_graphemes` counts as a reader would: an emoji is one character,
#' not the two code units JavaScript's `length` gives it.
#| shot_expect = "document.querySelector('.el-input__count').innerText.replace(/\\s/g, '') === '2/10'"
tagList(
  el_input(
    "in_graph",
    value = "\U0001F600\U0001F601",
    maxlength = 10,
    placeholder = "Please input",
    show_word_limit = TRUE,
    count_graphemes = JS("function(value) { return Array.from(value).length; }")
  ),
  tags$div(style = "margin: 20px 0"),
  el_input(
    "in_graph_area",
    type = "textarea",
    value = "\U0001F600\U0001F601",
    maxlength = 20,
    placeholder = "Please input",
    show_word_limit = TRUE,
    count_graphemes = JS("function(value) { return Array.from(value).length; }")
  )
)
