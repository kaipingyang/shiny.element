devtools::load_all()
library(shiny)

note <- function(txt) tags$p(style = "color:#888; font-size:13px; margin:2px 0 8px;", txt)

ui <- el_page(
  tags$h2("el_tabs + el_dialog 展示", style = "margin-bottom:24px;"),

  # ── 1. el_tabs ───────────────────────────────────────────────────────────
  tags$h4("1. el_tabs — 标签页切换"),
  note("type: '' / card / border-card；tab-position: top / right / bottom / left"),

  tags$h5("默认样式（tab-position=top）"),
  el_tabs("tabs_default",
    tabs = list(
      list(name = "news",    label = "新闻",    content = tags$p("这是新闻内容")),
      list(name = "message", label = "消息",    content = tags$p("这是消息内容")),
      list(name = "notice",  label = "通知",    content = tags$p("这是通知内容")),
      list(name = "setting", label = "设置（禁用）", disabled = TRUE,
           content = tags$p("此页被禁用"))
    ),
    selected = "news"
  ),
  tags$br(),

  tags$h5("card 样式"),
  el_tabs("tabs_card",
    tabs = list(
      list(name = "tab1", label = "标签一", content = tags$p("标签一内容")),
      list(name = "tab2", label = "标签二", content = tags$p("标签二内容")),
      list(name = "tab3", label = "标签三", content = tags$p("标签三内容"))
    ),
    type = "card"
  ),
  tags$br(),

  tags$h5("border-card 样式，tab-position=left"),
  el_tabs("tabs_left",
    tabs = list(
      list(name = "profile",  label = "个人资料",
           content = tags$div(tags$p("姓名：张三"), tags$p("邮箱：zhangsan@example.com"))),
      list(name = "account",  label = "账户设置",
           content = tags$div(tags$p("修改密码"), tags$p("绑定手机"))),
      list(name = "info",     label = "消息通知",
           content = tags$p("暂无消息"))
    ),
    type = "border-card",
    tab_position = "left"
  ),
  note("当前 active tab 通过 input$tabs_* 读取"),
  verbatimTextOutput("tabs_out"),
  tags$hr(),

  # ── 2. el_tabs 服务端更新 ────────────────────────────────────────────────
  tags$h4("2. 服务端切换 tab（update_el_tabs）"),
  el_tabs("tabs_ctrl",
    tabs = list(
      list(name = "step1", label = "第一步", content = tags$p("填写基本信息")),
      list(name = "step2", label = "第二步", content = tags$p("上传材料")),
      list(name = "step3", label = "第三步", content = tags$p("确认提交"))
    )
  ),
  tags$div(style = "margin-top:8px; display:flex; gap:8px;",
    el_button("goto_step1", "跳到第一步", type = "default", size = "small"),
    el_button("goto_step2", "跳到第二步", type = "primary", size = "small"),
    el_button("goto_step3", "跳到第三步", type = "success", size = "small")
  ),
  tags$hr(),

  # ── 3. el_dialog ─────────────────────────────────────────────────────────
  tags$h4("3. el_dialog — 模态对话框"),
  note("通过 update_el_dialog(session, id, visible=TRUE) 打开"),

  tags$div(style = "display:flex; gap:12px; flex-wrap:wrap;",
    # 基础对话框
    el_button("open_basic", "基础对话框", type = "primary"),
    # 带 footer 按钮的对话框
    el_button("open_footer", "带底部按钮", type = "success"),
    # 宽度自定义
    el_button("open_wide", "宽对话框 80%", type = "info"),
    # 居中
    el_button("open_center", "居中 + 全屏", type = "warning")
  ),

  # 基础
  el_dialog("dlg_basic",
    title   = "基础对话框",
    content = tags$p("这是对话框内容。点击关闭按钮或遮罩层可关闭。"),
    width   = "40%"
  ),

  # 带 footer
  el_dialog("dlg_footer",
    title   = "确认操作",
    content = tags$p("确定要执行此操作吗？此操作不可撤销。"),
    footer  = tagList(
      el_button("dlg_cancel", "取消", type = "default"),
      el_button("dlg_confirm", "确认", type = "danger")
    ),
    width = "40%",
    close_on_click_modal = FALSE
  ),

  # 宽
  el_dialog("dlg_wide",
    title   = "宽对话框",
    content = tags$div(
      tags$p("这是一个较宽的对话框。"),
      tags$p("适用于展示表格或图表内容。")
    ),
    width = "80%"
  ),

  # 居中
  el_dialog("dlg_center",
    title      = "居中对话框",
    content    = tags$p("标题和底部均居中显示。"),
    footer     = el_button("dlg_center_close", "关闭", type = "primary"),
    center     = TRUE,
    width      = "30%"
  ),

  note("input$dlg_*_visible: TRUE=打开，FALSE=关闭"),
  verbatimTextOutput("dlg_out")
)

server <- function(input, output, session) {
  # tabs 状态输出
  output$tabs_out <- renderText({
    paste0(
      "tabs_default: ", input$tabs_default, "\n",
      "tabs_card:    ", input$tabs_card,    "\n",
      "tabs_left:    ", input$tabs_left,    "\n",
      "tabs_ctrl:    ", input$tabs_ctrl
    )
  })

  # 服务端切换 tab
  observeEvent(input$goto_step1, update_el_tabs(session, "tabs_ctrl", selected = "step1"))
  observeEvent(input$goto_step2, update_el_tabs(session, "tabs_ctrl", selected = "step2"))
  observeEvent(input$goto_step3, update_el_tabs(session, "tabs_ctrl", selected = "step3"))

  # 打开对话框
  observeEvent(input$open_basic,  update_el_dialog(session, "dlg_basic",  visible = TRUE))
  observeEvent(input$open_footer, update_el_dialog(session, "dlg_footer", visible = TRUE))
  observeEvent(input$open_wide,   update_el_dialog(session, "dlg_wide",   visible = TRUE))
  observeEvent(input$open_center, update_el_dialog(session, "dlg_center", visible = TRUE))

  # 对话框内按钮
  observeEvent(input$dlg_cancel,       update_el_dialog(session, "dlg_footer", visible = FALSE))
  observeEvent(input$dlg_confirm,      update_el_dialog(session, "dlg_footer", visible = FALSE))
  observeEvent(input$dlg_center_close, update_el_dialog(session, "dlg_center", visible = FALSE))

  # dialog 状态输出
  output$dlg_out <- renderText({
    paste0(
      "dlg_basic_visible:  ", input$dlg_basic_visible,  "\n",
      "dlg_footer_visible: ", input$dlg_footer_visible, "\n",
      "dlg_confirm click:  ", input$dlg_confirm
    )
  })
}

shinyApp(ui, server)
