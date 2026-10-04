# Set fields of a Vue component from the server

The Vue layer's `update*Input()`: assigns fields of a component's state
– its `data`, or what its `setup()` returned, or a
[`vue_store()`](https://kaipingyang.github.io/shiny.element/reference/vue_store.md)'s
– and the component, and every template showing them, follow. As with
Shiny's updaters, the component's value is reported back to `input$<id>`
afterwards.

## Usage

``` r
update_vue(session = shiny::getDefaultReactiveDomain(), id, ..., value = NULL)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  The component's id (un-namespaced).

- ...:

  Fields to set, `<field> = <value>`. A function is
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md).

- value:

  The component's value: sets whichever field its `input` names.

## Value

Called for its side effect; returns `NULL` invisibly.

## See also

[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md),
[`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md).

## Examples

``` r
if (interactive()) {
  # inside a server function
  update_vue(id = "counter", value = 0)
  update_vue(id = "cart", note = "Free delivery today")
}
```
