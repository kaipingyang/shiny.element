# A data argument: an R value converted, a binding passed as it is

Two rules, as DT's
[`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
and Shiny's [`I()`](https://rdrr.io/r/base/AsIs.html): an R value is
converted from R's terms (a named vector, renamed fields) to the
component's; a
[`v_bind()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
is the component's own form – a library's `[{ value, label }]` – and
goes to it as it is, followed in the browser, its content never checked
in R. A
[`v_model()`](https://kaipingyang.github.io/shiny.element/dev/reference/v_bind.md)
is refused: the component reads the argument, it never sets it.

## Usage

``` r
.vue_data_arg(x, convert = identity, name = "", shape = NULL)
```

## Arguments

- x:

  The argument.

- convert:

  The conversion of an R value.

- name:

  The argument's name, for the message.

- shape:

  What a binding gives, for the bridge's check in Vue's development
  build: `"records"`, a list of objects.

## Value

`convert(x)`, or the binding.
