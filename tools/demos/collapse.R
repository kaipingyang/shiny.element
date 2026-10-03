## basic
panels <- list(
  list(
    name = "1",
    title = "Consistency",
    tags$div(
      "Consistent with real life: in line with the process and logic of real life, and comply with languages and habits that the users are used to;"
    )
  ),
  list(
    name = "2",
    title = "Feedback",
    tags$div(
      "Operation feedback: enable the users to clearly perceive their operations by style updates and interactive effects;"
    )
  ),
  list(
    name = "3",
    title = "Efficiency",
    tags$div(
      "Simplify the process: keep operating process simple and intuitive;"
    )
  ),
  list(
    name = "4",
    title = "Controllability",
    tags$div(
      "Decision making: giving advices about operations is acceptable, but do not make decisions for the users;"
    )
  )
)
el_collapse("coll", items = panels, value = "1")

## accordion
el_collapse(
  "coll_acc",
  value = "1",
  accordion = TRUE,
  items = list(
    list(
      name = "1",
      title = "Consistency",
      tags$div("Consistent with real life.")
    ),
    list(name = "2", title = "Feedback", tags$div("Operation feedback.")),
    list(name = "3", title = "Efficiency", tags$div("Simplify the process.")),
    list(name = "4", title = "Controllability", tags$div("Decision making."))
  )
)

## customization
#' A title may be markup: an icon beside the text.
el_collapse(
  "coll_title",
  accordion = TRUE,
  items = list(
    list(
      name = "1",
      title = tags$span(
        "Consistency ",
        el_icon("InfoFilled", class = "header-icon")
      ),
      tags$div("Consistent with real life.")
    ),
    list(name = "2", title = "Feedback", tags$div("Operation feedback."))
  )
)

## custom-icon
el_collapse(
  "coll_icon",
  value = "1",
  items = list(
    list(
      name = "1",
      title = "Consistency",
      icon = "CaretRight",
      tags$div("Consistent with real life.")
    ),
    list(
      name = "2",
      title = "Feedback",
      icon = "ArrowRightBold",
      tags$div("Operation feedback.")
    )
  )
)

## custom-icon-position
el_collapse(
  "coll_pos",
  expand_icon_position = "left",
  items = list(
    list(
      name = "1",
      title = "Consistency",
      tags$div("Consistent with real life.")
    ),
    list(name = "2", title = "Feedback", tags$div("Operation feedback."))
  )
)

## prevent-collapsing
#' `before_collapse` may hold a panel as it is: return `false`, or a promise.
el_collapse(
  "coll_guard",
  before_collapse = JS(
    "function(name) { return confirm('Toggle ' + name + '?'); }"
  ),
  items = list(
    list(
      name = "1",
      title = "Consistency",
      tags$div("Consistent with real life.")
    ),
    list(name = "2", title = "Feedback", tags$div("Operation feedback."))
  )
)
