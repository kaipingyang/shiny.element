## usage
#' The button switches the language of what is inside the provider, with
#' `update_el_config_provider(locale =)`: the table's empty text, the
#' pagination's words. The page's own language is `el_page(locale =)`.
#| shot_js = c("window.zh = document.querySelector('#cfg .el-pagination').innerText.indexOf('\\u5171') >= 0", "document.querySelector('#toggle button').click()")
#| shot_expect = c("window.zh", "document.querySelector('#cfg .el-pagination').innerText.indexOf('Total') >= 0")
ui <- el_page(
  el_button("toggle", "Switch Language"),
  tags$br(),
  el_config_provider(
    id = "cfg",
    locale = "zh-cn",
    el_table(data = data.frame(date = character(), name = character())),
    el_pagination("cfg_pg", total = 100, layout = "total, prev, pager, next")
  )
)
server <- function(input, output, session) {
  language <- reactiveVal("zh-cn")
  observeEvent(input$toggle, {
    language(if (language() == "zh-cn") "en" else "zh-cn")
    update_el_config_provider(session, "cfg", locale = language())
  })
}
shinyApp(ui, server)

## button
#' The checkboxes and the select are a store's fields, [v_model()]; the
#' provider's `button` settings a getter of the store built from them,
#' [v_bind()],
#' which the button inside takes as its defaults -- all in the browser.
#| shot_js = c("document.querySelector('#cfg_dashed .el-checkbox').click()", "document.querySelector('#cfg_plain .el-checkbox').click()")
#| shot_expect = c("document.querySelector('#cfg .el-button.is-dashed')", "!document.querySelector('#cfg .el-button.is-plain')")
vue_store(
  "cfg_button",
  state = list(
    autoInsertSpace = TRUE,
    type = "default",
    plain = TRUE,
    round = TRUE,
    text = FALSE,
    dashed = FALSE
  ),
  getters = list(config = JS("function(s) { return Object.assign({}, s); }"))
)
tags$div(
  el_checkbox(
    "cfg_space",
    "autoInsertSpace",
    value = v_model("$vueStore.cfg_button.autoInsertSpace")
  ),
  el_checkbox(
    "cfg_plain",
    "plain",
    value = v_model("$vueStore.cfg_button.plain")
  ),
  el_checkbox(
    "cfg_round",
    "round",
    value = v_model("$vueStore.cfg_button.round")
  ),
  el_checkbox(
    "cfg_dashed",
    "dashed",
    value = v_model("$vueStore.cfg_button.dashed")
  ),
  el_checkbox("cfg_text", "text", value = v_model("$vueStore.cfg_button.text")),
  el_select(
    "cfg_type",
    choices = c("primary", "success", "warning", "danger", "info", "default"),
    selected = v_model("$vueStore.cfg_button.type"),
    width = "150px"
  )
)
el_divider()
el_config_provider(
  id = "cfg",
  button = v_bind("$vueStore.cfg_button.config"),
  el_button("cfg_btn", "中文")
)

## link
#' The selects set the provider's `link` settings through a store's getter,
#' which the link inside takes as its defaults.
#| shot_js = c("document.querySelector('#cfg_type .el-select__wrapper').click()", "Array.from(document.querySelectorAll('.el-select-dropdown__item')).find(function(o){ return o.innerText.trim() === 'danger'; }).click()")
#| shot_expect = "document.querySelector('#cfg .el-link--danger')"
vue_store(
  "cfg_links",
  state = list(type = "success", underline = "always"),
  getters = list(config = JS("function(s) { return Object.assign({}, s); }"))
)
tags$div(
  style = "display: flex; gap: 16px",
  tags$div(
    style = "display: flex; flex-direction: column; gap: 4px; flex-basis: 150px",
    tags$span("Type:"),
    el_select(
      "cfg_type",
      choices = c("primary", "success", "warning", "info", "danger", "default"),
      selected = v_model("$vueStore.cfg_links.type")
    )
  ),
  tags$div(
    style = "display: flex; flex-direction: column; gap: 4px; flex-basis: 150px",
    tags$span("Underline:"),
    el_select(
      "cfg_underline",
      choices = c("always", "never", "hover"),
      selected = v_model("$vueStore.cfg_links.underline")
    )
  )
)
el_divider()
el_config_provider(
  id = "cfg",
  link = v_bind("$vueStore.cfg_links.config"),
  el_link("Link desu!", id = "cfg_link")
)

## card
#' The radios set the provider's `card` settings through a store's getter;
#' a card inside takes them when it sets no `shadow` of its own.
#| shot_js = "Array.from(document.querySelectorAll('#cfg_shadow .el-radio')).find(function(r){ return r.innerText.trim() === 'never'; }).click()"
#| shot_expect = "document.querySelector('.el-card.is-never-shadow')"
vue_store(
  "cfg_card",
  state = list(shadow = "always"),
  getters = list(config = JS("function(s) { return { shadow: s.shadow }; }"))
)
tags$span("Shadow:")
el_radio_group(
  "cfg_shadow",
  choices = c("always", "hover", "never"),
  value = v_model("$vueStore.cfg_card.shadow")
)
el_divider()
el_config_provider(
  id = "cfg",
  card = v_bind("$vueStore.cfg_card.config"),
  el_card("Card desu!")
)

