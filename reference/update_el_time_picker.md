# Update Element Plus Time Picker

Server-side update for
[`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md)
and
[`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md);
`update_el_time_select()` is the time select's, with its own arguments.

## Usage

``` r
update_el_time_picker(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  is_range = NULL,
  value_format = NULL,
  arrow_control = NULL,
  placeholder = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  range_separator = NULL,
  clearable = NULL,
  editable = NULL,
  readonly = NULL,
  size = NULL,
  popper_class = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  format = NULL,
  popper_style = NULL,
  popper_options = NULL,
  placement = NULL,
  fallback_placements = NULL,
  disabled_hours = NULL,
  disabled_minutes = NULL,
  disabled_seconds = NULL,
  teleported = NULL,
  tabindex = NULL,
  aria_label = NULL,
  empty_values = NULL,
  value_on_clear = NULL,
  save_on_blur = NULL
)

update_el_time_select(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  placeholder = NULL,
  clearable = NULL,
  editable = NULL,
  size = NULL,
  popper_class = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  start = NULL,
  end = NULL,
  step = NULL,
  min_time = NULL,
  max_time = NULL,
  include_end_time = NULL,
  format = NULL,
  effect = NULL,
  popper_style = NULL,
  empty_values = NULL,
  value_on_clear = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Picker ID (un-namespaced).

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

  An error message to show on the component, as Element's `error` does –
  for a check only the server can make, such as whether a name is taken.
  `""` clears it.

- is_range:

  Pick a start and an end rather than a single time.

- value_format:

  Format of the value reported to Shiny, in day.js's tokens. Default
  `"HH:mm:ss"`.

- arrow_control:

  Whether hours, minutes and seconds are changed with arrow buttons
  rather than by scrolling.

- placeholder, start_placeholder, end_placeholder:

  Placeholder text, the latter two for a range.

- range_separator:

  Text between the two times of a range. Default `"-"`.

- clearable, editable, readonly:

  As for
  [`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md).

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- popper_class, popper_style:

  Extra class name and style for the panel.

- prefix_icon, clear_icon:

  Icons, by name: `"Clock"`, `"CircleClose"`.

- format:

  Format of the time shown in the input, in day.js's tokens.

- popper_options, placement, fallback_placements:

  Where the panel opens, as Element Plus's tooltip takes them.

- disabled_hours, disabled_minutes, disabled_seconds:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions returning the hours, minutes or seconds that cannot be
  picked – what Element UI's `selectableRange` did.

- teleported:

  Whether the panel is moved to `<body>`.

- tabindex, aria_label:

  Native attributes of the input.

- empty_values, value_on_clear:

  What counts as empty, and the value a cleared picker reports. See
  Element Plus's config provider.

- save_on_blur:

  Whether the time typed is kept when the input loses focus.

- include_end_time, start, end, step, min_time, max_time:

  For
  [`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md):
  the first and last time offered, the interval, whether `end` itself is
  offered, and the bounds of what can be picked.

- effect:

  `"light"` (default) or `"dark"` panel, for
  [`el_time_select()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md).

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Every other argument of
[`el_time_picker()`](https://kaipingyang.github.io/shiny.element/reference/el_time_picker.md)
that can change once it is drawn is an argument here too, under the same
name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_time_picker(session, "start", value = "09:00:00")
  )
}
```
