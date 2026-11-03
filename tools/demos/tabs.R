## basic
el_tabs(
  "basic",
  selected = "first",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)

## card-style
el_tabs(
  "card",
  type = "card",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)

## border-card
el_tabs(
  "bc",
  type = "border-card",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)

## tab-position
#' The radios move the tabs: `tab_position` follows them in the browser,
#' [v_bind()].
#| shot_js = "Array.from(document.querySelectorAll('#position .el-radio-button')).find(function(r){ return r.innerText.trim() === 'left'; }).click()"
#| shot_expect = c("document.querySelector('#tabs_pos.el-tabs--left .el-tabs__header.is-left.el-tabs__header-vertical')", "document.querySelector('#tabs_pos').firstElementChild.classList.contains('el-tabs__header')")
el_radio_group(
  "position",
  choices = c("top", "right", "bottom", "left"),
  value = "top",
  button = TRUE
)
tags$div(style = "height: 16px")
el_tabs(
  "tabs_pos",
  tab_position = v_bind("$inputs.position"),
  tabs = list(
    el_tab_pane("User", "User"),
    el_tab_pane("Config", "Config"),
    el_tab_pane("Role", "Role"),
    el_tab_pane("Task", "Task")
  )
)

## custom-tab
#' A `label` may be markup.
el_tabs(
  "cus",
  type = "border-card",
  tabs = list(
    el_tab_pane(
      tagList(el_icon("Calendar"), " Route"),
      "Route",
      name = "route"
    ),
    el_tab_pane("Config", "Config", name = "config"),
    el_tab_pane("Role", "Role", name = "role"),
    el_tab_pane("Task", "Task", name = "task")
  )
)

## dynamic-tabs
#' Tabs added and closed in the browser, as upstream's: `el$tabs()` in a
#' [vue_app()], its panes a `v_for()` over the app's list and `edit` its
#' handler. An `el_tabs()` is markup with no Vue of its own to follow a
#' list; from the server it takes a tab with [insert_el_tab()].
#| shot_js = "var b = document.querySelector('#docs_tabs .el-tabs__new-tab'); b.click(); setTimeout(function(){ b.click(); }, 600)", shot_wait = 2.5
tags$style(
  ".demo-tabs > .el-tabs__content { padding: 32px; color: #6b778c;
     font-size: 32px; font-weight: 600; }"
)
vue_app(
  "docs_tabs",
  el$tabs(
    v_model("editableTabsValue"),
    type = "card",
    editable = NA,
    class = "demo-tabs",
    v_on(edit = "handleTabsEdit"),
    el$tab_pane(
      v_for("item in editableTabs", key = "item.name"),
      label = v_bind("item.title"),
      name = v_bind("item.name"),
      "{{ item.content }}"
    )
  ),
  data = list(
    tabIndex = 2,
    editableTabsValue = "2",
    editableTabs = list(
      list(title = "Tab 1", name = "1", content = "Tab 1 content"),
      list(title = "Tab 2", name = "2", content = "Tab 2 content")
    )
  ),
  methods = list(
    handleTabsEdit = JS(
      "function(targetName, action) {",
      "  if (action === 'add') {",
      "  var newTabName = String(++this.tabIndex);",
      "  this.editableTabs.push({ title: 'New Tab', name: newTabName, content: 'New Tab content' });",
      "  this.editableTabsValue = newTabName;",
      "  } else if (action === 'remove') {",
      "  var tabs = this.editableTabs;",
      "  var activeName = this.editableTabsValue;",
      "  if (activeName === targetName) {",
      "    tabs.forEach(function(tab, index) {",
      "      if (tab.name === targetName) {",
      "        var nextTab = tabs[index + 1] || tabs[index - 1];",
      "        if (nextTab) activeName = nextTab.name;",
      "      }",
      "    });",
      "  }",
      "  this.editableTabsValue = activeName;",
      "  this.editableTabs = tabs.filter(function(tab) { return tab.name !== targetName; });",
      "  }",
      "}"
    )
  ),
  use = "shinyElement.plugin"
)

## customized-add-button-icon
el_tabs(
  "icon",
  type = "card",
  editable = TRUE,
  add_icon = "CirclePlus",
  tabs = list(
    el_tab_pane("Tab 1", "Tab 1 content", name = "1"),
    el_tab_pane("Tab 2", "Tab 2 content", name = "2")
  )
)

## customized-trigger
#' A button of its own adds a tab, and `tab-remove` closes one -- as
#' upstream's, in a [vue_app()].
#| shot_js = "document.querySelector('#trigger_tabs button').click()", shot_wait = 1.5
tags$style(
  ".demo-tabs > .el-tabs__content { padding: 32px; color: #6b778c;
     font-size: 32px; font-weight: 600; }"
)
vue_app(
  "trigger_tabs",
  tags$div(
    tags$div(
      style = "margin-bottom: 20px",
      el$button(
        size = "small",
        v_on(click = "addTab(editableTabsValue)"),
        "add tab"
      )
    ),
    el$tabs(
      v_model("editableTabsValue"),
      type = "card",
      class = "demo-tabs",
      closable = NA,
      v_on("tab-remove" = "removeTab"),
      el$tab_pane(
        v_for("item in editableTabs", key = "item.name"),
        label = v_bind("item.title"),
        name = v_bind("item.name"),
        "{{ item.content }}"
      )
    )
  ),
  data = list(
    tabIndex = 2,
    editableTabsValue = "2",
    editableTabs = list(
      list(title = "Tab 1", name = "1", content = "Tab 1 content"),
      list(title = "Tab 2", name = "2", content = "Tab 2 content")
    )
  ),
  methods = list(
    addTab = JS(
      "function(targetName) {",
      "  var newTabName = String(++this.tabIndex);",
      "  this.editableTabs.push({ title: 'New Tab', name: newTabName, content: 'New Tab content' });",
      "  this.editableTabsValue = newTabName;",
      "}"
    ),
    removeTab = JS(
      "function(targetName) {",
      "  var tabs = this.editableTabs;",
      "  var activeName = this.editableTabsValue;",
      "  if (activeName === targetName) {",
      "    tabs.forEach(function(tab, index) {",
      "      if (tab.name === targetName) {",
      "        var nextTab = tabs[index + 1] || tabs[index - 1];",
      "        if (nextTab) activeName = nextTab.name;",
      "      }",
      "    });",
      "  }",
      "  this.editableTabsValue = activeName;",
      "  this.editableTabs = tabs.filter(function(tab) { return tab.name !== targetName; });",
      "}"
    )
  ),
  use = "shinyElement.plugin"
)

## default-value
#' `selected` opens a tab other than the first.
el_tabs(
  "dv",
  selected = "third",
  type = "card",
  tabs = list(
    el_tab_pane("User", "User", name = "first"),
    el_tab_pane("Config", "Config", name = "second"),
    el_tab_pane("Role", "Role", name = "third"),
    el_tab_pane("Task", "Task", name = "fourth")
  )
)
