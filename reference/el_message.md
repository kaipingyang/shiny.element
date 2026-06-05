# Show Element UI Message

Server-side function to show a top-centre message toast. Requires
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
or
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
in the UI to load the JS handler.

## Usage

``` r
el_message(
  session,
  message,
  type = "info",
  duration = 3000,
  show_close = FALSE,
  center = FALSE
)
```

## Arguments

- session:

  Shiny session object.

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
