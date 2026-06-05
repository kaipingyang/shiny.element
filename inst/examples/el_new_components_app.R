devtools::load_all()
library(shiny)

note <- function(txt) tags$p(style = "color:#888; font-size:13px; margin:2px 0 8px;", txt)

ui <- el_page(
  tags$h2("新组件展示", style = "margin-bottom:24px;"),

  # ── 1. el_alert ──────────────────────────────────────────────────────────────
  tags$h4("1. el_alert — 内联提示"),
  note("type: info / success / warning / error；可加 description + show_icon"),

  el_alert("al_info",    "这是一条 info 提示",   type = "info",    show_icon = TRUE, closable = TRUE),
  tags$br(),
  el_alert("al_success", "操作成功",              type = "success", show_icon = TRUE),
  tags$br(),
  el_alert("al_warning", "请注意检查输入",
    description = "某些字段尚未完整填写，请重新核对。",
    type = "warning", show_icon = TRUE),
  tags$br(),
  el_alert("al_error",   "操作失败",
    description = "服务器返回错误，请稍后重试。",
    type = "error",   show_icon = TRUE, effect = "dark"),
  note("input$al_info_closed: 关闭时触发"),
  verbatimTextOutput("alert_out"),
  tags$hr(),

  # ── 2. el_tag ────────────────────────────────────────────────────────────────
  tags$h4("2. el_tag — 标签"),
  note("支持 type / size / effect / closable；click → input$id；close → input$id_closed"),

  tags$div(style = "display:flex; gap:8px; flex-wrap:wrap; align-items:center;",
    el_tag("tag_default",  "Default"),
    el_tag("tag_success",  "Success",  type = "success"),
    el_tag("tag_info",     "Info",     type = "info"),
    el_tag("tag_warning",  "Warning",  type = "warning"),
    el_tag("tag_danger",   "Danger",   type = "danger"),
    el_tag("tag_dark",     "Dark",     effect = "dark"),
    el_tag("tag_plain",    "Plain",    effect = "plain"),
    el_tag("tag_close",    "可关闭",   closable = TRUE),
    el_tag("tag_mini",     "Mini",     size = "mini",  type = "success")
  ),
  note("input$tag_click / input$tag_close_closed"),
  verbatimTextOutput("tag_out"),
  tags$hr(),

  # ── 3. el_badge ──────────────────────────────────────────────────────────────
  tags$h4("3. el_badge — 角标"),
  note("value / max / is_dot / hidden"),

  tags$div(style = "display:flex; gap:24px; align-items:center; flex-wrap:wrap;",
    tags$div(
      tags$label("数字", style = "font-size:12px; display:block;"),
      el_badge(el_button("btn_badge1", "消息"), value = 5)
    ),
    tags$div(
      tags$label("超出 max", style = "font-size:12px; display:block;"),
      el_badge(el_button("btn_badge2", "提醒"), value = 200, max = 99)
    ),
    tags$div(
      tags$label("小红点", style = "font-size:12px; display:block;"),
      el_badge(el_button("btn_badge3", "更新"), is_dot = TRUE)
    ),
    tags$div(
      tags$label("hidden", style = "font-size:12px; display:block;"),
      el_badge(el_button("btn_badge4", "无角标"), value = 5, hidden = TRUE)
    )
  ),
  tags$hr(),

  # ── 4. el_divider ─────────────────────────────────────────────────────────
  tags$h4("4. el_divider — 分割线"),

  el_divider(),
  el_divider("Left Title",   content_position = "left"),
  el_divider("Center Title", content_position = "center"),
  el_divider("Right Title",  content_position = "right"),
  tags$p(
    "行内分隔",
    el_divider(direction = "vertical"),
    "Item A",
    el_divider(direction = "vertical"),
    "Item B"
  ),
  tags$hr(),

  # ── 5. el_card ────────────────────────────────────────────────────────────
  tags$h4("5. el_card — 卡片"),

  tags$div(style = "display:flex; gap:16px; flex-wrap:wrap;",
    el_card(
      tags$p("always shadow（默认）"),
      header = "卡片标题",
      shadow = "always"
    ),
    el_card(
      tags$p("hover 时出现阴影"),
      header = "Hover Shadow",
      shadow = "hover"
    ),
    el_card(
      tags$p("无阴影"),
      shadow = "never"
    )
  ),
  tags$hr(),

  # ── 6. el_link ────────────────────────────────────────────────────────────
  tags$h4("6. el_link — 文字链接"),

  tags$div(style = "display:flex; gap:12px; flex-wrap:wrap; align-items:center;",
    el_link("默认",       type = "default"),
    el_link("Primary",    type = "primary"),
    el_link("Success",    type = "success"),
    el_link("Warning",    type = "warning"),
    el_link("Danger",     type = "danger"),
    el_link("Info",       type = "info"),
    el_link("Disabled",   disabled = TRUE),
    el_link("带图标",     icon = "el-icon-edit",  type = "primary"),
    el_link("GitHub",     href = "https://github.com", type = "primary")
  ),
  tags$hr(),

  # ── 7. el_collapse ───────────────────────────────────────────────────────
  tags$h4("7. el_collapse — 折叠面板"),
  note("普通（多开）& accordion（单开）"),

  tags$h5("普通模式"),
  el_collapse("col_normal",
    items = list(
      list(name = "p1", title = "一致性 Consistency",
           content = tags$p("与现实生活一致：与现实生活的流程、逻辑保持一致，遵循用户习惯的语言和概念；")),
      list(name = "p2", title = "反馈 Feedback",
           content = tags$p("控制反馈：通过界面样式和交互动效让用户可以清晰的感知自己的操作；")),
      list(name = "p3", title = "效率 Efficiency",
           content = tags$p("简化流程：设计简洁直观的操作流程；")),
      list(name = "p4", title = "可控 Controllability", disabled = TRUE,
           content = tags$p("用户决策：根据场景可给予用户操作建议或安全提示，但不能代替用户进行决策；"))
    ),
    value = "p1"
  ),
  tags$br(),
  tags$h5("accordion 模式"),
  el_collapse("col_acc",
    items = list(
      list(name = "a1", title = "选项一", content = tags$p("内容一")),
      list(name = "a2", title = "选项二", content = tags$p("内容二")),
      list(name = "a3", title = "选项三", content = tags$p("内容三"))
    ),
    accordion = TRUE
  ),
  note("input$col_normal / input$col_acc"),
  verbatimTextOutput("collapse_out"),
  tags$hr(),

  # ── 8. el_rate ────────────────────────────────────────────────────────────
  tags$h4("8. el_rate — 评分"),

  tags$div(style = "display:flex; gap:32px; flex-wrap:wrap; align-items:flex-start;",
    tags$div(
      tags$label("普通评分", style = "font-size:13px;"), tags$br(),
      el_rate("rate1", value = 3)
    ),
    tags$div(
      tags$label("half-star", style = "font-size:13px;"), tags$br(),
      el_rate("rate2", allow_half = TRUE, value = 3.5)
    ),
    tags$div(
      tags$label("show_score", style = "font-size:13px;"), tags$br(),
      el_rate("rate3", show_score = TRUE, value = 4)
    ),
    tags$div(
      tags$label("show_text", style = "font-size:13px;"), tags$br(),
      el_rate("rate4", show_text = TRUE, value = 2)
    ),
    tags$div(
      tags$label("disabled", style = "font-size:13px;"), tags$br(),
      el_rate("rate5", disabled = TRUE, value = 3.7, allow_half = TRUE)
    )
  ),
  note("input$rate1 / input$rate2 等"),
  verbatimTextOutput("rate_out"),
  tags$hr(),

  # ── 9. el_input_number ────────────────────────────────────────────────────
  tags$h4("9. el_input_number — 计数器"),

  tags$div(style = "display:flex; gap:24px; flex-wrap:wrap; align-items:flex-end;",
    tags$div(
      tags$label("基础", style = "font-size:13px;"), tags$br(),
      el_input_number("num1", value = 1, min = 0, max = 10)
    ),
    tags$div(
      tags$label("step=5", style = "font-size:13px;"), tags$br(),
      el_input_number("num2", value = 0, min = 0, max = 100, step = 5)
    ),
    tags$div(
      tags$label("precision=2", style = "font-size:13px;"), tags$br(),
      el_input_number("num3", value = 1.0, step = 0.1, precision = 2)
    ),
    tags$div(
      tags$label("controls right", style = "font-size:13px;"), tags$br(),
      el_input_number("num4", value = 5, controls_position = "right")
    ),
    tags$div(
      tags$label("无 controls", style = "font-size:13px;"), tags$br(),
      el_input_number("num5", value = 3, controls = FALSE)
    )
  ),
  note("input$num1 / input$num2 等"),
  verbatimTextOutput("num_out"),
  tags$hr(),

  # ── 10. el_color_picker ───────────────────────────────────────────────────
  tags$h4("10. el_color_picker — 颜色选择器"),

  tags$div(style = "display:flex; gap:32px; flex-wrap:wrap; align-items:flex-start;",
    tags$div(
      tags$label("基础", style = "font-size:13px;"), tags$br(),
      el_color_picker("cp1", value = "#409EFF")
    ),
    tags$div(
      tags$label("带透明度", style = "font-size:13px;"), tags$br(),
      el_color_picker("cp2", value = "#409EFF", show_alpha = TRUE)
    ),
    tags$div(
      tags$label("预设色板", style = "font-size:13px;"), tags$br(),
      el_color_picker("cp3",
        predefine = c("#ff4500", "#ff8c00", "#ffd700",
                     "#90ee90", "#00ced1", "#1e90ff",
                     "#c71585", "#409EFF"))
    )
  ),
  note("input$cp1 / input$cp2 等"),
  verbatimTextOutput("color_out"),
  tags$hr(),

  # ── 11. el_drawer ─────────────────────────────────────────────────────────
  tags$h4("11. el_drawer — 抽屉"),
  note("方向: rtl(右) / ltr(左) / ttb(顶) / btt(底)；input$id_visible 追踪状态"),

  tags$div(style = "display:flex; gap:8px; flex-wrap:wrap;",
    el_button("open_rtl",  "右侧抽屉", type = "primary"),
    el_button("open_ltr",  "左侧抽屉", type = "success"),
    el_button("open_ttb",  "顶部抽屉", type = "warning"),
    el_button("open_btt",  "底部抽屉", type = "info")
  ),

  el_drawer("drw_rtl",
    title   = "右侧抽屉",
    content = tags$div(tags$p("这是右侧抽屉内容。"), tags$p("可放任意 UI 组件。")),
    direction = "rtl"
  ),
  el_drawer("drw_ltr",
    title   = "左侧抽屉",
    content = tags$p("左侧打开的抽屉。"),
    direction = "ltr"
  ),
  el_drawer("drw_ttb",
    title   = "顶部抽屉",
    content = tags$p("从顶部滑入的抽屉。"),
    direction = "ttb",
    size = "200px"
  ),
  el_drawer("drw_btt",
    title   = "底部抽屉",
    content = tags$p("从底部滑入的抽屉。"),
    direction = "btt",
    size = "30%"
  ),
  note("input$drw_rtl_visible 等"),
  verbatimTextOutput("drawer_out"),
  tags$hr(),

  # ── 12. el_dropdown ───────────────────────────────────────────────────────
  tags$h4("12. el_dropdown — 下拉菜单"),
  note("command 点击 → input$id；input$id_count 计数"),

  tags$div(style = "display:flex; gap:16px; flex-wrap:wrap; align-items:center;",
    el_dropdown("dd_hover", "Hover 触发",
      items = list(
        list(command = "action1", label = "黄金糕"),
        list(command = "action2", label = "狮子头"),
        list(command = "action3", label = "螺蛳粉"),
        list(command = "action4", label = "双皮奶",  divided = TRUE),
        list(command = "action5", label = "蚵仔煎",  disabled = TRUE)
      )
    ),

    el_dropdown("dd_click", "Click 触发",
      trigger = "click",
      items = list(
        list(command = "edit",   label = "编辑",   icon = "el-icon-edit"),
        list(command = "copy",   label = "复制",   icon = "el-icon-document"),
        list(command = "delete", label = "删除",   icon = "el-icon-delete",
             divided = TRUE)
      )
    )
  ),
  note("input$dd_hover / input$dd_click"),
  verbatimTextOutput("dropdown_out")
)

