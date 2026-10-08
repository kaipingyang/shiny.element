## basic-usage
opts <- c("Option1", "Option2", "Option3", "Option4", "Option5")
tags$div(
  style = "display: flex; gap: 16px",
  el_select(
    "sel_l",
    choices = opts,
    placeholder = "Select",
    size = "large",
    width = "240px"
  ),
  el_select("sel_d", choices = opts, placeholder = "Select", width = "240px"),
  el_select(
    "sel_s",
    choices = opts,
    placeholder = "Select",
    size = "small",
    width = "240px"
  )
)

## options
el_select(
  "sel_opts",
  placeholder = "Select",
  width = "240px",
  choices = list(
    el_option("Option 1", "Option1"),
    el_option("Option 2", "Option2"),
    el_option("Option 3", "Option3", disabled = TRUE)
  )
)

## disabled-option
el_select(
  "sel_dis_opt",
  placeholder = "Select",
  width = "240px",
  choices = list(
    el_option("Option1"),
    el_option("Option2", disabled = TRUE),
    el_option("Option3")
  )
)

## disabled
el_select(
  "sel_dis",
  choices = c("Option1", "Option2"),
  placeholder = "Select",
  disabled = TRUE,
  width = "240px"
)

## clearable
el_select(
  "sel_clear",
  choices = c("Option1", "Option2", "Option3"),
  selected = "Option1",
  clearable = TRUE,
  width = "240px"
)

## size
opts <- c("Option1", "Option2", "Option3")
tags$div(
  style = "display: grid; gap: 16px",
  el_select("sel_sz_l", choices = opts, size = "large", width = "240px"),
  el_select("sel_sz_d", choices = opts, width = "240px"),
  el_select("sel_sz_s", choices = opts, size = "small", width = "240px")
)

## multiple
opts <- c("Option1", "Option2", "Option3", "Option4", "Option5")
tags$div(
  style = "display: grid; gap: 16px",
  el_select(
    "sel_m1",
    choices = opts,
    multiple = TRUE,
    placeholder = "Select",
    width = "240px"
  ),
  el_select(
    "sel_m2",
    choices = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    placeholder = "Select",
    width = "240px"
  ),
  el_select(
    "sel_m3",
    choices = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    placeholder = "Select",
    width = "240px"
  ),
  el_select(
    "sel_m4",
    choices = opts,
    multiple = TRUE,
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    max_collapse_tags = 3,
    placeholder = "Select",
    width = "240px"
  )
)

## custom-template
el_select(
  "sel_tpl",
  placeholder = "Select",
  width = "240px",
  choices = list(
    list(value = "Beijing", label = "Beijing", code = "BJ"),
    list(value = "Shanghai", label = "Shanghai", code = "SH"),
    list(value = "Nanjing", label = "Nanjing", code = "NJ")
  ),
  option_template = tagList(
    tags$span(style = "float: left", "{{ opt.label }}"),
    tags$span(
      style = "float: right; color: var(--el-text-color-secondary); font-size: 13px",
      "{{ opt.code }}"
    )
  )
)

## custom-header
el_select(
  "sel_head",
  choices = c("Option1", "Option2", "Option3"),
  multiple = TRUE,
  clearable = TRUE,
  collapse_tags = TRUE,
  placeholder = "Select",
  width = "240px",
  slots = list(header = el_checkbox("sel_all", "All"))
)

## custom-footer
el_select(
  "sel_foot",
  choices = c("Option1", "Option2", "Option3"),
  placeholder = "Select",
  width = "240px",
  slots = list(
    footer = el_button("sel_add", "Add an option", text = TRUE, size = "small")
  )
)

## grouping
el_select(
  "sel_group",
  placeholder = "Select",
  width = "240px",
  choices = list(
    "Popular cities" = c(Shanghai = "Shanghai", Beijing = "Beijing"),
    "City name" = c(
      Chengdu = "Chengdu",
      Shenzhen = "Shenzhen",
      Guangzhou = "Guangzhou",
      Dalian = "Dalian"
    )
  )
)

## filterable
el_select(
  "sel_filter",
  choices = c("Option1", "Option2", "Option3", "Option4"),
  filterable = TRUE,
  placeholder = "Select",
  width = "240px"
)

## remote-search
#' The server does the search: `input$<id>_query` is the text typed, and
#' `update_el_select(choices =)` answers it.
el_select(
  "sel_remote",
  multiple = TRUE,
  filterable = TRUE,
  remote = TRUE,
  reserve_keyword = FALSE,
  placeholder = "Please enter a keyword",
  width = "240px"
)

## allow-create
el_select(
  "sel_create",
  choices = c("HTML", "CSS", "JavaScript"),
  multiple = TRUE,
  filterable = TRUE,
  allow_create = TRUE,
  default_first_option = TRUE,
  reserve_keyword = FALSE,
  placeholder = "Choose tags for your article",
  width = "240px"
)

## value-key
#' Values that are objects need `value_key`, the field that tells them apart.
el_select(
  "sel_vkey",
  value_key = "id",
  placeholder = "Select",
  width = "240px",
  choices = list(
    el_option("Option A", list(id = 1, name = "Option A")),
    el_option("Option B", list(id = 2, name = "Option B"))
  )
)

## custom-tag
el_select(
  "sel_tag",
  choices = c("Red" = "#ff0000", "Green" = "#00ff00", "Blue" = "#0000ff"),
  selected = c("#ff0000", "#00ff00"),
  multiple = TRUE,
  placeholder = "Select",
  width = "240px",
  # the tag slot's scope is `{ data, selectDisabled, deleteTag }`; `value`,
  # with none written, is the select's own value
  slots = list(
    tag = template(
      htmltools::HTML(
        "<el-tag v-for=\"color in value\" :key=\"color\" :color=\"color\" :aria-label=\"color\" />"
      ),
      slot = "tag"
    )
  )
)

## custom-loading
el_select(
  "sel_load",
  remote = TRUE,
  filterable = TRUE,
  loading = TRUE,
  placeholder = "Please enter a keyword",
  width = "240px",
  slots = list(loading = el_icon("Loading", class = "is-loading"))
)

## empty-values
el_select(
  "sel_empty",
  choices = c("Option1", "Option2"),
  clearable = TRUE,
  empty_values = list(NULL),
  value_on_clear = NULL,
  placeholder = "Select",
  width = "240px"
)

## custom-label
el_select(
  "sel_label",
  choices = c("Option1", "Option2", "Option3"),
  selected = "Option1",
  width = "240px",
  slots = list(
    label = template(
      htmltools::HTML(
        "<span>{{ label }}: </span><span style=\"font-weight: bold\">{{ value }}</span>"
      ),
      slot = "label",
      scope = "{ label, value }"
    )
  )
)
