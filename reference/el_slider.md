# Element Plus Slider Component

Creates an Element Plus slider with Vue instance, supporting single
value and range modes, marks, vertical orientation, and optional numeric
input box.

## Usage

``` r
el_slider(
  id = NULL,
  value = 0,
  min = 0,
  max = 100,
  step = 1,
  range = FALSE,
  disabled = FALSE,
  show_input = FALSE,
  show_stops = FALSE,
  show_tooltip = TRUE,
  vertical = FALSE,
  height = NULL,
  marks = NULL,
  label = NULL,
  input_size = NULL,
  show_input_controls = NULL,
  tooltip_class = NULL,
  format_tooltip = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  aria_label = NULL,
  format_value_text = NULL,
  persistent = NULL,
  placement = NULL,
  range_end_label = NULL,
  range_start_label = NULL,
  size = NULL,
  validate_event = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Slider ID. Auto-generated UUID if `NULL`.

- value:

  Initial value. A single number, or `c(low, high)` when `range = TRUE`.
  When `range = TRUE` and a scalar is supplied, the upper bound is set
  to `max`.

- min:

  Minimum value. Default `0`.

- max:

  Maximum value. Default `100`.

- step:

  Step size. Default `1`.

- range:

  Whether to enable range selection. Default `FALSE`.

- disabled:

  Whether the slider is disabled. Default `FALSE`.

- show_input:

  Whether to display a numeric input box beside the slider (non-range
  mode only). Default `FALSE`.

- show_stops:

  Whether to display stop markers at each step. Default `FALSE`.

- show_tooltip:

  Whether to display the tooltip when dragging. Default `TRUE`.

- vertical:

  Whether to display in vertical orientation. Default `FALSE`.

- height:

  Height of the slider in vertical mode (e.g., `"200px"`). Defaults to
  `"200px"` when `vertical = TRUE` and not explicitly provided.

- marks:

  Named list of mark labels, e.g., `list("0" = "0km", "50" = "50km")`.
  Default `NULL` (no marks).

- label:

  A label shown with the component, as Shiny's inputs have: text or a
  tag. `NULL`, the default, shows none. It is the component's accessible
  name too – tied to it with `for` where the component has a native
  input that takes the id `<id>-input`, else with `aria-labelledby`.

- input_size:

  Size of the companion input when `show_input = TRUE`.

- show_input_controls:

  Whether the companion input shows its spinner buttons.

- tooltip_class:

  Extra class name for the value tooltip.

- format_tooltip:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function formatting the value shown in the tooltip.

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

- aria_label:

  Native `aria-label` attribute. Element Plus's `aria-label` (string).

- format_value_text:

  Format to display the `aria-valuenow` attribute for screen readers.
  Element Plus's `format-value-text` ((value: number) =\> string).

- persistent:

  When slider tooltip inactive and `persistent` is `false` , tooltip
  will be destroyed. `persistent` always be `false` when `show-tooltip `
  is `false`. Element Plus's `persistent` (boolean).

- placement:

  Position of Tooltip. Element Plus's `placement` (enum).

- range_end_label:

  When `range` is true, screen reader label for the end of the range.
  Element Plus's `range-end-label` (string).

- range_start_label:

  When `range` is true, screen reader label for the start of the range.
  Element Plus's `range-start-label` (string).

- size:

  Size of the slider wrapper, will not work in vertical mode. Element
  Plus's `size` (” \| 'large' \| 'default' \| 'small').

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

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

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList with a Vue-managed slider component.

## Shiny inputs

`input$<id>` — Number (`range = FALSE`) or two-element array
(`range = TRUE`), updated when the user finishes dragging.

## Examples

``` r
# Basic usage
el_slider("slider1", value = 30, min = 0, max = 100)
#> <div id="slider1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="slider1_container" style="display: contents">
#>   <el-slider v-model="value" :min="min" :max="max" :step="step" :range="range" :disabled="disabled" :show-input="showInput" :show-stops="showStops" :show-tooltip="showTooltip" :vertical="vertical" @change="handleChange" :height="height === null ? undefined : height" :marks="marks === null ? undefined : marks" :label="label === null ? undefined : label" :input-size="inputSize === null ? undefined : inputSize" :show-input-controls="showInputControls === null ? undefined : showInputControls" :tooltip-class="tooltipClass === null ? undefined : tooltipClass" :format-tooltip="formatTooltip === null ? undefined : formatTooltip" @input="elEmitInput" :aria-label="ariaLabel === null ? undefined : ariaLabel" :format-value-text="formatValueText === null ? undefined : formatValueText" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :range-end-label="rangeEndLabel === null ? undefined : rangeEndLabel" :range-start-label="rangeStartLabel === null ? undefined : rangeStartLabel" :size="size === null ? undefined : size" :validate-event="validateEvent === null ? undefined : validateEvent"></el-slider>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":30,"min":0,"max":100,"step":1,"range":false,"disabled":false,"showInput":false,"showStops":false,"showTooltip":true,"vertical":false,"height":null,"marks":null,"label":null,"inputSize":null,"showInputControls":null,"tooltipClass":null,"formatTooltip":null,"ariaLabel":null,"formatValueText":null,"persistent":null,"placement":null,"rangeEndLabel":null,"rangeStartLabel":null,"size":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('slider1', 'input', arguments, 200); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitInput","options.methods.handleChange"]}</script>
#> </div>

