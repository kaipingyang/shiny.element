# A render function for a component drawn in an output of its own id

What
[`render_el_table()`](https://kaipingyang.github.io/shiny.element/reference/el_table_output.md)
and
[`render_el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_output.md)
share: the component drawn under the output's id, its data kept on the
server for its inputs and
[`el_table_data()`](https://kaipingyang.github.io/shiny.element/reference/el_table_data.md),
only what changed sent after the first render, a promise waited for, and
[`shiny::bindCache()`](https://rdrr.io/pkg/shiny/man/bindCache.html)
keeping the output as it stands while each page still gets only what
changed for it.

## Usage

``` r
.el_render_component(expr, env, class, what, data_arg, output_fn, label)
```

## Arguments

- expr:

  The expression, quoted.

- env:

  Its environment.

- class:

  The component's class: `"el_table"`.

- what:

  The error when the expression returns something else.

- data_arg:

  The argument holding the component's data: `"data"`.

- output_fn:

  The output function.

- label:

  The render function's name, for its cache hint.

## Value

A render function, of class `el_render_output`.
