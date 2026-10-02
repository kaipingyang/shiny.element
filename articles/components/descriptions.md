# Descriptions

Display multiple fields in list form. `items` is a named vector or list
– names the labels – or a list of `list(label =, content =)`.

## Basic usage

``` r

el_descriptions("user", title = "User Info", items = c(
  Username = "kooriookami", Telephone = "18100000000", Place = "Suzhou",
  Remarks = "School", Address = "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou"))
```

## Sizes

``` r

info <- c(Username = "kooriookami", Telephone = "18100000000", Place = "Suzhou")
el_descriptions("d1", title = "Default", border = TRUE, items = info)
el_descriptions("d2", title = "Medium", border = TRUE, size = "medium", items = info)
el_descriptions("d3", title = "Small", border = TRUE, size = "small", items = info)
el_descriptions("d4", title = "Mini", border = TRUE, size = "mini", items = info)
```

## Vertical list

``` r

el_descriptions("v1", title = "Vertical list with border", direction = "vertical",
                column = 4, border = TRUE, items = c(
  Username = "kooriookami", Telephone = "18100000000", Place = "Suzhou", Remarks = "School"))
```

## Customized style

Each item may carry `label_style`, `content_style`, `span` and class
names; a `content` may be a component.

``` r

el_descriptions("st", title = "Customized style", border = TRUE, column = 3, items = list(
  list(label = "Username", content = "kooriookami",
       label_style = list(width = "120px"), content_style = list(color = "#409EFF")),
  list(label = "Telephone", content = "18100000000"),
  list(label = "Remarks", content = el_tag("school", "School", size = "small")),
  list(label = "Address", content = "No.1188, Wuzhong Avenue", span = 3)))
```

## API

### Descriptions Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `border` | `border` | with or without border | boolean | — | false |
| `column` | `column` | numbers of `Descriptions Item` in one line | number | — | 3 |
| `direction` | `direction` | direction of list | string | vertical / horizontal | horizontal |
| `size` | `size` | size of list | string | medium / small / mini | — |
| `title` | `title` | title text, display on the top left | string | — | — |
| `extra` | `extra` | extra text, display on the top right | string | — | — |
| `colon` | `colon` | change default props colon value of Descriptions Item | boolean | — | true |
| `labelClassName` | `label_class_name` | custom label class name | string | — | — |
| `contentClassName` | `content_class_name` | custom content class name | string | — | — |
| `labelStyle` | `label_style` | custom label style | object | — | — |
| `contentStyle` | `content_style` | custom content style | object | — | — |

### Descriptions Slots

| Element | In R | Description |
|----|----|----|
| `title` | `slots = list(title = )` | custom title, display on the top left |
| `extra` | `slots = list(extra = )` | custom extra area, display on the top right |

### Descriptions Item Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `label` | item field `label` | label text | string | — | — |
| `span` | field `span` of each of `items` | colspan of column | number | — | 1 |
| `labelClassName` | `label_class_name` | custom label class name | string | — | — |
| `contentClassName` | `content_class_name` | custom content class name | string | — | — |
| `labelStyle` | `label_style` | custom label style | object | — | — |
| `contentStyle` | `content_style` | custom content style | object | — | — |

### Descriptions Item Slots

| Element | In R                     | Description  |
|---------|--------------------------|--------------|
| `label` | `slots = list(label = )` | custom label |
