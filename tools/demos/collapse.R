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
#' The switch moves each header's icon: `expand_icon_position` follows it
#' in the browser, [v_bind()].
#| shot_js = "document.querySelector('#position .el-switch').click()"
#| shot_expect = "document.querySelector('#coll_pos.el-collapse-icon-position-right')"
tags$div(
  style = "display: flex; align-items: center; margin-bottom: 16px",
  tags$span(style = "margin-right: 16px", "expand icon position: "),
  el_switch(
    "position",
    value = "left",
    inactive_value = "left",
    active_value = "right",
    inactive_text = "left",
    active_text = "right",
    inactive_color = "#88b8fe"
  )
)
el_collapse(
  "coll_pos",
  expand_icon_position = v_bind("$inputs.position"),
  items = list(
    el_collapse_item(
      "Consistency",
      tags$div(
        "Consistent with real life: in line with the process and logic of",
        "real life, and comply with languages and habits that the users are",
        "used to;"
      ),
      tags$div(
        "Consistent within interface: all elements should be consistent,",
        "such as: design style, icons and texts, position of elements, etc."
      ),
      name = "1"
    ),
    el_collapse_item(
      "Feedback",
      tags$div(
        "Operation feedback: enable the users to clearly perceive their",
        "operations by style updates and interactive effects;"
      ),
      tags$div(
        "Visual feedback: reflect current state by updating or rearranging",
        "elements of the page."
      ),
      name = "2"
    ),
    el_collapse_item(
      "Efficiency",
      tags$div(
        "Simplify the process: keep operating process simple and intuitive;"
      ),
      tags$div(
        "Definite and clear: enunciate your intentions clearly so that the",
        "users can quickly understand and make decisions;"
      ),
      name = "3"
    )
  )
)

## prevent-collapsing
#' `before_collapse` returns a promise: the panel turns after a second, or
#' stays, as the switch says. The switch's value is a store's field,
#' [v_model()], which the function reads when it runs.
#| shot_js = c("document.querySelector('#before .el-switch').click()", "document.querySelectorAll('#coll_guard .el-collapse-item__header')[1].click()")
#| shot_wait = 2
#| shot_expect = "!document.querySelectorAll('#coll_guard .el-collapse-item')[1].classList.contains('is-active')"
vue_store("collapsing", state = list(allow = TRUE))
tags$div(
  style = "display: flex; align-items: center; margin-bottom: 16px",
  tags$span(style = "margin-right: 16px", "before collapse return: "),
  el_switch(
    "before",
    value = v_model("$vueStore.collapsing.allow"),
    inactive_text = "false",
    active_text = "true"
  )
)
el_collapse(
  "coll_guard",
  value = "1",
  before_collapse = JS(
    "function() {
      var allow = shinyVue.useStore('collapsing').allow;
      return new Promise(function(resolve) {
        setTimeout(function() { resolve(allow); }, 1000);
      });
    }"
  ),
  items = list(
    el_collapse_item(
      "Consistency",
      tags$div(
        "Consistent with real life: in line with the process and logic of",
        "real life, and comply with languages and habits that the users are",
        "used to;"
      ),
      name = "1"
    ),
    el_collapse_item(
      "Feedback",
      tags$div(
        "Operation feedback: enable the users to clearly perceive their",
        "operations by style updates and interactive effects;"
      ),
      name = "2"
    )
  )
)
