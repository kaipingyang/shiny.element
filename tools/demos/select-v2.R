## basic-usage
el_select_v2("v2_basic", options = paste("Option", 1:1000), placeholder = "Please select", width = "240px")

## multiple
opts <- paste("Option", 1:1000)
tags$div(style = "display: grid; gap: 16px",
  el_select_v2("v2_m1", options = opts, multiple = TRUE, placeholder = "Please select", width = "240px"),
  el_select_v2("v2_m2", options = opts, multiple = TRUE, collapse_tags = TRUE, placeholder = "Please select",
               width = "240px"),
  el_select_v2("v2_m3", options = opts, multiple = TRUE, collapse_tags = TRUE, collapse_tags_tooltip = TRUE,
               placeholder = "Please select", width = "240px"))

## size
opts <- paste("Option", 1:1000)
tags$div(style = "display: grid; gap: 16px",
  el_select_v2("v2_l", options = opts, size = "large", placeholder = "Please select", width = "240px"),
  el_select_v2("v2_d", options = opts, placeholder = "Please select", width = "240px"),
  el_select_v2("v2_s", options = opts, size = "small", placeholder = "Please select", width = "240px"))

## hide-extra-tags
el_select_v2("v2_hide", options = paste("Option", 1:1000), multiple = TRUE, collapse_tags = TRUE,
             max_collapse_tags = 3, placeholder = "Please select", width = "240px")

## filterable
el_select_v2("v2_filter", options = paste("Option", 1:1000), filterable = TRUE, multiple = TRUE,
             placeholder = "Please select", width = "240px")

## disabled
tagList(
  el_select_v2("v2_dis1", options = list(list(value = "a", label = "Option a"),
                                         list(value = "b", label = "Option b", disabled = TRUE)),
               placeholder = "Please select", width = "240px"),
  el_select_v2("v2_dis2", options = c("a", "b"), disabled = TRUE, placeholder = "Please select", width = "240px"))

## grouping
el_select_v2("v2_group", placeholder = "Please select", width = "240px", options = lapply(1:10, function(g)
  list(label = paste("Group", g), options = lapply(1:10, function(i)
    list(value = paste0(g, "-", i), label = paste("Option", g, i))))))

## clearable
el_select_v2("v2_clear", options = paste("Option", 1:1000), multiple = TRUE, clearable = TRUE,
             placeholder = "Please select", width = "240px")

## customized-option
el_select_v2("v2_opt", options = paste("Option", 1:1000), placeholder = "Please select", width = "240px",
  slots = list(default = template(htmltools::HTML(
    "<div style=\"display: flex; justify-content: space-between\"><span>{{ item.label }}</span><span style=\"color: var(--el-text-color-secondary)\">{{ item.value }}</span></div>"),
    scope = "{ item }")))

## custom-header
el_select_v2("v2_head", options = paste("Option", 1:100), multiple = TRUE, placeholder = "Please select",
             width = "240px", slots = list(header = "Header content"))

## custom-footer
el_select_v2("v2_foot", options = paste("Option", 1:100), placeholder = "Please select", width = "240px",
             slots = list(footer = "Footer content"))

## allow-create
el_select_v2("v2_create", options = c("HTML", "CSS", "JavaScript"), multiple = TRUE, filterable = TRUE,
             allow_create = TRUE, default_first_option = TRUE, placeholder = "Please select", width = "240px")

## remote-search
#' A `remote_method` of your own, a `JS()` function, fetches options in the
#' browser; for the server's options use `el_select(remote = TRUE)`.
el_select_v2("v2_remote", filterable = TRUE, remote = TRUE, placeholder = "Please enter a keyword",
             width = "240px", remote_method = JS("function(q) {}"))

## use-valueKey
el_select_v2("v2_vkey", value_key = "id", placeholder = "Please select", width = "240px",
             options = list(list(value = list(id = 1, name = "a"), label = "Option a"),
                            list(value = list(id = 2, name = "b"), label = "Option b")))

## props
#' `props` names the fields each option carries.
el_select_v2("v2_props", placeholder = "Please select", width = "240px",
             options = c("Option 1", "Option 2", "Option 3"))

## custom-tag
el_select_v2("v2_tag", options = c("Red" = "#ff0000", "Green" = "#00ff00"), value = c("#ff0000"),
             multiple = TRUE, placeholder = "Please select", width = "240px")

## custom-loading
el_select_v2("v2_load", loading = TRUE, filterable = TRUE, remote = TRUE, placeholder = "Please enter a keyword",
             width = "240px", remote_method = JS("function(q) {}"),
             slots = list(loading = el_icon("Loading", class = "is-loading")))

## empty-values
el_select_v2("v2_empty", options = c("Option1", "Option2"), clearable = TRUE, empty_values = list(NULL),
             value_on_clear = NULL, placeholder = "Please select", width = "240px")

## custom-label
el_select_v2("v2_label", options = c("Option1", "Option2"), value = "Option1", width = "240px",
             slots = list(label = template(htmltools::HTML("<span>{{ label }}: </span><b>{{ value }}</b>"),
                                           slot = "label", scope = "{ label, value }")))

## custom-width
el_select_v2("v2_width", options = paste("A much longer option, number", 1:100), fit_input_width = FALSE,
             placeholder = "Please select", width = "240px")
