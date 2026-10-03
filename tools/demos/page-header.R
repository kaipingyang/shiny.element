## complete
#' Back is `input$<id>_back`.
el_page_header("ph_full", slots = list(
  breadcrumb = el_breadcrumb("ph_crumbs", items = list(list(label = "homepage", to = "./page-header.html"),
    list(label = "route 1"), list(label = "route 2"))),
  content = tags$div(style = "display: flex; align-items: center",
    el_avatar(size = 32, src = "https://avatars.githubusercontent.com/u/72015883?v=4"),
    tags$span(style = "margin: 0 12px; font-weight: 600", "Title"),
    tags$span(style = "margin-right: 12px; font-size: 13px", "Sub title"),
    el_tag("ph_tag", "Default")),
  extra = tags$div(el_button("ph_print", "Print"), el_button("ph_edit", "Edit", type = "primary"))))

## basic
el_page_header("ph_basic", slots = list(content = tags$span(style = "font-weight: 600", "Title")))

## custom-icon
el_page_header("ph_icon", icon = "ArrowLeft",
               slots = list(content = tags$span(style = "font-weight: 600", "Title")))

## no-icon
el_page_header("ph_noicon", icon = "", slots = list(content = tags$span(style = "font-weight: 600", "Title")))

## breadcrumb
el_page_header("ph_bc", slots = list(
  breadcrumb = el_breadcrumb("ph_bc_crumbs", items = list(
    list(label = "homepage", to = "./page-header.html"), list(label = "route 1"), list(label = "route 2"))),
  content = tags$span(style = "font-weight: 600", "Title")))

## additional-sections
el_page_header("ph_extra", icon = "", slots = list(
  content = tags$div(style = "display: flex; align-items: center",
    el_avatar(size = 32, content = "T"), tags$span(style = "margin-left: 12px; font-weight: 600", "Title")),
  extra = tags$div(el_button("ph_x1", "Print"), el_button("ph_x2", "Edit", type = "primary"))))

## main-content
el_page_header("ph_main", slots = list(
  content = tags$span(style = "font-weight: 600", "Title"),
  default = tags$div(style = "margin-top: 16px; font-size: 13px; font-weight: bold",
    "Your additional content can be added with default slot, You may put as many content as you want here.")))
