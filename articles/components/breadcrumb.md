# Breadcrumb

Displays the location of the current page, making it easier to browser
back.

## Basic usage

In `el-breadcrumb`, each `el-breadcrumb-item` is a tag that stands for
every level starting from homepage. This component has a `String`
attribute `separator`, and it determines the separator. Its default
value is ‘/’.

``` r

el_breadcrumb("crumbs", separator = "/", items = list(
  list(label = "homepage", to = "/"),
  list(label = "promotion management"),
  list(label = "promotion list"),
  list(label = "promotion detail")))
```

## Icon separator

Set `separator-icon` to use `svg icon` as the separator，it will cover
`separator`

``` r

el_breadcrumb("crumbs_icon", separator_icon = "ArrowRight", items = list(
  list(label = "homepage", to = "/"), list(label = "promotion management"),
  list(label = "promotion list"), list(label = "promotion detail")))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Breadcrumb Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `separator` | `separator` | separator character | [^1] |  | / |
| `separator-icon` | `separator_icon` | icon component of icon separator | [^2] / [^3] |  | — |

### Breadcrumb Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### BreadcrumbItem Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `to` | field `to` of each of `items` | target route of the link, same as `to` of `vue-router` | [^4] / [^5]`RouteLocationRaw` |  | ’’ |
| `replace` | field `replace` of each of `items` | if `true`, the navigation will not leave a history record | [^6] |  | false |

### BreadcrumbItem Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

[^1]: string

[^2]: string

[^3]: Component

[^4]: string

[^5]: object

[^6]: boolean
