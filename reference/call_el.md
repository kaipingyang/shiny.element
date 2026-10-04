# Call a method of an Element component

[`update_el_table()`](https://kaipingyang.github.io/shiny.element/reference/update_el_table.md)
and the other `update_el_*()` functions assign into the Vue instance's
data, which reaches a component's props. Element also documents
*methods* – `clearSelection()`, `setCheckedKeys()`,
[`validate()`](https://rdrr.io/pkg/shiny/man/validate.html) – which are
functions on the component and cannot be reached that way. `call_el()`
invokes one: it is
[`call_vue()`](https://kaipingyang.github.io/shiny.element/reference/call_vue.md)
with Element's references to table rows, upload files and tree nodes.

## Usage

``` r
call_el(
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

  Component ID (un-namespaced).

- method:

  Name of the Element method to call.

- args:

  A list of arguments, passed positionally. A row of a table or a file
  of an upload is given by
  [`el_table_row()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md)
  or
  [`el_upload_file()`](https://kaipingyang.github.io/shiny.element/reference/el_table_row.md):
  the method needs the object itself.

- result:

  Whether to report the return value as an input. Default `TRUE`. The
  input is `<id>_<method>`; an input of your own with that name – an
  `actionButton("car_next")` beside `call_el(session, "car", "next")` –
  would hear it too. Give `result = FALSE`, or another name, then.

- component:

  Optional Element component name (`"ElTable"`) to look for under the
  component's id. Only needed when a component nests another of its own.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

A method that returns something reports it as `input$<id>_<method>`,
with the method name in snake_case, matching how events are reported:
`getCheckedKeys` arrives as `input$<id>_get_checked_keys`. The input is
set with event priority, so asking twice and getting the same answer
still fires an
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html) the
second time.

A method that returns nothing reports `TRUE`, so an
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html) can
still tell that it ran. Pass `result = FALSE` to send nothing back.

Each component's methods are listed in its own help page, under "Element
methods".

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(shiny.element)

  ui <- el_page(
    el_tree(
      "tree",
      show_checkbox = TRUE,
      node_key = "id",
      checked = "apple",
      default_expand_all = TRUE,
      data = list(list(
        id = "fruit",
        label = "Fruit",
        children = list(
          list(id = "apple", label = "Apple"),
          list(id = "pear", label = "Pear")
        )
      ))
    ),
    el_button("clear", "Clear the ticks"),
    el_button("ask", "Which are ticked?"),
    verbatimTextOutput("answer")
  )

  server <- function(input, output, session) {
    # A command: setCheckedKeys() with an empty set
    observeEvent(input$clear, {
      call_el(session, "tree", "setCheckedKeys", list(list()))
    })

    # A method with a return value answers asynchronously
    observeEvent(input$ask, {
      call_el(session, "tree", "getCheckedKeys")
    })
    output$answer <- renderPrint(input$tree_get_checked_keys)
  }

  shinyApp(ui, server)
}
```
