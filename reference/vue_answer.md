# Answer a Vue component that asked the server

A component that needs the server – a lazy tree its children, a remote
search its matches – asks with `shinyVue.ask(input, question)` in the
browser: the question arrives as an input, with a `request` number, and
the component waits for the answer. This sends it, or refuses
(`failed`), which rejects the component's promise.

## Usage

``` r
vue_answer(
  session = shiny::getDefaultReactiveDomain(),
  id,
  request,
  value = NULL,
  failed = FALSE
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- id:

  The component's id (un-namespaced).

- request:

  The question as it arrived, or its `request` number.

- value:

  The answer.

- failed:

  `TRUE` to refuse the request instead.

## Value

Called for its side effect; returns `NULL` invisibly.

## See also

[`vue_app()`](https://kaipingyang.github.io/shiny.element/reference/vue_app.md).

## Examples

``` r
if (interactive()) {
  # inside a server function: a component asked input$places_query
  observeEvent(input$places_query, {
    q <- input$places_query
    vue_answer(
      id = "places",
      request = q,
      value = grep(q$text, cities, value = TRUE)
    )
  })
}
```
