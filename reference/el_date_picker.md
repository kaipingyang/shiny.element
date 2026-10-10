# Element Plus Date Picker Component

Creates an Element Plus date picker with Vue instance, supporting single
date, datetime, month, year, week, and date range selection modes.

## Usage

``` r
el_date_picker(
  id = NULL,
  value = NULL,
  type = "date",
  value_format = NULL,
  format = NULL,
  placeholder = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  clearable = TRUE,
  disabled = FALSE,
  editable = TRUE,
  readonly = FALSE,
  range_separator = "-",
  size = NULL,
  name = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  popper_class = NULL,
  default_value = NULL,
  default_time = NULL,
  unlink_panels = NULL,
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
  arrow_control = NULL,
  automatic_dropdown = NULL,
  cell_class_name = NULL,
  date_format = NULL,
  disabled_date = NULL,
  disabled_hours = NULL,
  disabled_minutes = NULL,
  disabled_seconds = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  shortcuts = NULL,
  show_confirm = NULL,
  show_footer = NULL,
  show_now = NULL,
  show_week_number = NULL,
  single_panel = NULL,
  teleported = NULL,
  time_format = NULL,
  value_on_clear = NULL,
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_date_picker(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  type = NULL,
  clearable = NULL,
  readonly = NULL,
  placeholder = NULL,
  label = NULL,
  error = NULL,
  value_format = NULL,
  format = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  editable = NULL,
  range_separator = NULL,
  size = NULL,
  name = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  popper_class = NULL,
  unlink_panels = NULL,
  validate_event = NULL,
  arrow_control = NULL,
  automatic_dropdown = NULL,
  cell_class_name = NULL,
  date_format = NULL,
  disabled_date = NULL,
  disabled_hours = NULL,
  disabled_minutes = NULL,
  disabled_seconds = NULL,
  empty_values = NULL,
  fallback_placements = NULL,
  placement = NULL,
  popper_options = NULL,
  popper_style = NULL,
  shortcuts = NULL,
  show_confirm = NULL,
  show_footer = NULL,
  show_now = NULL,
  show_week_number = NULL,
  single_panel = NULL,
  teleported = NULL,
  time_format = NULL,
  value_on_clear = NULL
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

  Format string returned to Shiny when a date is selected, in day.js's
  tokens, as Element Plus takes it (e.g., `"YYYY-MM-DD"`). `NULL`
  (default) is `"YYYY-MM-DD HH:mm:ss"` for `"datetime"` and
  `"datetimerange"` and `"YYYY-MM-DD"` for the rest. Element UI's tokens
  – `"yyyy-MM-dd"`, `"timestamp"` – are translated.

- format:

  Display format shown in the input box, in day.js's tokens. `NULL`
  (default) is Element's for the type: `"YYYY-MM-DD HH:mm:ss"` for a
  datetime, `"YYYY-MM"` for a month, `"YYYY"` for a year, and so on.

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

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

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

- arrow_control:

  Whether to pick time using arrow buttons. Element Plus's
  `arrow-control` (boolean).

- automatic_dropdown:

  This prop decides if the date picker panel pops up when the input is
  focused. (The default value will be set to false in version 3.0).
  Element Plus's `automatic-dropdown` (boolean).

- cell_class_name:

  Set custom className. Element Plus's `cell-class-name` ((data: Date)
  =\> string).

- date_format:

  Optional, format of the date displayed in input's inner panel. Element
  Plus's `date-format` (string).

- disabled_date:

  A function determining if a date is disabled with that date as its
  parameter. Should return a Boolean. Element Plus's `disabled-date`
  ((data: Date) =\> boolean).

- disabled_hours:

  To specify the array of hours that cannot be selected. Element Plus's
  `disabled-hours` ((role: string, comparingDate?: Dayjs) =\>
  number\[\]).

- disabled_minutes:

  To specify the array of minutes that cannot be selected. Element
  Plus's `disabled-minutes` ((hour: number, role: string,
  comparingDate?: Dayjs) =\> number\[\]).

- disabled_seconds:

  To specify the array of seconds that cannot be selected. Element
  Plus's `disabled-seconds` (Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- empty_values:

  Empty values of component, see config-provider. Element Plus's
  `empty-values` (array).

- fallback_placements:

  List of possible positions for Tooltip popper.js. Element Plus's
  `fallback-placements` (`Placement[]`).

- placement:

  Position of dropdown. Element Plus's `placement`.

- popper_options:

  Customized popper option see more at popper.js. Element Plus's
  `popper-options` (`Partial<PopperOptions>`).

- popper_style:

  Custom style for DatePicker's dropdown. Element Plus's `popper-style`
  (string / object).

- shortcuts:

  An object array to set shortcut options. Element Plus's `shortcuts`
  (`Array<{ text: string, value: Date | Function }>`). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- show_confirm:

  Whether to show the confirm button. Element Plus's `show-confirm`
  (boolean).

- show_footer:

  Whether to show footer where the date picker is one
  `'dates' | 'months' | 'years' | 'quarters'`. Element Plus's
  `show-footer` (boolean).

- show_now:

  Whether to show the now button. Element Plus's `show-now` (boolean).

- show_week_number:

  Show the week number besides the week. Element Plus's
  `show-week-number` (boolean).

- single_panel:

  Show only one panel in range-picker. Element Plus's `single-panel`
  (boolean).

- teleported:

  Whether date-picker dropdown is teleported to the body. Element Plus's
  `teleported` (boolean).

- time_format:

  Optional, format of the time displayed in input's inner panel. Element
  Plus's `time-format` (string).

- value_on_clear:

  Clear return value, see config-provider. Element Plus's
  `value-on-clear` (string / number / boolean / Function). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

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

  In `el_date_picker()`, deprecated: inside a module, wrap `id` in
  `ns()`, as for any Shiny input; a session given here namespaces `id`
  once more, with a warning. In `update_el_date_picker()`, the Shiny
  session, the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed date picker component.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):

- `focus()` – Focus the Input component

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>` | unasked | the date, two for a range |
| `input$<id>_blur` | `events = "blur"` | triggers when Input blurs |
| `input$<id>_focus` | `events = "focus"` | triggers when Input focuses |
| `input$<id>_calendar_change` | `events = "calendar_change"` | triggers when the calendar selected date is changed. Only for range |
| `input$<id>_clear` | `events = "clear"` | triggers when a clear button is clicked |
| `input$<id>_panel_change` | `events = "panel_change"` | triggers when the navigation button click. |
| `input$<id>_visible_change` | `events = "visible_change"` | triggers when the DatePicker's dropdown appears/disappears |

