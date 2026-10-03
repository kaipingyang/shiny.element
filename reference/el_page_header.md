# Element Plus Page Header

A page title with a back link.

## Usage

``` r
el_page_header(
  id = NULL,
  title = NULL,
  content = NULL,
  icon = NULL,
  width = NULL,
  slots = NULL,
  session = NULL
)
```

## Arguments

- id:

  Header ID. Auto-generated if `NULL`.

- title:

  Text of the back link. Default `"Back"`.

- content:

  The page's own title, shown after the separator.

- icon:

  Icon component of page header. Element Plus's `icon` (string /
  Component). An icon's name, such as `"Search"`.

- width:

  Component width, as a CSS unit.

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

A Shiny UI element.

## Shiny inputs

- `input$<id>_back` – fires when the back link is clicked. Observe it to
  decide what going back means in your app; the component navigates
  nowhere on its own.

## Examples

``` r
el_page_header("hdr", content = "Sales for March")
#> <div id="hdr" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hdr_container" style="display: contents">
#>   <el-page-header :title="title === null ? undefined : title" :content="content === null ? undefined : content" @back="elEmitBack" :icon="icon === null ? undefined : icon"></el-page-header>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"title":null,"content":"Sales for March","icon":null},"methods":{"elEmitBack":"function() { window.shinyVue.emit('hdr', 'back', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitBack"]}</script>
#> </div>
el_page_header("hdr", title = "All reports", content = "Sales for March")
#> <div id="hdr" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hdr_container" style="display: contents">
#>   <el-page-header :title="title === null ? undefined : title" :content="content === null ? undefined : content" @back="elEmitBack" :icon="icon === null ? undefined : icon"></el-page-header>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"title":"All reports","content":"Sales for March","icon":null},"methods":{"elEmitBack":"function() { window.shinyVue.emit('hdr', 'back', arguments); }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.elEmitBack"]}</script>
#> </div>

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
