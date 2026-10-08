## basic
tree <- list(
  list(
    value = "guide",
    label = "Guide",
    children = list(
      list(
        value = "disciplines",
        label = "Disciplines",
        children = list(
          list(value = "consistency", label = "Consistency"),
          list(value = "feedback", label = "Feedback")
        )
      ),
      list(
        value = "navigation",
        label = "Navigation",
        children = list(
          list(value = "side", label = "Side Navigation"),
          list(value = "top", label = "Top Navigation")
        )
      )
    )
  ),
  list(
    value = "component",
    label = "Component",
    children = list(
      list(
        value = "basic",
        label = "Basic",
        children = list(
          list(value = "layout", label = "Layout"),
          list(value = "color", label = "Color")
        )
      )
    )
  )
)
tagList(
  tags$p("Child options expand when clicked (default)"),
  el_cascader("cas_click", options = tree),
  tags$p("Child options expand when hovered"),
  el_cascader(
    "cas_hover",
    options = tree,
    props = list(expandTrigger = "hover")
  )
)

## option-disabling
el_cascader(
  "cas_dis",
  options = list(
    list(
      value = "guide",
      label = "Guide",
      disabled = TRUE,
      children = list(
        list(value = "disciplines", label = "Disciplines")
      )
    ),
    list(
      value = "component",
      label = "Component",
      children = list(
        list(value = "basic", label = "Basic")
      )
    )
  )
)

## clearable
el_cascader(
  "cas_clear",
  clearable = TRUE,
  options = list(
    list(
      value = "guide",
      label = "Guide",
      children = list(
        list(value = "disciplines", label = "Disciplines")
      )
    )
  )
)

## clear-icon
el_cascader(
  "cas_clear_icon",
  clearable = TRUE,
  clear_icon = "CloseBold",
  placeholder = "Custom clear icon",
  options = list(
    list(
      value = "guide",
      label = "Guide",
      children = list(
        list(value = "disciplines", label = "Disciplines")
      )
    )
  )
)

## last-level
el_cascader(
  "cas_last",
  show_all_levels = FALSE,
  options = list(
    list(
      value = "guide",
      label = "Guide",
      children = list(
        list(
          value = "disciplines",
          label = "Disciplines",
          children = list(
            list(value = "consistency", label = "Consistency")
          )
        )
      )
    )
  )
)

## multiple-selection
world <- list(list(
  value = 1,
  label = "Asia",
  children = list(
    list(
      value = 2,
      label = "China",
      children = list(
        list(value = 3, label = "Beijing"),
        list(value = 4, label = "Shanghai"),
        list(value = 5, label = "Hangzhou")
      )
    ),
    list(
      value = 6,
      label = "Japan",
      children = list(
        list(value = 7, label = "Tokyo"),
        list(value = 8, label = "Osaka")
      )
    )
  )
))
tagList(
  tags$p("Display all tags (default)"),
  el_cascader(
    "cas_m1",
    options = world,
    props = list(multiple = TRUE),
    clearable = TRUE
  ),
  tags$p("Collapse tags"),
  el_cascader(
    "cas_m2",
    options = world,
    props = list(multiple = TRUE),
    collapse_tags = TRUE,
    clearable = TRUE
  ),
  tags$p("Collapse tags tooltip"),
  el_cascader(
    "cas_m3",
    options = world,
    props = list(multiple = TRUE),
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    clearable = TRUE
  ),
  tags$p("Max Collapse Tags"),
  el_cascader(
    "cas_m4",
    options = world,
    props = list(multiple = TRUE),
    collapse_tags = TRUE,
    collapse_tags_tooltip = TRUE,
    max_collapse_tags = 3,
    clearable = TRUE
  )
)

## any-level
tree <- list(list(
  value = "guide",
  label = "Guide",
  children = list(
    list(
      value = "disciplines",
      label = "Disciplines",
      children = list(
        list(value = "consistency", label = "Consistency")
      )
    )
  )
))
tagList(
  tags$p("Select any level of options (Single selection)"),
  el_cascader(
    "cas_any1",
    options = tree,
    props = list(checkStrictly = TRUE),
    clearable = TRUE
  ),
  tags$p("Select any level of options (Multiple selection)"),
  el_cascader(
    "cas_any2",
    options = tree,
    props = list(multiple = TRUE, checkStrictly = TRUE),
    clearable = TRUE
  )
)

## dynamic-loading
#' The server answers each level: `input$<id>_lazy_load` asks, and
#' `el_load_children()` replies -- see the Shiny integration guide.
el_cascader("cas_lazy", props = list(lazy = TRUE))

## filterable
tree <- list(list(
  value = "guide",
  label = "Guide",
  children = list(
    list(value = "disciplines", label = "Disciplines"),
    list(value = "navigation", label = "Navigation")
  )
))
tagList(
  tags$p("Filterable (Single selection)"),
  el_cascader(
    "cas_f1",
    options = tree,
    filterable = TRUE,
    placeholder = "Try searching: Guide"
  ),
  tags$p("Filterable (Multiple selection)"),
  el_cascader(
    "cas_f2",
    options = tree,
    filterable = TRUE,
    props = list(multiple = TRUE),
    placeholder = "Try searching: Guide"
  )
)

## custom-content
el_cascader(
  "cas_content",
  options = list(
    list(
      value = "guide",
      label = "Guide",
      children = list(
        list(value = "disciplines", label = "Disciplines"),
        list(value = "navigation", label = "Navigation")
      )
    )
  ),
  slots = list(
    default = template(
      htmltools::HTML(paste0(
        "<span>{{ data.label }}</span>",
        "<span v-if=\"!node.isLeaf\"> ({{ data.children.length }}) </span>"
      )),
      scope = "{ node, data }"
    )
  )
)

