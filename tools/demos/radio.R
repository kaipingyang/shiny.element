## basic-usage
tags$div(
  style = "display: grid; gap: 12px",
  el_radio_group(
    "rd_l",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1",
    size = "large"
  ),
  el_radio_group(
    "rd_d",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1"
  ),
  el_radio_group(
    "rd_s",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1",
    size = "small"
  ),
  el_radio_group(
    "rd_x",
    choices = c("Option 1" = "1", "Option 2" = "2"),
    selected = "1",
    size = "small",
    disabled = TRUE
  )
)

## disabled
el_radio_group(
  "rd_dis",
  choices = c("Option A" = "disabled", "Option B" = "selected and disabled"),
  selected = "selected and disabled",
  disabled = TRUE
)

## radio-group
el_radio_group(
  "rd_group",
  choices = c("Option A" = 3, "Option B" = 6, "Option C" = 9),
  selected = 3
)

## with-borders
#' A choice's `border = TRUE` draws it bordered.
tags$div(
  style = "display: grid; gap: 12px",
  el_radio_group(
    "rd_b1",
    selected = "1",
    size = "large",
    choices = list(
      list(label = "Option A", value = "1", border = TRUE),
      list(label = "Option B", value = "2", border = TRUE)
    )
  ),
  el_radio_group(
    "rd_b2",
    selected = "1",
    choices = list(
      list(label = "Option A", value = "1", border = TRUE),
      list(label = "Option B", value = "2", border = TRUE)
    )
  )
)

## options
el_radio_group(
  "rd_opts",
  selected = "Value A",
  props = list(label = "name", value = "id", disabled = "unable"),
  choices = list(
    el_option("Option A", "Value A"),
    el_option("Option B", "Value B"),
    el_option("Option C", "Value C")
  )
)

## radio-button
cities <- c("New York", "Washington", "Los Angeles", "Chicago")
tags$div(
  style = "display: grid; gap: 12px",
  el_radio_group(
    "rdb1",
    choices = cities,
    selected = "New York",
    button = TRUE,
    size = "large"
  ),
  el_radio_group(
    "rdb2",
    choices = cities,
    selected = "New York",
    button = TRUE
  ),
  el_radio_group(
    "rdb3",
    choices = cities,
    selected = "New York",
    button = TRUE,
    size = "small"
  )
)
