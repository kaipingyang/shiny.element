# Set fields of a component's Vue instance

The escape hatch beside `update_el_*()`: assigns any declared field of
the instance behind `id` – a field of a component built with
[`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md),
or of one absorbed into a wrapper, which has no update function of its
own. A field the instance does not declare is refused, with a
`[shiny-vue]` warning in the browser console.

## Usage

``` r
update_vue_data(session = shiny::getDefaultReactiveDomain(), id, data)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  Vue component id (string)

- data:

  Named list of fields and their new values.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
# In a Shiny server function:
# Set two fields of a component of your own
update_vue_data(session, "price", list(range = list(0, 50), max = 500))
} # }
```
