# Element Plus Rate (Star Rating)

A star-rating input. Supports half-stars, custom icons, and read-only
display.

## Usage

``` r
el_rate(
  id = NULL,
  value = 0,
  max = 5L,
  disabled = FALSE,
  allow_half = FALSE,
  show_text = FALSE,
  show_score = FALSE,
  texts = NULL,
  text_color = NULL,
  score_template = "{value}",
  colors = NULL,
  void_color = NULL,
  disabled_void_color = NULL,
  low_threshold = NULL,
  high_threshold = NULL,
  label = NULL,
  label_position = c("top", "left", "right"),
  label_width = NULL,
  label_suffix = NULL,
  required = FALSE,
  error = NULL,
  show_message = TRUE,
  inline_message = FALSE,
  aria_label = NULL,
  clearable = NULL,
  disabled_void_icon = NULL,
  icons = NULL,
  size = NULL,
  void_icon = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)

update_el_rate(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  disabled = NULL,
  label = NULL,
  error = NULL,
  max = NULL,
  allow_half = NULL,
  show_text = NULL,
  show_score = NULL,
  texts = NULL,
  text_color = NULL,
  score_template = NULL,
  void_color = NULL,
  disabled_void_color = NULL,
  low_threshold = NULL,
  high_threshold = NULL,
  aria_label = NULL,
  clearable = NULL,
  disabled_void_icon = NULL,
  icons = NULL,
  size = NULL,
  void_icon = NULL
)
```

## Arguments

- id:

  Rate ID. Auto-generated UUID if `NULL`.

- value:

  Initial rating value. Default `0`.

- max:

  Maximum number of stars. Default `5`.

- disabled:

  Read-only display mode. Default `FALSE`.

- allow_half:

  Whether to allow half-star selection. Default `FALSE`.

- show_text:

  Whether to show descriptive text beside the stars. Uses the `texts`
  vector. Default `FALSE`.

- show_score:

  Whether to show the numeric score. Default `FALSE`.

- texts:

  Character vector of length `max` used when `show_text = TRUE`. `NULL`
  takes Element Plus's: "Extremely bad", "Disappointed", "Fair",
  "Satisfied", "Surprise".

- text_color:

  Colour of the text or score. `NULL` takes Element Plus's, from its CSS
  variables.

- score_template:

  Template for score display. `{value}` is replaced. Default
  `"{value}"`.

- colors:

  Colours for the three score levels, or a named list keyed by
  threshold.

- void_color:

  Colour of unselected icons.

- disabled_void_color:

  Colour of unselected icons when `disabled = TRUE`.

- low_threshold:

  Scores at or below this use the first colour and icon. Default `2`.

- high_threshold:

  Scores above this use the third colour and icon. Default `4`.

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

- aria_label:

  Same as `aria-label` in Rate. Element Plus's `aria-label` (string).

- clearable:

  Whether value can be reset to `0`. Element Plus's `clearable`
  (boolean).

- disabled_void_icon:

  Component of unselected read-only icons. Element Plus's
  `disabled-void-icon` (string / Component). An icon's name, such as
  `"Search"`.

- icons:

  Icon components. If array, it should have 3 elements, each of which
  corresponds with a score level, else if object, the key should be
  threshold value between two levels, and the value should be
  corresponding icon component. Element Plus's `icons`
  (`string[] | Component[] / Record<number, string | Component>`). An
  icon's name, such as `"Search"`.

- size:

  Size of Rate. Element Plus's `size` ('large' \| 'default' \| 'small').

- void_icon:

  Component of unselected icons. Element Plus's `void-icon` (string /
  Component). An icon's name, such as `"Search"`.

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

  In `el_rate()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_rate()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed rate component.

## Shiny inputs

`input$<id>` – numeric rating value (0 to `max`, increments of 0.5 when
`allow_half = TRUE`).

## Updating from the server

Server-side update for `el_rate()`.

Every other argument of `el_rate()` that can change once it is drawn is
an argument here too, under the same name. One left `NULL` stays as it
is; `NA` returns it to Element's default.

`update_el_rate()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_rate("rate1", value = 3)
#> <div id="rate1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="rate1_container" style="display: contents">
#>   <el-rate v-model="value" :max="max" :disabled="disabled" :allow-half="allowHalf" :show-text="showText" :show-score="showScore" :text-color="textColor === null ? undefined : textColor" :score-template="scoreTemplate" :texts="texts === null ? undefined : texts" @change="handleChange" :colors="colors === null ? undefined : colors" :void-color="voidColor === null ? undefined : voidColor" :disabled-void-color="disabledVoidColor === null ? undefined : disabledVoidColor" :low-threshold="lowThreshold === null ? undefined : lowThreshold" :high-threshold="highThreshold === null ? undefined : highThreshold" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clearable="clearable === null ? undefined : clearable" :disabled-void-icon="disabledVoidIcon === null ? undefined : disabledVoidIcon" :icons="icons === null ? undefined : icons" :size="size === null ? undefined : size" :void-icon="voidIcon === null ? undefined : voidIcon"></el-rate>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":3,"max":5,"disabled":false,"allowHalf":false,"showText":false,"showScore":false,"textColor":null,"scoreTemplate":"{value}","texts":null,"colors":null,"voidColor":null,"disabledVoidColor":null,"lowThreshold":null,"highThreshold":null,"ariaLabel":null,"clearable":null,"disabledVoidIcon":null,"icons":null,"size":null,"voidIcon":null},"methods":{"handleChange":"function(val) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
el_rate("rate2", allow_half = TRUE, show_score = TRUE)
#> <div id="rate2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="rate2_container" style="display: contents">
#>   <el-rate v-model="value" :max="max" :disabled="disabled" :allow-half="allowHalf" :show-text="showText" :show-score="showScore" :text-color="textColor === null ? undefined : textColor" :score-template="scoreTemplate" :texts="texts === null ? undefined : texts" @change="handleChange" :colors="colors === null ? undefined : colors" :void-color="voidColor === null ? undefined : voidColor" :disabled-void-color="disabledVoidColor === null ? undefined : disabledVoidColor" :low-threshold="lowThreshold === null ? undefined : lowThreshold" :high-threshold="highThreshold === null ? undefined : highThreshold" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clearable="clearable === null ? undefined : clearable" :disabled-void-icon="disabledVoidIcon === null ? undefined : disabledVoidIcon" :icons="icons === null ? undefined : icons" :size="size === null ? undefined : size" :void-icon="voidIcon === null ? undefined : voidIcon"></el-rate>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":0,"max":5,"disabled":false,"allowHalf":true,"showText":false,"showScore":true,"textColor":null,"scoreTemplate":"{value}","texts":null,"colors":null,"voidColor":null,"disabledVoidColor":null,"lowThreshold":null,"highThreshold":null,"ariaLabel":null,"clearable":null,"disabledVoidIcon":null,"icons":null,"size":null,"voidIcon":null},"methods":{"handleChange":"function(val) { }"}},"input":"value","rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleChange"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_rate(session, "stars", value = 5)
  })
}
```
