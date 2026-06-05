devtools::load_all()
library(shiny)

icon_row <- function(...) {
  tags$div(style = "display:flex; gap:16px; align-items:center; margin-bottom:8px;", ...)
}

ui <- el_page(
  tags$h2("el_icon 展示", style = "margin-bottom:24px;"),

  # ── 1. 基础图标 ──────────────────────────────────────────────────────────
  tags$h4("1. 基础图标"),
  tags$p(style = "color:#888; font-size:13px;",
    "el_icon('search') / 'edit' / 'delete' / 'star-on' / 'bell'"),
  icon_row(
    el_icon("search",  size = "1.5em"),
    el_icon("edit",    size = "1.5em"),
    el_icon("delete",  size = "1.5em"),
    el_icon("star-on", size = "1.5em"),
    el_icon("bell",    size = "1.5em")
  ),
  tags$hr(),

  # ── 2. 尺寸（size）────────────────────────────────────────────────────────
  tags$h4("2. 尺寸 size"),
  tags$p(style = "color:#888; font-size:13px;", "1em / 1.5em / 2em / 3em"),
  icon_row(
    el_icon("star-on", size = "1em"),
    el_icon("star-on", size = "1.5em"),
    el_icon("star-on", size = "2em"),
    el_icon("star-on", size = "3em")
  ),
  tags$hr(),

  # ── 3. 名称规范化 ─────────────────────────────────────────────────────────
  tags$h4("3. 名称规范化"),
  tags$p(style = "color:#888; font-size:13px;",
    "大写 'SEARCH'、空格 'arrow left'、误带前缀 'el-icon-edit' — 全部正确渲染"),
  icon_row(
    tags$span("'SEARCH' →",    style = "color:#888; font-size:13px;"),
    el_icon("SEARCH",        size = "1.5em"),
    tags$span("'arrow left' →", style = "color:#888; font-size:13px; margin-left:12px;"),
    el_icon("arrow left",    size = "1.5em"),
    tags$span("'el-icon-edit' →", style = "color:#888; font-size:13px; margin-left:12px;"),
    el_icon("el-icon-edit",  size = "1.5em")
  ),
  tags$hr(),

  # ── 4. 无障碍模式（a11y）──────────────────────────────────────────────────
  tags$h4("4. 无障碍模式 a11y（悬停查看 title，F12 审查元素看 aria 属性）"),
  el_row(
    gutter = 20,
    el_col(
      span = 6,
      tags$p(style = "color:#888; font-size:13px;", "auto（无 title）→ aria-hidden"),
      el_icon("search", size = "2em")
    ),
    el_col(
      span = 6,
      tags$p(style = "color:#888; font-size:13px;", "auto（有 title）→ aria-label + 悬停提示"),
      el_icon("delete", size = "2em", title = "删除此项")
    ),
    el_col(
      span = 6,
      tags$p(style = "color:#888; font-size:13px;", "deco → aria-hidden='true'"),
      el_icon("close", size = "2em", a11y = "deco")
    ),
    el_col(
      span = 6,
      tags$p(style = "color:#888; font-size:13px;", "sem（无 title）→ aria-label 回退为图标名"),
      el_icon("check", size = "2em", a11y = "sem")
    )
  ),
  tags$hr(),

  # ── 5. lib 参数 ───────────────────────────────────────────────────────────
  tags$h4("5. lib 参数"),
  el_row(
    gutter = 20,
    el_col(
      span = 8,
      tags$p(style = "color:#888; font-size:13px;", "lib='element-ui'（默认）"),
      icon_row(
        el_icon("search",  size = "2em", lib = "element-ui"),
        el_icon("star-on", size = "2em", lib = "element-ui")
      )
    ),
    el_col(
      span = 8,
      tags$p(style = "color:#888; font-size:13px;", "lib='font-awesome'"),
      icon_row(
        el_icon("magnifying-glass", size = "2em", lib = "font-awesome"),
        el_icon("star",             size = "2em", lib = "font-awesome")
      )
    ),
    el_col(
      span = 8,
      tags$p(style = "color:#888; font-size:13px;", "lib='none'（手动传 class）"),
      icon_row(
        el_icon("ignored", lib = "none", class = "el-icon-search", size = "2em")
      )
    )
  ),
  tags$hr(),

  # ── 6. 嵌入按钮 ───────────────────────────────────────────────────────────
  tags$h4("6. 嵌入 el_button"),
  icon_row(
    el_button("btn_search", "搜索",   type = "primary", icon = el_icon("search")),
    el_button("btn_edit",   "编辑",   type = "success", icon = el_icon("edit")),
    el_button("btn_del",    "删除",   type = "danger",  icon = el_icon("delete")),
    el_button("btn_fa",     "FA 图标", type = "info",
              icon = el_icon("magnifying-glass", lib = "font-awesome"))
  ),
  verbatimTextOutput("btn_out"),
  tags$hr(),

  # ── 7. 对比旧版 ──────────────────────────────────────────────────────────
  tags$h4("7. 旧版 el_icon vs 新版 el_icon（视觉应一致）"),
  el_row(
    gutter = 20,
    el_col(
      span = 12,
      tags$p(style = "color:#888; font-size:13px;", "el_icon('search')（旧）"),
      el_icon("search", style = "font-size:2em;")
    ),
    el_col(
      span = 12,
      tags$p(style = "color:#888; font-size:13px;",
        "el_icon('search', size='2em', a11y='none')（新）"),
      el_icon("search", size = "2em", a11y = "none")
    )
  )
)

server <- function(input, output, session) {
  output$btn_out <- renderText({
    vals <- list(
      "搜索"   = input$btn_search,
      "编辑"   = input$btn_edit,
      "删除"   = input$btn_del,
      "FA图标" = input$btn_fa
    )
    clicked <- names(Filter(function(x) !is.null(x) && x > 0, vals))
    if (length(clicked) == 0) "点击上方按钮..." else paste("已点击:", paste(clicked, collapse = ", "))
  })
}

shinyApp(ui, server)