server <- function(input, output, session) {

  output$alert_out <- renderText({
    paste0("al_info closed: ", input$al_info_closed)
  })

  output$tag_out <- renderText({
    paste0(
      "tag_default click: ", input$tag_default, "\n",
      "tag_close closed:  ", input$tag_close_closed
    )
  })

  output$collapse_out <- renderText({
    paste0(
      "col_normal: ", paste(input$col_normal, collapse = ", "), "\n",
      "col_acc:    ", input$col_acc
    )
  })

  output$rate_out <- renderText({
    paste0(
      "rate1: ", input$rate1, "  ",
      "rate2: ", input$rate2, "  ",
      "rate3: ", input$rate3
    )
  })

  output$num_out <- renderText({
    paste0(
      "num1: ", input$num1, "  ",
      "num2: ", input$num2, "  ",
      "num3: ", input$num3
    )
  })

  output$color_out <- renderText({
    paste0(
      "cp1: ", input$cp1, "\n",
      "cp2: ", input$cp2, "\n",
      "cp3: ", input$cp3
    )
  })

  observeEvent(input$open_rtl, update_el_drawer(session, "drw_rtl", visible = TRUE))
  observeEvent(input$open_ltr, update_el_drawer(session, "drw_ltr", visible = TRUE))
  observeEvent(input$open_ttb, update_el_drawer(session, "drw_ttb", visible = TRUE))
  observeEvent(input$open_btt, update_el_drawer(session, "drw_btt", visible = TRUE))

  output$drawer_out <- renderText({
    paste0("drw_rtl_visible: ", input$drw_rtl_visible)
  })

  output$dropdown_out <- renderText({
    paste0(
      "dd_hover:  ", input$dd_hover,  "\n",
      "dd_click:  ", input$dd_click,  "\n",
      "dd_hover_count: ", input$dd_hover_count
    )
  })
}

shinyApp(ui, server)
