## complete
#' Back is `input$<id>_back`.
#| shot_expect = c("document.querySelectorAll('#ph_full .el-descriptions__cell').length >= 5", "document.querySelector('#ph_full .el-page-header__main')")
avatar <- "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png"
tags$div(
  `aria-label` = "A complete example of page header",
  el_page_header(
    "ph_full",
    slots = list(
      breadcrumb = el_breadcrumb(
        "ph_crumbs",
        separator = "/",
        items = list(
          list(label = "homepage", to = "./page-header.html"),
          list(label = "route 1"),
          list(label = "route 2")
        )
      ),
      content = tags$div(
        style = "display: flex; align-items: center",
        el_avatar(size = 32, src = avatar, style = "margin-right: 12px"),
        tags$span(
          style = "margin-right: 12px; font-size: 18px; font-weight: 600",
          "Title"
        ),
        tags$span(
          style = "margin-right: 8px; font-size: 14px; color: var(--el-text-color-regular)",
          "Sub title"
        ),
        el_tag(label = "Default")
      ),
      extra = tags$div(
        style = "display: flex; align-items: center; gap: 8px",
        el_button(label = "Print"),
        el_button(label = "Edit", type = "primary")
      ),
      default = tagList(
        tags$div(
          style = "margin-top: 16px",
          el_descriptions(
            column = 3,
            size = "small",
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
        ),
        tags$p(
          style = "margin-top: 16px; font-size: 14px",
          "Element Plus team uses ",
          tags$b("weekly"),
          " release strategy under normal circumstance, but critical bug",
          " fixes would require hotfix so the actual release number ",
          tags$b("could be"),
          " more than 1 per week."
        )
      )
    )
  )
)

## basic
el_page_header(
  "ph_basic",
  slots = list(content = tags$span(style = "font-weight: 600", "Title"))
)

## custom-icon
el_page_header(
  "ph_icon",
  icon = "ArrowLeft",
  slots = list(content = tags$span(style = "font-weight: 600", "Title"))
)

## no-icon
el_page_header(
  "ph_noicon",
  icon = "",
  slots = list(content = tags$span(style = "font-weight: 600", "Title"))
)

## breadcrumb
el_page_header(
  "ph_bc",
  slots = list(
    breadcrumb = el_breadcrumb(
      "ph_bc_crumbs",
      items = list(
        list(label = "homepage", to = "./page-header.html"),
        list(label = "route 1"),
        list(label = "route 2")
      )
    ),
    content = tags$span(style = "font-weight: 600", "Title")
  )
)

## additional-sections
el_page_header(
  "ph_extra",
  icon = "",
  slots = list(
    content = tags$div(
      style = "display: flex; align-items: center",
      el_avatar(
        size = 32,
        src = "https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png",
        style = "margin-right: 12px"
      ),
      tags$span(
        style = "margin-right: 12px; font-size: 18px; font-weight: 600",
        "Title"
      ),
      tags$span(
        style = "margin-right: 8px; font-size: 14px; color: var(--el-text-color-regular)",
        "Sub title"
      ),
      el_tag(label = "Default")
    ),
    extra = tags$div(
      style = "display: flex; align-items: center; gap: 8px",
      el_button(label = "Print"),
      el_button(label = "Edit", type = "primary")
    )
  )
)

## main-content
el_page_header(
  "ph_main",
  slots = list(
    content = tags$span(style = "font-weight: 600", "Title"),
    default = tags$div(
      style = "margin-top: 16px; font-size: 13px; font-weight: bold",
      "Your additional content can be added with default slot, You may put as many content as you want here."
    )
  )
)
