# Element UI Rate (Star Rating)

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
  texts = c("极差", "失望", "一般", "满意", "惊喜"),
  text_color = "#1f2d3d",
  score_template = "{value}",
  colors = NULL,
  void_color = NULL,
  disabled_void_color = NULL,
  icon_classes = NULL,
  void_icon_class = NULL,
  disabled_void_icon_class = NULL,
  low_threshold = NULL,
  high_threshold = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
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

  Character vector of length `max` used when `show_text = TRUE`.
  Defaults to `c("极差", "失望", "一般", "满意", "惊喜")`.

- text_color:

  Colour of the text/score. Default `"#1f2d3d"`.

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

- icon_classes:

  Icon classes for the three score levels, or a named list keyed by
  threshold.

- void_icon_class:

  Icon class for unselected icons.

- disabled_void_icon_class:

  Icon class for unselected icons when `disabled = TRUE`.

- low_threshold:

  Scores at or below this use the first colour and icon. Default `2`.

- high_threshold:

  Scores above this use the third colour and icon. Default `4`.

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

An `htmltools` tagList with a Vue-managed rate component.

## Shiny input

`input$<id>` — numeric rating value (0 to `max`, increments of 0.5 when
`allow_half = TRUE`).

## Examples

``` r
el_rate("rate1", value = 3)
#> <div id="rate1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="rate1_container" style="display: contents">
#>   <el-rate v-model="value" :max="max" :disabled="disabled" :allow-half="allowHalf" :show-text="showText" :show-score="showScore" :text-color="textColor" :score-template="scoreTemplate" :texts="texts" @change="handleChange" :colors="colors === null ? undefined : colors" :void-color="voidColor === null ? undefined : voidColor" :disabled-void-color="disabledVoidColor === null ? undefined : disabledVoidColor" :icon-classes="iconClasses === null ? undefined : iconClasses" :void-icon-class="voidIconClass === null ? undefined : voidIconClass" :disabled-void-icon-class="disabledVoidIconClass === null ? undefined : disabledVoidIconClass" :low-threshold="lowThreshold === null ? undefined : lowThreshold" :high-threshold="highThreshold === null ? undefined : highThreshold"></el-rate>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":3,"max":5,"disabled":false,"allowHalf":false,"showText":false,"showScore":false,"textColor":"#1f2d3d","scoreTemplate":"{value}","texts":["极差","失望","一般","满意","惊喜"],"colors":null,"voidColor":null,"disabledVoidColor":null,"iconClasses":null,"voidIconClass":null,"disabledVoidIconClass":null,"lowThreshold":null,"highThreshold":null},"methods":{"handleChange":"function(val) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('rate1', val); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleChange"]}</script>
#> </div>
el_rate("rate2", allow_half = TRUE, show_score = TRUE)
#> <div id="rate2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="rate2_container" style="display: contents">
#>   <el-rate v-model="value" :max="max" :disabled="disabled" :allow-half="allowHalf" :show-text="showText" :show-score="showScore" :text-color="textColor" :score-template="scoreTemplate" :texts="texts" @change="handleChange" :colors="colors === null ? undefined : colors" :void-color="voidColor === null ? undefined : voidColor" :disabled-void-color="disabledVoidColor === null ? undefined : disabledVoidColor" :icon-classes="iconClasses === null ? undefined : iconClasses" :void-icon-class="voidIconClass === null ? undefined : voidIconClass" :disabled-void-icon-class="disabledVoidIconClass === null ? undefined : disabledVoidIconClass" :low-threshold="lowThreshold === null ? undefined : lowThreshold" :high-threshold="highThreshold === null ? undefined : highThreshold"></el-rate>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":0,"max":5,"disabled":false,"allowHalf":true,"showText":false,"showScore":true,"textColor":"#1f2d3d","scoreTemplate":"{value}","texts":["极差","失望","一般","满意","惊喜"],"colors":null,"voidColor":null,"disabledVoidColor":null,"iconClasses":null,"voidIconClass":null,"disabledVoidIconClass":null,"lowThreshold":null,"highThreshold":null},"methods":{"handleChange":"function(val) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('rate2', val); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleChange"]}</script>
#> </div>
```
