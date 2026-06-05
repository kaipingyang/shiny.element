# Show Element UI Notification

Server-side function to show a desktop-corner notification popup.
Requires
[`use_element()`](https://kaipingyang.github.io/shiny.element/reference/use_element.md)
or
[`el_page()`](https://kaipingyang.github.io/shiny.element/reference/el_page.md)
in the UI to load the JS handler.

## Usage

``` r
el_notification(
  session,
  message,
  title = "",
  type = "info",
  duration = 4500,
  position = "top-right",
  show_close = TRUE,
  offset = 0
)
```

## Arguments

- session:

  Shiny session object.

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
