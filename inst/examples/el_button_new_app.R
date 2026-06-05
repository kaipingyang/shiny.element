devtools::load_all()
library(shiny)

icon_row <- function(...) {
  tags$div(style = "display:flex; gap:12px; align-items:center; flex-wrap:wrap; margin-bottom:8px;", ...)
}
note <- function(txt) tags$p(style = "color:#888; font-size:13px; margin:4px 0 8px;", txt)

ui <- el_page(
  tags$h2("el_button 展示", style = "margin-bottom:24px;"),

  # ── 1. type ──────────────────────────────────────────────────────────────
  tags$h4("1. type"),
  note("default / primary / success / warning / danger / info / text"),
  icon_row(
    el_button("t_def",  "Default",  type = "default"),
    el_button("t_pri",  "Primary",  type = "primary"),
    el_button("t_suc",  "Success",  type = "success"),
    el_button("t_war",  "Warning",  type = "warning"),
    el_button("t_dan",  "Danger",   type = "danger"),
    el_button("t_inf",  "Info",     type = "info"),
    el_button("t_txt",  "Text",     type = "text")
  ),
  tags$hr(),

  # ── 2. plain ─────────────────────────────────────────────────────────────
  tags$h4("2. plain（镂空）"),
  note("plain = TRUE"),
  icon_row(
    el_button("p_def",  "Default",  type = "default",  plain = TRUE),
    el_button("p_pri",  "Primary",  type = "primary",  plain = TRUE),
    el_button("p_suc",  "Success",  type = "success",  plain = TRUE),
    el_button("p_war",  "Warning",  type = "warning",  plain = TRUE),
    el_button("p_dan",  "Danger",   type = "danger",   plain = TRUE),
    el_button("p_inf",  "Info",     type = "info",     plain = TRUE)
  ),
  tags$hr(),

  # ── 3. round ─────────────────────────────────────────────────────────────
  tags$h4("3. round（圆角）"),
  note("round = TRUE"),
  icon_row(
    el_button("r_def",  "Default",  type = "default",  round = TRUE),
    el_button("r_pri",  "Primary",  type = "primary",  round = TRUE),
    el_button("r_suc",  "Success",  type = "success",  round = TRUE),
    el_button("r_war",  "Warning",  type = "warning",  round = TRUE),
    el_button("r_dan",  "Danger",   type = "danger",   round = TRUE),
    el_button("r_inf",  "Info",     type = "info",     round = TRUE)
  ),
  tags$hr(),

  # ── 4. circle ────────────────────────────────────────────────────────────
  tags$h4("4. circle（圆形图标按钮）"),
  note("circle = TRUE，label 被忽略，需配合 icon"),
  icon_row(
    el_button("c_def",  type = "default",  circle = TRUE, icon = el_icon("search")),
    el_button("c_pri",  type = "primary",  circle = TRUE, icon = el_icon("edit")),
    el_button("c_suc",  type = "success",  circle = TRUE, icon = el_icon("check")),
    el_button("c_war",  type = "warning",  circle = TRUE, icon = el_icon("warning-outline")),
    el_button("c_dan",  type = "danger",   circle = TRUE, icon = el_icon("delete")),
    el_button("c_inf",  type = "info",     circle = TRUE, icon = el_icon("info"))
  ),
  tags$hr(),

  # ── 5. size ──────────────────────────────────────────────────────────────
  tags$h4("5. size"),
  note("medium / small / mini（不传则为默认尺寸）"),
  icon_row(
    el_button("s_def",  "Default", type = "primary"),
    el_button("s_med",  "Medium",  type = "primary", size = "medium"),
    el_button("s_sml",  "Small",   type = "primary", size = "small"),
    el_button("s_min",  "Mini",    type = "primary", size = "mini")
  ),
  tags$hr(),

  # ── 6. loading ────────────────────────────────────────────────────────────
  tags$h4("6. loading（加载中，点击无效）"),
  note("初始 loading=TRUE；点 '停止加载' 关闭"),
  icon_row(
    el_button("btn_load", "加载中…", type = "primary", loading = TRUE),
    el_button("btn_stop_load", "停止加载", type = "default")
  ),
  tags$hr(),

  # ── 7. disabled ───────────────────────────────────────────────────────────
  tags$h4("7. disabled（禁用）"),
  note("点 '切换禁用' 动态切换"),
  icon_row(
    el_button("btn_dis",        "禁用按钮",  type = "primary", disabled = TRUE),
    el_button("btn_toggle_dis", "切换禁用",  type = "warning")
  ),
  tags$hr(),

  # ── 8. 图标按钮 ────────────────────────────────────────────────────────────
  tags$h4("8. 图标按钮（icon 参数）"),
  note("el_icon / fontawesome"),
  icon_row(
    el_button("i_search", "搜索",  type = "primary", icon = el_icon("search")),
    el_button("i_edit",   "编辑",  type = "success", icon = el_icon("edit")),
    el_button("i_del",    "删除",  type = "danger",  icon = el_icon("delete")),
    el_button("i_fa",     "GitHub", type = "info",
                  icon = el_icon("github", lib = "font-awesome"))
  ),
  tags$hr(),

  # ── 9. update_el_button ───────────────────────────────────────────────
  tags$h4("9. 服务端更新（update_el_button）"),
  note("点击下方按钮触发各种更新"),
  icon_row(
    el_button("target_btn", "原始按钮", type = "default")
  ),
  icon_row(
    el_button("upd_label",   "改 label",    type = "info",    size = "small"),
    el_button("upd_type",    "改 type",     type = "info",    size = "small"),
    el_button("upd_plain",   "切换 plain",  type = "info",    size = "small"),
    el_button("upd_round",   "切换 round",  type = "info",    size = "small"),
    el_button("upd_loading", "触发 loading",type = "warning", size = "small"),
    el_button("upd_reset",   "重置",        type = "danger",  size = "small")
  ),
  verbatimTextOutput("click_out"),
  tags$hr(),

  # ── 点击事件验证面板 ──────────────────────────────────────────────────────
  tags$h4("点击事件验证"),
  note("点击上方任意按钮，此处实时显示"),
  tags$div(
    style = "display:flex; gap:16px;",
    tags$div(
      style = "flex:1;",
      tags$strong("最后一次点击"),
      verbatimTextOutput("last_click")
    ),
    tags$div(
      style = "flex:2;",
      tags$strong("各按钮点击计数"),
      verbatimTextOutput("all_counts")
    )
  )
)

