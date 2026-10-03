# Timeline

Visually display timeline.

## Basic usage

Timeline can be split into multiple activities. Timestamps are important
features that distinguish them from other components. Note the
difference with Steps.

``` r

el_timeline(
  "tl",
  items = list(
    list(content = "Event start", timestamp = "2018-04-15"),
    list(content = "Approved", timestamp = "2018-04-13"),
    list(content = "Success", timestamp = "2018-04-11")
  )
)
```

## Mode

Use `mode` to control the relative position of timeline and content.

> **Tip**
>
> After 2.13.1, `el-timeline` explicitly sets padding styles. If you
> have overridden padding styles of `ul` tag in your project, please
> check to ensure the layout is correct.

`mode` puts the content after the line (`"start"`), before it (`"end"`),
or on alternate sides.

``` r

tagList(lapply(
  c("start", "alternate", "alternate-reverse", "end"),
  function(m) {
    tags$div(
      style = "margin-bottom: 20px",
      tags$b(m),
      el_timeline(
        paste0("tl_", gsub("-", "_", m)),
        mode = m,
        items = list(
          list(content = "Event start", timestamp = "2018-04-15"),
          list(content = "Approved", timestamp = "2018-04-13"),
          list(content = "Success", timestamp = "2018-04-11")
        )
      )
    )
  }
))
```

**start**

**alternate**

**alternate-reverse**

**end**

## Custom node

Size, color, and icons can be customized in node.

``` r

el_timeline(
  "nodes",
  items = list(
    list(
      content = "Custom icon",
      timestamp = "2018-04-12 20:46",
      size = "large",
      type = "primary",
      icon = "MoreFilled"
    ),
    list(
      content = "Custom color",
      timestamp = "2018-04-03 20:46",
      color = "#0bbd87"
    ),
    list(
      content = "Custom size",
      timestamp = "2018-04-03 20:46",
      size = "large"
    ),
    list(
      content = "Custom hollow",
      timestamp = "2018-04-03 20:46",
      type = "primary",
      hollow = TRUE
    ),
    list(content = "Default node", timestamp = "2018-04-03 20:46")
  )
)
```

## Custom timestamp

Timestamp can be placed on top of content when content is too high.

``` r

el_timeline(
  "stamps",
  items = list(
    list(
      timestamp = "2018/4/12",
      placement = "top",
      content = el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/12 20:46")
      )
    ),
    list(
      timestamp = "2018/4/3",
      placement = "top",
      content = el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/3 20:46")
      )
    ),
    list(
      timestamp = "2018/4/2",
      placement = "top",
      content = el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/2 20:46")
      )
    )
  )
)
```

## Vertically centered

Timeline-Item is centered vertically.

``` r

el_timeline(
  "centred",
  items = list(
    list(
      timestamp = "2018/4/12",
      placement = "top",
      center = TRUE,
      content = el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/12 20:46")
      )
    ),
    list(
      timestamp = "2018/4/3",
      placement = "top",
      content = el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/3 20:46")
      )
    ),
    list(
      timestamp = "2018/4/2",
      placement = "top",
      center = TRUE,
      content = "Event start"
    ),
    list(timestamp = "2018/4/2", placement = "top", content = "Event end")
  )
)
```

## Reverse

Use the reverse property to control the order of the nodes.

`reverse` shows the entries newest first;
[`update_el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/update_el_timeline.md)
flips it.

``` r

ui <- el_page(
  el_radio_group(
    "order",
    choices = c(Ascending = "asc", Descending = "desc"),
    value = "asc"
  ),
  el_timeline(
    "tl",
    items = list(
      list(content = "Event start", timestamp = "2018-04-15"),
      list(content = "Approved", timestamp = "2018-04-13"),
      list(content = "Success", timestamp = "2018-04-11")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$order,
    update_el_timeline(id = "tl", reverse = input$order == "desc")
  )
}

shinyApp(ui, server)
```

![The reverse example, running](../../shots/timeline-reverse.png)

## API

Element Plus’s tables, and beside each entry where it is in R.

### Timeline Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `reverse` | `reverse` | whether reverse order | [^1] |  | false |
| `mode` | `mode` | relative position of timeline and content | [^2]`'start' \\| 'alternate' \\| 'alternate-reverse' \\| 'end'` |  | start |

### Timeline Slots

| Element   | In R            | Description                            |
|-----------|-----------------|----------------------------------------|
| `default` | default content | customize default content for timeline |

### Timeline-Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `timestamp` | field `timestamp` of each of `items` | timestamp content | [^3] |  | ’’ |
| `hide-timestamp` | field `hide_timestamp` of each of `items` | whether to show timestamp | [^4] |  | false |
| `center` | field `center` of each of `items` | whether vertically centered | [^5] |  | false |
| `placement` | field `placement` of each of `items` | position of timestamp | [^6]`'top' \\| 'bottom'` |  | bottom |
| `type` | field `type` of each of `items` | node type | [^7]`'primary' \\| 'success' \\| 'warning' \\| 'danger' \\| 'info'` |  | ’’ |
| `color` | field `color` of each of `items` | background color of node | [^8] |  | ’’ |
| `size` | field `size` of each of `items` | node size | [^9]`'normal' \\| 'large'` |  | normal |
| `icon` | field `icon` of each of `items` | icon component | [^10] / [^11] |  | — |
| `hollow` | field `hollow` of each of `items` | icon is hollow | [^12] |  | false |

### Timeline-Item Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | customize default content for timeline item |
| `dot` | `slots = list(dot = )` | customize defined node for timeline item |

[^1]: boolean

[^2]: enum

[^3]: string

[^4]: boolean

[^5]: boolean

[^6]: enum

[^7]: enum

[^8]: string

[^9]: enum

[^10]: string

[^11]: Component

[^12]: boolean
