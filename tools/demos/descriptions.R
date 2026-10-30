## basic-usage
el_descriptions(
  "desc",
  title = "User Info",
  items = list(
    el_descriptions_item("Username", "kooriookami"),
    el_descriptions_item("Telephone", "18100000000"),
    el_descriptions_item("Place", "Suzhou"),
    el_descriptions_item(
      "Remarks",
      el_tag(label = "School", size = "small")
    ),
    el_descriptions_item(
      "Address",
      "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
    )
  )
)

## sizes
#' The radios resize both lists: their `size` follows them in the browser,
#' [v_bind()].
#| shot_js = "document.querySelectorAll('#desc_size .el-radio')[0].click()"
#| shot_expect = c("document.querySelectorAll('.el-descriptions--large').length === 2", "document.querySelectorAll('.el-descriptions .el-tag').length === 2")
label <- function(icon, text) {
  tags$div(
    class = "cell-item",
    el_icon(icon, style = "margin-right: 6px"),
    text
  )
}
items <- function() {
  list(
    list(label = label("User", "Username"), content = "kooriookami"),
    list(label = label("Iphone", "Telephone"), content = "18100000000"),
    list(label = label("Location", "Place"), content = "Suzhou"),
    list(
      label = label("Tickets", "Remarks"),
      content = el_tag(label = "School", size = "small")
    ),
    list(
      label = label("OfficeBuilding", "Address"),
      content = "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
    )
  )
}
tags$style(
  ".el-descriptions { margin-top: 20px; }
   .cell-item { display: flex; align-items: center; }"
)
el_radio_group(
  "desc_size",
  choices = c(Large = "large", Default = "default", Small = "small"),
  selected = "default"
)
el_descriptions(
  "desc_border",
  title = "With border",
  column = 3,
  size = v_bind("$inputs.desc_size"),
  border = TRUE,
  items = items(),
  slots = list(extra = el_button("desc_op1", "Operation", type = "primary"))
)
el_descriptions(
  "desc_plain",
  title = "Without border",
  column = 3,
  size = v_bind("$inputs.desc_size"),
  items = items(),
  slots = list(extra = el_button("desc_op2", "Operation", type = "primary"))
)

## vertical-list
#' The radios resize both lists: their `size` follows them in the browser,
#' [v_bind()].
#| shot_js = "document.querySelectorAll('#desc_v_size .el-radio')[2].click()"
#| shot_expect = "document.querySelectorAll('.el-descriptions--small').length === 2"
items <- function() {
  list(
    el_descriptions_item("Username", "kooriookami"),
    el_descriptions_item("Telephone", "18100000000"),
    el_descriptions_item("Place", "Suzhou", span = 2),
    el_descriptions_item("Remarks", el_tag(label = "School", size = "small")),
    el_descriptions_item(
      "Address",
      "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
    )
  )
}
el_radio_group(
  "desc_v_size",
  choices = c(Large = "large", Default = "default", Small = "small"),
  selected = "default"
)
el_descriptions(
  "desc_v",
  title = "Vertical list with border",
  direction = "vertical",
  column = 4,
  size = v_bind("$inputs.desc_v_size"),
  border = TRUE,
  items = items()
)
tags$div(
  style = "margin-top: 28px",
  el_descriptions(
    "desc_v_plain",
    title = "Vertical list without border",
    direction = "vertical",
    column = 4,
    size = v_bind("$inputs.desc_v_size"),
    items = items()
  )
)

## rowspan
#| shot_expect = "document.querySelectorAll('.el-descriptions td[rowspan=\"2\"], .el-descriptions th[rowspan=\"2\"]').length >= 2"
items <- function() {
  list(
    el_descriptions_item(
      "Photo",
      el_image(
        src = "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png",
        style = "width: 100px; height: 100px"
      ),
      rowspan = 2,
      width = 140,
      align = "center"
    ),
    el_descriptions_item("Username", "kooriookami"),
    el_descriptions_item("Telephone", "18100000000"),
    el_descriptions_item("Place", "Suzhou"),
    el_descriptions_item("Remarks", el_tag(label = "School", size = "small")),
    el_descriptions_item(
      "Address",
      "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
    )
  )
}
tagList(
  el_descriptions(
    "desc_rs",
    title = "Width horizontal list",
    border = TRUE,
    items = items()
  ),
  tags$div(
    style = "margin-top: 20px",
    el_descriptions(
      "desc_rs_v",
      title = "Width vertical list",
      direction = "vertical",
      border = TRUE,
      items = items()
    )
  )
)

## customized-style
#| shot_expect = "document.querySelector('.my-label') && document.querySelector('.my-content')"
item <- function(label, content, ...) {
  el_descriptions_item(
    label,
    content,
    label_align = "right",
    align = "center",
    ...
  )
}
tagList(
  tags$style(
    ".my-label { background: var(--el-color-success-light-9) !important; }
     .my-content { background: var(--el-color-danger-light-9); }"
  ),
  el_descriptions(
    "desc_style",
    title = "Customized style list",
    column = 3,
    border = TRUE,
    items = list(
      item(
        "Username",
        "kooriookami",
        label_class_name = "my-label",
        class_name = "my-content",
        width = "150px"
      ),
      item("Telephone", "18100000000"),
      item("Place", "Suzhou"),
      item("Remarks", el_tag(label = "School", size = "small")),
      item(
        "Address",
        "No.1188, Wuzhong Avenue, Wuzhong District, Suzhou, Jiangsu Province"
      )
    )
  )
)
