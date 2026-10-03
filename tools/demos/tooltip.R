## basic
#| shot_js = "var b = document.querySelectorAll('#shot button')[4]; ['mouseenter','mouseover'].forEach(function(t){ b.dispatchEvent(new MouseEvent(t, {bubbles: true})); });", shot_sel = ".el-popper", shot_wait = 1
places <- c(
  "top-start",
  "top",
  "top-end",
  "left-start",
  "left",
  "left-end",
  "right-start",
  "right",
  "right-end",
  "bottom-start",
  "bottom",
  "bottom-end"
)
tags$div(
  style = "padding: 40px 80px",
  lapply(places, function(p) {
    el_tooltip(
      paste0("tip_", gsub("-", "_", p)),
      el$button(p),
      placement = p,
      content = paste(p, "prompts info"),
      effect = "dark"
    )
  })
)

## theme
#| shot_js = "var b = document.querySelector('#shot button'); ['mouseenter','mouseover'].forEach(function(t){ b.dispatchEvent(new MouseEvent(t, {bubbles: true})); });", shot_sel = ".el-popper", shot_wait = 1
tagList(
  el_tooltip(
    "dark",
    el$button("Dark"),
    content = "Top center",
    placement = "top"
  ),
  el_tooltip(
    "light",
    el$button("Light"),
    content = "Bottom center",
    placement = "bottom",
    effect = "light"
  ),
  el_tooltip(
    "custom",
    el$button("Customized theme"),
    content = "Bottom center",
    effect = "customized",
    placement = "bottom"
  )
)

## rich-content
#| shot_js = "var b = document.querySelector('#shot button'); ['mouseenter','mouseover'].forEach(function(t){ b.dispatchEvent(new MouseEvent(t, {bubbles: true})); });", shot_sel = ".el-popper", shot_wait = 1
el_tooltip(
  "multi",
  el$button("Top center"),
  placement = "top",
  slots = list(content = tags$div("multiple lines", tags$br(), "second line"))
)

## advanced-usage
#' Turned on and off from the server, `update_el_tooltip(disabled =)`.
ui <- el_page(
  el_switch("tip_on", value = TRUE, active_text = "tooltip on"),
  el_tooltip(
    "adv",
    el$button("Hover me"),
    content = "click the switch to turn me off",
    placement = "bottom"
  )
)
server <- function(input, output, session) {
  observeEvent(
    input$tip_on,
    update_el_tooltip(id = "adv", disabled = !input$tip_on)
  )
}
shinyApp(ui, server)

## html-content
#| shot_js = "var b = document.querySelector('#shot button'); ['mouseenter','mouseover'].forEach(function(t){ b.dispatchEvent(new MouseEvent(t, {bubbles: true})); });", shot_sel = ".el-popper", shot_wait = 1
el_tooltip(
  "html_tip",
  el$button("hover me"),
  raw_content = TRUE,
  content = "<span>The content can be <strong>HTML</strong></span>"
)

## virtual-trigger
#' Upstream hands `virtual-ref` an element from the page's script. In R,
#' `virtual_ref` is a CSS selector for it -- here a button drawn apart from
#' the tooltip -- and `virtual_triggering` turns on with it. A `JS()`
#' function returning an object with `getBoundingClientRect()` also works,
#' for a point that is not an element.
#| shot_js = "document.querySelector('#shot button').click()", shot_sel = ".el-popper", shot_wait = 1
tagList(
  el_button("vt_btn", "test"),
  el_tooltip(
    "vt",
    content = "Bottom center",
    placement = "bottom",
    effect = "light",
    trigger = "click",
    virtual_ref = "#vt_btn"
  )
)

## singleton
#' A `virtual_ref` matching several elements gives them one tooltip, which
#' moves to whichever the pointer is over.
#| shot_js = "var b = document.querySelectorAll('#shot .singleton-btn button'); b[1].dispatchEvent(new MouseEvent('mouseover', {bubbles: true})); setTimeout(function(){ b[1].click(); }, 100);", shot_sel = ".el-popper", shot_wait = 1
tagList(
  lapply(1:3, function(i) {
    tags$span(
      class = "singleton-btn",
      el_button(paste0("single_", i), "Click to open tooltip")
    )
  }),
  el_tooltip(
    "single",
    content = "Some content",
    trigger = "click",
    virtual_ref = ".singleton-btn",
    popper_class = "singleton-tooltip"
  ),
  tags$style(
    ".singleton-tooltip {
      transition: transform 0.3s var(--el-transition-function-fast-bezier);
    }"
  )
)

## controlled
#' Shown and hidden from the server, `update_el_tooltip(visible =)`, and
#' then stays as set.
el_tooltip("ctl", el$button("Hover me"), visible = TRUE, content = "controlled")

## animations
#| shot_js = "var b = document.querySelector('#shot button'); ['mouseenter','mouseover'].forEach(function(t){ b.dispatchEvent(new MouseEvent(t, {bubbles: true})); });", shot_sel = ".el-popper", shot_wait = 1
el_tooltip(
  "anim",
  el$button("trigger me"),
  content = "I am an el-tooltip",
  transition = "slide-fade"
)

## append-to
#| shot_js = "var b = document.querySelector('#shot button'); ['mouseenter','mouseover'].forEach(function(t){ b.dispatchEvent(new MouseEvent(t, {bubbles: true})); });", shot_sel = ".el-popper", shot_wait = 1
tags$div(
  id = "tip-host",
  el_tooltip(
    "app",
    el$button("Hover me"),
    content = "Appended to #tip-host",
    append_to = "#tip-host"
  )
)
