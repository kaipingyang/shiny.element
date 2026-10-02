# Timeline

Visually display a timeline.
[`update_el_timeline()`](https://kaipingyang.github.io/shiny.element/reference/update_el_timeline.md)
replaces the entries, which suits a log that grows.

## Basic usage

``` r

el_timeline("tl", items = list(
  list(content = "Event start", timestamp = "2018-04-15"),
  list(content = "Approved", timestamp = "2018-04-13"),
  list(content = "Success", timestamp = "2018-04-11")))
```

## Custom node

``` r

el_timeline("nodes", items = list(
  list(content = "Custom icon", timestamp = "2018-04-12 20:46", size = "large",
       type = "primary", icon = "el-icon-more"),
  list(content = "Custom color", timestamp = "2018-04-03 20:46", color = "#0bbd87"),
  list(content = "Custom size", timestamp = "2018-04-03 20:46", size = "large"),
  list(content = "Default node", timestamp = "2018-04-03 20:46")))
```

## Custom timestamp

``` r

el_timeline("stamps", items = list(
  list(timestamp = "2018/4/12", placement = "top",
       content = el_card(tags$h4("Update Github template"), tags$p("Tom committed 2018/4/12 20:46"))),
  list(timestamp = "2018/4/3", placement = "top",
       content = el_card(tags$h4("Update Github template"), tags$p("Tom committed 2018/4/3 20:46")))))
```

## API

### Timeline Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `reverse` | `reverse` | whether the node is ascending or descending, default is ascending | boolean | — | false |

### Timeline-item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `timestamp` | field `timestamp` of each of `items` | timestamp content | string | \- | — |
| `hide-timestamp` | field `hide_timestamp` of each of `items` | whether to show timestamp | boolean | — | false |
| `placement` | field `placement` of each of `items` | position of timestamp | string | top / bottom | bottom |
| `type` | field `type` of each of `items` | node type | string | primary / success / warning / danger / info | \- |
| `color` | field `color` of each of `items` | background color of node | string | hsl / hsv / hex / rgb | \- |
| `size` | field `size` of each of `items` | node size | string | normal / large | normal |
| `icon` | field `icon` of each of `items` | icon class name | string | — | \- |

### Timeline-Item Slot

| Element | In R                   | Description         |
|---------|------------------------|---------------------|
| `dot`   | `slots = list(dot = )` | Custom defined node |
