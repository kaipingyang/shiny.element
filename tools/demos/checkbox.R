## basic
row <- function(...) tags$div(style = "margin: 8px 0", ...)
tagList(
  row(
    el_checkbox("cb1", "Option 1", value = TRUE, size = "large"),
    el_checkbox("cb2", "Option 2", size = "large")
  ),
  row(el_checkbox("cb3", "Option 1"), el_checkbox("cb4", "Option 2")),
  row(
    el_checkbox("cb5", "Option 1", size = "small"),
    el_checkbox("cb6", "Option 2", size = "small")
  )
)

## disabled
tagList(
  el_checkbox("cbd1", "Disabled", disabled = TRUE),
  el_checkbox("cbd2", "Not disabled", value = TRUE)
)

## grouping
el_checkbox_group(
  "cbg",
  selected = c("Value selected and disabled", "Value A"),
  choices = list(
    el_option("Option A", "Value A"),
    el_option("Option B", "Value B"),
    el_option("Option C", "Value C"),
    el_option("disabled", "Value disabled", disabled = TRUE),
    el_option(
      "selected and disabled",
      "Value selected and disabled",
      disabled = TRUE
    )
  )
)

## options
#' Choices given in fields of other names, mapped with `props`.
el_checkbox_group(
  "cbo",
  selected = c("Value A"),
  props = list(label = "name", value = "id", disabled = "unable"),
  choices = list(
    el_option("Option A", "Value A"),
    el_option("Option B", "Value B"),
    el_option("Option C", "Value C")
  )
)

## intermediate
#' "Check all" ticks the group from the server, as Element Plus's demo does
#' in its handler: `observeEvent(input$all, update_el_checkbox_group(...))`.
tagList(
  el_checkbox("all", "Check all", indeterminate = TRUE),
  el_checkbox_group(
    "cities",
    choices = c("Shanghai", "Beijing", "Guangzhou", "Shenzhen"),
    selected = c("Shanghai", "Beijing")
  )
)

## limitation
el_checkbox_group(
  "cities_lim",
  choices = c("Shanghai", "Beijing", "Guangzhou", "Shenzhen"),
  selected = c("Shanghai", "Beijing"),
  min = 1,
  max = 2
)

## button-style
cities <- c("Shanghai", "Beijing", "Guangzhou", "Shenzhen")
tags$div(
  style = "display: grid; gap: 16px",
  el_checkbox_group(
    "cbb1",
    choices = cities,
    selected = "Shanghai",
    button = TRUE,
    size = "large"
  ),
  el_checkbox_group(
    "cbb2",
    choices = cities,
    selected = "Shanghai",
    button = TRUE
  ),
  el_checkbox_group(
    "cbb3",
    choices = cities,
    selected = "Shanghai",
    button = TRUE,
    size = "small"
  ),
  el_checkbox_group(
    "cbb4",
    choices = cities,
    selected = "Shanghai",
    button = TRUE,
    size = "small",
    disabled = TRUE
  )
)

## with-border
row <- function(...) tags$div(style = "margin-top: 16px", ...)
tagList(
  row(
    el_checkbox("cbr1", "Option1", value = TRUE, size = "large", border = TRUE),
    el_checkbox("cbr2", "Option2", size = "large", border = TRUE)
  ),
  row(
    el_checkbox("cbr3", "Option1", border = TRUE),
    el_checkbox("cbr4", "Option2", value = TRUE, border = TRUE)
  )
)
