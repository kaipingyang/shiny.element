## basic
#' `update_el_steps(active =)` moves it, as the demo's button does.
el_steps(
  "st_basic",
  active = 0,
  finish_status = "success",
  steps = list(
    el_step("Step 1"),
    el_step("Step 2"),
    el_step("Step 3")
  )
)

## with-status
el_steps(
  "st_status",
  active = 1,
  space = 200,
  finish_status = "success",
  steps = list(
    el_step("Done"),
    el_step("Processing"),
    el_step("Step 3")
  )
)

## centered
el_steps(
  "st_center",
  active = 2,
  align_center = TRUE,
  steps = list(
    el_step("Step 1", "Some description"),
    el_step("Step 2", "Some description"),
    el_step("Step 3", "Some description"),
    el_step("Step 4", "Some description")
  )
)

## with-description
el_steps(
  "st_desc",
  active = 1,
  steps = list(
    el_step("Step 1", "Some description"),
    el_step("Step 2", "Some description"),
    el_step("Step 3", "Some description")
  )
)

## with-icon
el_steps(
  "st_icon",
  active = 1,
  steps = list(
    el_step("Step 1", icon = "Edit"),
    el_step("Step 2", icon = "Upload"),
    el_step("Step 3", icon = "Picture")
  )
)

## vertical
tags$div(
  style = "height: 300px",
  el_steps(
    "st_vert",
    direction = "vertical",
    active = 1,
    steps = list(
      el_step("Step 1"),
      el_step("Step 2"),
      el_step("Step 3")
    )
  )
)

## simple
tagList(
  el_steps(
    "st_simple",
    active = 0,
    simple = TRUE,
    steps = list(
      el_step("Step 1", icon = "Edit"),
      el_step("Step 2", icon = "UploadFilled"),
      el_step("Step 3", icon = "Picture")
    )
  ),
  tags$div(style = "margin-top: 20px"),
  el_steps(
    "st_simple2",
    active = 0,
    finish_status = "success",
    simple = TRUE,
    steps = list(
      el_step("Step 1"),
      el_step("Step 2"),
      el_step("Step 3")
    )
  )
)
