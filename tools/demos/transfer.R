## basic
#' `data` is a data frame of `key` and `label` (and `disabled`), and
#' `input$<id>` the keys on the right.
items <- data.frame(
  key = 1:15,
  label = paste("Option", 1:15),
  disabled = 1:15 %% 4 == 0
)
el_transfer("basic", data = items, value = c(1, 4))

## filterable
states <- c(
  "California",
  "Illinois",
  "Maryland",
  "Texas",
  "Florida",
  "Colorado",
  "Connecticut"
)
el_transfer(
  "states",
  data = data.frame(key = seq_along(states), label = states),
  filterable = TRUE,
  filter_placeholder = "State Abbreviations"
)

## customizable
#' `titles`, `button_texts` and `format` relabel it; the default slot,
#' scoped with `option`, draws each item.
items <- data.frame(key = 1:15, label = paste("Option", 1:15))
el_transfer(
  "custom",
  data = items,
  value = 1,
  filterable = TRUE,
  titles = c("Source", "Target"),
  button_texts = c("To left", "To right"),
  format = list(noChecked = "${total}", hasChecked = "${checked}/${total}"),
  slots = list(
    default = template(
      tags$span("{{ option.key }} - {{ option.label }}"),
      scope = "{ option }"
    )
  )
)

## empty-content
items <- data.frame(key = integer(0), label = character(0))
el_transfer(
  "empty",
  data = items,
  slots = list(
    leftEmpty = el_empty(image_size = 60, description = "No data"),
    rightEmpty = el_empty(image_size = 60, description = "No data")
  )
)

## prop-alias
#' Items whose fields are named otherwise: `props` says which is which.
items <- data.frame(value = 1:15, desc = paste("Option", 1:15))
el_transfer(
  "aliases",
  data = items,
  props = list(key = "value", label = "desc")
)

## virtual-scroll
#' `virtual_scroll` draws only the rows in view, for long lists.
items <- data.frame(key = 1:10000, label = paste("Option", 1:10000))
el_transfer(
  "virtual",
  data = items,
  virtual_scroll = TRUE,
  item_size = 34,
  filterable = TRUE
)
