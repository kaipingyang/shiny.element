# Badge

A number or status mark on buttons and icons. Given an `id`, a badge is
changed from the server with
[`update_el_badge()`](https://kaipingyang.github.io/shiny.element/reference/update_el_badge.md).

## Basic usage

``` r

tags$div(style = "display: flex; gap: 40px; padding-top: 10px",
  el_badge(el_button("comments", "comments", size = "small"), value = 12),
  el_badge(el_button("replies", "replies", size = "small"), value = 3),
  el_badge(el_button("mentions", "mentions", size = "small"), value = 1, type = "primary"),
  el_badge(el_button("remind", "remind", size = "small"), value = 2, type = "warning"))
```

¹²

³

¹

²

## Max value

``` r

tags$div(style = "display: flex; gap: 40px; padding-top: 10px",
  el_badge(el_button("c200", "comments", size = "small"), value = 200, max = 99),
  el_badge(el_button("r100", "replies", size = "small"), value = 100, max = 10))
```

⁹⁹⁺

¹⁰⁺

## Customizations

``` r

tags$div(style = "display: flex; gap: 40px; padding-top: 10px",
  el_badge(el_button("new", "comments", size = "small"), value = "new"),
  el_badge(el_button("hot", "replies", size = "small"), value = "hot"))
```

^(new)

^(hot)

## Little red dot

``` r

tags$div(style = "display: flex; gap: 40px; padding-top: 10px",
  el_badge("query", is_dot = TRUE),
  el_badge(el_button("share", NULL, icon = "el-icon-share", type = "primary", size = "small"), is_dot = TRUE))
```

query

## Updated from the server

``` r

ui <- el_page(tags$div(style = "padding-top: 10px",
  el_badge(el_button("inbox", "Inbox"), value = 3, id = "unread")),
  el_button("bump", "New message", type = "text"))

server <- function(input, output, session) {
  n <- reactiveVal(3)
  observeEvent(input$bump, { n(n() + 1); update_el_badge(id = "unread", value = n()) })
}

shinyApp(ui, server)
```

![The server example, running](../../shots/badge-server.png)

## API

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `value` | `value` | display value | string, number | — | — |
| `max` | `max` | maximum value, shows ‘{max}+’ when exceeded. Only works if `value` is a `Number` | number | — | — |
| `is-dot` | `is_dot` | if a little dot is displayed | boolean | — | false |
| `hidden` | `hidden` | hidden badge | boolean | — | false |
| `type` | `type` | button type | string | primary / success / warning / danger / info | — |
