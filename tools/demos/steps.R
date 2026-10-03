## basic
#' `update_el_steps(active =)` moves it, as the demo's button does.
el_steps(
  "st_basic",
  active = 0,
  finish_status = "success",
  steps = list(
    list(title = "Step 1"),
    list(title = "Step 2"),
    list(title = "Step 3")
  )
)

## with-status
el_steps(
  "st_status",
  active = 1,
  space = 200,
  finish_status = "success",
  steps = list(
    list(title = "Done"),
    list(title = "Processing"),
    list(title = "Step 3")
  )
)

## centered
el_steps(
  "st_center",
  active = 2,
  align_center = TRUE,
  steps = list(
    list(title = "Step 1", description = "Some description"),
    list(title = "Step 2", description = "Some description"),
    list(title = "Step 3", description = "Some description"),
    list(title = "Step 4", description = "Some description")
  )
)

## with-description
el_steps(
  "st_desc",
  active = 1,
  steps = list(
    list(title = "Step 1", description = "Some description"),
    list(title = "Step 2", description = "Some description"),
    list(title = "Step 3", description = "Some description")
  )
)

## with-icon
el_steps(
  "st_icon",
  active = 1,
  steps = list(
    list(title = "Step 1", icon = "Edit"),
    list(title = "Step 2", icon = "Upload"),
    list(title = "Step 3", icon = "Picture")
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
      list(title = "Step 1"),
      list(title = "Step 2"),
      list(title = "Step 3")
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
      list(title = "Step 1", icon = "Edit"),
      list(title = "Step 2", icon = "UploadFilled"),
      list(title = "Step 3", icon = "Picture")
    )
  ),
  tags$div(style = "margin-top: 20px"),
  el_steps(
    "st_simple2",
    active = 0,
    finish_status = "success",
    simple = TRUE,
    steps = list(
      list(title = "Step 1"),
      list(title = "Step 2"),
      list(title = "Step 3")
    )
  )
)
