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
#' Each button opens its popover as its label says: `contextmenu` on a
#' right-click, as the browser's own menu, not on a left click. The last
#' one is opened and closed by the server, `update_el_popover(visible =)`.
#| shot_js = "document.querySelector('#p_manual_btn button, #p_manual .el-button:last-child').click()"
#| shot_sel = ".el-popper"
#| shot_wait = 1.5
#| shot_expect = "Array.from(document.querySelectorAll('.el-popover.el-popper')).filter(function(p) { return p.offsetParent; }).length === 1"
pop <- function(id, label, trigger, placement = NULL, ...) {
  el_popover(
    id,
    reference = el_button(label = label),
    trigger = trigger,
    placement = placement,
    title = "Title",
    popover_width = 200,
    content = "this is content, this is content, this is content",
    ...
  )
}
ui <- el_page(
  tags$style(".el-button + .el-button { margin-left: 8px; }"),
  pop("p_hover", "Hover to activate", "hover", "top-start"),
  pop("p_click", "Click to activate", "click", "bottom"),
  pop("p_focus", "Focus to activate", "focus", "right"),
  pop("p_contextmenu", "contextmenu to activate", "contextmenu"),
  el_popover(
    "p_manual",
    reference = el_button("p_manual_btn", "Manual to activate"),
    visible = FALSE,
    placement = "bottom",
    title = "Title",
    popover_width = 200,
    content = "this is content, this is content, this is content"
  )
)
server <- function(input, output, session) {
  observeEvent(input$p_manual_btn, {
    update_el_popover(
      session,
      "p_manual",
      visible = input$p_manual_btn %% 2 == 1
    )
  })
}
shinyApp(ui, server)

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
#' A popover holds any UI: a table, or rich content beside an avatar.
#| shot_js = "document.querySelector('#addr .el-button').click()"
#| shot_sel = ".el-popper"
#| shot_wait = 1
#| shot_expect = "document.querySelectorAll('.el-popper .el-table__body tr').length === 4"
avatar <- "https://avatars.githubusercontent.com/u/72015883?v=4"
tags$div(
  style = "display: flex; align-items: center",
  el_popover(
    "addr",
    reference = el_button(
      label = "Click to activate",
      style = "margin-right: 16px"
    ),
    trigger = "click",
    popover_width = 400,
    placement = "right",
    body = el_table(
      data = data.frame(
        date = c("2016-05-02", "2016-05-04", "2016-05-01", "2016-05-03"),
        name = "Jack",
        address = "New York City"
      ),
      columns = list(
        el_table_column("date", "date", width = 150),
        el_table_column("name", "name", width = 100),
        el_table_column("address", "address", width = 300)
      )
    )
  ),
  el_popover(
    "rich",
    reference = el_avatar(src = avatar),
    popover_width = 300,
    popper_style = paste(
      "box-shadow: rgb(14 18 22 / 35%) 0px 10px 38px -10px,",
      "rgb(14 18 22 / 20%) 0px 10px 20px -15px; padding: 20px;"
    ),
    body = tags$div(
      class = "demo-rich-conent",
      style = "display: flex; gap: 16px; flex-direction: column",
      el_avatar(size = 60, src = avatar, style = "margin-bottom: 8px"),
      tags$div(
        tags$p(
          class = "demo-rich-content__name",
          style = "margin: 0; font-weight: 500",
          "Element Plus"
        ),
        tags$p(
          class = "demo-rich-content__mention",
          style = "margin: 0; font-size: 14px; color: var(--el-color-info)",
          "@element-plus"
        )
      ),
      tags$p(
        class = "demo-rich-content__desc",
        style = "margin: 0",
        "Element Plus, a Vue 3 based component library for developers,",
        "designers and product managers"
      )
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
