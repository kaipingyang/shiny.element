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
#| shot_sel = ".el-dropdown__popper"
#| shot_js = "document.querySelector('#dd_top .el-button').dispatchEvent(new MouseEvent('mouseenter'))"
#| shot_wait = 1
#| shot_expect = "Array.from(document.querySelectorAll('.el-dropdown__popper')).some(function(p) { return p.offsetParent; })"
items <- list(
  el_dropdown_item("1", "The Action 1st"),
  el_dropdown_item("2", "The Action 2nd"),
  el_dropdown_item("3", "The Action 3rd")
)
placements <- c(
  topStart = "top-start",
  top = "top",
  topEnd = "top-end",
  bottomStart = "bottom-start",
  bottom = "bottom",
  bottomEnd = "bottom-end"
)
tags$div(
  style = "display: flex; flex-wrap: wrap; align-items: center; gap: 16px",
  lapply(names(placements), function(label) {
    el_dropdown(
      paste0("dd_", label),
      placement = placements[[label]],
      items = items,
      trigger_label = el_button(label = label)
    )
  })
)

## triggering-element
#' With `split_button = TRUE` the left part is a button of its own: its
#' clicks are `input$dd_split_click`.
items <- function(divided = NULL) {
  lapply(1:5, function(i) {
    el_dropdown_item(
      paste0("a", i),
      paste("Action", i),
      divided = if (i == 4) divided
    )
  })
}
tags$div(
  style = "display: flex; flex-wrap: wrap; align-items: center; gap: 16px",
  el_dropdown(
    "dd_btn",
    items = items(),
    trigger_label = el_button(
      label = tagList(
        "Dropdown List",
        el_icon("ArrowDown", class = "el-icon--right")
      ),
      type = "primary"
    )
  ),
  el_dropdown(
    "dd_split",
    items = items(divided = TRUE),
    split_button = TRUE,
    type = "primary",
    trigger_label = "Dropdown List"
  )
)

## how-to-trigger
#| shot_sel = ".el-dropdown__popper"
#| shot_js = "document.querySelector('#dd_click .el-dropdown-link').click()"
#| shot_wait = 1
#| shot_expect = "document.querySelectorAll('.el-dropdown-menu__item [data-el-icon], .el-dropdown-menu__item .el-icon').length >= 5"
items <- list(
  el_dropdown_item("a", "Action 1", icon = "Plus"),
  el_dropdown_item("b", "Action 2", icon = "CirclePlusFilled"),
  el_dropdown_item("c", "Action 3", icon = "CirclePlus"),
  el_dropdown_item("d", "Action 4", icon = "Check"),
  el_dropdown_item("e", "Action 5", icon = "CircleCheck")
)
col <- function(title, id, trigger) {
  el_col(
    span = 8,
    tags$span(class = "demonstration", title),
    el_dropdown(
      id,
      items = items,
      trigger = trigger,
      trigger_label = "Dropdown List"
    )
  )
}
tagList(
  tags$style(
    ".block-col-2 .demonstration { display: block; margin-bottom: 20px;
       color: var(--el-text-color-secondary); font-size: 14px; }
     .block-col-2 .el-dropdown-link { display: flex; align-items: center; }"
  ),
  el_row(
    class = "block-col-2",
    col("hover to trigger", "dd_hover", "hover"),
    col("click to trigger", "dd_click", "click"),
    col("right click to trigger", "dd_ctx", "contextmenu")
  )
)

## menu-hiding-behavior
el_dropdown(
  "dd_keep",
  hide_on_click = FALSE,
  trigger_label = "Dropdown List",
  items = list(
    el_dropdown_item("a", "Action 1"),
    el_dropdown_item("b", "Action 2"),
    el_dropdown_item("c", "Action 3")
  )
)

## command-event
#' The item clicked is `input$<id>`, its `command`.
el_dropdown(
  "dd_cmd",
  trigger_label = "Dropdown List",
  items = list(
    el_dropdown_item("a", "Action 1"),
    el_dropdown_item("b", "Action 2"),
    el_dropdown_item("c", "Action 3")
  )
)

## dropdown-methods
#| shot_sel = ".el-dropdown__popper"
#' `call_el(session, id, "handleOpen")` opens a dropdown from the server and
#' `"handleClose"` closes it; `input$<id>_visible_change` says when one
#' opens or closes.
#| shot_js = c("document.querySelector('#dd_show button').click()", "window.opened = document.querySelector('#dd_list1 .el-dropdown-link').getAttribute('aria-expanded')", "document.querySelector('#dd_list2 .el-dropdown-link').dispatchEvent(new MouseEvent('contextmenu', {bubbles: true}))")
#| shot_wait = 1
#| shot_expect = c("window.opened === 'true'", "document.querySelector('#dd_list2 .el-dropdown-link').getAttribute('aria-expanded') === 'true'", "document.querySelector('#dd_list1 .el-dropdown-link').getAttribute('aria-expanded') === 'false'")
items <- list(
  el_dropdown_item("1", "Action 1"),
  el_dropdown_item("2", "Action 2"),
  el_dropdown_item("3", "Action 3"),
  el_dropdown_item("4", "Action 4", disabled = TRUE),
  el_dropdown_item("5", "Action 5", divided = TRUE)
)
ui <- el_page(
  tags$div(
    style = "font-size: 14px",
    tags$p(
      "open(close) the Dropdown list2 will close(open) the Dropdown List1."
    )
  ),
  tags$div(style = "margin: 15px", el_button("dd_show", "show")),
  tags$div(
    style = "display: flex; gap: 30px",
    el_dropdown(
      "dd_list1",
      trigger = "contextmenu",
      trigger_label = tags$span(class = "el-dropdown-link", "Dropdown List1"),
      items = items
    ),
    el_dropdown(
      "dd_list2",
      trigger = "contextmenu",
      trigger_label = tags$span(class = "el-dropdown-link", "Dropdown List2"),
      items = items
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$dd_show, call_el(session, "dd_list1", "handleOpen"))
  observeEvent(input$dd_list2_visible_change, {
    method <- if (isTRUE(input$dd_list2_visible_change)) {
      "handleClose"
    } else {
      "handleOpen"
    }
    call_el(session, "dd_list1", method)
  })
}
shinyApp(ui, server)

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

## virtual-trigger
#' `virtual_ref` is a CSS selector for the element the menu opens from, here
#' a card: right-click it. Upstream also moves the menu to the pointer, from
#' its own script; here it opens at the card's corner.
#| shot_js = "var c = document.querySelector('#ctx-card .el-card'); c.dispatchEvent(new MouseEvent('contextmenu', {bubbles: true, clientX: 20, clientY: 20}));", shot_sel = ".el-popper", shot_wait = 1
tagList(
  tags$div(
    id = "ctx-card",
    el_card(
      tags$div(
        style = "height: 160px; display: flex; align-items: center;
          justify-content: center",
        "Right click"
      )
    )
  ),
  el_dropdown(
    "vdd",
    virtual_ref = "#ctx-card .el-card",
    trigger = "contextmenu",
    placement = "bottom-start",
    show_arrow = FALSE,
    items = list(
      el_dropdown_item("a1", "Action 1", icon = "Plus"),
      el_dropdown_item("a2", "Action 2", icon = "CirclePlusFilled"),
      el_dropdown_item("a3", "Action 3", icon = "CirclePlus"),
      el_dropdown_item("a4", "Action 4", icon = "Check"),
      el_dropdown_item("a5", "Action 5", icon = "CircleCheck")
    )
  )
)
