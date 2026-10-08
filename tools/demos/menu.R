## basic
#| shot_expect = "document.querySelectorAll('#top_menu .el-menu > .el-menu-item').length === 3"
workspace <- function() {
  el_sub_menu(
    "Workspace",
    "2",
    el_menu_item("item one", "2-1"),
    el_menu_item("item two", "2-2"),
    el_menu_item("item three", "2-3"),
    el_sub_menu(
      "item four",
      "2-4",
      el_menu_item("item one", "2-4-1"),
      el_menu_item("item two", "2-4-2"),
      el_menu_item("item three", "2-4-3")
    )
  )
}
items <- list(
  el_menu_item("Processing Center", "1"),
  workspace(),
  el_menu_item("Info", "3", disabled = TRUE),
  el_menu_item("Orders", "4")
)
tagList(
  el_menu(
    "top_menu",
    active = "1",
    class = "el-menu-demo",
    mode = "horizontal",
    items = items
  ),
  tags$div(style = "height: 24px"),
  el_menu(
    "top_menu_dark",
    active = "1",
    class = "el-menu-demo",
    mode = "horizontal",
    background_color = "#545c64",
    text_color = "#fff",
    active_text_color = "#ffd04b",
    items = items
  )
)

## left-and-right
#' The first item is pushed to the left by its own `margin-right: auto`.
tagList(
  tags$style(
    ".el-menu--horizontal > .el-menu-item:nth-child(1) { margin-right: auto; }"
  ),
  el_menu(
    "lr_menu",
    active = "1",
    class = "el-menu-demo",
    mode = "horizontal",
    ellipsis = FALSE,
    items = list(
      el_menu_item(
        tags$img(
          style = "width: 100px",
          src = "https://element-plus.org/images/element-plus-logo.svg",
          alt = "Element logo"
        ),
        "0"
      ),
      el_menu_item("Processing Center", "1"),
      el_sub_menu(
        "Workspace",
        "2",
        el_menu_item("item one", "2-1"),
        el_menu_item("item two", "2-2"),
        el_menu_item("item three", "2-3"),
        el_sub_menu(
          "item four",
          "2-4",
          el_menu_item("item one", "2-4-1"),
          el_menu_item("item two", "2-4-2"),
          el_menu_item("item three", "2-4-3")
        )
      )
    )
  )
)

## vertical
#| shot_js = "document.querySelector('#v_menu .el-sub-menu__title').click()"
#| shot_expect = "document.querySelector('#v_menu .el-sub-menu').classList.contains('is-opened')"
items <- list(
  el_sub_menu(
    "Navigator One",
    "1",
    el_menu_item_group(
      "Group One",
      el_menu_item("item one", "1-1"),
      el_menu_item("item two", "1-2")
    ),
    el_menu_item_group("Group Two", el_menu_item("item three", "1-3")),
    el_sub_menu("item four", "1-4", el_menu_item("item one", "1-4-1")),
    icon = "Location"
  ),
  el_menu_item("Navigator Two", "2", icon = "Menu"),
  el_menu_item("Navigator Three", "3", icon = "Document", disabled = TRUE),
  el_menu_item("Navigator Four", "4", icon = "Setting")
)
el_row(
  class = "tac",
  el_col(
    span = 12,
    tags$h5(style = "margin-bottom: 8px", "Default colors"),
    el_menu(
      "v_menu",
      active = "2",
      class = "el-menu-vertical-demo",
      items = items
    )
  ),
  el_col(
    span = 12,
    tags$h5(style = "margin-bottom: 8px", "Custom colors"),
    el_menu(
      "v_menu_dark",
      active = "2",
      class = "el-menu-vertical-demo",
      items = items,
      background_color = "#545c64",
      text_color = "#fff",
      active_text_color = "#ffd04b"
    )
  )
)

## collapse
#' The radio buttons fold the menu with `update_el_menu(collapse =)`.
#| shot_js = "document.querySelectorAll('#menu_fold .el-radio-button')[0].click()"
#| shot_wait = 2
#| shot_expect = "!document.querySelector('#col_menu .el-menu').classList.contains('el-menu--collapse')"
ui <- el_page(
  tags$style(
    ".el-menu-vertical-demo:not(.el-menu--collapse) { width: 200px;
       min-height: 400px; }"
  ),
  tags$div(
    style = "margin-bottom: 20px",
    el_radio_group(
      "menu_fold",
      choices = c(expand = "expand", collapse = "collapse"),
      selected = "collapse",
      button = TRUE
    )
  ),
  el_menu(
    "col_menu",
    active = "2",
    class = "el-menu-vertical-demo",
    collapse = TRUE,
    items = list(
      el_sub_menu(
        "Navigator One",
        "1",
        el_menu_item_group(
          "Group One",
          el_menu_item("item one", "1-1"),
          el_menu_item("item two", "1-2")
        ),
        el_menu_item_group("Group Two", el_menu_item("item three", "1-3")),
        el_sub_menu("item four", "1-4", el_menu_item("item one", "1-4-1")),
        icon = "Location"
      ),
      el_menu_item("Navigator Two", "2", icon = "Menu"),
      el_menu_item("Navigator Three", "3", icon = "Document", disabled = TRUE),
      el_menu_item("Navigator Four", "4", icon = "Setting")
    )
  )
)
server <- function(input, output, session) {
  observeEvent(input$menu_fold, ignoreInit = TRUE, {
    update_el_menu(
      session,
      "col_menu",
      collapse = input$menu_fold == "collapse"
    )
  })
}
shinyApp(ui, server)

## popper-offset
el_menu(
  "off_menu",
  class = "el-menu-popper-demo",
  mode = "horizontal",
  ellipsis = TRUE,
  popper_offset = 16,
  style = "max-width: 600px",
  items = list(
    el_menu_item("Processing Center", "1"),
    el_sub_menu(
      "Workspace",
      "2",
      el_menu_item("item one", "2-1"),
      el_menu_item("item two", "2-2"),
      el_menu_item("item three", "2-3"),
      el_sub_menu(
        "item four",
        "2-4",
        el_menu_item("item one", "2-4-1"),
        el_menu_item("item two", "2-4-2"),
        el_menu_item("item three", "2-4-3")
      )
    ),
    el_sub_menu(
      "Override Popper Offset",
      "3",
      el_menu_item("item one", "3-1"),
      el_menu_item("item two", "3-2"),
      el_menu_item("item three", "3-3"),
      el_sub_menu(
        "override child",
        "3-4",
        el_menu_item("item one", "3-4-1"),
        el_menu_item("item two", "3-4-2"),
        el_menu_item("item three", "3-4-3"),
        popper_offset = 20
      ),
      popper_offset = 8
    ),
    el_menu_item("Info", "4", disabled = TRUE),
    el_menu_item("Orders", "5")
  )
)
