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
  session = shiny::getDefaultReactiveDomain()
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

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed rate component.

## Shiny input

`input$<id>` — numeric rating value (0 to `max`, increments of 0.5 when
`allow_half = TRUE`).

## Examples

``` r
el_rate("rate1", value = 3)
#> <div id="rate1_container">
#>   <el-rate v-model="value" :max="max" :disabled="disabled" :allow-half="allowHalf" :show-text="showText" :show-score="showScore" :text-color="textColor" :score-template="scoreTemplate" :texts="texts" @change="handleChange"></el-rate>
#> </div>
#> <div class="vue html-widget html-fill-item" id="rate1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="rate1">{"x":{"el":"#rate1_container","data":{"value":3,"max":5,"disabled":false,"allowHalf":false,"showText":false,"showScore":false,"textColor":"#1f2d3d","scoreTemplate":"{value}","texts":["极差","失望","一般","满意","惊喜"]},"methods":{"handleChange":"function(val) { Shiny.setInputValue('rate1', val); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
el_rate("rate2", allow_half = TRUE, show_score = TRUE)
#> <div id="rate2_container">
#>   <el-rate v-model="value" :max="max" :disabled="disabled" :allow-half="allowHalf" :show-text="showText" :show-score="showScore" :text-color="textColor" :score-template="scoreTemplate" :texts="texts" @change="handleChange"></el-rate>
#> </div>
#> <div class="vue html-widget html-fill-item" id="rate2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="rate2">{"x":{"el":"#rate2_container","data":{"value":0,"max":5,"disabled":false,"allowHalf":true,"showText":false,"showScore":true,"textColor":"#1f2d3d","scoreTemplate":"{value}","texts":["极差","失望","一般","满意","惊喜"]},"methods":{"handleChange":"function(val) { Shiny.setInputValue('rate2', val); }"}},"evals":["methods.handleChange"],"jsHooks":[]}</script>
```
