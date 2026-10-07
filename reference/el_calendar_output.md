# A calendar as a Shiny output

The calendar of an app whose events the server reads – from a database,
a folder, a computation – as toastui's `calendarOutput()` and
`renderCalendar()`: the page holds `el_calendar_output()`, the server
renders
[`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md)
into it with its events. Rendering again with new events patches the
calendar in place: the month shown and an open dialog stay, and only
what changed is sent.

## Usage

``` r
el_calendar_output(outputId, width = "100%", loading = TRUE)

render_el_calendar(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  The output's id.

- width:

  The calendar's width, as a CSS unit.

- loading:

  Whether Element's loading mask covers the calendar while Shiny
  recalculates it, in place of Shiny fading the output.

- expr:

  An expression returning
  [`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md),
  given no `id`.

- env, quoted:

  As for
  [`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html).

## Value

`el_calendar_output()`, a tag; `render_el_calendar()`, a render
function.

## Details

The output's id is the calendar's: `input$<id>` is the day picked and
`input$<id>_click`, `_dates`, `_add`, `_update`, `_delete` are as for
[`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md);
[`update_el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md)
reaches the calendar by it, and
[`el_calendar_events()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_events.md)
reads the events it shows.

## See also

[`el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md),
[`update_el_calendar()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar.md),
[`el_calendar_events()`](https://kaipingyang.github.io/shiny.element/reference/el_calendar_events.md).

## Examples

``` r
if (interactive()) {
  library(shiny)
  archive <- data.frame(
    date = Sys.Date() - c(9, 6, 2),
    title = c("", "", "Validated"),
    body = c("Raw data", "Archive", "Validated data"),
    color = c("lightgrey", "#EED5B7", "#E9C46B")
  )
  ui <- el_page(el_calendar_output("snapshot"), verbatimTextOutput("picked"))
  server <- function(input, output, session) {
    output$snapshot <- render_el_calendar(
      el_calendar(value = max(archive$date), events = archive)
    )
    output$picked <- renderPrint(input$snapshot_click$date)
  }
  shinyApp(ui, server)
}
```
