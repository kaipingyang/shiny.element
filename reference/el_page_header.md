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
  events = NULL,
  on = NULL,
  session = NULL
)

update_el_page_header(
  session = shiny::getDefaultReactiveDomain(),
  id,
  title = NULL,
  content = NULL,
  icon = NULL
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

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_page_header()`, deprecated: inside a module, wrap `id` in
  `ns()`, as for any Shiny input; a session given here namespaces `id`
  once more, with a warning. In `update_el_page_header()`, the Shiny
  session, the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|                   |          |                                     |
|-------------------|----------|-------------------------------------|
| Input             | Reported | Value                               |
| `input$<id>_back` | unasked  | triggers when right side is clicked |

The same list as `el_events("el_page_header")`, which says how an
event's arguments travel.

## Updating from the server

Server-side update for `el_page_header()`.

Every other argument of `el_page_header()` that can change once it is
drawn is an argument here too, under the same name. One left `NULL`
stays as it is; `NA` returns it to Element's default.

`update_el_page_header()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
el_page_header("hdr", content = "Sales for March")
#> <div id="hdr" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hdr_container" style="display: contents">
#>   <el-page-header :title="title === null ? undefined : title" :content="content === null ? undefined : content" @back="elEmitBack" :icon="icon === null ? undefined : icon"></el-page-header>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"title":null,"content":"Sales for March","icon":null},"methods":{"elEmitBack":"function() { window.shinyVue.emit('hdr', 'back', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitBack"]}</script>
#> </div>
el_page_header("hdr", title = "All reports", content = "Sales for March")
#> <div id="hdr" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="hdr_container" style="display: contents">
#>   <el-page-header :title="title === null ? undefined : title" :content="content === null ? undefined : content" @back="elEmitBack" :icon="icon === null ? undefined : icon"></el-page-header>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"title":"All reports","content":"Sales for March","icon":null},"methods":{"elEmitBack":"function() { window.shinyVue.emit('hdr', 'back', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.elEmitBack"]}</script>
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
if (interactive()) {
  # inside a server function
  observeEvent(input$row_click, {
    update_el_page_header(session, "hdr", content = selected_name())
  })
}
```
