# Element UI Message Box

A modal that asks something and waits for an answer: a confirmation, an
acknowledgement, or a line of text.

## Usage

``` r
el_message_box(
  session,
  id,
  message,
  title = NULL,
  type = NULL,
  box_type = c("confirm", "alert", "prompt"),
  confirm_button_text = NULL,
  cancel_button_text = NULL,
  show_cancel_button = NULL,
  show_close = NULL,
  center = FALSE,
  round_button = FALSE,
  dangerously_use_html_string = FALSE,
  custom_class = NULL,
  icon_class = NULL,
  close_on_click_modal = NULL,
  close_on_press_escape = NULL,
  input_placeholder = NULL,
  input_value = NULL,
  input_pattern = NULL,
  input_error_message = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Input ID the answer is reported to.

- message:

  The question or statement.

- title:

  Title of the box.

- type:

  Icon shown: `"success"`, `"info"`, `"warning"` or `"error"`.

- box_type:

  `"confirm"` (default) offers two buttons, `"alert"` one, and
  `"prompt"` asks for text.

- confirm_button_text, cancel_button_text:

  Button labels.

- show_cancel_button:

  Whether to offer a cancel button. Default `TRUE` for `"confirm"` and
  `"prompt"`.

- show_close:

  Whether to show the close cross. Default `TRUE`.

- center:

  Whether to centre the content.

- round_button:

  Whether the buttons are rounded.

- dangerously_use_html_string:

  Whether `message` is rendered as HTML. Only pass `TRUE` for markup you
  control – it is inserted unescaped.

- custom_class, icon_class:

  Extra class names.

- close_on_click_modal:

  Whether clicking the backdrop closes it.

- close_on_press_escape:

  Whether Escape closes it.

- input_placeholder, input_value:

  For `box_type = "prompt"`: the placeholder and the initial text.

- input_pattern:

  Regular expression the text must match, as a string.

- input_error_message:

  Message shown when it does not match.

## Value

Called for its side effect; returns `NULL` invisibly.

## Details

Unlike
[`el_message()`](https://kaipingyang.github.io/shiny.element/reference/el_message.md)
and
[`el_notification()`](https://kaipingyang.github.io/shiny.element/reference/el_notification.md),
this one answers back. The reply arrives as `input$<id>`, so read it
with
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html): the
input is set with event priority, so answering "confirm" twice in a row
fires the observer twice, where an output reading the value would see no
change.

## Shiny inputs

- `input$<id>` – `"confirm"`, `"cancel"` or `"close"`. For a prompt that
  was confirmed, a list of `action` and `value`, where `value` is the
  text the user typed.

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(shiny.element)

  ui <- el_page(el_button("del", "Delete", type = "danger"),
                verbatimTextOutput("answer"))

  server <- function(input, output, session) {
    observeEvent(input$del, {
      el_message_box(session, "confirm_delete",
                     "This cannot be undone.",
                     title = "Delete the row?", type = "warning")
    })
    observeEvent(input$confirm_delete, {
      output$answer <- renderPrint(input$confirm_delete)
    })
  }
  shinyApp(ui, server)
}
```
