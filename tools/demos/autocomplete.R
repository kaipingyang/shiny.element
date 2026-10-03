## autocomplete
restaurants <- c(
  "vue",
  "element",
  "cooking",
  "mint-ui",
  "vuex",
  "vue-router",
  "babel"
)
tags$div(
  style = "display: flex; gap: 40px",
  tags$div(
    tags$div(class = "demo-title", "list suggestions when activated"),
    el_autocomplete(
      "ac1",
      suggestions = restaurants,
      clearable = TRUE,
      placeholder = "Please Input",
      width = "240px"
    )
  ),
  tags$div(
    tags$div(class = "demo-title", "list suggestions on input"),
    el_autocomplete(
      "ac2",
      suggestions = restaurants,
      trigger_on_focus = FALSE,
      clearable = TRUE,
      placeholder = "Please Input",
      width = "240px"
    )
  )
)

## autocomplete-template
#' Each suggestion drawn with a template of its own: the scoped default slot.
el_autocomplete(
  "ac_tpl",
  placeholder = "Please input",
  popper_class = "my-autocomplete",
  suggestions = list(
    list(value = "vue", link = "https://github.com/vuejs/vue"),
    list(value = "element", link = "https://github.com/ElemeFE/element")
  ),
  slots = list(
    suffix = el_icon("Edit", class = "el-input__icon"),
    default = template(
      htmltools::HTML(
        '<div class="value">{{ item.value }}</div><span class="link">{{ item.link }}</span>'
      ),
      scope = "{ item }"
    )
  )
)

## remote-search
#' `remote = TRUE` asks the server: `input$<id>_query` is the text typed, and
#' `update_el_autocomplete(suggestions =)` answers it.
el_autocomplete("ac_remote", remote = TRUE, placeholder = "Please input")

## custom-loading
el_autocomplete(
  "ac_loading",
  remote = TRUE,
  placeholder = "Please input",
  slots = list(loading = el_icon("Loading", class = "is-loading"))
)

## custom-header-footer
tags$div(
  style = "display: flex; gap: 40px",
  el_autocomplete(
    "ac_header",
    suggestions = c("vue", "element", "cooking"),
    placeholder = "Please input",
    slots = list(header = "header content")
  ),
  el_autocomplete(
    "ac_footer",
    suggestions = c("vue", "element", "cooking"),
    placeholder = "Please input",
    slots = list(footer = "footer content")
  )
)
