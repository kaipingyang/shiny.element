# Build either time picker

Build either time picker

## Usage

``` r
.el_time_widget(
  tag,
  id,
  value,
  is_range,
  value_format,
  arrow_control,
  placeholder,
  start_placeholder,
  end_placeholder,
  range_separator,
  picker_options,
  clearable,
  disabled,
  editable,
  readonly,
  size,
  align,
  popper_class,
  default_value,
  name,
  prefix_icon,
  clear_icon,
  width,
  slots,
  session
)
```

## Arguments

- tag:

  `"el-time-picker"` or `"el-time-select"`.

- id:

  Picker ID. Auto-generated if `NULL`.

- value:

  Initial time, as `"HH:mm:ss"` text – two of them for a range.

- is_range:

  Pick a start and an end rather than a single time.

- value_format:

  Format of the value reported to Shiny. Default `"HH:mm:ss"`.

- arrow_control:

  Whether hours, minutes and seconds are changed with arrow buttons
  rather than by scrolling.

- placeholder, start_placeholder, end_placeholder:

  Placeholder text, the latter two for a range.

- range_separator:

  Text between the two times of a range. Default `"-"`.

- picker_options:

  Further options, as a named list – for
  [`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md),
  `selectableRange` and `format`; for
  [`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md),
  `start`, `end`, `step`, `minTime` and `maxTime`.

- clearable, disabled, editable, readonly:

  As for an input.

- size:

  `"medium"`, `"small"` or `"mini"`.

- align:

  Alignment of the panel: `"left"` (default), `"center"`, `"right"`.

- popper_class:

  Extra class name for the panel.

- default_value:

  Time the panel opens on when nothing is picked.

- name:

  Native `name` attribute.

- prefix_icon, clear_icon:

  Icon classes.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents.

- session:

  Shiny session for module support.

## Value

A Shiny UI element.
