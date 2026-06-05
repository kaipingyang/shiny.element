devtools::load_all()
library(shiny)

note <- function(txt) tags$p(style = "color:#888; font-size:13px; margin:2px 0 8px;", txt)

# 生成模拟数据
make_data <- function(page, size) {
  start <- (page - 1) * size + 1
  end   <- min(start + size - 1, 100)
  lapply(start:end, function(i) list(id = i, name = paste0("用户", i),
    status = sample(c("active", "inactive"), 1),
    score  = round(runif(1, 60, 100))
  ))
}

ui <- el_page(
  tags$h2("反馈组件 + 分页展示", style = "margin-bottom:24px;"),

  # ── 1. el_progress ───────────────────────────────────────────────────────
  tags$h4("1. el_progress — 进度条"),
  note("line / circle / dashboard；update_el_progress 从服务端更新"),

  tags$div(style = "max-width:500px;",
    tags$label("line（默认）", style = "font-size:13px;"),
    el_progress("prog_line", percentage = 60),
    tags$br(),
    tags$label("line + text-inside", style = "font-size:13px;"),
    el_progress("prog_inside", percentage = 80, text_inside = TRUE, stroke_width = 18),
    tags$br(),
    tags$label("line + status", style = "font-size:13px;"),
    el_progress("prog_status", percentage = 100, status = "success")
  ),
  tags$div(style = "display:flex; gap:32px; margin-top:12px;",
    tags$div(
      tags$label("circle", style = "font-size:13px;"), tags$br(),
      el_progress("prog_circle", percentage = 75, type = "circle")
    ),
    tags$div(
      tags$label("dashboard", style = "font-size:13px;"), tags$br(),
      el_progress("prog_dash", percentage = 45, type = "dashboard")
    )
  ),
  tags$div(style = "display:flex; gap:8px; margin-top:12px;",
    el_button("prog_inc",   "+10%",    type = "primary", size = "small"),
    el_button("prog_dec",   "-10%",    type = "default", size = "small"),
    el_button("prog_reset", "重置",    type = "warning", size = "small"),
    el_button("prog_done",  "完成",    type = "success", size = "small"),
    el_button("prog_err",   "出错",    type = "danger",  size = "small")
  ),
  tags$hr(),

  # ── 2. el_notification + el_message ──────────────────────────────────────
  tags$h4("2. el_notification + el_message"),
  note("服务端发送，自动消失；需要 el_page() 加载 JS handler"),

  tags$div(style = "margin-bottom:8px;",
    tags$strong("el_message（顶部 toast）："),
    tags$div(style = "display:flex; gap:8px; margin-top:4px;",
      el_button("msg_info",    "Info",    type = "default", size = "small"),
      el_button("msg_success", "Success", type = "success", size = "small"),
      el_button("msg_warning", "Warning", type = "warning", size = "small"),
      el_button("msg_error",   "Error",   type = "danger",  size = "small")
    )
  ),
  tags$div(
    tags$strong("el_notification（角落弹出）："),
    tags$div(style = "display:flex; gap:8px; margin-top:4px;",
      el_button("noti_tr",  "右上角",   type = "primary", size = "small"),
      el_button("noti_tl",  "左上角",   type = "primary", size = "small"),
      el_button("noti_br",  "右下角",   type = "primary", size = "small"),
      el_button("noti_stay","不自动关闭", type = "info",    size = "small")
    )
  ),
  tags$hr(),

  # ── 3. el_pagination + el_table ──────────────────────────────────────────
  tags$h4("3. el_pagination — 分页 + 数据联动"),
  note("current-change → input$pg_page；size-change → input$pg_size"),

  el_pagination("pg",
    total    = 100,
    page_size = 10,
    layout   = "total, sizes, prev, pager, next, jumper",
    background = TRUE,
    page_sizes = c(5, 10, 20, 50)
  ),
  tags$br(),
  el_table(
    id      = "pg_table",
    data    = make_data(1, 10),
    columns = list(
      list(prop = "id",     label = "ID",     width = "80"),
      list(prop = "name",   label = "姓名",   width = "120"),
      list(prop = "status", label = "状态",   width = "120"),
      list(prop = "score",  label = "评分",   width = "100")
    ),
    border = TRUE
  ),
  tags$div(style = "margin-top:8px; color:#888; font-size:13px;",
    "当前页：", textOutput("pg_info", inline = TRUE)
  )
)

