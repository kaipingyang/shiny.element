# Breadcrumb

Displays the location of the current page. `input$<id>` is the label
clicked, so it can drive navigation in a Shiny app without routing.

## Basic usage

``` r

el_breadcrumb("trail", separator = "/", items = list(
  list(label = "homepage"), list(label = "promotion management"),
  list(label = "promotion list"), list(label = "promotion detail")))
```

## Icon separator

``` r

el_breadcrumb("trail2", separator_class = "el-icon-arrow-right", items = list(
  list(label = "homepage"), list(label = "promotion management"),
  list(label = "promotion list"), list(label = "promotion detail")))
```

## API

### Breadcrumb Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `separator` | `separator` | separator character | string | — | / |
| `separator-class` | `separator_class` | class name of icon separator | string | — | \- |

### Breadcrumb Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `to` | field `to` of each of `items` | target route of the link, same as `to` of `vue-router` | string/object | — | — |
| `replace` | field `replace` of each of `items` | if `true`, the navigation will not leave a history record | boolean | — | false |
