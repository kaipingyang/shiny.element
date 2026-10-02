# Declare a validation rule

Builds one async-validator rule, the format Element UI's form expects.

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
  trigger = "blur",
  enum = NULL,
  whitespace = NULL,
  validator = NULL,
  transform = NULL
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

  Value type to check: `"string"`, `"number"`, `"boolean"`, `"integer"`,
  `"float"`, `"array"`, `"object"`, `"enum"`, `"date"`, `"url"`,
  `"hex"`, `"email"` or `"any"`.

- message:

  Text shown when the rule fails.

- trigger:

  When to run the rule: `"blur"`, `"change"`, or both as
  `c("blur", "change")`.

- enum:

  Allowed values, with `type = "enum"`.

- whitespace:

  Whether a value of only whitespace counts as empty, with
  `required = TRUE`.

- validator:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function `function(rule, value, callback)` that calls `callback()`
  when the value is valid and `callback(new Error("message"))` when it
  is not – Element's custom rule. A check only the server can make goes
  through
  [`update_el_form()`](https://kaipingyang.github.io/shiny.element/reference/update_el_form.md)'s
  `errors` instead.

- transform:

  A
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  function turning the value into what the rule checks, such as
  `function(v) { return v.trim(); }`.

## Value

A rule, for
[`el_form_field()`](https://kaipingyang.github.io/shiny.element/reference/el_form_field.md)'s
`rules` argument.

## Examples

``` r
el_rule(required = TRUE, message = "Please enter your name")
#> $required
#> [1] TRUE
#> 
#> $message
#> [1] "Please enter your name"
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
el_rule(type = "enum", enum = c("a", "b"), message = "a or b")
#> $type
#> [1] "enum"
#> 
#> $enum
#> $enum[[1]]
#> [1] "a"
#> 
#> $enum[[2]]
#> [1] "b"
#> 
#> 
#> $message
#> [1] "a or b"
#> 
#> $trigger
#> [1] "blur"
#> 
# Element's custom validator
el_rule(validator = JS(
  "function(rule, value, callback) {",
  "  value % 2 === 0 ? callback() : callback(new Error('An even number'));",
  "}"), trigger = "change")
#> $validator
#> [1] "function(rule, value, callback) {\n  value % 2 === 0 ? callback() : callback(new Error('An even number'));\n}"
#> attr(,"class")
#> [1] "JS_EVAL"
#> 
#> $trigger
#> [1] "change"
#> 
```