server <- function(input, output, session) {

  # ── 点击日志 ────────────────────────────────────────────────────────────
  log <- reactiveVal("（尚未点击）")

  record <- function(id, label) {
    observeEvent(input[[id]], {
      log(sprintf("[%s]  id=%-20s  第 %d 次",
        format(Sys.time(), "%H:%M:%S"), id, input[[id]]))
    }, ignoreInit = TRUE)
  }

  # 注册所有按钮的点击监听
  all_btns <- list(
    t_def="Default", t_pri="Primary", t_suc="Success",
    t_war="Warning", t_dan="Danger",  t_inf="Info", t_txt="Text",
    p_def="Plain/Default", p_pri="Plain/Primary", p_suc="Plain/Success",
    p_war="Plain/Warning", p_dan="Plain/Danger",  p_inf="Plain/Info",
    r_def="Round/Default", r_pri="Round/Primary", r_suc="Round/Success",
    r_war="Round/Warning", r_dan="Round/Danger",  r_inf="Round/Info",
    c_def="Circle/Default",c_pri="Circle/Primary",c_suc="Circle/Success",
    c_war="Circle/Warning",c_dan="Circle/Danger", c_inf="Circle/Info",
    s_def="Size/Default",  s_med="Size/Medium",   s_sml="Size/Small", s_min="Size/Mini",
    btn_stop_load="停止加载", btn_toggle_dis="切换禁用",
    i_search="搜索", i_edit="编辑", i_del="删除", i_fa="GitHub",
    target_btn="目标按钮",
    upd_label="改label", upd_type="改type", upd_plain="切换plain",
    upd_round="切换round", upd_loading="触发loading", upd_reset="重置"
  )
  for (id in names(all_btns)) record(id, all_btns[[id]])

  output$last_click  <- renderText(log())

  output$all_counts  <- renderText({
    ids <- names(all_btns)
    vals <- sapply(ids, function(i) if (is.null(input[[i]])) 0L else input[[i]])
    active <- vals[vals > 0]
    if (length(active) == 0) return("（尚未点击）")
    paste(sprintf("%-20s: %d", names(active), active), collapse = "\n")
  })

  # ── loading 切换 ────────────────────────────────────────────────────────
  observeEvent(input$btn_stop_load, {
    update_el_button(session, "btn_load", loading = FALSE, label = "加载完成")
  })

  # ── disabled 切换 ───────────────────────────────────────────────────────
  dis_state <- reactiveVal(TRUE)
  observeEvent(input$btn_toggle_dis, {
    new_state <- !dis_state()
    dis_state(new_state)
    update_el_button(session, "btn_dis",
      disabled = new_state,
      label    = if (new_state) "禁用按钮" else "可点击了"
    )
  })

  # ── 服务端更新演示 ──────────────────────────────────────────────────────
  observeEvent(input$upd_label,   update_el_button(session, "target_btn", label = "Label 已更新"))
  observeEvent(input$upd_type,    update_el_button(session, "target_btn", type  = "danger"))
  observeEvent(input$upd_plain,   update_el_button(session, "target_btn", plain = TRUE))
  observeEvent(input$upd_round,   update_el_button(session, "target_btn", round = TRUE))
  observeEvent(input$upd_loading, update_el_button(session, "target_btn", loading = TRUE, label = "Loading…"))
  observeEvent(input$upd_reset,   update_el_button(session, "target_btn",
    label = "原始按钮", type = "default", plain = FALSE, round = FALSE, loading = FALSE
  ))

  # ── 旧版 click_out ───────────────────────────────────────────────────────
  output$click_out <- renderText({
    ids <- c("target_btn", "i_search", "i_edit", "i_del", "i_fa")
    vals <- sapply(ids, function(i) if (is.null(input[[i]])) 0L else input[[i]])
    paste(paste0(ids, ": ", vals), collapse = "  |  ")
  })
}

shinyApp(ui, server)
