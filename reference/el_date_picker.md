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
  width = NULL,
  slots = NULL,
  append_to_body = NULL,
  session = shiny::getDefaultReactiveDomain()
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

- width:

  Component width, as a CSS unit – `"200px"`, `"50%"`, or a

- slots:

  Named list of Element slot contents, such as

- append_to_body:

  Whether the picker panel is appended to `body`. Default `TRUE`;
  `FALSE` keeps it inside a dialog or a scrolling container.
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).
  number taken as pixels. Element's own markup carries it, so it behaves
  like the `width` argument of a Shiny input.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed date picker component.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `focus()` – Focus the Input component

## Shiny input

`input$<id>` — String for single-date types, or two-element array for
range types. The format is controlled by `value_format`.

## Examples

``` r
# Basic date picker
el_date_picker("dp1")
#> <div id="dp1_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :default-time="defaultTime === null ? undefined : defaultTime" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :picker-options="pickerOptions === null ? undefined : pickerOptions" :validate-event="validateEvent === null ? undefined : validateEvent" :append-to-body="appendToBody === null ? undefined : appendToBody" @blur="elEmitBlur" @focus="elEmitFocus"></el-date-picker>
#> </div>
#> <div id="dp1" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="dp1">{"x":{"el":"#dp1_container","data":{"value":"","type":"date","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left","placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"pickerOptions":null,"validateEvent":null,"appendToBody":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('dp1', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('dp1', 'focus', arguments); }","handleChange":"function(value) { Shiny.setInputValue('dp1', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"dp1\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>

# Pre-filled with today's date
el_date_picker("dp2", value = Sys.Date())
#> <div id="dp2_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :default-time="defaultTime === null ? undefined : defaultTime" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :picker-options="pickerOptions === null ? undefined : pickerOptions" :validate-event="validateEvent === null ? undefined : validateEvent" :append-to-body="appendToBody === null ? undefined : appendToBody" @blur="elEmitBlur" @focus="elEmitFocus"></el-date-picker>
#> </div>
#> <div id="dp2" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="dp2">{"x":{"el":"#dp2_container","data":{"value":"2026-09-30","type":"date","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left","placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"pickerOptions":null,"validateEvent":null,"appendToBody":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('dp2', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('dp2', 'focus', arguments); }","handleChange":"function(value) { Shiny.setInputValue('dp2', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"dp2\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>

# Date range picker
el_date_picker("dp3", type = "daterange",
               start_placeholder = "Start date",
               end_placeholder   = "End date")
#> <div id="dp3_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :default-time="defaultTime === null ? undefined : defaultTime" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :picker-options="pickerOptions === null ? undefined : pickerOptions" :validate-event="validateEvent === null ? undefined : validateEvent" :append-to-body="appendToBody === null ? undefined : appendToBody" @blur="elEmitBlur" @focus="elEmitFocus"></el-date-picker>
#> </div>
#> <div id="dp3" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="dp3">{"x":{"el":"#dp3_container","data":{"value":[],"type":"daterange","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left","placeholder":null,"startPlaceholder":"Start date","endPlaceholder":"End date","size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"pickerOptions":null,"validateEvent":null,"appendToBody":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('dp3', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('dp3', 'focus', arguments); }","handleChange":"function(value) { Shiny.setInputValue('dp3', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"dp3\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>

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
