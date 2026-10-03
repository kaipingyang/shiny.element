# Result

Used to give feedback on the result of user’s operation or access
exception.

## Basic usage

`primary` has been added in 2.9.11.

``` r

el_row(
  el_col(
    span = 6,
    el_result(
      icon = "success",
      title = "Success Tip",
      sub_title = "Please follow the instructions",
      el_button("res1", "Back", type = "primary")
    )
  ),
  el_col(
    span = 6,
    el_result(
      icon = "warning",
      title = "Warning Tip",
      sub_title = "Please follow the instructions",
      el_button("res2", "Back", type = "primary")
    )
  ),
  el_col(
    span = 6,
    el_result(
      icon = "error",
      title = "Error Tip",
      sub_title = "Please follow the instructions",
      el_button("res3", "Back", type = "primary")
    )
  ),
  el_col(
    span = 6,
    el_result(
      icon = "info",
      title = "Info Tip",
      sub_title = "Please follow the instructions",
      el_button("res4", "Back", type = "primary")
    )
  )
)
```

## Customized content

``` r

el_result(
  title = "404",
  sub_title = "Sorry, request error",
  slots = list(
    icon = tags$img(
      src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png",
      alt = "A hamburger"
    )
  ),
  el_button("res_back", "Back", type = "primary")
)
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `title` | `title` | title of result | [^1] |  | ’’ |
| `sub-title` | `sub_title` | sub title of result | [^2] |  | ’’ |
| `icon` | `icon` | icon type of result | [^3]`'primary' (2.9.11) \\| 'success' \\| 'warning' \\| 'info' \\| 'error'` |  | info |

### Slots

| Element     | In R                         | Description                  |
|-------------|------------------------------|------------------------------|
| `icon`      | `slots = list(icon = )`      | content as result icon       |
| `title`     | `slots = list(title = )`     | content as result title      |
| `sub-title` | `slots = list(sub-title = )` | content as result sub title  |
| `extra`     | `slots = list(extra = )`     | content as result extra area |

[^1]: string

[^2]: string

[^3]: enum
