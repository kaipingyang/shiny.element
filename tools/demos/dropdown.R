## basic-usage
items <- list(
  list(command = "a", label = "Action 1"),
  list(command = "b", label = "Action 2"),
  list(command = "c", label = "Action 3"),
  list(command = "d", label = "Action 4", disabled = TRUE),
  list(command = "e", label = "Action 5", divided = TRUE)
)
el_dropdown("dd", trigger_label = "Dropdown List", items = items)

## placements
items <- list(
  list(command = "1", label = "The Action 1st"),
  list(command = "2", label = "The Action 2nd"),
  list(command = "3", label = "The Action 3rd")
)
tags$div(
  style = "display: flex; flex-wrap: wrap; gap: 16px",
  lapply(
    c("top-start", "top", "top-end", "bottom-start", "bottom", "bottom-end"),
    function(p) {
      el_dropdown(
        paste0("dd_", p),
        placement = p,
        items = items,
        trigger_label = el_button(paste0("ddb_", p), p)
      )
    }
  )
)

## triggering-element
items <- list(
  list(command = "a", label = "Action 1"),
  list(command = "b", label = "Action 2"),
  list(command = "c", label = "Action 3")
)
tags$div(
  style = "display: flex; gap: 16px",
  el_dropdown(
    "dd_btn",
    items = items,
    trigger_label = el_button(
      "dd_btn_t",
      "Dropdown List",
      type = "primary",
      icon = "ArrowDown"
    )
  ),
  el_dropdown(
    "dd_split",
    items = items,
    split_button = TRUE,
    type = "primary",
    trigger_label = "Dropdown List"
  )
)

## how-to-trigger
items <- list(
  list(command = "a", label = "Action 1", icon = "Plus"),
  list(command = "b", label = "Action 2", icon = "CirclePlusFilled"),
  list(command = "c", label = "Action 3", icon = "CirclePlus")
)
tags$div(
  style = "display: flex; gap: 40px",
  tagList(
    tags$div("hover to trigger"),
    el_dropdown("dd_hover", items = items, trigger_label = "Dropdown List")
  ),
  tagList(
    tags$div("click to trigger"),
    el_dropdown(
      "dd_click",
      items = items,
      trigger = "click",
      trigger_label = "Dropdown List"
    )
  ),
  tagList(
    tags$div("right click to trigger"),
    el_dropdown(
      "dd_ctx",
      items = items,
      trigger = "contextmenu",
      trigger_label = "Dropdown List"
    )
  )
)

## menu-hiding-behavior
el_dropdown(
  "dd_keep",
  hide_on_click = FALSE,
  trigger_label = "Dropdown List",
  items = list(
    list(command = "a", label = "Action 1"),
    list(command = "b", label = "Action 2"),
    list(command = "c", label = "Action 3")
  )
)

## command-event
#' The item clicked is `input$<id>`, its `command`.
el_dropdown(
  "dd_cmd",
  trigger_label = "Dropdown List",
  items = list(
    list(command = "a", label = "Action 1"),
    list(command = "b", label = "Action 2"),
    list(command = "c", label = "Action 3")
  )
)

## dropdown-methods
#' `el_call(session, "dd_m", "handleOpen")` opens it from the server;
#' `"handleClose"` closes it.
el_dropdown(
  "dd_m",
  trigger = "contextmenu",
  trigger_label = "Dropdown List",
  items = list(
    list(command = "a", label = "Action 1"),
    list(command = "b", label = "Action 2")
  )
)

## sizes
items <- list(
  list(command = "a", label = "Action 1"),
  list(command = "b", label = "Action 2")
)
tags$div(
  style = "display: flex; gap: 16px",
  lapply(c("large", "default", "small"), function(s) {
    el_dropdown(
      paste0("dd_s_", s),
      size = s,
      split_button = TRUE,
      type = "primary",
      trigger_label = s,
      items = items
    )
  })
)

## virtual-trigger !skip
Element Plus's virtual trigger takes a DOM element from the page's own
script; in R, put the trigger in `trigger_label` instead.
