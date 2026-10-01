# Element UI Time Picker

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
  picker_options = NULL,
  clearable = NULL,
  disabled = NULL,
  editable = NULL,
  readonly = NULL,
  size = NULL,
  align = NULL,
  popper_class = NULL,
  default_value = NULL,
  name = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
)

el_time_select(
  id = NULL,
  value = NULL,
  picker_options = NULL,
  placeholder = NULL,
  clearable = NULL,
  disabled = NULL,
  editable = NULL,
  readonly = NULL,
  size = NULL,
  align = NULL,
  popper_class = NULL,
  default_value = NULL,
  name = NULL,
  prefix_icon = NULL,
  clear_icon = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
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

  Format of the value reported to Shiny. Default `"HH:mm:ss"`.

- arrow_control:

  Whether hours, minutes and seconds are changed with arrow buttons
  rather than by scrolling.

- placeholder, start_placeholder, end_placeholder:

  Placeholder text, the latter two for a range.

- range_separator:

  Text between the two times of a range. Default `"-"`.

- picker_options:

  Further options, as a named list – for `el_time_picker()`,
  `selectableRange` and `format`; for `el_time_select()`, `start`,
  `end`, `step`, `minTime` and `maxTime`.

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

## Shiny inputs

- `input$<id>` – the time, or two for a range, on load and on change.

- `input$<id>_blur`, `input$<id>_focus` – as the field loses and gains
  focus.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):

- `focus()` – focus the input

## Examples

``` r
el_time_picker("start", value = "09:30:00")
#> <div id="start_container" style="display: contents">
#>   <el-time-picker v-model="value" @change="handleChange" :is-range="isRange === null ? undefined : isRange" :value-format="valueFormat === null ? undefined : valueFormat" :arrow-control="arrowControl === null ? undefined : arrowControl" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :range-separator="rangeSeparator === null ? undefined : rangeSeparator" :picker-options="pickerOptions === null ? undefined : pickerOptions" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :readonly="readonly === null ? undefined : readonly" :size="size === null ? undefined : size" :align="align === null ? undefined : align" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" @blur="elEmitBlur" @focus="elEmitFocus"></el-time-picker>
#> </div>
#> <div id="start" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="start">{"x":{"el":"#start_container","data":{"value":"09:30:00","isRange":false,"valueFormat":"HH:mm:ss","arrowControl":null,"placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"rangeSeparator":null,"pickerOptions":null,"clearable":null,"disabled":null,"editable":null,"readonly":null,"size":null,"align":null,"popperClass":null,"defaultValue":null,"name":null,"prefixIcon":null,"clearIcon":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('start', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('start', 'focus', arguments); }","handleChange":"function(v) { Shiny.setInputValue('start', v); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"start\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>

# Only office hours
el_time_picker("start", picker_options = list(selectableRange = "09:00:00 - 18:00:00"))
#> <div id="start_container" style="display: contents">
#>   <el-time-picker v-model="value" @change="handleChange" :is-range="isRange === null ? undefined : isRange" :value-format="valueFormat === null ? undefined : valueFormat" :arrow-control="arrowControl === null ? undefined : arrowControl" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :range-separator="rangeSeparator === null ? undefined : rangeSeparator" :picker-options="pickerOptions === null ? undefined : pickerOptions" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :readonly="readonly === null ? undefined : readonly" :size="size === null ? undefined : size" :align="align === null ? undefined : align" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" @blur="elEmitBlur" @focus="elEmitFocus"></el-time-picker>
#> </div>
#> <div id="start" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="start">{"x":{"el":"#start_container","data":{"value":"","isRange":false,"valueFormat":"HH:mm:ss","arrowControl":null,"placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"rangeSeparator":null,"pickerOptions":{"selectableRange":"09:00:00 - 18:00:00"},"clearable":null,"disabled":null,"editable":null,"readonly":null,"size":null,"align":null,"popperClass":null,"defaultValue":null,"name":null,"prefixIcon":null,"clearIcon":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('start', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('start', 'focus', arguments); }","handleChange":"function(v) { Shiny.setInputValue('start', v); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"start\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>

# A range
el_time_picker("shift", is_range = TRUE, value = c("09:00:00", "17:30:00"))
#> <div id="shift_container" style="display: contents">
#>   <el-time-picker v-model="value" @change="handleChange" :is-range="isRange === null ? undefined : isRange" :value-format="valueFormat === null ? undefined : valueFormat" :arrow-control="arrowControl === null ? undefined : arrowControl" :placeholder="placeholder === null ? undefined : placeholder" :start-placeholder="startPlaceholder === null ? undefined : startPlaceholder" :end-placeholder="endPlaceholder === null ? undefined : endPlaceholder" :range-separator="rangeSeparator === null ? undefined : rangeSeparator" :picker-options="pickerOptions === null ? undefined : pickerOptions" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :readonly="readonly === null ? undefined : readonly" :size="size === null ? undefined : size" :align="align === null ? undefined : align" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" @blur="elEmitBlur" @focus="elEmitFocus"></el-time-picker>
#> </div>
#> <div id="shift" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="shift">{"x":{"el":"#shift_container","data":{"value":["09:00:00","17:30:00"],"isRange":true,"valueFormat":"HH:mm:ss","arrowControl":null,"placeholder":null,"startPlaceholder":null,"endPlaceholder":null,"rangeSeparator":null,"pickerOptions":null,"clearable":null,"disabled":null,"editable":null,"readonly":null,"size":null,"align":null,"popperClass":null,"defaultValue":null,"name":null,"prefixIcon":null,"clearIcon":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('shift', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('shift', 'focus', arguments); }","handleChange":"function(v) { Shiny.setInputValue('shift', v); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"shift\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>

# Every half hour between nine and six
el_time_select("slot", picker_options = list(start = "09:00", step = "00:30",
                                             end = "18:00"))
#> <div id="slot_container" style="display: contents">
#>   <el-time-select v-model="value" @change="handleChange" :placeholder="placeholder === null ? undefined : placeholder" :picker-options="pickerOptions === null ? undefined : pickerOptions" :clearable="clearable === null ? undefined : clearable" :disabled="disabled === null ? undefined : disabled" :editable="editable === null ? undefined : editable" :readonly="readonly === null ? undefined : readonly" :size="size === null ? undefined : size" :align="align === null ? undefined : align" :popper-class="popperClass === null ? undefined : popperClass" :default-value="defaultValue === null ? undefined : defaultValue" :name="name === null ? undefined : name" :prefix-icon="prefixIcon === null ? undefined : prefixIcon" :clear-icon="clearIcon === null ? undefined : clearIcon" @blur="elEmitBlur" @focus="elEmitFocus"></el-time-select>
#> </div>
#> <div id="slot" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="slot">{"x":{"el":"#slot_container","data":{"value":"","placeholder":null,"pickerOptions":{"start":"09:00","step":"00:30","end":"18:00"},"clearable":null,"disabled":null,"editable":null,"readonly":null,"size":null,"align":null,"popperClass":null,"defaultValue":null,"name":null,"prefixIcon":null,"clearIcon":null},"methods":{"elEmitBlur":"function() { window.shinyElement.emit('slot', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('slot', 'focus', arguments); }","handleChange":"function(v) { Shiny.setInputValue('slot', v); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"slot\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"evals":["methods.elEmitBlur","methods.elEmitFocus","methods.handleChange","mounted"],"jsHooks":[]}</script>
```
