## basic
el_timeline(
  "tl",
  items = list(
    el_timeline_item("Event start", timestamp = "2018-04-15"),
    el_timeline_item("Approved", timestamp = "2018-04-13"),
    el_timeline_item("Success", timestamp = "2018-04-11")
  )
)

## mode
#' `mode` puts the content after the line (`"start"`), before it (`"end"`),
#' or on alternate sides; it follows the radio buttons in the browser,
#' [v_bind()].
#| shot_js = "document.querySelectorAll('#tl_mode_pick .el-radio-button')[1].click()"
#| shot_expect = "document.querySelector('#tl_mode .el-timeline').classList.contains('is-alternate')"
el_radio_group(
  "tl_mode_pick",
  choices = c("start", "alternate", "alternate-reverse", "end"),
  selected = "start",
  button = TRUE
)
tags$div(
  style = "margin-top: 16px",
  el_timeline(
    "tl_mode",
    mode = v_bind("$inputs.tl_mode_pick"),
    items = list(
      el_timeline_item("Event start", timestamp = "2018-04-15"),
      el_timeline_item("Approved", timestamp = "2018-04-13"),
      el_timeline_item("Success", timestamp = "2018-04-11")
    )
  )
)

## custom-node
el_timeline(
  "nodes",
  items = list(
    el_timeline_item(
      "Custom icon",
      timestamp = "2018-04-12 20:46",
      size = "large",
      type = "primary",
      icon = "MoreFilled"
    ),
    el_timeline_item(
      "Custom color",
      timestamp = "2018-04-03 20:46",
      color = "#0bbd87"
    ),
    el_timeline_item(
      "Custom size",
      timestamp = "2018-04-03 20:46",
      size = "large"
    ),
    el_timeline_item(
      "Custom hollow",
      timestamp = "2018-04-03 20:46",
      type = "primary",
      hollow = TRUE
    ),
    el_timeline_item("Default node", timestamp = "2018-04-03 20:46")
  )
)

## custom-timestamp
el_timeline(
  "stamps",
  items = list(
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/12 20:46")
      ),
      timestamp = "2018/4/12",
      placement = "top"
    ),
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/3 20:46")
      ),
      timestamp = "2018/4/3",
      placement = "top"
    ),
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/2 20:46")
      ),
      timestamp = "2018/4/2",
      placement = "top"
    )
  )
)

## center
el_timeline(
  "centred",
  items = list(
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/12 20:46")
      ),
      timestamp = "2018/4/12",
      placement = "top",
      center = TRUE
    ),
    el_timeline_item(
      el_card(
        tags$h4("Update Github template"),
        tags$p("Tom committed 2018/4/3 20:46")
      ),
      timestamp = "2018/4/3",
      placement = "top"
    ),
    el_timeline_item(
      "Event start",
      timestamp = "2018/4/2",
      placement = "top",
      center = TRUE
    ),
    el_timeline_item("Event end", timestamp = "2018/4/2", placement = "top")
  )
)

## reverse
#' `reverse` shows the entries newest first; it follows the radios, whose
#' values are `FALSE` and `TRUE`.
#| shot_js = "document.querySelectorAll('#order .el-radio')[1].click()"
#| shot_expect = "document.querySelector('#tl .el-timeline-item__content').textContent.trim() === 'Success'"
el_radio_group(
  "order",
  choices = c(Ascending = FALSE, Descending = TRUE),
  value = FALSE
)
el_timeline(
  "tl",
  reverse = v_bind("$inputs.order"),
  items = list(
    el_timeline_item("Event start", timestamp = "2018-04-15"),
    el_timeline_item("Approved", timestamp = "2018-04-13"),
    el_timeline_item("Success", timestamp = "2018-04-11")
  )
)
