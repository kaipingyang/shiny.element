# Show Element Plus Message

Server-side function to show a top-centre message toast. Requires
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
or
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
in the UI to load the JS handler.

## Usage

``` r
el_message(
  session = shiny::getDefaultReactiveDomain(),
  message,
  type = "info",
  duration = 3000,
  show_close = FALSE,
  offset = 16,
  custom_class = NULL,
  dangerously_use_html_string = FALSE,
  id = NULL,
  icon = NULL,
  plain = NULL,
  placement = NULL,
  append_to = NULL,
  grouping = NULL,
  repeat_num = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- message:

  Message text.

- type:

  Message type: `"info"`, `"success"`, `"warning"`, or `"error"`.
  Default `"info"`.

- duration:

  Auto-close delay in milliseconds. `0` disables auto-close. Default
  `3000`.

- show_close:

  Whether to show the close button. Default `FALSE`.

- offset:

  Distance from the edge of the window, in pixels. Default `16`.

- custom_class:

  Extra class name.

- dangerously_use_html_string:

  Whether `message` is inserted as HTML. Only pass `TRUE` for markup you
  control – it is not escaped.

- id:

  Name for this message, so
  [`el_message_close()`](https://kaipingyang.github.io/shiny.element/reference/el_feedback_close.md)
  can close it and `input$<id>_close` reports when it closes.

- icon:

  Icon to show instead of the one `type` implies, by name.

- plain:

  Whether it is drawn plain, without a background colour.

- placement:

  Where it appears: `"top"` (the default), `"top-left"`, `"top-right"`,
  `"bottom"`, `"bottom-left"` or `"bottom-right"`.

- append_to:

  CSS selector of the element it is appended to. Default `<body>`.

- grouping:

  Whether identical messages shown together are merged into one, with a
  count.

- repeat_num:

  The count a grouped message starts from.

## Value

A Shiny UI element.

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_button("btn", "Message", type = "primary")
  )
  server <- function(input, output, session) {
    observeEvent(input$btn, {
      el_message(session,
        message = "This is a message toast.",
        type    = "warning"
      )
    })
  }
  shinyApp(ui, server)
}
```