## dialog
#' The switches set the provider's `dialog` settings through a store's
#' getter, which the dialog inside takes as its defaults; `overflow` is off
#' while the dialog cannot be dragged. Element's `transition` setting is not
#' taken: the dialog is markup and plays Element's own `dialog-fade`.
#| shot_js = c("document.querySelector('#cfg_align .el-switch').click()", "document.querySelector('#cfg_open button').click()")
#| shot_sel = ".el-overlay"
#| shot_expect = c("document.querySelector('#cfg_dlg .el-dialog.is-align-center')", "document.querySelector('#cfg_dlg .el-dialog__body').innerText.indexOf('Dialog Content') >= 0")
vue_store(
  "cfg_dialog",
  state = list(
    alignCenter = FALSE,
    draggable = FALSE,
    overflow = FALSE,
    open = FALSE
  ),
  getters = list(
    config = JS(
      "function(s) { return { alignCenter: s.alignCenter, draggable: s.draggable, overflow: s.overflow }; }"
    ),
    fixed = JS("function(s) { return !s.draggable; }")
  )
)
tags$div(
  style = "display: flex; flex-direction: column; gap: 16px",
  el_switch(
    "cfg_align",
    value = v_model("$vueStore.cfg_dialog.alignCenter"),
    active_text = "alignCenter"
  ),
  tags$div(
    style = "display: flex; gap: 16px",
    el_switch(
      "cfg_drag",
      value = v_model("$vueStore.cfg_dialog.draggable"),
      active_text = "draggable"
    ),
    el_switch(
      "cfg_overflow",
      value = v_model("$vueStore.cfg_dialog.overflow"),
      active_text = "overflow",
      disabled = v_bind("$vueStore.cfg_dialog.fixed")
    )
  ),
  tags$div(
    el_button(
      "cfg_open",
      "Open Dialog",
      type = "primary",
      size = "small",
      on = list(click = "$vueStore.cfg_dialog.open = true")
    )
  )
)
el_config_provider(
  id = "cfg",
  dialog = v_bind("$vueStore.cfg_dialog.config"),
  el_dialog(
    "cfg_dlg",
    title = "Dialog Title",
    destroy_on_close = TRUE,
    visible = v_model("$vueStore.cfg_dialog.open"),
    content = "Dialog Content"
  )
)

## message
#' The provider's `message` settings are Element Plus's page-wide message
#' defaults, so they reach every message on the page -- `$message()` in the
#' browser, `el_message()` from the server: at most three at a time, plain,
#' at the bottom.
#| shot_js = "var b = document.querySelector('.el-button'); [0, 300, 600, 900].forEach(function(t) { setTimeout(function() { b.click(); }, t); });", shot_wait = 2
#| shot_expect = c("document.querySelectorAll('.el-message').length === 3", "document.querySelector('.el-message.is-plain')", "document.querySelector('.el-message').style.bottom")
el_config_provider(
  message = list(max = 3, plain = TRUE, placement = "bottom"),
  el_button(
    "cfg_msg",
    "OPEN",
    on = list(click = "$message('This is a message from bottom.')")
  )
)

## empty-values
el_config_provider(
  value_on_clear = NULL,
  empty_values = list(NULL),
  el_select(
    "cfg_sel",
    choices = c("Option1", "Option2", "Option3"),
    clearable = TRUE,
    placeholder = "Select",
    width = "240px"
  )
)

## table
#' The checkbox and the select set the provider's `table` settings through
#' a store's getter: a column that sets no `show_overflow_tooltip` of its
#' own takes them.
#| shot_js = c("window.tip = Array.from(document.querySelectorAll('#cfg tbody tr:first-child .cell')).map(function(c) { return c.classList.contains('el-tooltip'); }).join()", "document.querySelector('#cfg_tip .el-checkbox').click()")
#| shot_expect = c("window.tip === 'false,true,true,true,false'", "document.querySelectorAll('#cfg tbody .cell.el-tooltip').length === 0")
vue_store(
  "cfg_table",
  state = list(showOverflowTooltip = TRUE, tooltipEffect = "dark"),
  getters = list(config = JS("function(s) { return Object.assign({}, s); }"))
)
tags$div(
  el_checkbox(
    "cfg_tip",
    "showOverflowTooltip",
    value = v_model("$vueStore.cfg_table.showOverflowTooltip")
  ),
  el_select(
    "cfg_effect",
    choices = c(dark = "dark", light = "light"),
    selected = v_model("$vueStore.cfg_table.tooltipEffect"),
    width = "150px"
  )
)
el_divider()
el_config_provider(
  id = "cfg",
  table = v_bind("$vueStore.cfg_table.config"),
  el_table(
    data = data.frame(
      date = c("2016-05-03", "2016-05-02", "2016-05-04"),
      name = "Tom",
      address = "No. 189, Grove St, Los Angeles, a long address for the cell"
    ),
    selection = TRUE,
    columns = list(
      el_table_column("date", "Date", width = 120),
      el_table_column("name", "Name", width = 120),
      el_table_column(
        "address",
        "Address (inherited from config-provider)",
        width = 300
      ),
      el_table_column(
        "address",
        "Address (explicit false)",
        show_overflow_tooltip = FALSE
      )
    )
  )
)
