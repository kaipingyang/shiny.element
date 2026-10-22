# Result

Used to give feedback on the result of user’s operation or access
exception.

## Basic usage

`primary` has been added in 2.9.11.

``` r

tip <- function(
  icon,
  title,
  sub_title = "Please follow the instructions",
  ...
) {
  el_col(
    sm = 12,
    lg = 6,
    xl = 4,
    el_result(
      paste0("res_", icon),
      icon = icon,
      title = title,
      sub_title = sub_title,
      el_button(label = "Back", type = "primary"),
      ...
    )
  )
}
el_row(
  tip("primary", "Primary Tip"),
  tip("success", "Success Tip"),
  tip("warning", "Warning Tip"),
  tip("error", "Error Tip"),
  tip(
    "info",
    "Info Tip",
    sub_title = NULL,
    slots = list(`sub-title` = tags$p("Using slot as subtitle"))
  )
)
```

## Customized content

``` r

el_result(
  "res_404",
  title = "404",
  sub_title = "Sorry, request error",
  el_button(label = "Back", type = "primary"),
  slots = list(
    icon = el_image(
      src = "https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
    )
  )
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
