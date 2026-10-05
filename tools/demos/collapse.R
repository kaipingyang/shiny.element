## basic
panels <- list(
  el_collapse_item(
    "Consistency",
    tags$div(
      "Consistent with real life: in line with the process and logic of real life, and comply with languages and habits that the users are used to;"
    ),
    name = "1"
  ),
  el_collapse_item(
    "Feedback",
    tags$div(
      "Operation feedback: enable the users to clearly perceive their operations by style updates and interactive effects;"
    ),
    name = "2"
  ),
  el_collapse_item(
    "Efficiency",
    tags$div(
      "Simplify the process: keep operating process simple and intuitive;"
    ),
    name = "3"
  ),
  el_collapse_item(
    "Controllability",
    tags$div(
      "Decision making: giving advices about operations is acceptable, but do not make decisions for the users;"
    ),
    name = "4"
  )
)
el_collapse("coll", items = panels, value = "1")

## accordion
el_collapse(
  "coll_acc",
  value = "1",
  accordion = TRUE,
  items = list(
    el_collapse_item(
      "Consistency",
      tags$div("Consistent with real life."),
      name = "1"
    ),
    el_collapse_item("Feedback", tags$div("Operation feedback."), name = "2"),
    el_collapse_item(
      "Efficiency",
      tags$div("Simplify the process."),
      name = "3"
    ),
    el_collapse_item(
      "Controllability",
      tags$div("Decision making."),
      name = "4"
    )
  )
)

## customization
#' A title may be markup: an icon beside the text.
el_collapse(
  "coll_title",
  accordion = TRUE,
  items = list(
    el_collapse_item(
      tags$span(
        "Consistency ",
        el_icon("InfoFilled", class = "header-icon")
      ),
      tags$div("Consistent with real life."),
      name = "1"
    ),
    el_collapse_item("Feedback", tags$div("Operation feedback."), name = "2")
  )
)

## custom-icon
el_collapse(
  "coll_icon",
  value = "1",
  items = list(
    el_collapse_item(
      "Consistency",
      tags$div("Consistent with real life."),
      name = "1",
      icon = "CaretRight"
    ),
    el_collapse_item(
      "Feedback",
      tags$div("Operation feedback."),
      name = "2",
      icon = "ArrowRightBold"
    )
  )
)

## custom-icon-position
el_collapse(
  "coll_pos",
  expand_icon_position = "left",
  items = list(
    el_collapse_item(
      "Consistency",
      tags$div("Consistent with real life."),
      name = "1"
    ),
    el_collapse_item("Feedback", tags$div("Operation feedback."), name = "2")
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
    el_collapse_item(
      "Consistency",
      tags$div("Consistent with real life."),
      name = "1"
    ),
    el_collapse_item("Feedback", tags$div("Operation feedback."), name = "2")
  )
)
