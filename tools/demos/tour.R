## basic
#' A step's `target` is a CSS selector; the server opens the tour with
#' `update_el_tour()`.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
ui <- el_page(
  el_button("begin", "Begin Tour", type = "primary"),
  el_divider(),
  el_space(
    tags$span(id = "t_up", el_button("up", "Upload")),
    tags$span(id = "t_save", el_button("save", "Save", type = "primary")),
    tags$span(id = "t_more", el_button("more", "", icon = "MoreFilled"))
  ),
  el_tour(
    "tour",
    steps = list(
      el_tour_step("#t_up", "Upload File", "Put you files here."),
      el_tour_step("#t_save", "Save", "Save your changes"),
      el_tour_step("#t_more", "Other Actions", "Click to see other")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$begin,
    update_el_tour(id = "tour", open = TRUE, current = 0)
  )
}

shinyApp(ui, server)

## non-modal
#' `mask = FALSE` leaves the page undimmed; `type = "primary"` colours the card.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
ui <- el_page(
  el_button("begin", "Begin Tour", type = "primary"),
  el_divider(),
  el_space(
    tags$span(id = "t_up", el_button("up", "Upload")),
    tags$span(id = "t_save", el_button("save", "Save", type = "primary")),
    tags$span(id = "t_more", el_button("more", "", icon = "MoreFilled"))
  ),
  el_tour(
    "tour",
    type = "primary",
    mask = FALSE,
    steps = list(
      el_tour_step("#t_up", "Upload File", "Put you files here."),
      el_tour_step("#t_save", "Save", "Save your changes"),
      el_tour_step("#t_more", "Other Actions", "Click to see other")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$begin,
    update_el_tour(id = "tour", open = TRUE, current = 0)
  )
}

shinyApp(ui, server)

## placement
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
ui <- el_page(
  tags$span(id = "t_btn", el_button("begin", "Begin Tour", type = "primary")),
  el_tour(
    "tour",
    steps = list(
      el_tour_step(
        title = "Center",
        description = "Displayed in the center of screen."
      ),
      el_tour_step(
        "#t_btn",
        "Right",
        "On the right of target.",
        placement = "right"
      ),
      el_tour_step("#t_btn", "Top", "On the top of target.", placement = "top")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$begin,
    update_el_tour(id = "tour", open = TRUE, current = 0)
  )
}

shinyApp(ui, server)

## mask
#' `mask` takes Element Plus's object: its `style` and `color`.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
ui <- el_page(
  el_button("begin", "Begin Tour", type = "primary"),
  el_divider(),
  el_space(
    tags$span(id = "t_up", el_button("up", "Upload")),
    tags$span(id = "t_save", el_button("save", "Save", type = "primary"))
  ),
  el_tour(
    "tour",
    mask = list(
      style = list(boxShadow = "inset 0 0 15px #333"),
      color = "rgba(80, 255, 255, .4)"
    ),
    steps = list(
      el_tour_step("#t_up", "Upload File", "Put you files here."),
      el_tour_step(
        "#t_save",
        "Save",
        "Save your changes",
        mask = list(
          style = list(boxShadow = "inset 0 0 15px #fff"),
          color = "rgba(40, 0, 255, .4)"
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$begin,
    update_el_tour(id = "tour", open = TRUE, current = 0)
  )
}

shinyApp(ui, server)

## indicator
#' The `indicators` slot draws the step counter; its scope is `current` and
#' `total`.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
ui <- el_page(
  el_button("begin", "Begin Tour", type = "primary"),
  el_divider(),
  el_space(
    tags$span(id = "t_up", el_button("up", "Upload")),
    tags$span(id = "t_save", el_button("save", "Save", type = "primary"))
  ),
  el_tour(
    "tour",
    steps = list(
      el_tour_step("#t_up", "Upload File", "Put you files here."),
      el_tour_step("#t_save", "Save", "Save your changes")
    ),
    slots = list(
      indicators = template(
        tags$span("{{ current + 1 }} / {{ total }}"),
        slot = "indicators",
        scope = "{ current, total }"
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$begin,
    update_el_tour(id = "tour", open = TRUE, current = 0)
  )
}

shinyApp(ui, server)

## target
#' A target may be any selector, and need not exist until the step is shown.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
ui <- el_page(
  el_button("begin", "Begin Tour", type = "primary"),
  el_divider(),
  tags$div(
    id = "first",
    style = "display: inline-block; padding: 8px; border: 1px dashed #ccc",
    "First"
  ),
  tags$div(
    class = "second",
    style = "display: inline-block; padding: 8px; border: 1px dashed #ccc",
    "Second"
  ),
  el_tour(
    "tour",
    steps = list(
      el_tour_step("#first", "By id", "A selector for an id."),
      el_tour_step(".second", "By class", "A selector for a class.")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(
    input$begin,
    update_el_tour(id = "tour", open = TRUE, current = 0)
  )
}

shinyApp(ui, server)