server <- function(input, output, session) {

  # ── 进度条控制 ────────────────────────────────────────────────────────────
  pct <- reactiveVal(60)

  observeEvent(input$prog_inc, {
    new_pct <- min(pct() + 10, 100)
    pct(new_pct)
    update_el_progress(session, "prog_line",   percentage = new_pct)
    update_el_progress(session, "prog_circle", percentage = new_pct)
    update_el_progress(session, "prog_dash",   percentage = new_pct)
  })

  observeEvent(input$prog_dec, {
    new_pct <- max(pct() - 10, 0)
    pct(new_pct)
    update_el_progress(session, "prog_line",   percentage = new_pct, status = NULL)
    update_el_progress(session, "prog_circle", percentage = new_pct, status = NULL)
    update_el_progress(session, "prog_dash",   percentage = new_pct, status = NULL)
  })

  observeEvent(input$prog_reset, {
    pct(0)
    update_el_progress(session, "prog_line",   percentage = 0, status = NULL)
    update_el_progress(session, "prog_circle", percentage = 0, status = NULL)
    update_el_progress(session, "prog_dash",   percentage = 0, status = NULL)
  })

  observeEvent(input$prog_done, {
    pct(100)
    update_el_progress(session, "prog_line",   percentage = 100, status = "success")
    update_el_progress(session, "prog_circle", percentage = 100, status = "success")
    update_el_progress(session, "prog_dash",   percentage = 100, status = "success")
  })

  observeEvent(input$prog_err, {
    update_el_progress(session, "prog_line",   percentage = pct(), status = "exception")
    update_el_progress(session, "prog_circle", percentage = pct(), status = "exception")
  })

  # ── message ───────────────────────────────────────────────────────────────
  observeEvent(input$msg_info,    el_message(session, "这是一条 info 消息",    type = "info"))
  observeEvent(input$msg_success, el_message(session, "操作成功！",             type = "success"))
  observeEvent(input$msg_warning, el_message(session, "注意：请检查输入",       type = "warning"))
  observeEvent(input$msg_error,   el_message(session, "错误：操作失败",         type = "error",
    show_close = TRUE, duration = 0))

  # ── notification ──────────────────────────────────────────────────────────
  observeEvent(input$noti_tr, el_notification(session,
    title   = "提示",
    message = "这是右上角通知（4.5s 后关闭）",
    type    = "info",
    position = "top-right"))

  observeEvent(input$noti_tl, el_notification(session,
    title   = "成功",
    message = "左上角：操作已完成",
    type    = "success",
    position = "top-left"))

  observeEvent(input$noti_br, el_notification(session,
    title   = "警告",
    message = "右下角：请注意此提示",
    type    = "warning",
    position = "bottom-right"))

  observeEvent(input$noti_stay, el_notification(session,
    title    = "重要通知",
    message  = "此通知不会自动关闭，需手动点×",
    type     = "error",
    duration = 0))

  # ── 分页联动 ──────────────────────────────────────────────────────────────
  cur_page <- reactiveVal(1)
  cur_size <- reactiveVal(10)

  observeEvent(input$pg_page, cur_page(input$pg_page))
  observeEvent(input$pg_size, {
    cur_size(input$pg_size)
    cur_page(1)
    update_el_pagination(session, "pg", current_page = 1)
  })

  output$pg_info <- renderText({
    sprintf("第 %d 页，每页 %d 条，共 100 条", cur_page(), cur_size())
  })

  # 分页数据更新（el_table 暂不支持 update，用重建方案）
  observe({
    data <- make_data(cur_page(), cur_size())
    # 注：当前 el_table 无 update 函数，可通过 renderUI 方案刷新
    # 此处仅演示 pagination input 值的读取
  })
}

shinyApp(ui, server)
