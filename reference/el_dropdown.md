# Element UI Dropdown Menu

A dropdown menu triggered by hover or click. Each menu item fires a
command that is reported as a Shiny input.

## Usage

``` r
el_dropdown(
  id = NULL,
  trigger_label = "Dropdown",
  items = list(),
  trigger = "hover",
  type = NULL,
  size = NULL,
  split_button = FALSE,
  hide_on_click = TRUE,
  placement = "bottom-end",
  disabled = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Dropdown ID. Auto-generated UUID if `NULL`.

- trigger_label:

  Label or tag placed as the dropdown trigger. Default `"Dropdown"`.

- items:

  A list of menu items. Each element is a named list with:

  command

  :   Command value sent to `input$<id>` on click. Required.

  label

  :   Display text. Defaults to `command`.

  icon

  :   Icon class string (e.g. `"el-icon-edit"`). Optional.

  disabled

  :   Whether the item is disabled. Default `FALSE`.

  divided

  :   Whether to show a divider above this item. Default `FALSE`.

- trigger:

  Trigger event: `"hover"` (default) or `"click"`.

- type:

  Button type when `split_button = TRUE`: `"primary"`, etc.

- size:

  Component size: `NULL`, `"medium"`, `"small"`, `"mini"`.

- split_button:

  Whether to render as a split button (main + dropdown arrow). Default
  `FALSE`.

- hide_on_click:

  Whether to close the menu after an item is clicked. Default `TRUE`.

- placement:

  Dropdown placement: `"bottom-end"` (default), `"bottom"`,
  `"bottom-start"`, `"top"`, `"top-start"`, `"top-end"`.

- disabled:

  Whether the entire dropdown is disabled. Default `FALSE`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed dropdown component.

## Shiny inputs

- `input$<id>` — the `command` value of the last clicked item.

- `input$<id>_count` — click counter, incremented for each item click
  (useful to detect re-clicks of the same command).

## Examples

``` r
el_dropdown("dd1", "Actions",
  items = list(
    list(command = "edit",   label = "Edit",   icon = "el-icon-edit"),
    list(command = "copy",   label = "Copy",   icon = "el-icon-document"),
    list(command = "delete", label = "Delete", icon = "el-icon-delete",
         divided = TRUE)
  )
)
#> <div id="dd1_container">
#>   <el-dropdown :trigger="trigger" :hide-on-click="hideOnClick" :placement="placement" :disabled="disabled" :split-button="splitButton" @command="handleCommand">
#>     <span class="el-dropdown-link">
#>       Actions
#>       <i class="el-icon-arrow-down el-icon--right"></i>
#>     </span>
#>     <el-dropdown-menu slot="dropdown">
#>       <el-dropdown-item :command="&quot;edit&quot;" icon="el-icon-edit">Edit</el-dropdown-item>
#>       <el-dropdown-item :command="&quot;copy&quot;" icon="el-icon-document">Copy</el-dropdown-item>
#>       <el-dropdown-item :command="&quot;delete&quot;" :divided="true" icon="el-icon-delete">Delete</el-dropdown-item>
#>     </el-dropdown-menu>
#>   </el-dropdown>
#> </div>
#> <div class="vue html-widget html-fill-item" id="dd1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="dd1">{"x":{"el":"#dd1_container","data":{"trigger":"hover","hideOnClick":true,"placement":"bottom-end","disabled":false,"splitButton":false,"count":0},"methods":{"handleCommand":"function(cmd) { this.count++; Shiny.setInputValue('dd1', cmd); Shiny.setInputValue('dd1_count', this.count); }"}},"evals":["methods.handleCommand"],"jsHooks":[]}</script>
```
