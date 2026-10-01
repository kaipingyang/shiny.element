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
  stroke_linecap = NULL,
  slots = NULL,
  define_back_color = NULL,
  text_color = NULL,
  format = NULL,
  session = NULL
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

- stroke_linecap:

  Shape of the bar's ends: `"round"` (default), `"butt"` or `"square"`.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- define_back_color:

  Background colour of the track.

- text_color:

  Colour of the percentage text.

- format:

  [`htmlwidgets::JS()`](https://rdrr.io/pkg/htmlwidgets/man/JS.html)
  function `function(percentage)` returning the text shown.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tagList with a Vue-managed progress component.

## Examples

``` r
# Basic line progress
el_progress("prog1", percentage = 60)
#> <div id="prog1" data-el-vue-host style="display: contents">
#>   <div id="prog1_container" data-el-mount style="display: contents">
#>     <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :status="status === null ? undefined : status" :color="color" :stroke-linecap="strokeLinecap === null ? undefined : strokeLinecap" :define-back-color="defineBackColor === null ? undefined : defineBackColor" :text-color="textColor === null ? undefined : textColor" :format="format === null ? undefined : format"></el-progress>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"percentage":60,"type":"line","strokeWidth":6,"textInside":false,"showText":true,"width":126,"status":null,"color":"","strokeLinecap":null,"defineBackColor":null,"textColor":null,"format":null}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>

# Circle progress with success status
el_progress("prog2", percentage = 100, type = "circle", status = "success")
#> <div id="prog2" data-el-vue-host style="display: contents">
#>   <div id="prog2_container" data-el-mount style="display: contents">
#>     <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :status="status === null ? undefined : status" :color="color" :stroke-linecap="strokeLinecap === null ? undefined : strokeLinecap" :define-back-color="defineBackColor === null ? undefined : defineBackColor" :text-color="textColor === null ? undefined : textColor" :format="format === null ? undefined : format"></el-progress>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"percentage":100,"type":"circle","strokeWidth":6,"textInside":false,"showText":true,"width":126,"status":"success","color":"","strokeLinecap":null,"defineBackColor":null,"textColor":null,"format":null}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>

# Dashboard style with custom colour
el_progress("prog3", percentage = 75, type = "dashboard", color = "#67C23A")
#> <div id="prog3" data-el-vue-host style="display: contents">
#>   <div id="prog3_container" data-el-mount style="display: contents">
#>     <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :status="status === null ? undefined : status" :color="color" :stroke-linecap="strokeLinecap === null ? undefined : strokeLinecap" :define-back-color="defineBackColor === null ? undefined : defineBackColor" :text-color="textColor === null ? undefined : textColor" :format="format === null ? undefined : format"></el-progress>
#>   </div>
#>   <script type="application/json" data-el-vue>{"options":{"data":{"percentage":75,"type":"dashboard","strokeWidth":6,"textInside":false,"showText":true,"width":126,"status":null,"color":"#67C23A","strokeLinecap":null,"defineBackColor":null,"textColor":null,"format":null}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>

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
