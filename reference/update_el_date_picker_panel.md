# Update Element Plus Date Picker Panel

Server-side update for
[`el_date_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker_panel.md).

## Usage

``` r
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

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Component ID (un-namespaced).

- value, disabled:

  New values; `NULL` leaves one unchanged.

- label:

  New label, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html):
  text, or tags or
  [`HTML()`](https://rstudio.github.io/htmltools/reference/HTML.html)
  drawn as markup. Only a component built with a `label` has one to
  change.

- error:

  An error message to show on the component; `""` clears it.

- border:

  Whether the date picker is bordered. Element Plus's `border`
  (boolean).

- clearable:

  Whether to show clear button. Element Plus's `clearable` (boolean).

- editable:

  Whether the input is editable. Element Plus's `editable` (boolean).

- type:

  Type of the picker. `quarter`, `quarters`, and `quarterrange` are
  supported. Element Plus's `type` (enum).

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

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_date_picker_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_date_picker_panel.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_date_picker_panel(session, "x", value = NULL)
  )
}
```
