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
  show_timeout = NULL,
  hide_timeout = NULL,
  tabindex = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Dropdown ID. Auto-generated UUID if `NULL`.

- trigger_label:

  The dropdown's trigger. Text gets a down arrow after it; a tag – an
  icon, an avatar – is used as it is. Default `"Dropdown"`.

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

- show_timeout:

  Delay in ms before the menu appears, for `trigger = "hover"`.

- hide_timeout:

  Delay in ms before the menu hides, for `trigger = "hover"`.

- tabindex:

  Tab index of the dropdown trigger.

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

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
#> <div id="dd1" data-el-vue-host style="display: contents">
#>   <div id="dd1_container" data-el-mount style="display: contents">
#>     <el-dropdown :trigger="trigger" :hide-on-click="hideOnClick" :placement="placement" :disabled="disabled" :split-button="splitButton" @command="handleCommand" :type="type === null ? undefined : type" :size="size === null ? undefined : size" :show-timeout="showTimeout === null ? undefined : showTimeout" :hide-timeout="hideTimeout === null ? undefined : hideTimeout" :tabindex="tabindex === null ? undefined : tabindex" @click="elEmitClick" @visible-change="elEmitVisibleChange">
#>       <span class="el-dropdown-link">
#>         Actions
#>         <i class="el-icon-arrow-down el-icon--right"></i>
#>       </span>
#>       <el-dropdown-menu slot="dropdown">
#>         <el-dropdown-item :command="&quot;edit&quot;" icon="el-icon-edit">Edit</el-dropdown-item>
#>         <el-dropdown-item :command="&quot;copy&quot;" icon="el-icon-document">Copy</el-dropdown-item>
#>         <el-dropdown-item :command="&quot;delete&quot;" :divided="true" icon="el-icon-delete">Delete</el-dropdown-item>
#>       </el-dropdown-menu>
#>     </el-dropdown>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"trigger":"hover","hideOnClick":true,"placement":"bottom-end","disabled":false,"splitButton":false,"count":0,"type":null,"size":null,"showTimeout":null,"hideTimeout":null,"tabindex":null},"methods":{"elEmitClick":"function() { window.shinyElement.emit('dd1', 'click', arguments); }","elEmitVisibleChange":"function() { window.shinyElement.emit('dd1', 'visible_change', arguments); }","handleCommand":"function(cmd) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('dd1', cmd); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('dd1_count', this.count); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitClick","options.methods.elEmitVisibleChange","options.methods.handleCommand"]}</script>
#> </div>
```
