# Show Element Plus Notification

Server-side function to show a desktop-corner notification popup.
Requires
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
or
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
in the UI to load the JS handler.

## Usage

``` r
el_notification(
  session = shiny::getDefaultReactiveDomain(),
  message,
  title = "",
  type = "info",
  duration = 4500,
  position = "top-right",
  show_close = TRUE,
  offset = 0,
  custom_class = NULL,
  dangerously_use_html_string = FALSE,
  id = NULL,
  icon = NULL,
  append_to = NULL,
  z_index = NULL,
  close_icon = NULL,
  progress = NULL,
  pause_on_hover = NULL
)
```

## Arguments

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

- message:

  Notification body text.

- title:

  Notification title. Default `""`.

- type:

  Notification type: `"info"`, `"success"`, `"warning"`, or `"error"`.
  Default `"info"`.

- duration:

  Auto-close delay in milliseconds. `0` disables auto-close. Default
  `4500`.

- position:

  Screen corner: `"top-right"`, `"top-left"`, `"bottom-right"`, or
  `"bottom-left"`. Default `"top-right"`.

- show_close:

  Whether to show the close button. Default `TRUE`.

- offset:

  Distance from the corner edge in pixels. Default `0`.

- custom_class:

  Extra class name.

- dangerously_use_html_string:

  Whether `message` is inserted as HTML. Only pass `TRUE` for markup you
  control – it is not escaped.

- id:

  Name for this notification, so
  [`el_notification_close()`](https://kaipingyang.github.io/shiny.element/reference/el_feedback_close.md)
  can close it, `input$<id>_close` reports when it closes and
  `input$<id>_click` when it is clicked.

- icon:

  Icon to show instead of the one `type` implies, by name.

- append_to:

  CSS selector of the element it is appended to. Default `<body>`.

- z_index:

  Its z-index, instead of the next one Element Plus hands out.

- close_icon:

  The close button's icon, by name.

- progress:

  Show a bar counting down `duration`: `TRUE`, or a list of Element
  Plus's progress options.

- pause_on_hover:

  Whether the countdown stops while the pointer is over it. Default
  `TRUE`.

## Value

A Shiny UI element.

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(shiny.element)
  ui <- el_page(
    el_button("btn", "Notify", type = "primary")
  )
  server <- function(input, output, session) {
    observeEvent(input$btn, {
      el_notification(session,
        message = "Operation successful!",
        title   = "Success",
        type    = "success"
      )
    })
  }
  shinyApp(ui, server)
}
```
