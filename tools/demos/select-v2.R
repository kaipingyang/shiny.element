## basic-usage
el_select_v2(
  "v2_basic",
  options = paste("Option", 1:1000),
  placeholder = "Please select",
  width = "240px"
)

## multiple
opts <- paste("Option", 1:1000)
tags$div(
  style = "display: grid; gap: 16px",
  el_select_v2(
    "v2_m1",
    options = opts,
    multiple = TRUE,
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_m2",
    options = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_m3",
    options = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    placeholder = "Please select",
    width = "240px"
  )
)

## size
opts <- paste("Option", 1:1000)
tags$div(
  style = "display: grid; gap: 16px",
  el_select_v2(
    "v2_l",
    options = opts,
    size = "large",
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_d",
    options = opts,
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_s",
    options = opts,
    size = "small",
    placeholder = "Please select",
    width = "240px"
  )
)

## hide-extra-tags
el_select_v2(
  "v2_hide",
  options = paste("Option", 1:1000),
  multiple = TRUE,
  collapse_tags = TRUE,
  max_collapse_tags = 3,
  placeholder = "Please select",
  width = "240px"
)

## filterable
el_select_v2(
  "v2_filter",
  options = paste("Option", 1:1000),
  filterable = TRUE,
  multiple = TRUE,
  placeholder = "Please select",
  width = "240px"
)

## disabled
tagList(
  el_select_v2(
    "v2_dis1",
    options = list(
      el_option("Option a", "a"),
      el_option("Option b", "b", disabled = TRUE)
    ),
    placeholder = "Please select",
    width = "240px"
  ),
  el_select_v2(
    "v2_dis2",
    options = c("a", "b"),
    disabled = TRUE,
    placeholder = "Please select",
    width = "240px"
  )
)

## grouping
el_select_v2(
  "v2_group",
  placeholder = "Please select",
  width = "240px",
  options = lapply(1:10, function(g) {
    list(
      label = paste("Group", g),
      options = lapply(1:10, function(i) {
        list(value = paste0(g, "-", i), label = paste("Option", g, i))
      })
    )
  })
)

## clearable
el_select_v2(
  "v2_clear",
  options = paste("Option", 1:1000),
  multiple = TRUE,
  clearable = TRUE,
  placeholder = "Please select",
  width = "240px"
)

## customized-option
el_select_v2(
  "v2_opt",
  options = paste("Option", 1:1000),
  placeholder = "Please select",
  width = "240px",
  slots = list(
    default = template(
      htmltools::HTML(
        "<div style=\"display: flex; justify-content: space-between\"><span>{{ item.label }}</span><span style=\"color: var(--el-text-color-secondary)\">{{ item.value }}</span></div>"
      ),
      scope = "{ item }"
    )
  )
)

## custom-header
el_select_v2(
  "v2_head",
  options = paste("Option", 1:100),
  multiple = TRUE,
  placeholder = "Please select",
  width = "240px",
  slots = list(header = "Header content")
)

## custom-footer
el_select_v2(
  "v2_foot",
  options = paste("Option", 1:100),
  placeholder = "Please select",
  width = "240px",
  slots = list(footer = "Footer content")
)

## allow-create
el_select_v2(
  "v2_create",
  options = c("HTML", "CSS", "JavaScript"),
  multiple = TRUE,
  filterable = TRUE,
  allow_create = TRUE,
  default_first_option = TRUE,
  placeholder = "Please select",
  width = "240px"
)

## remote-search
#' A `remote_method` of your own, a `JS()` function, fetches options in the
#' browser; for the server's options use `el_select(remote = TRUE)`.
el_select_v2(
  "v2_remote",
  filterable = TRUE,
  remote = TRUE,
  placeholder = "Please enter a keyword",
  width = "240px",
  remote_method = JS("function(q) {}")
)

## use-valueKey
el_select_v2(
  "v2_vkey",
  value_key = "id",
  placeholder = "Please select",
  width = "240px",
  options = list(
    el_option("Option a", list(id = 1, name = "a")),
    el_option("Option b", list(id = 2, name = "b"))
  )
)

## props
#' `props` names the fields each option carries.
el_select_v2(
  "v2_props",
  placeholder = "Please select",
  width = "240px",
  options = c("Option 1", "Option 2", "Option 3")
)

## custom-tag
#| shot_js = c("document.querySelector('#v2_tag .el-select__wrapper').click()", "document.querySelectorAll('.el-select-dropdown__item')[0].click()", "document.querySelectorAll('.el-select-dropdown__item')[3].click()")
#| shot_sel = ".el-select__popper"
#| shot_expect = "document.querySelectorAll('#v2_tag .el-select__selection .el-tag').length === 2"
colors <- c(
  red = "#E63415",
  orange = "#FF6600",
  yellow = "#FFDE0A",
  green = "#1EC79D",
  cyan = "#14CCCC",
  blue = "#4167F0",
  purple = "#6222C9"
)
el_select_v2(
  "v2_tag",
  options = colors,
  multiple = TRUE,
  placeholder = "Select",
  width = "240px",
  slots = list(
    default = template(
      slot = "default",
      scope = "{ item }",
      htmltools::HTML(paste0(
        "<div style=\"display: flex; align-items: center\">",
        "<el-tag :color=\"item.value\" :aria-label=\"item.label\" style=\"margin-right: 8px\" size=\"small\" />",
        "<span :style=\"{ color: item.value }\">{{ item.label }}</span></div>"
      ))
    ),
    tag = template(
      slot = "tag",
      htmltools::HTML(
        "<el-tag v-for=\"color in value\" :key=\"color\" :color=\"color\" :aria-label=\"color\" />"
      )
    )
  )
)

## custom-loading
el_select_v2(
  "v2_load",
  loading = TRUE,
  filterable = TRUE,
  remote = TRUE,
  placeholder = "Please enter a keyword",
  width = "240px",
  remote_method = JS("function(q) {}"),
  slots = list(loading = el_icon("Loading", class = "is-loading"))
)

## empty-values
el_select_v2(
  "v2_empty",
  options = c("Option1", "Option2"),
  clearable = TRUE,
  empty_values = list(NULL),
  value_on_clear = NULL,
  placeholder = "Please select",
  width = "240px"
)

## custom-label
#| shot_expect = "document.querySelector('#v2_label .el-select__placeholder').innerText.replace(/\\s+/g, ' ').trim() === 'Label1: Option1'"
options <- c(
  Label1 = "Option1",
  Label2 = "Option2",
  Label3 = "Option3",
  Label4 = "Option4",
  Label5 = "Option5"
)
label <- template(
  slot = "label",
  scope = "{ label, value }",
  htmltools::HTML(
    "<span>{{ label }}: </span><span style=\"font-weight: bold\">{{ value }}</span>"
  )
)
tags$div(
  style = "display: flex; flex-wrap: wrap; gap: 16px; align-items: center",
  el_select_v2(
    "v2_label",
    options = options,
    value = "Option1",
    placeholder = "Select",
    clearable = TRUE,
    width = "240px",
    slots = list(label = label)
  ),
  el_select_v2(
    "v2_label_multi",
    options = options,
    value = "Option1",
    multiple = TRUE,
    placeholder = "Select",
    clearable = TRUE,
    width = "240px",
    slots = list(label = label)
  )
)

## custom-width
el_select_v2(
  "v2_width",
  options = paste("A much longer option, number", 1:100),
  fit_input_width = FALSE,
  placeholder = "Please select",
  width = "240px"
)
