# The Vue layer inside the Element layer, and the other way round: a
# vue_app() in each kind of Element component -- the Vue apps (scrollbar,
# splitter, popover, config provider), markup (a card), the containers drawn
# as markup (dialog, tabs, collapse) -- and Element tags in a vue_app()'s
# template.
library(shiny)
library(shiny.element)

counter <- function(id) {
  vue_app(
    id,
    tags$button(
      class = paste0("vc-", id),
      v_on(click = "n++"),
      "{{ n }}"
    ),
    data = list(n = 0),
    input = "n"
  )
}

ui <- el_page(
  tags$h4("In Element's Vue apps"),
  el_scrollbar(id = "sc", height = "60px", counter("in_scrollbar")),
  el_splitter(
    el_splitter_panel(counter("in_splitter")),
    el_splitter_panel(tags$span("right"))
  ),
  el_popover(
    "pop",
    reference = el_button("pop_btn", "Open popover"),
    trigger = "click",
    body = counter("in_popover")
  ),
  el_card(counter("in_card")),
  el_config_provider(id = "cfg", counter("in_provider")),
  tags$h4("In the containers drawn as markup"),
  el_button(
    "open",
    "Open dialog",
    on = list(click = "$vueStore.ui.open = true")
  ),
  vue_store("ui", state = list(open = FALSE)),
  el_dialog(
    "dlg",
    title = "Dialog",
    visible = v_model("$vueStore.ui.open"),
    content = counter("in_dialog")
  ),
  el_tabs(
    "tabs",
    tabs = list(
      el_tab_pane("A", counter("in_tab_a"), name = "a"),
      el_tab_pane("B", counter("in_tab_b"), name = "b")
    )
  ),
  el_collapse(
    "col",
    value = "p",
    items = list(el_collapse_item("Panel", counter("in_collapse"), name = "p"))
  ),
  tags$h4("Element tags in a vue_app()"),
  vue_app(
    "raw",
    tags$div(
      el$input(v_model("text"), class = "raw-in"),
      el$tag(v_if("text"), class = "raw-tag", "{{ text }}"),
      el$button(v_on(click = "text = 'clicked'"), class = "raw-btn", "set")
    ),
    data = list(text = ""),
    input = "text",
    use = "shinyElement.plugin"
  ),
  verbatimTextOutput("seen")
)

server <- function(input, output, session) {
  ids <- c(
    "in_scrollbar",
    "in_splitter",
    "in_popover",
    "in_card",
    "in_provider",
    "in_dialog",
    "in_tab_a",
    "in_tab_b",
    "in_collapse",
    "raw"
  )
  output$seen <- renderText(paste(
    vapply(ids, function(i) paste0(i, "=", format(input[[i]])), ""),
    collapse = " "
  ))
}

shinyApp(ui, server)
