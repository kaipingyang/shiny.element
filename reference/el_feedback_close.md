# Close a message or a notification

Closes the one opened under `id`, or every one currently showing when
`id` is `NULL` – Element's
[`close()`](https://rdrr.io/r/base/connections.html) and `closeAll()`.

## Usage

``` r
el_message_close(session, id = NULL)

el_notification_close(session, id = NULL)
```

## Arguments

- session:

  Shiny session object.

- id:

  The `id` it was opened with, or `NULL` for all of them.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  # inside a server function
  observeEvent(input$start, {
    el_notification(session, "Uploading...", duration = 0, id = "up")
  })
  observeEvent(input$done, {
    el_notification_close(session, "up")
  })
}
```
