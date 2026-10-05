# Element Plus Time Picker

Pick a time of day. `el_time_picker()` takes any time, or a range of
them with `is_range = TRUE`; `el_time_select()` offers fixed times at a
set interval, such as every half hour between nine and six.

## Usage

``` r
el_time_picker(
  id = NULL,
  value = NULL,
  is_range = FALSE,
  value_format = "HH:mm:ss",
  arrow_control = NULL,
  placeholder = NULL,
  start_placeholder = NULL,
  end_placeholder = NULL,
  range_separator = NULL,
  clearable = NULL,
  disabled = NULL,
  editable = NULL,
  readonly = NULL,
  size = NULL,
  popper_class = NULL,
  default_value = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
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
  save_on_blur = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

el_time_select(
  id = NULL,
  value = NULL,
  placeholder = NULL,
  clearable = NULL,
  disabled = NULL,
  editable = NULL,
  size = NULL,
  popper_class = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
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
  value_on_clear = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

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

- id:

  Picker ID. Auto-generated if `NULL`.

- value:

  Initial time, as `"HH:mm:ss"` text – two of them for a range.

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

- clearable, disabled, editable, readonly:

  As for an input.

- size:

  Size: `"large"`, `"default"` or `"small"`; `NULL` follows the form or
  the page.

- popper_class, popper_style:

  Extra class name and style for the panel.

- default_value:

  Time the panel opens on when nothing is picked.

- prefix_icon, clear_icon:

  Icons, by name: `"Clock"`, `"CircleClose"`.

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

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents.

- session:

  In `el_time_picker()`, deprecated: inside a module, wrap `id` in
  `ns()`, as for any Shiny input; a session given here namespaces `id`
  once more, with a warning. In `update_el_time_picker()`, the Shiny
  session, the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- include_end_time, start, end, step, min_time, max_time:

  For `el_time_select()`: the first and last time offered, the interval,
  whether `end` itself is offered, and the bounds of what can be picked.

- effect:

  `"light"` (default) or `"dark"` panel, for `el_time_select()`.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the time, or two for a range, on load and on change.

- `input$<id>_blur`, `input$<id>_focus`, `input$<id>_clear` – as the
  field loses and gains focus, and is cleared;
  `input$<id>_visible_change` as the panel opens and closes
  (`el_time_picker()`).

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
`focus()`, `blur()`; and for `el_time_picker()`, `handleOpen()` and
`handleClose()`.

## Updating from the server

Server-side update for `el_time_picker()` and `el_time_select()`;
`update_el_time_select()` is the time select's, with its own arguments.

Every other argument of `el_time_picker()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_time_picker()` is called for its side effect and returns
`NULL` invisibly.

## Updating a time select

`update_el_time_select()` changes the time select from the server: every
argument of `el_time_select()` that can change once it is drawn, under
the same name. One left `NULL` stays as it is; `NA` returns it to
Element's default.

`update_el_time_select()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
el_time_picker("start", value = "09:30:00")
#> <div id="start" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="start_container" style="display: contents">
#>   <el-time-picker v-model="value" @change="handleChange" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" @visible-change="elEmitVisibleChange" :is-range="isRange === null ? undefined : isRange" :value-format="valueFormat === null ? undefined : valueFormat" :format="format === null ? undefined : format" :arrow-control="arrowControl === null ? undefined : arrowControl" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :range-separator="rangeSeparator === null ? undefined : rangeSeparator" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :readonly="readonly === null ? undefined : readonly" :size="size === null ? undefined : size" :popper-class="popperClass === null ? undefined : popperClass" :popper-style="popperStyle === null ? undefined : popperStyle" :popper-options="popperOptions === null ? undefined : popperOptions" :placement="placement === null ? undefined : placement" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :default-value="$elDate(defaultValue)" :disabled-hours="disabledHours === null ? undefined : disabledHours" :disabled-minutes="disabledMinutes === null ? undefined : disabledMinutes" :disabled-seconds="disabledSeconds === null ? undefined : disabledSeconds" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :teleported="teleported === null ? undefined : teleported" :tabindex="tabindex === null ? undefined : tabindex" :aria-label="ariaLabel === null ? undefined : ariaLabel" :empty-values="emptyValues === null ? undefined : emptyValues" :value-on-clear="valueOnClear === null ? undefined : valueOnClear" :save-on-blur="saveOnBlur === null ? undefined : saveOnBlur"></el-time-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"09:30:00","isRange":false,"valueFormat":"HH:mm:ss","format":null,"arrowControl":null,"placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"rangeSeparator":null,"clearable":null,"disabled":null,"editable":null,"readonly":null,"size":null,"popperClass":null,"popperStyle":null,"popperOptions":null,"placement":null,"fallbackPlacements":null,"defaultValue":null,"disabledHours":null,"disabledMinutes":null,"disabledSeconds":null,"prefixIcon":null,"clearIcon":null,"teleported":null,"tabindex":null,"ariaLabel":null,"emptyValues":null,"valueOnClear":null,"saveOnBlur":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('start', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('start', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('start', 'clear', arguments); }","elEmitVisibleChange":"function() { window.shinyVue.emit('start', 'visible_change', arguments); }","handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.elEmitVisibleChange","options.methods.handleChange"]}</script>
#> </div>

