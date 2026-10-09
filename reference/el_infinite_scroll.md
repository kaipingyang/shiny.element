# Element Plus Infinite Scroll

A scrolling area that asks the server for more as the user nears the
bottom. Element implements this as a directive rather than a component,
so the area is a container you put content into.

## Usage

``` r
el_infinite_scroll(
  id = NULL,
  ...,
  height = "300px",
  disabled = NULL,
  delay = NULL,
  distance = NULL,
  immediate = NULL,
  width = NULL,
  slots = NULL,
  on = NULL,
  session = NULL
)

update_el_infinite_scroll(
  session = shiny::getDefaultReactiveDomain(),
  id,
  disabled = NULL,
  delay = NULL,
  distance = NULL
)
```

## Arguments

- id:

  Container ID. Auto-generated if `NULL`.

- ...:

  Content of the scrolling area. Any Shiny UI, including shiny.element
  components – those are folded into this container's Vue instance
  rather than nested inside it, so their inputs keep reporting. Their
  `update_el_*()` no longer reaches them, though.

- height:

  Height of the area, as a CSS unit. Needed for it to scroll at all.
  Default `"300px"`.

- disabled:

  Whether loading is suspended. Set it from the server while a request
  is in flight, and again when there is nothing left to fetch.

- delay:

  Throttle between checks, in milliseconds. Default `200`.

- distance:

  How near the bottom to get before asking, in pixels. Default `0`.

- immediate:

  Whether to ask once on load, in case the content does not fill the
  area. Default `TRUE`.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents, such as
  `list(title = shiny::tags$b("Bold"))`. A shiny.element component given
  here is absorbed rather than nested. For a scoped slot, write the
  template with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  In `el_infinite_scroll()`, deprecated: inside a module, wrap `id` in
  `ns()`, as for any Shiny input; a session given here namespaces `id`
  once more, with a warning. In `update_el_infinite_scroll()`, the Shiny
  session, the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|                   |          |                                               |
|-------------------|----------|-----------------------------------------------|
| Input             | Reported | Value                                         |
| `input$<id>_load` | unasked  | rises by one each time more content is wanted |

The same list as `el_events("el_infinite_scroll")`, which says how an
event's arguments travel.

Observe `input$<id>_load`, fetch the next page, and render it into a
[`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)
inside the area.

## Updating from the server

Server-side update for `el_infinite_scroll()`. Setting `disabled` is how
a feed stops asking once everything has been sent.

`update_el_infinite_scroll()` is called for its side effect and returns
`NULL` invisibly.

## Examples

``` r
el_infinite_scroll("feed", shiny::uiOutput("rows"), height = "400px")
#> <div id="feed" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="feed_container" style="display: contents">
#>   <div v-infinite-scroll="handleLoad" :infinite-scroll-disabled="scrollDisabled" :infinite-scroll-delay="scrollDelay === null ? undefined : scrollDelay" :infinite-scroll-distance="scrollDistance === null ? undefined : scrollDistance" :infinite-scroll-immediate="scrollImmediate === null ? undefined : scrollImmediate" style="overflow: auto; height: 400px">
#>     <shiny-island name="1"></shiny-island>
#>   </div>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"scrollDisabled":false,"scrollDelay":null,"scrollDistance":null,"scrollImmediate":null,"scrollCount":0},"methods":{"handleLoad":"function() { this.scrollCount++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('feed_load', this.scrollCount); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":["options.methods.handleLoad"]}</script>
#>   <div data-shiny-vue-islands style="display: none">
#>     <div data-shiny-island-of="1" style="display: contents">
#>       <div id="rows" class="shiny-html-output"></div>
#>     </div>
#>   </div>
#> </div>

if (interactive()) {
  library(shiny)
  library(shiny.element)

  ui <- el_page(el_infinite_scroll("feed", uiOutput("rows")))

  server <- function(input, output, session) {
    shown <- reactiveVal(20)
    observeEvent(input$feed_load, {
      shown(min(shown() + 20, nrow(iris)))
    })
    output$rows <- renderUI({
      lapply(seq_len(shown()), function(i) tags$p(paste("Row", i)))
    })
  }
  shinyApp(ui, server)
}
if (interactive()) {
  # inside a server function
  observeEvent(input$feed_load, {
    if (all_rows_sent()) {
      update_el_infinite_scroll(session, "feed", disabled = TRUE)
    }
  })
}
```
