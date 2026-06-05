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

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed date picker component.

## Shiny input

`input$<id>` — String for single-date types, or two-element array for
range types. The format is controlled by `value_format`.

## Examples

``` r
# Basic date picker
el_date_picker("dp1")
#> <div id="dp1_container">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange"></el-date-picker>
#> </div>
#> <div class="vue html-widget html-fill-item" id="dp1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="dp1">{"x":{"el":"#dp1_container","data":{"value":"","type":"date","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left"},"methods":{"handleChange":"function(value) { Shiny.setInputValue('dp1', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Pre-filled with today's date
el_date_picker("dp2", value = Sys.Date())
#> <div id="dp2_container">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange"></el-date-picker>
#> </div>
#> <div class="vue html-widget html-fill-item" id="dp2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="dp2">{"x":{"el":"#dp2_container","data":{"value":"2026-06-05","type":"date","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left"},"methods":{"handleChange":"function(value) { Shiny.setInputValue('dp2', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

# Date range picker
el_date_picker("dp3", type = "daterange",
               start_placeholder = "Start date",
               end_placeholder   = "End date")
#> <div id="dp3_container">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" :align="align" @change="handleChange" :start-placeholder="startPlaceholder" :end-placeholder="endPlaceholder"></el-date-picker>
#> </div>
#> <div class="vue html-widget html-fill-item" id="dp3" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="dp3">{"x":{"el":"#dp3_container","data":{"value":[],"type":"daterange","valueFormat":"yyyy-MM-dd","displayFormat":"yyyy-MM-dd","clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","align":"left","startPlaceholder":"Start date","endPlaceholder":"End date"},"methods":{"handleChange":"function(value) { Shiny.setInputValue('dp3', value); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>

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
