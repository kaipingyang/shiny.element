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
  session,
  label = NULL,
  label_position = "top",
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE
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

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

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

## Value

A Shiny UI element.
