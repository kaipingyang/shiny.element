# Descriptions

Display multiple fields in list form.

## Basic usage

``` r

el_descriptions(
  "desc",
  title = "User Info",
  items = list(
    list(label = "Username", content = "kooriookami"),
    list(label = "Telephone", content = "18100000000"),
    list(label = "Place", content = "Suzhou"),
    list(
      label = "Remarks",
      content = el_tag("desc_tag", "School", size = "small")
    ),
    list(
      label = "Address",
      content = "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
    )
  )
)
```

## Sizes

``` r

items <- list(
  list(label = tagList(el_icon("User"), " Username"), content = "kooriookami"),
  list(
    label = tagList(el_icon("Iphone"), " Telephone"),
    content = "18100000000"
  ),
  list(label = tagList(el_icon("Location"), " Place"), content = "Suzhou"),
  list(
    label = tagList(el_icon("OfficeBuilding"), " Address"),
    content = "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
  )
)
tagList(lapply(c("large", "default", "small"), function(s) {
  el_descriptions(
    paste0("desc_", s),
    title = paste("With border,", s),
    column = 3,
    size = s,
    border = TRUE,
    items = items
  )
}))
```

## Vertical List

``` r

el_descriptions(
  "desc_v",
  title = "Vertical list with border",
  direction = "vertical",
  column = 4,
  border = TRUE,
  items = list(
    list(label = "Username", content = "kooriookami"),
    list(label = "Telephone", content = "18100000000"),
    list(label = "Place", content = "Suzhou", span = 2),
    list(
      label = "Remarks",
      content = el_tag("desc_tag_v", "School", size = "small")
    ),
    list(
      label = "Address",
      content = "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
    )
  )
)
```

## Rowspan

``` r

el_descriptions(
  "desc_rs",
  title = "Width horizontal list",
  border = TRUE,
  items = list(
    list(
      label = "Photo",
      rowspan = 2,
      width = 140,
      align = "center",
      content = el_image(
        src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png",
        alt = "A hamburger",
        fit = "cover",
        width = "100px"
      )
    ),
    list(label = "Username", content = "kooriookami"),
    list(label = "Place", content = "Suzhou"),
    list(
      label = "Address",
      content = "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
    )
  )
)
```

## Customized Style

``` r

tagList(
  tags$style(
    ".my-label { background: var(--el-color-success-light-9) !important; }
              .my-content { background: var(--el-color-danger-light-9); }"
  ),
  el_descriptions(
    "desc_style",
    title = "Customized style list",
    column = 3,
    border = TRUE,
    items = list(
      list(
        label = "Username",
        label_align = "right",
        align = "center",
        label_class_name = "my-label",
        class_name = "my-content",
        width = "150px",
        content = "kooriookami"
      ),
      list(
        label = "Telephone",
        label_align = "right",
        align = "center",
        content = "18100000000"
      ),
      list(
        label = "Place",
        label_align = "right",
        align = "center",
        content = "Suzhou"
      )
    )
  )
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Descriptions Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `border` | `border` | with or without border | [^1] |  | false |
| `column` | `column` | numbers of `Descriptions Item` in one line | [^2] |  | 3 |
| `direction` | `direction` | direction of list | [^3]`'vertical' \\| 'horizontal'` |  | horizontal |
| `size` | `size` | size of list | [^4]`'' \\| 'large' \\| 'default' \\| 'small'` |  | — |
| `title` | `title` | title text, display on the top left | [^5] |  | ’’ |
| `extra` | `extra` | extra text, display on the top right | [^6] |  | ’’ |
| `label-width` | `label_width` | label width of every column | [^7] / [^8] |  | — |

### Descriptions Slots

| Element | In R | Description |
|----|----|----|
| `default` | default content | customize default content |
| `title` | `slots = list(title = )` | custom title, display on the top left |
| `extra` | `slots = list(extra = )` | custom extra area, display on the top right |

### DescriptionsItem Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `label` | item field `label` | label text | [^9] |  | ’’ |
| `span` | field `span` of each of `items` | colspan of column | [^10] |  | 1 |
| `rowspan` | field `rowspan` of each of `items` | the number of rows a cell should span | [^11] |  | 1 |
| `width` | `width` | column width, the width of the same column in different rows is set by the max value (If no `border`, width contains label and content) | [^12] / [^13] |  | ’’ |
| `min-width` | field `min_width` of each of `items` | column minimum width, columns with `width` has a fixed width, while columns with `min-width` has a width that is distributed in proportion (If no`border`, width contains label and content) | [^14] / [^15] |  | ’’ |
| `label-width` | `label_width` | column label width, if not set, it will be the same as the width of the column. Higher priority than the `label-width` of `Descriptions` | [^16] / [^17] |  | — |
| `align` | field `align` of each of `items` | column content alignment (If no `border`, effective for both label and content) | [^18]`'left' \\| 'center' \\| 'right'` |  | left |
| `label-align` | field `label_align` of each of `items` | column label alignment, if omitted, the value of the above `align` attribute will be applied (If no `border`, please use `align` attribute) | [^19]`'left' \\| 'center' \\| 'right'` |  | — |
| `class-name` | field `class_name` of each of `items` | column content custom class name | [^20] |  | ’’ |
| `label-class-name` | field `label_class_name` of each of `items` | column label custom class name | [^21] |  | ’’ |

### DescriptionsItem Slots

| Element   | In R                     | Description               |
|-----------|--------------------------|---------------------------|
| `default` | default content          | customize default content |
| `label`   | `slots = list(label = )` | custom label              |

[^1]: boolean

[^2]: number

[^3]: enum

[^4]: enum

[^5]: string

[^6]: string

[^7]: string

[^8]: number

[^9]: string

[^10]: number

[^11]: number

[^12]: string

[^13]: number

[^14]: string

[^15]: number

[^16]: string

[^17]: number

[^18]: enum

[^19]: enum

[^20]: string

[^21]: string
