# Element UI Switch

Creates an Element UI switch with Vue instance.

## Usage

``` r
el_switch(
  id = NULL,
  value = FALSE,
  disabled = FALSE,
  width = NULL,
  active_text = NULL,
  inactive_text = NULL,
  active_color = NULL,
  inactive_color = NULL,
  active_value = TRUE,
  inactive_value = FALSE,
  active_icon_class = NULL,
  inactive_icon_class = NULL,
  name = NULL,
  validate_event = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Switch ID. Auto-generated UUID if `NULL`.

- value:

  Initial switch state. Default `FALSE`.

- disabled:

  Whether the switch is disabled. Default `FALSE`.

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

- active_icon_class:

  Icon class shown on the active side; overrides `active_text`.

- inactive_icon_class:

  Icon class shown on the inactive side; overrides `inactive_text`.

- name:

  Native `name` attribute of the inner checkbox.

- validate_event:

  Whether a change triggers form validation. Default `TRUE`.

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

An `htmltools` tagList with a Vue-managed switch component.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `focus()` – Focus the Switch component

## Shiny input

`input$<id>` — the value of `active_value` (when on) or `inactive_value`
(when off), matching the types of those arguments.

## Examples

``` r
el_switch("sw1", value = TRUE)
#> <div id="sw1" data-el-vue-host style="display: contents">
#>   <div id="sw1_container" data-el-mount style="display: contents">
#>     <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :active-icon-class="activeIconClass === null ? undefined : activeIconClass" :inactive-icon-class="inactiveIconClass === null ? undefined : inactiveIconClass" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent"></el-switch>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"value":true,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"activeIconClass":null,"inactiveIconClass":null,"name":null,"validateEvent":null},"methods":{"handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('sw1', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleChange"]}</script>
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
```
