# Result

Feedback on the result of an operation, or an access exception.

## Basic usage

``` r

el_row(gutter = 20,
  el_col(span = 6, el_result("r1", icon = "success", title = "Success Tip",
         sub_title = "Please follow the instructions", el_button("back1", "Back", type = "primary", size = "medium"))),
  el_col(span = 6, el_result("r2", icon = "warning", title = "Warning Tip",
         sub_title = "Please follow the instructions", el_button("back2", "Back", type = "primary", size = "medium"))),
  el_col(span = 6, el_result("r3", icon = "error", title = "Error Tip",
         sub_title = "Please follow the instructions", el_button("back3", "Back", type = "primary", size = "medium"))),
  el_col(span = 6, el_result("r4", icon = "info", title = "Info Tip",
         sub_title = "Please follow the instructions", el_button("back4", "Back", type = "primary", size = "medium"))))
```

## Customized content

The `icon`, `title` and `subTitle` slots take markup.

``` r

el_result("cus", title = "404", sub_title = "Sorry, request error",
  el_button("back", "Back", type = "primary", size = "medium"),
  slots = list(icon = tags$img(src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png", alt = "A hamburger", width = 120)))
```

## API

### Result Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | `title` | title | string | — | — |
| `sub-title` | `sub_title` | sub title | string | — | — |
| `icon` | `icon` | icon type | string | success / warning / info / error | info |

### Result Slots

| Element    | In R                        | Description       |
|------------|-----------------------------|-------------------|
| `icon`     | `slots = list(icon = )`     | custom icon       |
| `title`    | `slots = list(title = )`    | custom title      |
| `subTitle` | `slots = list(subTitle = )` | custom sub title  |
| `extra`    | `slots = list(extra = )`    | custom extra area |
