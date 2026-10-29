## basic
#' A step's `target` is a CSS selector. The tour's `visible` and `current`
#' follow a store, [vue_bind()]: the button starts it in the browser, and
#' finishing or closing it sets the store back. From the server it is
#' `update_el_tour(visible = TRUE, current = 0)`.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
vue_store("tour_basic", state = list(open = FALSE, current = 0))
el_button(
  "begin",
  "Begin Tour",
  type = "primary",
  on = list(
    click = "$store.tour_basic.current = 0; $store.tour_basic.open = true"
  )
)
el_divider()
el_space(
  tags$span(id = "t_up", el_button("up", "Upload")),
  tags$span(id = "t_save", el_button("save", "Save", type = "primary")),
  tags$span(id = "t_more", el_button("more", "", icon = "MoreFilled"))
)
el_tour(
  "tour",
  visible = vue_bind("$store.tour_basic.open"),
  current = vue_bind("$store.tour_basic.current"),
  steps = list(
    el_tour_step("#t_up", "Upload File", "Put you files here."),
    el_tour_step("#t_save", "Save", "Save your changes"),
    el_tour_step("#t_more", "Other Actions", "Click to see other")
  )
)

## non-modal
#' `mask = FALSE` leaves the page undimmed; `type = "primary"` colours the card.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
vue_store("tour_non_modal", state = list(open = FALSE, current = 0))
el_button(
  "begin",
  "Begin Tour",
  type = "primary",
  on = list(
    click = "$store.tour_non_modal.current = 0; $store.tour_non_modal.open = true"
  )
)
el_divider()
el_space(
  tags$span(id = "t_up", el_button("up", "Upload")),
  tags$span(id = "t_save", el_button("save", "Save", type = "primary")),
  tags$span(id = "t_more", el_button("more", "", icon = "MoreFilled"))
)
el_tour(
  "tour",
  visible = vue_bind("$store.tour_non_modal.open"),
  current = vue_bind("$store.tour_non_modal.current"),
  type = "primary",
  mask = FALSE,
  steps = list(
    el_tour_step("#t_up", "Upload File", "Put you files here."),
    el_tour_step("#t_save", "Save", "Save your changes"),
    el_tour_step("#t_more", "Other Actions", "Click to see other")
  )
)

## placement
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
vue_store("tour_placement", state = list(open = FALSE, current = 0))
tags$span(
  id = "t_btn",
  el_button(
    "begin",
    "Begin Tour",
    type = "primary",
    on = list(
      click = "$store.tour_placement.current = 0; $store.tour_placement.open = true"
    )
  )
)
el_tour(
  "tour",
  visible = vue_bind("$store.tour_placement.open"),
  current = vue_bind("$store.tour_placement.current"),
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

## mask
#' `mask` takes Element Plus's object: its `style` and `color`.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
vue_store("tour_mask", state = list(open = FALSE, current = 0))
el_button(
  "begin",
  "Begin Tour",
  type = "primary",
  on = list(
    click = "$store.tour_mask.current = 0; $store.tour_mask.open = true"
  )
)
el_divider()
el_space(
  tags$span(id = "t_up", el_button("up", "Upload")),
  tags$span(id = "t_save", el_button("save", "Save", type = "primary"))
)
el_tour(
  "tour",
  visible = vue_bind("$store.tour_mask.open"),
  current = vue_bind("$store.tour_mask.current"),
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

## indicator
#' The `indicators` slot draws the step counter; its scope is `current` and
#' `total`.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
vue_store("tour_indicator", state = list(open = FALSE, current = 0))
el_button(
  "begin",
  "Begin Tour",
  type = "primary",
  on = list(
    click = "$store.tour_indicator.current = 0; $store.tour_indicator.open = true"
  )
)
el_divider()
el_space(
  tags$span(id = "t_up", el_button("up", "Upload")),
  tags$span(id = "t_save", el_button("save", "Save", type = "primary"))
)
el_tour(
  "tour",
  visible = vue_bind("$store.tour_indicator.open"),
  current = vue_bind("$store.tour_indicator.current"),
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

## target
#' A target may be any selector, and need not exist until the step is shown.
#| shot_js = "document.querySelector('#begin_container button').click()", shot_sel = ".el-tour__content", shot_wait = 3.5
vue_store("tour_target", state = list(open = FALSE, current = 0))
el_button(
  "begin",
  "Begin Tour",
  type = "primary",
  on = list(
    click = "$store.tour_target.current = 0; $store.tour_target.open = true"
  )
)
el_divider()
tags$div(
  id = "first",
  style = "display: inline-block; padding: 8px; border: 1px dashed #ccc",
  "First"
)
tags$div(
  class = "second",
  style = "display: inline-block; padding: 8px; border: 1px dashed #ccc",
  "Second"
)
el_tour(
  "tour",
  visible = vue_bind("$store.tour_target.open"),
  current = vue_bind("$store.tour_target.current"),
  steps = list(
    el_tour_step("#first", "By id", "A selector for an id."),
    el_tour_step(".second", "By class", "A selector for a class.")
  )
)