# Only office hours
el_time_picker(
  "start",
  disabled_hours = JS(
    "function() {",
    "  var h = [];",
    "  for (var i = 0; i < 24; i++) if (i < 9 || i > 18) h.push(i);",
    "  return h;",
    "}"
  )
)
#> <div id="start" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="start_container" style="display: contents">
#>   <el-time-picker v-model="value" @change="handleChange" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" @visible-change="elEmitVisibleChange" :is-range="isRange === null ? undefined : isRange" :value-format="valueFormat === null ? undefined : valueFormat" :format="format === null ? undefined : format" :arrow-control="arrowControl === null ? undefined : arrowControl" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :range-separator="rangeSeparator === null ? undefined : rangeSeparator" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :readonly="readonly === null ? undefined : readonly" :size="size === null ? undefined : size" :popper-class="popperClass === null ? undefined : popperClass" :popper-style="popperStyle === null ? undefined : popperStyle" :popper-options="popperOptions === null ? undefined : popperOptions" :placement="placement === null ? undefined : placement" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :default-value="$elDate(defaultValue)" :disabled-hours="disabledHours === null ? undefined : disabledHours" :disabled-minutes="disabledMinutes === null ? undefined : disabledMinutes" :disabled-seconds="disabledSeconds === null ? undefined : disabledSeconds" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :teleported="teleported === null ? undefined : teleported" :tabindex="tabindex === null ? undefined : tabindex" :aria-label="ariaLabel === null ? undefined : ariaLabel" :empty-values="emptyValues === null ? undefined : emptyValues" :value-on-clear="valueOnClear === null ? undefined : valueOnClear" :save-on-blur="saveOnBlur === null ? undefined : saveOnBlur"></el-time-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","isRange":false,"valueFormat":"HH:mm:ss","format":null,"arrowControl":null,"placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"rangeSeparator":null,"clearable":null,"disabled":null,"editable":null,"readonly":null,"size":null,"popperClass":null,"popperStyle":null,"popperOptions":null,"placement":null,"fallbackPlacements":null,"defaultValue":null,"disabledHours":"function() {\n  var h = [];\n  for (var i = 0; i < 24; i++) if (i < 9 || i > 18) h.push(i);\n  return h;\n}","disabledMinutes":null,"disabledSeconds":null,"prefixIcon":null,"clearIcon":null,"teleported":null,"tabindex":null,"ariaLabel":null,"emptyValues":null,"valueOnClear":null,"saveOnBlur":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('start', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('start', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('start', 'clear', arguments); }","elEmitVisibleChange":"function() { window.shinyVue.emit('start', 'visible_change', arguments); }","handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.data.disabledHours","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.elEmitVisibleChange","options.methods.handleChange"]}</script>
#> </div>

