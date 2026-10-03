## basic
el_input_tag(
  "tags",
  placeholder = "Please input",
  aria_label = "Please click the Enter key after input"
)

## trigger
el_input_tag(
  "tags_space",
  trigger = "Space",
  placeholder = "Please input",
  aria_label = "Please click the Space key after input"
)

## max
el_input_tag("tags_max", max = 3, placeholder = "Please input")

## collapse
tags$div(
  style = "display: grid; gap: 16px",
  el_input_tag(
    "tags_col1",
    value = c("tag1", "tag2", "tag3"),
    collapse_tags = TRUE
  ),
  el_input_tag(
    "tags_col2",
    value = c("tag1", "tag2", "tag3"),
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE
  ),
  el_input_tag(
    "tags_col3",
    value = c("tag1", "tag2", "tag3", "tag4"),
    collapse_tags = TRUE,
    max_collapse_tags = 2
  )
)

## disabled
el_input_tag("tags_dis", value = c("tag1", "tag2"), disabled = TRUE)

## clearable
el_input_tag("tags_clear", value = c("tag1", "tag2"), clearable = TRUE)

## clear-icon
el_input_tag(
  "tags_clear_icon",
  value = c("tag1", "tag2"),
  clearable = TRUE,
  clear_icon = "CloseBold"
)

## draggable
el_input_tag("tags_drag", value = c("tag1", "tag2", "tag3"), draggable = TRUE)

## delimiter
el_input_tag(
  "tags_delim",
  delimiter = ",",
  placeholder = "Please input",
  aria_label = "Please input a comma after input"
)

## size
tags$div(
  style = "display: grid; gap: 16px",
  el_input_tag("tags_l", size = "large", placeholder = "Please input"),
  el_input_tag("tags_d", placeholder = "Please input"),
  el_input_tag("tags_s", size = "small", placeholder = "Please input")
)

## tag
el_input_tag(
  "tags_tpl",
  value = c("tag1", "tag2"),
  tag_type = "primary",
  tag_effect = "plain",
  slots = list(
    tag = template(
      htmltools::HTML(
        "<div class=\"flex items-center\"><el-icon><ElementPlus /></el-icon><span>{{ value }}</span></div>"
      ),
      slot = "tag",
      scope = "{ value }"
    )
  )
)

## prefix-suffix
el_input_tag(
  "tags_ps",
  placeholder = "Please input",
  slots = list(prefix = el_icon("CollectionTag"), suffix = el_icon("Search"))
)
