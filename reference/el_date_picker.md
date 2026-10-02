# Element UI Date Picker Component

Creates an Element UI date picker with Vue instance, supporting single
date, datetime, month, year, week, and date range selection modes.

## Usage

``` r
el_date_picker(
  id = NULL,
  value = NULL,
  type = "date",
  value_format = "yyyy-MM-dd",
  format = NULL,
  placeholder = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  clearable = TRUE,
  disabled = FALSE,
  editable = TRUE,
  readonly = FALSE,
  range_separator = "-",
  align = "left",
  size = NULL,
  name = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  popper_class = NULL,
  default_value = NULL,
  default_time = NULL,
  unlink_panels = NULL,
  picker_options = NULL,
  validate_event = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  slots = NULL,
  append_to_body = NULL,
  time_arrow_control = NULL,
  session = NULL
)
```

## Arguments

- id:

  Date picker ID. Auto-generated UUID if `NULL`.

- value:

  Initial value. A `Date` object, a string in the format matching
  `value_format`, or a two-element character vector for range types.
  `NULL` (default) leaves the picker empty.

- type:

  Picker type: `"date"` (default), `"datetime"`, `"daterange"`,
  `"datetimerange"`, `"month"`, `"year"`, `"week"`.

- value_format:

  Format string returned to Shiny when a date is selected. Uses Element
  UI format tokens (e.g., `"yyyy-MM-dd"`). Default `"yyyy-MM-dd"`.

- format:

  Display format shown in the input box. Uses Element UI format tokens.
  `NULL` (default) falls back to `value_format`.

- placeholder:

  Placeholder text for non-range types.

- start_placeholder:

  Placeholder for the start input in range types.

- end_placeholder:

  Placeholder for the end input in range types.

- clearable:

  Whether to show the clear button. Default `TRUE`.

- disabled:

  Whether the picker is disabled. Default `FALSE`.

- editable:

  Whether the user can type directly in the input. Default `TRUE`.

- readonly:

  Whether the picker is read-only. Default `FALSE`.

- range_separator:

  Separator string displayed between start and end in range types.
  Default `"-"`.

- align:

  Input alignment: `"left"` (default), `"center"`, `"right"`.

- size:

  Input size: `"medium"`, `"small"` or `"mini"`.

- name:

  Native `name` attribute.

- prefix_icon:

  Icon class shown at the start of the input.

- clear_icon:

  Icon class of the clear button.

- popper_class:

  Extra class name for the picker panel.

- default_value:

  Date the panel opens on when nothing is selected.

- default_time:

  Time part used when a date is picked, as `"HH:mm:ss"`.

- unlink_panels:

  Whether the two panels of a range picker move independently.

- picker_options:

  Additional Element picker options, as a named list.

- validate_event:

  Whether a change triggers form validation. Default `TRUE`.

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

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a number taken
  as pixels. Element's own markup carries it, so it behaves like the
  `width` argument of a Shiny input.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- append_to_body:

  Whether the picker panel is appended to `body`. Default `TRUE`;
  `FALSE` keeps it inside a dialog or a scrolling container.

- time_arrow_control:

  For `type = "datetime"`: whether the time is picked with arrow buttons
  rather than by scrolling.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList with a Vue-managed date picker component.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `focus()` – Focus the Input component

## Shiny inputs

`input$<id>` – for `type` `"date"`, `"dates"` and `"daterange"` with the
default `value_format`, a `Date` (two for a range, several for
`"dates"`), as
[`shiny::dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html)
gives one; `NULL` while empty. Any other type or `value_format` reports
the text the picker produces, in that format – you asked for that
format, so it is not converted.

## Examples

``` r
# Basic date picker
el_date_picker("dp1")
#> <div id="dp1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dp1_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :default-time="defaultTime === null ? undefined : defaultTime" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :picker-options="pickerOptions === null ? undefined : pickerOptions" :validate-event="validateEvent === null ? undefined : validateEvent" :append-to-body="appendToBody === null ? undefined : appendToBody" :time-arrow-control="timeArrowControl === null ? undefined : timeArrowControl" @blur="elEmitBlur" @focus="elEmitFocus"></el-date-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"date","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left","placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"pickerOptions":null,"validateEvent":null,"appendToBody":null,"timeArrowControl":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('dp1', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('dp1', 'focus', arguments); }","handleChange":"function() {}"}},"input":"value","rate":null,"type":"shiny.element.date","evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>

# Pre-filled with today's date
el_date_picker("dp2", value = Sys.Date())
#> <div id="dp2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dp2_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :default-time="defaultTime === null ? undefined : defaultTime" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :picker-options="pickerOptions === null ? undefined : pickerOptions" :validate-event="validateEvent === null ? undefined : validateEvent" :append-to-body="appendToBody === null ? undefined : appendToBody" :time-arrow-control="timeArrowControl === null ? undefined : timeArrowControl" @blur="elEmitBlur" @focus="elEmitFocus"></el-date-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-02","type":"date","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left","placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"pickerOptions":null,"validateEvent":null,"appendToBody":null,"timeArrowControl":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('dp2', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('dp2', 'focus', arguments); }","handleChange":"function() {}"}},"input":"value","rate":null,"type":"shiny.element.date","evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>

# Date range picker
el_date_picker("dp3", type = "daterange",
               start_placeholder = "Start date",
               end_placeholder   = "End date")
#> <div id="dp3" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dp3_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :default-time="defaultTime === null ? undefined : defaultTime" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :picker-options="pickerOptions === null ? undefined : pickerOptions" :validate-event="validateEvent === null ? undefined : validateEvent" :append-to-body="appendToBody === null ? undefined : appendToBody" :time-arrow-control="timeArrowControl === null ? undefined : timeArrowControl" @blur="elEmitBlur" @focus="elEmitFocus"></el-date-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":[],"type":"daterange","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left","placeholder":null,"startPlaceholder":"Start date","endPlaceholder":"End date","size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"pickerOptions":null,"validateEvent":null,"appendToBody":null,"timeArrowControl":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('dp3', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('dp3', 'focus', arguments); }","handleChange":"function() {}"}},"input":"value","rate":null,"type":"shiny.element.date","evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.handleChange"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_date_picker("dp1", placeholder = "Pick a date"),
    verbatimTextOutput("selected")
  )
  server <- function(input, output, session) {
    output$selected <- renderPrint(input$dp1)
  }
  shinyApp(ui, server)
}
```
