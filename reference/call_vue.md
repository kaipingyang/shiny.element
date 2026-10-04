# Call a method of a Vue component from the server

[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
assigns data; a method is a function, reached with this. The method is
looked up on the component the template renders – a library table's
`clearSelection()`, a child component's own – or, with `component`, on
the first component of that name under the id.

## Usage

``` r
call_vue(
  session = shiny::getDefaultReactiveDomain(),
  id,
  method,
  args = list(),
  result = TRUE,
  component = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  The component's id (un-namespaced).

- method:

  The method's name.

- args:

  A list of arguments, passed in order.

- result:

  Whether to report the return value. Default `TRUE`.

- component:

  Name of the component to look for under `id`, when the template
  renders more than one.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

A method that returns something reports it as `input$<id>_<method>`, the
method name in snake_case; one that returns nothing reports `TRUE`. The
input has event priority, so the same answer twice still fires an
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html). A
promise reports what it resolves to.

## See also

[`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md).

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$reset, call_vue(id = "form", method = "resetFields"))
}
```
