# Tabs

Divide data collections which are related yet belong to different types.

## Basic usage

Basic and concise tabs.

Tabs provide a selective card functionality. By default the first tab is
selected as active, and you can activate any tab by setting the `value`
attribute.

``` r

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
```

User

Config

Role

Task

User

Config

Role

Task

## Card Style

Tabs styled as cards.

Set `type` to `card` can get a card-styled tab.

``` r

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
```

User

Config

Role

Task

User

Config

Role

Task

## Border card

Border card tabs.

Set `type` to `border-card`.

``` r

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
```

User

Config

Role

Task

User

Config

Role

Task

## Tab position

You can use `tab-position` attribute to set the tab’s position.

You can choose from four directions:
`tabPosition="left|right|top|bottom"`

The radios move the tabs: `tab_position` follows them in the browser,
\[v_bind()\].

``` r

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
```

User

Config

Role

Task

User

Config

Role

Task

## Custom Tab

You can use named slot to customize the tab label content.

A `label` may be markup.

``` r

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
```

Route

Config

Role

Task

Route

Config

Role

Task

## Add & close tab

Only card type Tabs support addable & closeable.

Tabs added and closed in the browser, as upstream’s: `el$tabs()` in a
\[vue_app()\], its panes a
[`v_for()`](https://kaipingyang.github.io/shiny.element/dev/reference/directives.md)
over the app’s list and `edit` its handler. An
[`el_tabs()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tabs.md)
is markup with no Vue of its own to follow a list; from the server it
takes a tab with \[insert_el_tab()\].

``` r

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
```

## Customized add button icon

``` r

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
```

Tab 1

Tab 2

Tab 1 content

Tab 2 content

## Customized trigger button of new tab

A button of its own adds a tab, and `tab-remove` closes one – as
upstream’s, in a \[vue_app()\].

``` r

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
```

## Default value

`selected` opens a tab other than the first.

``` r

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
```

User

Config

Role

Task

User

Config

Role

Task

## API

Element Plus’s tables, and beside each entry where it is in R.

### Tabs Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `model-value` | `selected` or `value`; `input$<id>` | binding value, name of the selected tab, the default value is the name of first tab | [^1] / [^2] |  | — |
| `default-value` | `selected (or value)` | The value of the tab that should be active when initially rendered. (avoid initial transition) | [^3] / [^4] |  | — |
| `type` | `type` | type of Tab | [^5]`'' \\| 'card' \\| 'border-card'` |  | ’’ |
| `closable` | `closable` | whether Tab is closable | [^6] |  | false |
| `addable` | `addable` | whether Tab is addable | [^7] |  | false |
| `editable` | `editable` | whether Tab is addable and closable | [^8] |  | false |
| `tab-position` | `tab_position` | position of tabs | [^9]`'top' \\| 'right' \\| 'bottom' \\| 'left'` |  | top |
| `stretch` | `stretch` | whether width of tab automatically fits its container | [^10] |  | false |
| `before-leave` | `before_leave` | hook function before switching tab. If `false` is returned or a `Promise` is returned and then is rejected, switching will be prevented | [^11]`(activeName: TabPaneName, oldActiveName: TabPaneName) => Awaitable<void \\| boolean>` |  | () =\> true |
| `tabindex` | `(set by the tabs)` | tabs tabindex | [^12] / [^13] |  | 0 |

### Tabs Events

| Element | In R | Description |
|----|----|----|
| `tab-click` | `input$<id>_tab_click`, with `events = "tab_click"` | triggers when a tab is clicked |
| `tab-change` | `input$<id>_tab_change`, with `events = "tab_change"` | triggers when `activeName` is changed |
| `tab-remove` | `input$<id>_tab_remove` | triggers when tab-remove button is clicked |
| `tab-add` | `input$<id>_tab_add` | triggers when tab-add button is clicked |
| `edit` | `input$<id>_edit`, with `events = "edit"` | triggers when tab-add button or tab-remove is clicked |

### Tabs Slots

| Element    | In R                        | Description               |
|------------|-----------------------------|---------------------------|
| `default`  | default content             | customize default content |
| `add-icon` | `slots = list(add-icon = )` | customize add button icon |
| `addIcon`  | `slots = list(addIcon = )`  | customize add button icon |

### Tab-pane Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `label` | `el_tab_pane(label =)` | title of the tab | [^14] |  | ’’ |
| `disabled` | `el_tab_pane(disabled =)` | whether Tab is disabled | [^15] |  | false |
| `closable` | `el_tab_pane(closable =)` | whether Tab is closable | [^16] |  | false |
| `lazy` | `el_tab_pane(lazy =)` | whether Tab is lazily rendered | [^17] |  | false |

### Tab-pane Slots

| Element   | In R                     | Description        |
|-----------|--------------------------|--------------------|
| `default` | default content          | Tab-pane’s content |
| `label`   | `slots = list(label = )` | Tab-pane’s label   |

[^1]: string

[^2]: number

[^3]: string

[^4]: number

[^5]: enum

[^6]: boolean

[^7]: boolean

[^8]: boolean

[^9]: enum

[^10]: boolean

[^11]: Function

[^12]: string

[^13]: number

[^14]: string

[^15]: boolean

[^16]: boolean

[^17]: boolean
