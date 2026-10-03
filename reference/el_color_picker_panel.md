# Element Plus Color Picker Panel

The colour picker's panel, always open, without the trigger.

## Usage

``` r
el_color_picker_panel(
  id = NULL,
  value = NULL,
  border = NULL,
  disabled = NULL,
  show_alpha = NULL,
  color_format = NULL,
  predefine = NULL,
  validate_event = NULL,
  hue_slider_class = NULL,
  hue_slider_style = NULL,
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
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- value:

  Binding value: Element Plus's `model-value`, reported as `input$<id>`.

- border:

  Whether the color picker panel is bordered. Element Plus's `border`
  (boolean).

- disabled:

  Whether to disable the color picker. Element Plus's `disabled`
  (boolean).

- show_alpha:

  Whether to display the alpha slider. Element Plus's `show-alpha`
  (boolean).

- color_format:

  Color format of v-model. Element Plus's `color-format` (enum).

- predefine:

  Predefined color options. Element Plus's `predefine` (string\[\]).

- validate_event:

  Whether to trigger form validation. Element Plus's `validate-event`
  (boolean).

- hue_slider_class:

  Class names will be passed to hue-slider. Element Plus's
  `hue-slider-class` (string \| string\[\] \| Record\<string,
  boolean\>).

- hue_slider_style:

  Styles will be passed to hue-slider. Element Plus's `hue-slider-style`
  (string / StyleValue).

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

  Named list of Element slot contents: `footer`. A scoped slot is
  written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>` – the value, on load and on every change.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):
[`update()`](https://rdrr.io/r/stats/update.html).

## Examples

``` r
el_color_picker_panel("brand", value = "#409EFF")
#> <div id="brand" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="brand_container" style="display: contents">
#>   <el-color-picker-panel v-model="value" :border="border === null ? undefined : border" :disabled="disabled === null ? undefined : disabled" :show-alpha="showAlpha === null ? undefined : showAlpha" :color-format="colorFormat === null ? undefined : colorFormat" :predefine="predefine === null ? undefined : predefine" :validate-event="validateEvent === null ? undefined : validateEvent" :hue-slider-class="hueSliderClass === null ? undefined : hueSliderClass" :hue-slider-style="hueSliderStyle === null ? undefined : hueSliderStyle"></el-color-picker-panel>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"#409EFF","border":null,"disabled":null,"showAlpha":null,"colorFormat":null,"predefine":null,"validateEvent":null,"hueSliderClass":null,"hueSliderStyle":null},"methods":[],"watch":{"value":"function(v) { }"}},"input":"value","rate":null,"type":null,"evals":["options.watch.value"]}</script>
#> </div>
```
