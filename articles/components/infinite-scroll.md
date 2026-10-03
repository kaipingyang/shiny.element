# Infinite

> **Warning**
>
> We no longer maintain this directive. It will be **removed** in 3.0.0,
> please use the [el-scrollbar infinite
> scroll](https://kaipingyang.github.io/shiny.element/articles/components/scrollbar#infinite-scroll)
> instead.

## Infinite Scroll

Load more data while reach bottom of the page

### Basic usage

Add `v-infinite-scroll` to the list to automatically execute loading
method when scrolling to the bottom.

Reaching the bottom asks the server for more: `input$<id>_load`.

``` r

ui <- el_page(el_infinite_scroll("feed", height = "300px", uiOutput("rows")))

server <- function(input, output, session) {
  n <- reactiveVal(10)
  observeEvent(input$feed_load, n(n() + 5))
  output$rows <- renderUI(tags$ul(style = "padding: 0; margin: 0",
    lapply(seq_len(n()), function(i) tags$li(style = "list-style: none; height: 40px; line-height: 40px; background: #e8f3fe; margin: 6px; color: #7dbcfc; text-align: center", i))))
}

shinyApp(ui, server)
```

![The basic example, running](../../shots/infinite-scroll-basic.png)

### Disable Loading

`update_el_infinite_scroll(disabled = TRUE)` stops asking – while a load
is under way, and when there is nothing more.

``` r

ui <- el_page(el_infinite_scroll("list", height = "300px", uiOutput("items")), textOutput("note"))

server <- function(input, output, session) {
  n <- reactiveVal(10)
  observeEvent(input$list_load, {
    if (n() >= 20) return(update_el_infinite_scroll(id = "list", disabled = TRUE))
    n(n() + 2)
  })
  output$items <- renderUI(tags$ul(lapply(seq_len(n()), function(i) tags$li(i))))
  output$note <- renderText(if (n() >= 20) "No more" else "")
}

shinyApp(ui, server)
```

![The disable-loading example,
running](../../shots/infinite-scroll-disable-loading.png)

### Directives

| Name | Description | Type | Default |
|----|----|----|----|
| v-infinite-scroll | Load more data while reach bottom of the page | Function | — |
| infinite-scroll-disabled | is disabled | boolean | false |
| infinite-scroll-delay | throttle delay (ms) | number | 200 |
| infinite-scroll-distance | trigger distance (px) | number | 0 |
| infinite-scroll-immediate | Whether to execute the loading method immediately, in case the content cannot be filled up in the initial state. | boolean | true |

### API

Element Plus’s tables, and beside each entry where it is in R.
