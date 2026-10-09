# Element Plus Dropdown Menu

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
  append_to = NULL,
  button_props = NULL,
  effect = NULL,
  max_height = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_options = NULL,
  popper_style = NULL,
  role = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL,
  width = NULL,
  slots = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_dropdown(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  trigger = NULL,
  type = NULL,
  size = NULL,
  split_button = NULL,
  hide_on_click = NULL,
  placement = NULL,
  show_timeout = NULL,
  hide_timeout = NULL,
  tabindex = NULL,
  append_to = NULL,
  button_props = NULL,
  effect = NULL,
  max_height = NULL,
  persistent = NULL,
  popper_class = NULL,
  popper_options = NULL,
  popper_style = NULL,
  role = NULL,
  show_arrow = NULL,
  teleported = NULL,
  trigger_keys = NULL,
  virtual_ref = NULL,
  virtual_triggering = NULL
)
```

## Arguments

- id:

  Dropdown ID. Auto-generated UUID if `NULL`.

- trigger_label:

  The dropdown's trigger. Text gets a down arrow after it; a tag – an
  icon, an avatar – is used as it is. Default `"Dropdown"`.

- items:

  A list of menu entries, each an
  [`el_dropdown_item()`](https://kaipingyang.github.io/shiny.element/reference/el_dropdown_item.md)
  – or a named list with the same fields:

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

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

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

- append_to:

  Which element the dropdown CONTENT appends to. Element Plus's
  `append-to` (CSSSelector / HTMLElement).

- button_props:

  Props for the button component, refer to Button Attributes. Element
  Plus's `button-props` (object).

- effect:

  Tooltip theme, built-in theme: `dark` / `light`. Element Plus's
  `effect` ('dark' \| 'light' / string).

- max_height:

  The max height of menu. Element Plus's `max-height` (string / number).

- persistent:

  When dropdown inactive and `persistent` is `false` , dropdown menu
  will be destroyed. Element Plus's `persistent` (boolean).

- popper_class:

  Custom class name for Dropdown's dropdown. Element Plus's
  `popper-class` (string / object).

- popper_options:

  Popper.js parameters. Element Plus's `popper-options` (object).

- popper_style:

  Custom style for Dropdown's dropdown. Element Plus's `popper-style`
  (string / object).

- role:

  The ARIA role attribute for the dropdown menu. Depending on the use
  case, you may want to change this to 'navigation'. Element Plus's
  `role` (enum).

- show_arrow:

  Whether the tooltip content has an arrow. Element Plus's `show-arrow`
  (boolean).

- teleported:

  Whether the dropdown popup is teleported to the body. Element Plus's
  `teleported` (boolean).

- trigger_keys:

  Specify which keys on the keyboard can trigger when pressed. Element
  Plus's `trigger-keys` (`string[]`).

- virtual_ref:

  A CSS selector, `"#help-icon"`, for an element elsewhere on the page
  that the dropdown is attached to, in place of a trigger of its own.
  Element Plus's `virtual-ref` takes the element itself; the selector is
  looked up in the browser.

- virtual_triggering:

  Whether virtual triggering is enabled. Element Plus's
  `virtual-triggering` (boolean); `TRUE` when `virtual_ref` is given.

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

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_dropdown()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_dropdown()`, the Shiny session,
  the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed dropdown component.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the `command` of the item clicked, as an event |
| `input$<id>_count` | unasked | the number of items clicked |
| `input$<id>_click` | unasked | if split-button is true, triggers when left button is clicked |
| `input$<id>_visible_change` | `events = "visible_change"` | triggers when the dropdown appears/disappears, the param is true when it appears, and false otherwise |

The same list as `el_events("el_dropdown")`, which says how an event's
arguments travel.

## Updating from the server

Server-side update for `el_dropdown()`.

Every other argument of `el_dropdown()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_dropdown()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_dropdown(
  "dd1",
  "Actions",
  items = list(
    list(command = "edit", label = "Edit", icon = "el-icon-edit"),
    list(command = "copy", label = "Copy", icon = "el-icon-document"),
    list(
      command = "delete",
      label = "Delete",
      icon = "el-icon-delete",
      divided = TRUE
    )
  )
)
#> <div id="dd1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dd1_container" style="display: contents">
#>   <el-dropdown :trigger="trigger" :hide-on-click="hideOnClick" :placement="placement" :disabled="disabled" :split-button="splitButton" @command="handleCommand" :type="type === null ? undefined : type" :size="size === null ? undefined : size" :show-timeout="showTimeout === null ? undefined : showTimeout" :hide-timeout="hideTimeout === null ? undefined : hideTimeout" :tabindex="tabindex === null ? undefined : tabindex" @click="elEmitClick" :append-to="appendTo === null ? undefined : appendTo" :button-props="buttonProps === null ? undefined : buttonProps" :effect="effect === null ? undefined : effect" :max-height="maxHeight === null ? undefined : maxHeight" :persistent="persistent === null ? undefined : persistent" :popper-class="popperClass === null ? undefined : popperClass" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :role="role === null ? undefined : role" :show-arrow="showArrow === null ? undefined : showArrow" :teleported="teleported === null ? undefined : teleported" :trigger-keys="triggerKeys === null ? undefined : triggerKeys" :virtual-ref="$elRef(virtualRef)" :virtual-triggering="virtualTriggering === null ? undefined : virtualTriggering">
#>     <span class="el-dropdown-link">
#>       Actions
#>       <el-icon class="el-icon--right"><arrow-down /></el-icon>
#>     </span>
#>     <template v-slot:dropdown>
#>       <el-dropdown-menu>
#>         <el-dropdown-item :command="&quot;edit&quot;" icon="Edit">Edit</el-dropdown-item>
#>         <el-dropdown-item :command="&quot;copy&quot;" icon="Document">Copy</el-dropdown-item>
#>         <el-dropdown-item :command="&quot;delete&quot;" :divided="true" icon="Delete">Delete</el-dropdown-item>
#>       </el-dropdown-menu>
#>     </template>
#>   </el-dropdown>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"trigger":"hover","hideOnClick":true,"placement":"bottom-end","disabled":false,"splitButton":false,"count":0,"type":null,"size":null,"showTimeout":null,"hideTimeout":null,"tabindex":null,"appendTo":null,"buttonProps":null,"effect":null,"maxHeight":null,"persistent":null,"popperClass":null,"popperOptions":null,"popperStyle":null,"role":null,"showArrow":null,"teleported":null,"triggerKeys":null,"virtualRef":null,"virtualTriggering":null},"methods":{"elEmitClick":"function() { window.shinyVue.emit('dd1', 'click', arguments); }","handleCommand":"function(cmd) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('dd1', cmd, {priority: 'event'}); window.Shiny && Shiny.setInputValue && Shiny.setInputValue('dd1_count', this.count); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitClick","options.methods.handleCommand"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_dropdown(session, "actions", disabled = TRUE)
  })
}
```
