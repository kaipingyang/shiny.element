# Show Element UI Message

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
  center = FALSE,
  offset = 20,
  icon_class = NULL,
  custom_class = NULL,
  dangerously_use_html_string = FALSE,
  id = NULL
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

- center:

  Whether to centre the message text. Default `FALSE`.

- offset:

  Distance from the top of the window, in pixels.

- icon_class:

  Icon class to show instead of the one `type` implies.

- custom_class:

  Extra class name.

- dangerously_use_html_string:

  Whether `message` is inserted as HTML. Only pass `TRUE` for markup you
  control – it is not escaped.

- id:

  Name for this message, so
  [`el_message_close()`](https://kaipingyang.github.io/shiny.element/reference/el_feedback_close.md)
  can close it and `input$<id>_close` reports when it closes.

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
