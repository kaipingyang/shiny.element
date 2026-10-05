# Element Plus Switch

Creates an Element Plus switch with Vue instance.

## Usage

``` r
el_switch(
  id = NULL,
  value = FALSE,
  disabled = FALSE,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL,
  active_value = TRUE,
  inactive_value = FALSE,
  name = NULL,
  validate_event = NULL,
  active_action_icon = NULL,
  active_icon = NULL,
  aria_label = NULL,
  before_change = NULL,
  border_color = NULL,
  inactive_action_icon = NULL,
  inactive_icon = NULL,
  inline_prompt = NULL,
  loading = NULL,
  size = NULL,
  tabindex = NULL,
  slots = NULL,
  session = NULL
)

update_el_switch(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL,
  label = NULL,
  error = NULL,
  active_value = NULL,
  inactive_value = NULL,
  name = NULL,
  validate_event = NULL,
  active_action_icon = NULL,
  active_icon = NULL,
  aria_label = NULL,
  before_change = NULL,
  border_color = NULL,
  inactive_action_icon = NULL,
  inactive_icon = NULL,
  inline_prompt = NULL,
  loading = NULL,
  size = NULL,
  tabindex = NULL
)
```

## Arguments

- id:

  Switch ID. Auto-generated UUID if `NULL`.

- value:

  Initial switch state. Default `FALSE`.

- disabled:

  Whether the switch is disabled. Default `FALSE`.

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- label_position:

  Where the label sits, as
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)'s
  `label_position`: `"top"` (the default, as Shiny's labels sit), or
  beside the component, its text aligned `"left"` or `"right"` – which
  shows once `label_width` gives the labels a common width.

- label_width:

  Width of a label beside the component, as a CSS unit, so that several
  line up. Element's `label-width`.

- label_suffix:

  Text after the label, such as `":"`. Element's `label-suffix`.

- required:

  Draw Element's red asterisk before the label. It marks the field; it
  does not check it – shinyvalidate or
  [`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md)
  does that.

- error:

  An error message shown under the component in Element's style, the
  field framed in red. Element's `error`.

- show_message, inline_message:

  Whether `error`'s message is shown, and whether beside the component
  rather than under it. Element's `show-message` and `inline-message`.

- width:

  Switch width in pixels (integer).

- active_text:

  Text displayed when switch is on.

- inactive_text:

  Text displayed when switch is off.

- active_color:

  Background color when switch is on (e.g. `"#409EFF"`).

- inactive_color:

  Background color when switch is off.

- active_value:

  Value reported to Shiny when switch is on. Default `TRUE`.

- inactive_value:

  Value reported to Shiny when switch is off. Default `FALSE`.

- name:

  Native `name` attribute of the inner checkbox.

- validate_event:

  Whether a change triggers form validation. Default `TRUE`.

- active_action_icon:

  Component of the icon displayed in action when in `on` state. Element
  Plus's `active-action-icon` (string / Component). An icon's name, such
  as `"Search"`.

- active_icon:

  Component of the icon displayed when in `on` state, overrides
  `active-text`. Element Plus's `active-icon` (string / Component). An
  icon's name, such as `"Search"`.

- aria_label:

  Same as `aria-label` in native input. Element Plus's `aria-label`
  (string).

- before_change:

  Before-change hook before the switch state changes. If `false` is
  returned or a `Promise` is returned and then is rejected, will stop
  switching. Element Plus's `before-change`
  (`() => Promise<boolean> | boolean`).

- border_color:

  Border color of the switch ( use CSS var `--el-switch-border-color`
  instead ). Element Plus's `border-color` (string).

- inactive_action_icon:

  Component of the icon displayed in action when in `off` state. Element
  Plus's `inactive-action-icon` (string / Component). An icon's name,
  such as `"Search"`.

- inactive_icon:

  Component of the icon displayed when in `off` state, overrides
  `inactive-text`. Element Plus's `inactive-icon` (string / Component).
  An icon's name, such as `"Search"`.

- inline_prompt:

  Whether icon or text is displayed inside dot, only the first character
  will be rendered for text. Element Plus's `inline-prompt` (boolean).

- loading:

  Whether Switch is in loading state. Element Plus's `loading`
  (boolean).

- size:

  Size of Switch. Element Plus's `size` (” \| 'large' \| 'default' \|
  'small').

- tabindex:

  Tabindex for input. Element Plus's `tabindex` (string / number).

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  In `el_switch()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_switch()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed switch component.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- `focus()` – Focus the Switch component

## Shiny inputs

`input$<id>` – the value of `active_value` (when on) or `inactive_value`
(when off), matching the types of those arguments.

## Updating from the server

Server-side update for `el_switch()`. Pass only the fields to change;
`NULL` fields are excluded from the update message.

Every other argument of `el_switch()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

`update_el_switch()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_switch("sw1", value = TRUE)
#> <div id="sw1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="sw1_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent" :active-action-icon="activeActionIcon === null ? undefined : activeActionIcon" :active-icon="activeIcon === null ? undefined : activeIcon" :aria-label="ariaLabel === null ? undefined : ariaLabel" :before-change="beforeChange === null ? undefined : beforeChange" :border-color="borderColor === null ? undefined : borderColor" :inactive-action-icon="inactiveActionIcon === null ? undefined : inactiveActionIcon" :inactive-icon="inactiveIcon === null ? undefined : inactiveIcon" :inline-prompt="inlinePrompt === null ? undefined : inlinePrompt" :loading="loading === null ? undefined : loading" :size="size === null ? undefined : size" :tabindex="tabindex === null ? undefined : tabindex"></el-switch>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":true,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"name":null,"validateEvent":null,"activeActionIcon":null,"activeIcon":null,"ariaLabel":null,"beforeChange":null,"borderColor":null,"inactiveActionIcon":null,"inactiveIcon":null,"inlinePrompt":null,"loading":null,"size":null,"tabindex":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>

if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_switch("sw1", active_text = "On", inactive_text = "Off"),
    verbatimTextOutput("state")
  )
  server <- function(input, output, session) {
    output$state <- renderPrint(input$sw1)
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_switch(session, "live", value = TRUE)
  })
}
```
