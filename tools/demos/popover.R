## placement
#| shot_js = "var b = document.querySelector('#shot button'); ['mouseenter','mouseover'].forEach(function(t){ b.dispatchEvent(new MouseEvent(t, {bubbles: true})); });", shot_sel = ".el-popper", shot_wait = 1
places <- c(
  "top-start",
  "top",
  "top-end",
  "left",
  "right",
  "bottom-start",
  "bottom",
  "bottom-end"
)
tags$div(
  style = "padding: 60px 100px; display: flex; flex-wrap: wrap; gap: 12px",
  lapply(places, function(p) {
    el_popover(
      paste0("po_", gsub("-", "_", p)),
      reference = el$button(p),
      placement = p,
      title = "Title",
      popover_width = 200,
      content = "this is content, this is content, this is content"
    )
  })
)

## basic-usage
#| shot_js = "document.querySelectorAll('#shot button')[1].click()", shot_sel = ".el-popper", shot_wait = 1
tagList(lapply(c("hover", "click", "focus", "contextmenu"), function(t) {
  el_popover(
    paste0("p_", t),
    reference = el$button(t),
    trigger = t,
    title = "Title",
    popover_width = 200,
    placement = "bottom",
    content = "this is content, this is content, this is content"
  )
}))

## virtual-triggering
#' `virtual_ref` is a CSS selector for the element that opens the popover,
#' wherever it is on the page.
#| shot_js = "document.querySelector('#shot button').click()", shot_sel = ".el-popper", shot_wait = 1
tagList(
  el_button("vp_btn", "Click me"),
  el_popover(
    "vp",
    title = "With title",
    content = "Some content",
    trigger = "click",
    virtual_ref = "#vp_btn"
  )
)

## nested-information
#| shot_js = "document.querySelector('#shot button').click()", shot_sel = ".el-popper", shot_wait = 1
el_popover(
  "addr",
  reference = el$button("Click to activate"),
  trigger = "click",
  popover_width = 400,
  placement = "right",
  body = el_table(
    data = data.frame(
      date = c("2016-05-02", "2016-05-04"),
      name = c("Jack", "Jack"),
      address = c("New York City", "New York City")
    )
  )
)

## nested-operation
#' Opened and closed from the server with `update_el_popover(visible =)`.
#| shot_js = "document.querySelector('#shot .el-button').click()", shot_sel = ".el-popper", shot_wait = 1.5
ui <- el_page(el_popover(
  "confirm",
  popover_width = 160,
  placement = "top",
  reference = el_button("delete", "Delete"),
  body = tagList(
    tags$p("Are you sure to delete this?"),
    el_button("no", "cancel", size = "small", text = TRUE),
    el_button("yes", "confirm", size = "small", type = "primary")
  )
))
server <- function(input, output, session) {
  observeEvent(input$delete, update_el_popover(id = "confirm", visible = TRUE))
  observeEvent(
    c(input$no, input$yes),
    update_el_popover(id = "confirm", visible = FALSE),
    ignoreInit = TRUE
  )
}
shinyApp(ui, server)

## directive-usage !skip
Element Plus's `v-popover` directive is template syntax on another
component's element, and each component here is an application of its own,
so it has no R form. `virtual_ref` does what it does -- see Virtual
triggering above.