The same list as `el_events("el_date_picker")`, which says how an
event's arguments travel.

For `type` `"date"`, `"dates"` and `"daterange"` with the default
`value_format`, `input$<id>` is a `Date` (two for a range, several for
`"dates"`), as
[`shiny::dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html)
gives one; `NULL` while empty. Any other type or `value_format` reports
the text the picker produces, in that format – you asked for that
format, so it is not converted.

## Updating from the server

Server-side update for `el_date_picker()`. Supports updating value,
disabled state, type, clearable, readonly, and placeholder text.

Every other argument of `el_date_picker()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_date_picker()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
# Basic date picker
el_date_picker("dp1")
#> <div id="dp1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dp1_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat === null ? undefined : displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="$elDate(defaultValue)" :default-time="$elDate(defaultTime)" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :validate-event="validateEvent === null ? undefined : validateEvent" :arrow-control="arrowControl === null ? undefined : arrowControl" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :cell-class-name="cellClassName === null ? undefined : cellClassName" :date-format="dateFormat === null ? undefined : dateFormat" :disabled-date="disabledDate === null ? undefined : disabledDate" :disabled-hours="disabledHours === null ? undefined : disabledHours" :disabled-minutes="disabledMinutes === null ? undefined : disabledMinutes" :disabled-seconds="disabledSeconds === null ? undefined : disabledSeconds" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :shortcuts="shortcuts === null ? undefined : shortcuts" :show-confirm="showConfirm === null ? undefined : showConfirm" :show-footer="showFooter === null ? undefined : showFooter" :show-now="showNow === null ? undefined : showNow" :show-week-number="showWeekNumber === null ? undefined : showWeekNumber" :single-panel="singlePanel === null ? undefined : singlePanel" :teleported="teleported === null ? undefined : teleported" :time-format="timeFormat === null ? undefined : timeFormat" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-date-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"date","valueFormat":"YYYY-MM-DD","displayFormat":null,"clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"validateEvent":null,"arrowControl":null,"automaticDropdown":null,"cellClassName":null,"dateFormat":null,"disabledDate":null,"disabledHours":null,"disabledMinutes":null,"disabledSeconds":null,"emptyValues":null,"fallbackPlacements":null,"placement":null,"popperOptions":null,"popperStyle":null,"shortcuts":null,"showConfirm":null,"showFooter":null,"showNow":null,"showWeekNumber":null,"singlePanel":null,"teleported":null,"timeFormat":null,"valueOnClear":null},"methods":{"handleChange":"function() {}"}},"input":"value","rate":null,"type":"shiny.element.date","use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>

# Pre-filled with today's date
el_date_picker("dp2", value = Sys.Date())
#> <div id="dp2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dp2_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat === null ? undefined : displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="$elDate(defaultValue)" :default-time="$elDate(defaultTime)" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :validate-event="validateEvent === null ? undefined : validateEvent" :arrow-control="arrowControl === null ? undefined : arrowControl" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :cell-class-name="cellClassName === null ? undefined : cellClassName" :date-format="dateFormat === null ? undefined : dateFormat" :disabled-date="disabledDate === null ? undefined : disabledDate" :disabled-hours="disabledHours === null ? undefined : disabledHours" :disabled-minutes="disabledMinutes === null ? undefined : disabledMinutes" :disabled-seconds="disabledSeconds === null ? undefined : disabledSeconds" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :shortcuts="shortcuts === null ? undefined : shortcuts" :show-confirm="showConfirm === null ? undefined : showConfirm" :show-footer="showFooter === null ? undefined : showFooter" :show-now="showNow === null ? undefined : showNow" :show-week-number="showWeekNumber === null ? undefined : showWeekNumber" :single-panel="singlePanel === null ? undefined : singlePanel" :teleported="teleported === null ? undefined : teleported" :time-format="timeFormat === null ? undefined : timeFormat" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-date-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-10","type":"date","valueFormat":"YYYY-MM-DD","displayFormat":null,"clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"validateEvent":null,"arrowControl":null,"automaticDropdown":null,"cellClassName":null,"dateFormat":null,"disabledDate":null,"disabledHours":null,"disabledMinutes":null,"disabledSeconds":null,"emptyValues":null,"fallbackPlacements":null,"placement":null,"popperOptions":null,"popperStyle":null,"shortcuts":null,"showConfirm":null,"showFooter":null,"showNow":null,"showWeekNumber":null,"singlePanel":null,"teleported":null,"timeFormat":null,"valueOnClear":null},"methods":{"handleChange":"function() {}"}},"input":"value","rate":null,"type":"shiny.element.date","use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>

# Date range picker
el_date_picker(
  "dp3",
  type = "daterange",
  start_placeholder = "Start date",
  end_placeholder = "End date"
)
#> <div id="dp3" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="dp3_container" style="display: contents">
#>   <el-date-picker v-model="value" :type="type" :value-format="valueFormat" :format="displayFormat === null ? undefined : displayFormat" :clearable="clearable" :disabled="disabled" :editable="editable" :readonly="readonly" :range-separator="rangeSeparator" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :size="size === null ? undefined : size" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :popper-class="popperClass === null ? undefined : popperClass" :default-value="$elDate(defaultValue)" :default-time="$elDate(defaultTime)" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :validate-event="validateEvent === null ? undefined : validateEvent" :arrow-control="arrowControl === null ? undefined : arrowControl" :automatic-dropdown="automaticDropdown === null ? undefined : automaticDropdown" :cell-class-name="cellClassName === null ? undefined : cellClassName" :date-format="dateFormat === null ? undefined : dateFormat" :disabled-date="disabledDate === null ? undefined : disabledDate" :disabled-hours="disabledHours === null ? undefined : disabledHours" :disabled-minutes="disabledMinutes === null ? undefined : disabledMinutes" :disabled-seconds="disabledSeconds === null ? undefined : disabledSeconds" :empty-values="emptyValues === null ? undefined : emptyValues" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :placement="placement === null ? undefined : placement" :popper-options="popperOptions === null ? undefined : popperOptions" :popper-style="popperStyle === null ? undefined : popperStyle" :shortcuts="shortcuts === null ? undefined : shortcuts" :show-confirm="showConfirm === null ? undefined : showConfirm" :show-footer="showFooter === null ? undefined : showFooter" :show-now="showNow === null ? undefined : showNow" :show-week-number="showWeekNumber === null ? undefined : showWeekNumber" :single-panel="singlePanel === null ? undefined : singlePanel" :teleported="teleported === null ? undefined : teleported" :time-format="timeFormat === null ? undefined : timeFormat" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-date-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":[],"type":"daterange","valueFormat":"YYYY-MM-DD","displayFormat":null,"clearable":true,"disabled":false,"editable":true,"readonly":false,"rangeSeparator":"-","placeholder":null,"startPlaceholder":"Start date","endPlaceholder":"End date","size":null,"name":null,"prefixIcon":null,"clearIcon":null,"popperClass":null,"defaultValue":null,"defaultTime":null,"unlinkPanels":null,"validateEvent":null,"arrowControl":null,"automaticDropdown":null,"cellClassName":null,"dateFormat":null,"disabledDate":null,"disabledHours":null,"disabledMinutes":null,"disabledSeconds":null,"emptyValues":null,"fallbackPlacements":null,"placement":null,"popperOptions":null,"popperStyle":null,"shortcuts":null,"showConfirm":null,"showFooter":null,"showNow":null,"showWeekNumber":null,"singlePanel":null,"teleported":null,"timeFormat":null,"valueOnClear":null},"methods":{"handleChange":"function() {}"}},"input":"value","rate":null,"type":"shiny.element.date","use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
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
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_date_picker(session, "when", value = "2026-06-01")
  })
}
```
