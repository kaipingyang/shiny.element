# The events a calendar shows

What the browser holds, as R: the events last rendered with
[`render_el_calendar()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_calendar_output.md)
or sent with
[`update_el_calendar()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_calendar.md),
with every event
[`update_el_calendar()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_calendar.md)
has since inserted, replaced or deleted. The user's requests
(`input$<id>_add`, ...) are not in it until the server answers them. A
reactive read.

## Usage

``` r
el_calendar_events(session = shiny::getDefaultReactiveDomain(), id)
```

## Arguments

- session:

  The Shiny session, the current one by default.

- id:

  The calendar's id, the output's.

## Value

The events, as given; `NULL` for a calendar the server has not rendered
or updated.

## See also

[`render_el_calendar()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_calendar_output.md),
[`update_el_calendar()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_calendar.md).

## Examples

``` r
if (interactive()) {
  library(shiny)
  ui <- el_page(el_calendar_output("plan"), verbatimTextOutput("n"))
  server <- function(input, output, session) {
    output$plan <- render_el_calendar(el_calendar(
      events = data.frame(id = 1, date = Sys.Date(), title = "Review")
    ))
    # the events the calendar shows, read back as R
    output$n <- renderText(nrow(el_calendar_events(id = "plan")))
  }
  shinyApp(ui, server)
}
```
