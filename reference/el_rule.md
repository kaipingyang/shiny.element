# Declare a validation rule

Builds one async-validator rule, the format Element UI's form expects.
Custom `validator` functions are not supported: they are JavaScript
functions and cannot be expressed from R.

## Usage

``` r
el_rule(
  required = NULL,
  min = NULL,
  max = NULL,
  len = NULL,
  pattern = NULL,
  type = NULL,
  message = NULL,
  trigger = "blur"
)
```

## Arguments

- required:

  Whether the field must be filled.

- min, max:

  Minimum and maximum: length for strings, value for numbers.

- len:

  Exact length.

- pattern:

  A regular expression the value must match.

- type:

  Value type to check: `"string"`, `"number"`, `"email"`, `"url"`,
  `"date"`, `"array"` or `"object"`.

- message:

  Text shown when the rule fails.

- trigger:

  When to run the rule: `"blur"` or `"change"`.

## Value

A rule, for
[`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)'s
`rules` argument.

## Examples

``` r
el_rule(required = TRUE, message = "Name is required")
#> $required
#> [1] TRUE
#> 
#> $message
#> [1] "Name is required"
#> 
#> $trigger
#> [1] "blur"
#> 
el_rule(min = 2, max = 20, message = "Between 2 and 20 characters")
#> $min
#> [1] 2
#> 
#> $max
#> [1] 20
#> 
#> $message
#> [1] "Between 2 and 20 characters"
#> 
#> $trigger
#> [1] "blur"
#> 
el_rule(type = "email", message = "Not a valid email", trigger = "blur")
#> $type
#> [1] "email"
#> 
#> $message
#> [1] "Not a valid email"
#> 
#> $trigger
#> [1] "blur"
#> 

# Several rules on one field
list(
  el_rule(required = TRUE, message = "Required"),
  el_rule(min = 6, message = "At least 6 characters")
)
#> [[1]]
#> [[1]]$required
#> [1] TRUE
#> 
#> [[1]]$message
#> [1] "Required"
#> 
#> [[1]]$trigger
#> [1] "blur"
#> 
#> 
#> [[2]]
#> [[2]]$min
#> [1] 6
#> 
#> [[2]]$message
#> [1] "At least 6 characters"
#> 
#> [[2]]$trigger
#> [1] "blur"
#> 
#> 
```
