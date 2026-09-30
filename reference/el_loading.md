# Element UI Loading Mask

Cover the page, or one element, while something is being worked out.
Each mask is named, and stays until
[`el_loading_close()`](https://kaipingyang.github.io/shiny.element/reference/el_loading_close.md)
is called with the same `id`.

## Usage

``` r
el_loading(
  session,
  id = "default",
  text = NULL,
  target = NULL,
  fullscreen = NULL,
  lock = NULL,
  body = NULL,
  spinner = NULL,
  background = NULL,
  custom_class = NULL
)
```

## Arguments

- session:

  Shiny session object.

- id:

  Name for this mask, used to close it again.

- text:

  Text shown under the spinner.

- target:

  CSS selector of the element to cover. `NULL` covers the page.

- fullscreen:

  Whether the mask covers the viewport. Default `TRUE` when no `target`
  is given.

- lock:

  Whether to stop the page scrolling underneath.

- body:

  Whether the mask is inserted into `body` rather than the target.

- spinner:

  Class name of a custom spinner.

- background:

  Background colour of the mask.

- custom_class:

  Extra class name.

## Value

Called for its side effect; returns `NULL` invisibly.

## Examples

``` r
if (interactive()) {
  library(shiny)
  library(shiny.element)

  ui <- el_page(el_button("go", "Fetch"), el_table("out"))

  server <- function(input, output, session) {
    observeEvent(input$go, {
      el_loading(session, "fetching", text = "Fetching rows...")
      on.exit(el_loading_close(session, "fetching"), add = TRUE)
      update_el_table(session, "out", data = slow_query())
    })
  }
  shinyApp(ui, server)
}
```
