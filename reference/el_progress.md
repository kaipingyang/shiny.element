# Element Plus Progress Component

Creates an Element Plus progress bar. This is a display-only component;
update it from the server with `update_el_progress()`.

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
  format = NULL,
  duration = NULL,
  indeterminate = NULL,
  striped = NULL,
  striped_flow = NULL,
  on = NULL,
  session = NULL
)

update_el_progress(
  session = shiny::getDefaultReactiveDomain(),
  id,
  percentage = NULL,
  type = NULL,
  status = NULL,
  color = NULL,
  stroke_width = NULL,
  show_text = NULL,
  text_inside = NULL,
  stroke_linecap = NULL,
  format = NULL,
  duration = NULL,
  indeterminate = NULL,
  striped = NULL,
  striped_flow = NULL
)
```

## Arguments

- id:

  Progress ID. Auto-generated UUID if `NULL`.

- percentage:

  Progress percentage, `0` to `100`. Default `0`.

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

- format:

  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(percentage)` returning the text shown.

- duration:

  Control the animation duration of indeterminate progress or striped
  flow progress. Element Plus's `duration` (number).

- indeterminate:

  Set indeterminate progress. Element Plus's `indeterminate` (boolean).

- striped:

  Stripe over the progress bar's color. Element Plus's `striped`
  (boolean).

- striped_flow:

  Get the stripes to flow. Element Plus's `striped-flow` (boolean).

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_progress()`, deprecated: inside a module, wrap `id` in `ns()`,
  as for any Shiny input; a session given here namespaces `id` once
  more, with a warning. In `update_el_progress()`, the Shiny session,
  the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

An `htmltools` tagList with a Vue-managed progress component.

## Updating from the server

Server-side update for `el_progress()`.

Every other argument of `el_progress()` that can change once it is drawn
is an argument here too, under the same name. One left `NULL` stays as
it is; `NA` returns it to Element's default.

Unlike the other updates, which go with the flush
([`flush_vue()`](https://kaipingyang.github.io/shiny.element/reference/flush_vue.md)),
it is sent at once, as
[`shiny::withProgress()`](https://rdrr.io/pkg/shiny/man/withProgress.html)
reports: a loop updating it shows every step.

`update_el_progress()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
# Basic line progress
el_progress("prog1", percentage = 60)
#> <div id="prog1" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="prog1_container" style="display: contents">
#>   <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :status="status === null ? undefined : status" :color="color" :stroke-linecap="strokeLinecap === null ? undefined : strokeLinecap" :format="format === null ? undefined : format" :duration="duration === null ? undefined : duration" :indeterminate="indeterminate === null ? undefined : indeterminate" :striped="striped === null ? undefined : striped" :striped-flow="stripedFlow === null ? undefined : stripedFlow"></el-progress>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"percentage":60,"type":"line","strokeWidth":6,"textInside":false,"showText":true,"width":126,"status":null,"color":"","strokeLinecap":null,"format":null,"duration":null,"indeterminate":null,"striped":null,"stripedFlow":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>

# Circle progress with success status
el_progress("prog2", percentage = 100, type = "circle", status = "success")
#> <div id="prog2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="prog2_container" style="display: contents">
#>   <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :status="status === null ? undefined : status" :color="color" :stroke-linecap="strokeLinecap === null ? undefined : strokeLinecap" :format="format === null ? undefined : format" :duration="duration === null ? undefined : duration" :indeterminate="indeterminate === null ? undefined : indeterminate" :striped="striped === null ? undefined : striped" :striped-flow="stripedFlow === null ? undefined : stripedFlow"></el-progress>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"percentage":100,"type":"circle","strokeWidth":6,"textInside":false,"showText":true,"width":126,"status":"success","color":"","strokeLinecap":null,"format":null,"duration":null,"indeterminate":null,"striped":null,"stripedFlow":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>

# Dashboard style with custom colour
el_progress("prog3", percentage = 75, type = "dashboard", color = "#67C23A")
#> <div id="prog3" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="prog3_container" style="display: contents">
#>   <el-progress :percentage="percentage" :type="type" :stroke-width="strokeWidth" :text-inside="textInside" :show-text="showText" :width="width" :status="status === null ? undefined : status" :color="color" :stroke-linecap="strokeLinecap === null ? undefined : strokeLinecap" :format="format === null ? undefined : format" :duration="duration === null ? undefined : duration" :indeterminate="indeterminate === null ? undefined : indeterminate" :striped="striped === null ? undefined : striped" :striped-flow="stripedFlow === null ? undefined : stripedFlow"></el-progress>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"percentage":75,"type":"dashboard","strokeWidth":6,"textInside":false,"showText":true,"width":126,"status":null,"color":"#67C23A","strokeLinecap":null,"format":null,"duration":null,"indeterminate":null,"striped":null,"stripedFlow":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
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
      update_el_progress(
        session,
        "prog1",
        percentage = min(100, (input$go * 10))
      )
    })
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$go, {
    update_el_progress(session, "pct", percentage = 100)
  })
}
```
