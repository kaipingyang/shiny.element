## basic
days <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
tags$div(
  style = "display: grid; gap: 16px; justify-items: start",
  el_segmented("seg_l", options = days, value = "Mon", size = "large"),
  el_segmented("seg_d", options = days, value = "Mon"),
  el_segmented("seg_s", options = days, value = "Mon", size = "small")
)

## custom-direction
el_segmented(
  "seg_v",
  direction = "vertical",
  value = "Apple",
  options = c("Apple", "Cherry", "Grape", "Orange", "Pear")
)

## disabled
opts <- list(
  list(label = "Mon", value = "Mon"),
  list(label = "Tue", value = "Tue", disabled = TRUE),
  list(label = "Wed", value = "Wed")
)
tags$div(
  style = "display: grid; gap: 16px; justify-items: start",
  el_segmented("seg_dis1", options = opts, value = "Mon", disabled = TRUE),
  el_segmented("seg_dis2", options = opts, value = "Mon")
)

## props
#' Element Plus's `props` names the fields an option carries.
el_segmented(
  "seg_props",
  value = "Mon",
  options = c("Mon", "Tue", "Wed", "Thu", "Fri")
)

## block
el_segmented(
  "seg_block",
  block = TRUE,
  value = "Mon",
  options = c("Mon", "Tue", "Wednesday", "Thu", "Fri", "Saturday", "Sun")
)

## custom-content
el_segmented(
  "seg_icons",
  value = "Apple",
  options = list(
    list(label = "Apple", value = "Apple", icon = "Apple"),
    list(label = "Cherry", value = "Cherry", icon = "Cherry"),
    list(label = "Grape", value = "Grape", icon = "Grape")
  ),
  slots = list(
    default = template(
      htmltools::HTML(paste0(
        "<div style=\"display: flex; flex-direction: column; align-items: center; gap: 8px; padding: 8px\">",
        "<el-icon size=\"20\"><component :is=\"scope.item.icon\" /></el-icon><div>{{ scope.item.label }}</div></div>"
      )),
      scope = "scope"
    )
  )
)

## custom-style
tags$div(
  style = paste(
    "--el-segmented-item-selected-color: var(--el-text-color-primary);",
    "--el-segmented-item-selected-bg-color: #ffd100; --el-border-radius-base: 16px"
  ),
  el_segmented(
    "seg_style",
    value = "Mon",
    options = c("Mon", "Tue", "Wed", "Thu", "Fri")
  )
)
