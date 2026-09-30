# Element UI Page Header

A page title with a back link.

## Usage

``` r
el_page_header(
  id = NULL,
  title = NULL,
  content = NULL,
  width = NULL,
  slots = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Header ID. Auto-generated if `NULL`.

- title:

  Text of the back link. Default `"Back"`.

- content:

  The page's own title, shown after the separator.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_back` – fires when the back link is clicked. Observe it to
  decide what going back means in your app; the component navigates
  nowhere on its own.

## Examples

``` r
el_page_header("hdr", content = "Sales for March")
#> <div id="hdr_container" style="display: contents">
#>   <el-page-header :title="title === null ? undefined : title" :content="content === null ? undefined : content" @back="elEmitBack"></el-page-header>
#> </div>
#> <div id="hdr" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="hdr">{"x":{"el":"#hdr_container","data":{"title":null,"content":"Sales for March"},"methods":{"elEmitBack":"function() { window.shinyElement.emit('hdr', 'back', arguments); }"}},"evals":["methods.elEmitBack"],"jsHooks":[]}</script>
el_page_header("hdr", title = "All reports", content = "Sales for March")
#> <div id="hdr_container" style="display: contents">
#>   <el-page-header :title="title === null ? undefined : title" :content="content === null ? undefined : content" @back="elEmitBack"></el-page-header>
#> </div>
#> <div id="hdr" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="hdr">{"x":{"el":"#hdr_container","data":{"title":"All reports","content":"Sales for March"},"methods":{"elEmitBack":"function() { window.shinyElement.emit('hdr', 'back', arguments); }"}},"evals":["methods.elEmitBack"],"jsHooks":[]}</script>

if (interactive()) {
  library(shiny)
  ui <- el_page(
    el_page_header("hdr", content = "Detail"),
    verbatimTextOutput("where")
  )
  server <- function(input, output, session) {
    output$where <- renderPrint(input$hdr_back)
  }
  shinyApp(ui, server)
}
```
