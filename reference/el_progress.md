# Element UI Progress Component

Creates an Element UI progress bar. This is a display-only component;
update it from the server with
[`update_el_progress()`](https://kaipingyang.github.io/shiny.element/reference/update_el_progress.md).

## Usage

``` r
el_progress(
  id = NULL,
  percentage = 0,
  type = "line",
  status = NULL,
  stroke_width = 6,
  text_inside = FALSE,
  show_text = TRUE,
  color = NULL,
  width = 126,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Progress ID. Auto-generated UUID if `NULL`.

- percentage:

  Progress percentage, `0`–`100`. Default `0`.

- type:

  Progress bar type: `"line"`, `"circle"`, or `"dashboard"`. Default
  `"line"`.

- status:

  Status theme: `NULL`, `"success"`, `"exception"`, or `"warning"`.
  `NULL` means no status colour. Default `NULL`.

- stroke_width:

  Stroke width in pixels. Default `6`.

- text_inside:

  Whether to display the percentage text inside the bar (only applies to
  `type = "line"`). Default `FALSE`.

- show_text:

  Whether to show the progress text. Default `TRUE`.

- color:

  Custom colour string (e.g. `"#409EFF"`). Overrides `status` colour
  when set. Default `NULL`.

- width:

  Width in pixels for `"circle"` and `"dashboard"` types. Default `126`.

- session:

  Shiny session for module support.

## Value

An `htmltools` tagList with a Vue-managed progress component.

## Examples

``` r
# Basic line progress
el_progress("prog1", percentage = 60)
#> <div id="prog1_container">
#>   <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width"></el-progress>
#> </div>
#> <div class="vue html-widget html-fill-item" id="prog1" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="prog1">{"x":{"el":"#prog1_container","data":{"percentage":60,"type":"line","strokeWidth":6,"textInside":false,"showText":true,"width":126}},"evals":[],"jsHooks":[]}</script>

# Circle progress with success status
el_progress("prog2", percentage = 100, type = "circle", status = "success")
#> <div id="prog2_container">
#>   <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :status="status"></el-progress>
#> </div>
#> <div class="vue html-widget html-fill-item" id="prog2" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="prog2">{"x":{"el":"#prog2_container","data":{"percentage":100,"type":"circle","strokeWidth":6,"textInside":false,"showText":true,"width":126,"status":"success"}},"evals":[],"jsHooks":[]}</script>

# Dashboard style with custom colour
el_progress("prog3", percentage = 75, type = "dashboard", color = "#67C23A")
#> <div id="prog3_container">
#>   <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :color="color"></el-progress>
#> </div>
#> <div class="vue html-widget html-fill-item" id="prog3" style="width:960px;height:500px;"></div>
#> <script type="application/json" data-for="prog3">{"x":{"el":"#prog3_container","data":{"percentage":75,"type":"dashboard","strokeWidth":6,"textInside":false,"showText":true,"width":126,"color":"#67C23A"}},"evals":[],"jsHooks":[]}</script>

# Shiny app example
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_progress("prog1", percentage = 0),
    actionButton("go", "Advance")
  )
  server <- function(input, output, session) {
    observeEvent(input$go, {
      update_el_progress(session, "prog1", percentage = min(100, (input$go * 10)))
    })
  }
  shinyApp(ui, server)
}
```
