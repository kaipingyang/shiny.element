## basic
#' `data` is a data frame of `key` and `label` (and `disabled`), and
#' `input$<id>` the keys on the right.
items <- data.frame(
  key = 1:15,
  label = paste("Option", 1:15),
  disabled = 1:15 %% 4 == 0
)
el_transfer("basic", data = items)

## filterable
#' `filter_method` searches the states by their initials.
#| shot_js = "var i = document.querySelector('#states .el-transfer-panel__filter input'); i.value = 'c'; i.dispatchEvent(new Event('input', {bubbles: true}));"
#| shot_expect = "document.querySelectorAll('#states .el-transfer-panel')[0].querySelectorAll('.el-transfer-panel__item').length === 3"
states <- c(
  "California",
  "Illinois",
  "Maryland",
  "Texas",
  "Florida",
  "Colorado",
  "Connecticut "
)
el_transfer(
  "states",
  data = data.frame(
    label = states,
    key = seq_along(states) - 1,
    initial = c("CA", "IL", "MD", "TX", "FL", "CO", "CT")
  ),
  filterable = TRUE,
  filter_method = JS(
    "function(query, item) { return item.initial.toLowerCase().includes(query.toLowerCase()); }"
  ),
  filter_placeholder = "State Abbreviations"
)

## customizable
#' The first draws each item with `render_content`, a function given `h`;
#' the second with the default slot, scoped with `option`. Both relabel the
#' panels and buttons, start with items checked, and put a button in each
#' footer.
#| shot_expect = c("document.querySelectorAll('.transfer-footer').length === 4", "document.querySelectorAll('#custom_slot .el-transfer-panel__item')[0].innerText.trim() === '2 - Option 2'")
items <- data.frame(
  key = 1:15,
  label = paste("Option", 1:15),
  disabled = 1:15 %% 4 == 0
)
custom <- function(id, ...) {
  tags$div(
    style = "text-align: center",
    el_transfer(
      id,
      data = items,
      value = 1,
      filterable = TRUE,
      left_default_checked = c(2, 3),
      right_default_checked = 1,
      titles = c("Source", "Target"),
      button_texts = c("To left", "To right"),
      format = list(noChecked = "${total}", hasChecked = "${checked}/${total}"),
      ...
    )
  )
}
footers <- function(side) {
  el_button(label = "Operation", size = "small", class = "transfer-footer")
}
tagList(
  tags$style(
    ".transfer-footer { margin-left: 15px; padding: 6px 5px; }
     #custom_render .el-transfer, #custom_slot .el-transfer {
       text-align: left; display: inline-block; }"
  ),
  tags$p(
    style = "text-align: center; margin: 0 0 20px",
    "Customize data items using render-content"
  ),
  custom(
    "custom_render",
    render_content = JS(
      "function(h, option) { return h('span', null, option.label); }"
    ),
    slots = list(`left-footer` = footers(), `right-footer` = footers())
  ),
  tags$p(
    style = "text-align: center; margin: 50px 0 20px",
    "Customize data items using scoped slot"
  ),
  custom(
    "custom_slot",
    slots = list(
      default = template(
        tags$span("{{ option.key }} - {{ option.label }}"),
        scope = "{ option }"
      ),
      `left-footer` = footers(),
      `right-footer` = footers()
    )
  )
)

## empty-content
#' The `left-empty` and `right-empty` slots draw an empty list: the right
#' one at the start.
#| shot_expect = "Array.from(document.querySelectorAll('#empty .el-empty')).filter(function(e) { return e.offsetParent; }).length === 1"
items <- data.frame(
  key = 1:15,
  label = paste("Option", 1:15),
  disabled = 1:15 %% 4 == 0
)
el_transfer(
  "empty",
  data = items,
  slots = list(
    `left-empty` = el_empty(
      "empty_left",
      image_size = 60,
      description = "No data"
    ),
    `right-empty` = el_empty(
      "empty_right",
      image_size = 60,
      description = "No data"
    )
  )
)

## prop-alias
#' Items whose fields are named otherwise: `props` says which is which.
items <- data.frame(
  value = 1:15,
  desc = paste("Option", 1:15),
  disabled = 1:15 %% 4 == 0
)
el_transfer(
  "aliases",
  data = items,
  props = list(key = "value", label = "desc")
)

## virtual-scroll
#' `virtual_scroll` draws only the rows in view, for long lists.
#| shot_expect = "document.querySelectorAll('#virtual .el-transfer-panel')[0].querySelectorAll('.el-transfer-panel__item').length < 50"
items <- data.frame(
  key = 1:2000,
  label = paste("Option", 1:2000),
  disabled = 1:2000 %% 4 == 0
)
el_transfer("virtual", data = items, virtual_scroll = TRUE, item_size = 30)
