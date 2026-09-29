# Declare a form field

Declare a form field

## Usage

``` r
el_form_field(
  prop,
  type = "input",
  label = NULL,
  value = NULL,
  choices = NULL,
  rules = NULL,
  ...
)
```

## Arguments

- prop:

  Field name. Keys the form's model and is what
  [`el_rule()`](https://kaipingyang.github.io/shiny.element/reference/el_rule.md)s
  and validation messages refer to.

- type:

  Control type: one of `"input"`, `"input-number"`, `"select"`,
  `"radio-group"`, `"checkbox-group"`, `"switch"`, `"slider"`,
  `"date-picker"`, `"time-picker"`, `"rate"`, `"cascader"` or
  `"color-picker"`.

- label:

  Label text.

- value:

  Initial value. Defaults to the type's empty value, which is also what
  `resetFields()` restores.

- choices:

  Options for `"select"`, `"radio-group"` and `"checkbox-group"`. A
  named vector `c(Label = value)` or a list of `list(value=, label=)`.

- rules:

  A single
  [`el_rule()`](https://kaipingyang.github.io/shiny.element/reference/el_rule.md)
  or a list of them.

- ...:

  Further props passed to the control, e.g. `placeholder`, `min`, `max`,
  `disabled`. Names are converted to camelCase.

## Value

A field declaration, for
[`el_form()`](https://kaipingyang.github.io/shiny.element/reference/el_form.md).

## Examples

``` r
el_form_field("name", "input", label = "Name",
              rules = el_rule(required = TRUE, message = "Required"))
#> $prop
#> [1] "name"
#> 
#> $label
#> [1] "Name"
#> 
#> $tag
#> [1] "el-input"
#> 
#> $props
#> list()
#> 
#> $value
#> [1] ""
#> 
#> $rules
#> $rules[[1]]
#> $rules[[1]]$required
#> [1] TRUE
#> 
#> $rules[[1]]$message
#> [1] "Required"
#> 
#> $rules[[1]]$trigger
#> [1] "blur"
#> 
#> 
#> 
el_form_field("age", "input-number", label = "Age", value = 18,
              min = 0, max = 150)
#> $prop
#> [1] "age"
#> 
#> $label
#> [1] "Age"
#> 
#> $tag
#> [1] "el-input-number"
#> 
#> $props
#> $props$min
#> [1] 0
#> 
#> $props$max
#> [1] 150
#> 
#> 
#> $value
#> [1] 18
#> 
#> $rules
#> NULL
#> 
el_form_field("city", "select", label = "City",
              choices = c(Beijing = "bj", Shanghai = "sh"))
#> $prop
#> [1] "city"
#> 
#> $label
#> [1] "City"
#> 
#> $tag
#> [1] "el-select"
#> 
#> $props
#> list()
#> 
#> $value
#> [1] ""
#> 
#> $rules
#> NULL
#> 
#> $optionTag
#> [1] "el-option"
#> 
#> $options
#> $options[[1]]
#> $options[[1]]$label
#> [1] "Beijing"
#> 
#> $options[[1]]$value
#> [1] "bj"
#> 
#> $options[[1]]$text
#> [1] ""
#> 
#> 
#> $options[[2]]
#> $options[[2]]$label
#> [1] "Shanghai"
#> 
#> $options[[2]]$value
#> [1] "sh"
#> 
#> $options[[2]]$text
#> [1] ""
#> 
#> 
#> 
```