# Range slider
el_slider("slider2", value = c(20, 80), range = TRUE)
#> <div id="slider2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="slider2_container" style="display: contents">
#>   <el-slider v-model="value" :min="min" :max="max" :step="step" :range="range" :disabled="disabled" :show-input="showInput" :show-stops="showStops" :show-tooltip="showTooltip" :vertical="vertical" @change="handleChange" :height="height === null ? undefined : height" :marks="marks === null ? undefined : marks" :label="label === null ? undefined : label" :input-size="inputSize === null ? undefined : inputSize" :show-input-controls="showInputControls === null ? undefined : showInputControls" :tooltip-class="tooltipClass === null ? undefined : tooltipClass" :format-tooltip="formatTooltip === null ? undefined : formatTooltip" @input="elEmitInput" :aria-label="ariaLabel === null ? undefined : ariaLabel" :format-value-text="formatValueText === null ? undefined : formatValueText" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :range-end-label="rangeEndLabel === null ? undefined : rangeEndLabel" :range-start-label="rangeStartLabel === null ? undefined : rangeStartLabel" :size="size === null ? undefined : size" :validate-event="validateEvent === null ? undefined : validateEvent"></el-slider>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":[20,80],"min":0,"max":100,"step":1,"range":true,"disabled":false,"showInput":false,"showStops":false,"showTooltip":true,"vertical":false,"height":null,"marks":null,"label":null,"inputSize":null,"showInputControls":null,"tooltipClass":null,"formatTooltip":null,"ariaLabel":null,"formatValueText":null,"persistent":null,"placement":null,"rangeEndLabel":null,"rangeStartLabel":null,"size":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('slider2', 'input', arguments, 200); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitInput","options.methods.handleChange"]}</script>
#> </div>

# Vertical slider with marks
el_slider(
  "slider3",
  value = 50,
  vertical = TRUE,
  height = "200px",
  marks = list("0" = "0km", "50" = "50km", "100" = "100km")
)
#> <div id="slider3" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="slider3_container" style="display: contents">
#>   <el-slider v-model="value" :min="min" :max="max" :step="step" :range="range" :disabled="disabled" :show-input="showInput" :show-stops="showStops" :show-tooltip="showTooltip" :vertical="vertical" @change="handleChange" :height="height === null ? undefined : height" :marks="marks === null ? undefined : marks" :label="label === null ? undefined : label" :input-size="inputSize === null ? undefined : inputSize" :show-input-controls="showInputControls === null ? undefined : showInputControls" :tooltip-class="tooltipClass === null ? undefined : tooltipClass" :format-tooltip="formatTooltip === null ? undefined : formatTooltip" @input="elEmitInput" :aria-label="ariaLabel === null ? undefined : ariaLabel" :format-value-text="formatValueText === null ? undefined : formatValueText" :persistent="persistent === null ? undefined : persistent" :placement="placement === null ? undefined : placement" :range-end-label="rangeEndLabel === null ? undefined : rangeEndLabel" :range-start-label="rangeStartLabel === null ? undefined : rangeStartLabel" :size="size === null ? undefined : size" :validate-event="validateEvent === null ? undefined : validateEvent"></el-slider>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":50,"min":0,"max":100,"step":1,"range":false,"disabled":false,"showInput":false,"showStops":false,"showTooltip":true,"vertical":true,"height":"200px","marks":{"0":"0km","50":"50km","100":"100km"},"label":null,"inputSize":null,"showInputControls":null,"tooltipClass":null,"formatTooltip":null,"ariaLabel":null,"formatValueText":null,"persistent":null,"placement":null,"rangeEndLabel":null,"rangeStartLabel":null,"size":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('slider3', 'input', arguments, 200); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitInput","options.methods.handleChange"]}</script>
#> </div>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_slider("slider1", value = 50, min = 0, max = 100),
    verbatimTextOutput("val")
  )
  server <- function(input, output, session) {
    output$val <- renderPrint(input$slider1)
  }
  shinyApp(ui, server)
}
```