## custom-suggestion-item
el_cascader(
  "cas_sugg",
  filterable = TRUE,
  placeholder = "Try searching: Guide",
  options = list(
    list(
      value = "guide",
      label = "Guide",
      children = list(
        list(value = "disciplines", label = "Disciplines")
      )
    )
  ),
  slots = list(
    `suggestion-item` = template(
      htmltools::HTML(
        "<span>\U0001F50D {{ item.pathLabels.join(' > ') }}</span>"
      ),
      slot = "suggestion-item",
      scope = "{ item }"
    )
  )
)

## panel
el_cascader_panel(
  "cas_panel",
  options = list(
    list(
      value = "guide",
      label = "Guide",
      children = list(
        list(value = "disciplines", label = "Disciplines"),
        list(value = "navigation", label = "Navigation")
      )
    ),
    list(
      value = "component",
      label = "Component",
      children = list(
        list(value = "basic", label = "Basic")
      )
    )
  )
)

## custom-tag
world <- list(list(
  value = 1,
  label = "Asia",
  children = list(
    list(value = 2, label = "China"),
    list(value = 3, label = "Japan")
  )
))
el_cascader(
  "cas_tag",
  options = world,
  props = list(multiple = TRUE),
  clearable = TRUE,
  slots = list(
    tag = template(
      htmltools::HTML(
        "<el-tag v-for=\"(item, index) in data\" :key=\"item.key\" :color=\"index % 2 === 0 ? '#FFDE0A' : ''\">{{ item.text }}</el-tag>"
      ),
      slot = "tag",
      scope = "{ data }"
    )
  )
)

## show-checked-strategy
world <- list(list(
  value = 1,
  label = "Asia",
  children = list(
    list(
      value = 2,
      label = "China",
      children = list(
        list(value = 3, label = "Beijing"),
        list(value = 4, label = "Shanghai")
      )
    )
  )
))
tagList(
  tags$p("Strategy: child (default, show all selected child nodes)"),
  el_cascader(
    "cas_s1",
    options = world,
    props = list(multiple = TRUE),
    show_checked_strategy = "child",
    clearable = TRUE
  ),
  tags$p(
    "Strategy: parent (show only parent nodes when all children are selected)"
  ),
  el_cascader(
    "cas_s2",
    options = world,
    props = list(multiple = TRUE),
    show_checked_strategy = "parent",
    clearable = TRUE
  )
)

## check-on-click-node
#| shot_js = c("document.querySelector('#show_prefix .el-switch').click()", "document.querySelector('#cas_c1 .el-input__inner').click()")
#| shot_sel = ".el-cascader__dropdown"
#| shot_expect = c("document.querySelector('.el-cascader__dropdown .el-cascader-node')", "!document.querySelector('.el-cascader__dropdown .el-cascader-node .el-radio')")
#' The switch shows or hides each node's prefix -- its radio or checkbox --
#' with `update_el_cascader(props =)`.
tree <- list(list(
  value = "guide",
  label = "Guide",
  children = list(
    list(
      value = "disciplines",
      label = "Disciplines",
      children = list(list(value = "consistency", label = "Consistency"))
    ),
    list(
      value = "navigation",
      label = "Navigation",
      children = list(list(value = "side nav", label = "Side Navigation"))
    )
  )
))
strict <- function(prefix) {
  list(showPrefix = prefix, checkStrictly = TRUE, checkOnClickNode = TRUE)
}
multiple <- function(prefix) {
  list(showPrefix = prefix, multiple = TRUE, checkOnClickNode = TRUE)
}
ui <- el_page(
  el_switch(
    "show_prefix",
    value = TRUE,
    active_text = "show prefix",
    inactive_text = "hide prefix"
  ),
  tags$p("checkStrictly | Single mode"),
  el_cascader(
    "cas_c1",
    options = tree,
    clearable = TRUE,
    props = strict(TRUE)
  ),
  tags$p("Multiple mode"),
  el_cascader(
    "cas_c2",
    options = tree,
    clearable = TRUE,
    show_checked_strategy = "parent",
    props = multiple(TRUE)
  )
)
server <- function(input, output, session) {
  observeEvent(input$show_prefix, ignoreInit = TRUE, {
    update_el_cascader(session, "cas_c1", props = strict(input$show_prefix))
    update_el_cascader(session, "cas_c2", props = multiple(input$show_prefix))
  })
}
shinyApp(ui, server)

## custom-header-footer
tree <- list(list(
  value = "guide",
  label = "Guide",
  children = list(
    list(value = "disciplines", label = "Disciplines")
  )
))
tagList(
  tags$p("Custom header content"),
  el_cascader(
    "cas_h",
    options = tree,
    props = list(multiple = TRUE),
    clearable = TRUE,
    slots = list(header = "All")
  ),
  tags$p("Custom footer content"),
  el_cascader(
    "cas_ft",
    options = tree,
    clearable = TRUE,
    slots = list(footer = "Footer content")
  )
)

## virtual-scroll
big <- lapply(1:100, function(i) {
  list(
    value = paste0("v", i),
    label = paste("Option", i),
    children = lapply(1:100, function(j) {
      list(value = paste0("v", i, "-", j), label = paste("Option", i, j))
    })
  )
})
el_cascader(
  "cas_virtual",
  options = big,
  filterable = TRUE,
  virtual_scroll = TRUE,
  clearable = TRUE,
  placeholder = "Select with large data"
)

## fit-input-width
el_cascader(
  "cas_fit",
  fit_input_width = TRUE,
  options = list(
    list(
      value = "guide",
      label = "Guide",
      children = list(
        list(value = "disciplines", label = "Disciplines")
      )
    )
  )
)
