# Element UI Infinite Scroll

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
  session = shiny::getDefaultReactiveDomain()
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

- session:

  Shiny session for module support.

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_load` – rises by one each time more content is wanted.
  Observe it, fetch the next page, and render it into a
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)
  inside the area.

## Examples

``` r
el_infinite_scroll("feed", shiny::uiOutput("rows"), height = "400px")
#> <div id="feed_container" style="display: contents">
#>   <div v-infinite-scroll="handleLoad" :infinite-scroll-disabled="scrollDisabled" :infinite-scroll-delay="scrollDelay === null ? undefined : scrollDelay" :infinite-scroll-distance="scrollDistance === null ? undefined : scrollDistance" :infinite-scroll-immediate="scrollImmediate === null ? undefined : scrollImmediate" style="overflow: auto; height: 400px">
#>     <div id="rows" class="shiny-html-output"></div>
#>   </div>
#> </div>
#> <div id="feed" style="width:0px;height:0px;" class="vue html-widget"></div>
#> <script type="application/json" data-for="feed">{"x":{"el":"#feed_container","data":{"scrollDisabled":false,"scrollDelay":null,"scrollDistance":null,"scrollImmediate":null,"scrollCount":0},"methods":{"handleLoad":"function() { this.scrollCount++; Shiny.setInputValue('feed_load', this.scrollCount); }"}},"evals":["methods.handleLoad"],"jsHooks":[]}</script>

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
```
