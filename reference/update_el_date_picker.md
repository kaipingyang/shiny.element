# Update Element Plus Date Picker

Server-side update for
[`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md).
Supports updating value, disabled state, type, clearable, readonly, and
placeholder text.

## Usage

``` r
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

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Date picker ID (un-namespaced).

- value:

  New picker value (string or two-element vector for range types).

- disabled:

  New disabled state.

- type:

  New picker type.

- clearable:

  New clearable state.

- readonly:

  New readonly state.

- placeholder:

  New placeholder text (non-range types).

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- value_format:

  Format string returned to Shiny when a date is selected, in day.js's
  tokens, as Element Plus takes it (e.g., `"YYYY-MM-DD"`). Default
  `"YYYY-MM-DD"`. Element UI's tokens – `"yyyy-MM-dd"`, `"timestamp"` –
  are translated.

- start_placeholder:

  Placeholder for the start input in range types.

- end_placeholder:

  Placeholder for the end input in range types.

- editable:

  Whether the user can type directly in the input. Default `TRUE`.

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

- unlink_panels:

  Whether the two panels of a range picker move independently.

- validate_event:

  Whether a change triggers form validation. Default `TRUE`.

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
  `popper-options` (Partial).

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

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_date_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_date_picker(session, "when", value = "2026-06-01")
  })
}
```