# A range
el_time_picker("shift", is_range = TRUE, value = c("09:00:00", "17:30:00"))
#> <div id="shift" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="shift_container" style="display: contents">
#>   <el-time-picker v-model="value" @change="handleChange" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" @visible-change="elEmitVisibleChange" :is-range="isRange === null ? undefined : isRange" :value-format="valueFormat === null ? undefined : valueFormat" :format="format === null ? undefined : format" :arrow-control="arrowControl === null ? undefined : arrowControl" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :range-separator="rangeSeparator === null ? undefined : rangeSeparator" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :readonly="readonly === null ? undefined : readonly" :size="size === null ? undefined : size" :popper-class="popperClass === null ? undefined : popperClass" :popper-style="popperStyle === null ? undefined : popperStyle" :popper-options="popperOptions === null ? undefined : popperOptions" :placement="placement === null ? undefined : placement" :fallback-placements="fallbackPlacements === null ? undefined : fallbackPlacements" :default-value="$elDate(defaultValue)" :disabled-hours="disabledHours === null ? undefined : disabledHours" :disabled-minutes="disabledMinutes === null ? undefined : disabledMinutes" :disabled-seconds="disabledSeconds === null ? undefined : disabledSeconds" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :teleported="teleported === null ? undefined : teleported" :tabindex="tabindex === null ? undefined : tabindex" :aria-label="ariaLabel === null ? undefined : ariaLabel" :empty-values="emptyValues === null ? undefined : emptyValues" :value-on-clear="valueOnClear === null ? undefined : valueOnClear" :save-on-blur="saveOnBlur === null ? undefined : saveOnBlur"></el-time-picker>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":["09:00:00","17:30:00"],"isRange":true,"valueFormat":"HH:mm:ss","format":null,"arrowControl":null,"placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"rangeSeparator":null,"clearable":null,"disabled":null,"editable":null,"readonly":null,"size":null,"popperClass":null,"popperStyle":null,"popperOptions":null,"placement":null,"fallbackPlacements":null,"defaultValue":null,"disabledHours":null,"disabledMinutes":null,"disabledSeconds":null,"prefixIcon":null,"clearIcon":null,"teleported":null,"tabindex":null,"ariaLabel":null,"emptyValues":null,"valueOnClear":null,"saveOnBlur":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('shift', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('shift', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('shift', 'clear', arguments); }","elEmitVisibleChange":"function() { window.shinyVue.emit('shift', 'visible_change', arguments); }","handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.elEmitVisibleChange","options.methods.handleChange"]}</script>
#> </div>

# Every half hour between nine and six
el_time_select("slot", start = "09:00", step = "00:30", end = "18:00")
#> <div id="slot" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="slot_container" style="display: contents">
#>   <el-time-select v-model="value" @change="handleChange" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" :start="start === null ? undefined : start" :end="end === null ? undefined : end" :step="step === null ? undefined : step" :min-time="minTime === null ? undefined : minTime" :max-time="maxTime === null ? undefined : maxTime" :include-end-time="includeEndTime === null ? undefined : includeEndTime" :format="format === null ? undefined : format" :placeholder="placeholder === null ? undefined : placeholder" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :size="size === null ? undefined : size" :effect="effect === null ? undefined : effect" :popper-class="popperClass === null ? undefined : popperClass" :popper-style="popperStyle === null ? undefined : popperStyle" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" :empty-values="emptyValues === null ? undefined : emptyValues" :value-on-clear="valueOnClear === null ? undefined : valueOnClear"></el-time-select>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","start":"09:00","end":"18:00","step":"00:30","minTime":null,"maxTime":null,"includeEndTime":null,"format":null,"placeholder":null,"clearable":null,"disabled":null,"editable":null,"size":null,"effect":null,"popperClass":null,"popperStyle":null,"prefixIcon":null,"clearIcon":null,"emptyValues":null,"valueOnClear":null},"methods":{"elEmitBlur":"function() { window.shinyVue.emit('slot', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('slot', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('slot', 'clear', arguments); }","handleChange":"function(v) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(
    input$reset,
    update_el_time_picker(session, "start", value = "09:00:00")
  )
}
```
