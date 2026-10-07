# Element Plus Date Picker Panel

The date picker's panel, always open, without the input.

## Usage

``` r
el_date_picker_panel(
  id = NULL,
  value = NULL,
  border = NULL,
  disabled = NULL,
  clearable = NULL,
  editable = NULL,
  type = NULL,
  default_value = NULL,
  default_time = NULL,
  value_format = NULL,
  date_format = NULL,
  time_format = NULL,
  unlink_panels = NULL,
  single_panel = NULL,
  disabled_date = NULL,
  shortcuts = NULL,
  cell_class_name = NULL,
  show_footer = NULL,
  show_confirm = NULL,
  show_week_number = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  width = NULL,
  slots = NULL
)

update_el_date_picker_panel(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  border = NULL,
  clearable = NULL,
  editable = NULL,
  type = NULL,
  value_format = NULL,
  date_format = NULL,
  time_format = NULL,
  unlink_panels = NULL,
  single_panel = NULL,
  disabled_date = NULL,
  shortcuts = NULL,
  cell_class_name = NULL,
  show_footer = NULL,
  show_confirm = NULL,
  show_week_number = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  Binding value, if it is an `range` picker, the length of the array
  should be 2: Element Plus's `model-value`, reported as `input$<id>`.

- border:

  Whether the date picker is bordered. Element Plus's `border`
  (boolean).

- disabled:

  Whether DatePicker is disabled. Element Plus's `disabled` (boolean).

- clearable:

  Whether to show clear button. Element Plus's `clearable` (boolean).

- editable:

  Whether the input is editable. Element Plus's `editable` (boolean).

- type:

  Type of the picker. `quarter`, `quarters`, and `quarterrange` are
  supported. Element Plus's `type` (enum).

- default_value:

  Optional, default date of the calendar. Element Plus's `default-value`
  (`Date | [Date, Date]`).

- default_time:

  Optional, the time value to use when selecting date range. Element
  Plus's `default-time` (`Date | [Date, Date]`).

- value_format:

  Optional, format of binding value. If not specified, the binding value
  will be a Date object. Element Plus's `value-format` (string).

- date_format:

  Optional, format of the date displayed in input's inner panel. Element
  Plus's `date-format` (string).

- time_format:

  Optional, format of the time displayed in input's inner panel. Element
  Plus's `time-format` (string).

- unlink_panels:

  Unlink two date-panels in range-picker. Element Plus's `unlink-panels`
  (boolean).

- single_panel:

  Show only one panel in range-picker. Element Plus's `single-panel`
  (boolean).

- disabled_date:

  A function determining if a date is disabled with that date as its
  parameter. Should return a Boolean. Element Plus's `disabled-date`
  ((data: Date) =\> boolean). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- shortcuts:

  An object array to set shortcut options. Element Plus's `shortcuts`
  (`Array<{ text: string, value: Date | Function }>`). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- cell_class_name:

  Set custom className. Element Plus's `cell-class-name` ((data: Date)
  =\> string). Give it as
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- show_footer:

  Whether to show footer where the date picker is one
  `'dates' | 'months' | 'years' | 'quarters' | 'datetime' | 'datetimerange'`.
  Element Plus's `show-footer` (boolean).

- show_confirm:

  Whether to show the confirm button. Element Plus's `show-confirm`
  (boolean).

- show_week_number:

  Show the week number besides the week. Element Plus's
  `show-week-number` (boolean).

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

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `prev-month`, `next-month`,
  `prev-year`, `next-year`. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the value, on load and on every change.

- `input$<id>_calendar_change` – Element Plus's `calendar-change` event.

- `input$<id>_panel_change` – Element Plus's `panel-change` event.

- `input$<id>_clear` – Element Plus's `clear` event.

## Updating from the server

Server-side update for `el_date_picker_panel()`.

Every other argument of `el_date_picker_panel()` that can change once it
is drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_date_picker_panel()` is called for its side effect and
returns `NULL` invisibly.

## Examples

``` r
el_date_picker_panel("day", value = Sys.Date(), value_format = "YYYY-MM-DD")
#> <div id="day" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="day_container" style="display: contents">
#>   <el-date-picker-panel v-model="value" @calendar-change="elEmitCalendarChange" @panel-change="elEmitPanelChange" @clear="elEmitClear" :border="border === null ? undefined : border" :disabled="disabled === null ? undefined : disabled" :clearable="clearable === null ? undefined : clearable" :editable="editable === null ? undefined : editable" :type="type === null ? undefined : type" :default-value="$elDate(defaultValue)" :default-time="$elDate(defaultTime)" :value-format="valueFormat === null ? undefined : valueFormat" :date-format="dateFormat === null ? undefined : dateFormat" :time-format="timeFormat === null ? undefined : timeFormat" :unlink-panels="unlinkPanels === null ? undefined : unlinkPanels" :single-panel="singlePanel === null ? undefined : singlePanel" :disabled-date="disabledDate === null ? undefined : disabledDate" :shortcuts="shortcuts === null ? undefined : shortcuts" :cell-class-name="cellClassName === null ? undefined : cellClassName" :show-footer="showFooter === null ? undefined : showFooter" :show-confirm="showConfirm === null ? undefined : showConfirm" :show-week-number="showWeekNumber === null ? undefined : showWeekNumber"></el-date-picker-panel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"2026-10-07","border":null,"disabled":null,"clearable":null,"editable":null,"type":null,"defaultValue":null,"defaultTime":null,"valueFormat":"YYYY-MM-DD","dateFormat":null,"timeFormat":null,"unlinkPanels":null,"singlePanel":null,"disabledDate":null,"shortcuts":null,"cellClassName":null,"showFooter":null,"showConfirm":null,"showWeekNumber":null},"methods":{"elEmitCalendarChange":"function() { window.shinyVue.emit('day', 'calendar_change', arguments); }","elEmitPanelChange":"function() { window.shinyVue.emit('day', 'panel_change', arguments); }","elEmitClear":"function() { window.shinyVue.emit('day', 'clear', arguments); }"},"watch":{"value":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitCalendarChange","options.methods.elEmitPanelChange","options.methods.elEmitClear","options.watch.value"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_date_picker_panel(session, "x", value = NULL)
  )
}
```
