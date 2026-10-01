# Element UI Skeleton

Grey placeholder shapes shown while content is on its way, then the
content itself. In Shiny the usual pattern is to start with
`loading = TRUE` and switch it off from the server once the work is
done.

## Usage

``` r
el_skeleton(
  id = NULL,
  ...,
  loading = TRUE,
  rows = NULL,
  animated = NULL,
  count = NULL,
  throttle = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- ...:

  The real content, shown once `loading` is `FALSE`. A shiny.element
  component here is absorbed, not nested.

- loading:

  Whether to show the placeholder. Default `TRUE`.

- rows:

  Number of placeholder lines. Default `3`.

- animated:

  Whether the placeholder shimmers.

- count:

  How many copies of the placeholder to show.

- throttle:

  Delay in milliseconds before the placeholder appears, so a fast load
  does not flash it.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. `template` replaces the
  placeholder's shape; build it from `el$skeleton_item(variant = ...)`.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

A Shiny UI element.

## Examples

``` r
el_skeleton("report", rows = 4, animated = TRUE,
            shiny::tableOutput("summary"))
#> <div id="report" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="report_container" style="display: contents">
#>   <el-skeleton :loading="skLoading" :rows="skRows === null ? undefined : skRows" :animated="skAnimated === null ? undefined : skAnimated" :count="skCount === null ? undefined : skCount" :throttle="skThrottle === null ? undefined : skThrottle">
#>     <div>
#>       <div id="summary" class="shiny-html-output shiny-table-output"></div>
#>     </div>
#>   </el-skeleton>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"skLoading":true,"skRows":4,"skAnimated":true,"skCount":null,"skThrottle":null}},"input":null,"rate":null,"type":null,"evals":[]}</script>
#> </div>

if (interactive()) {
  library(shiny)
  ui <- el_page(el_skeleton("report", animated = TRUE, tableOutput("summary")))
  server <- function(input, output, session) {
    output$summary <- renderTable({
      Sys.sleep(2)
      on.exit(update_el_skeleton(session, "report", loading = FALSE))
      head(mtcars)
    })
  }
  shinyApp(ui, server)
}
```
