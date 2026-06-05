devtools::load_all()
library(shiny)

row1 <- function(...) tags$div(style = "display:flex; gap:24px; align-items:flex-start; flex-wrap:wrap; margin-bottom:12px;", ...)
note <- function(txt) tags$p(style = "color:#888; font-size:13px; margin:2px 0 8px;", txt)
section <- function(title, ...) tagList(tags$h4(title), ...)

ui <- el_page(
  tags$h2("Form Inputs 展示", style = "margin-bottom:24px;"),

  # ── 1. el_input ──────────────────────────────────────────────────────────
  section("1. el_input",
    note("text / password / textarea，带 clearable / prefix-icon / suffix-icon"),
    row1(
      tags$div(style = "width:220px;",
        tags$label("普通文本", style = "font-size:13px;"), tags$br(),
        el_input("inp_text", placeholder = "请输入文字", clearable = TRUE)
      ),
      tags$div(style = "width:220px;",
        tags$label("密码框", style = "font-size:13px;"), tags$br(),
        el_input("inp_pwd", type = "password", placeholder = "密码", show_password = TRUE)
      ),
      tags$div(style = "width:220px;",
        tags$label("前置图标", style = "font-size:13px;"), tags$br(),
        el_input("inp_icon", placeholder = "搜索…", prefix_icon = "el-icon-search")
      ),
      tags$div(style = "width:220px;",
        tags$label("尺寸 small", style = "font-size:13px;"), tags$br(),
        el_input("inp_small", placeholder = "small", size = "small")
      )
    ),
    row1(
      tags$div(style = "width:300px;",
        tags$label("Textarea", style = "font-size:13px;"), tags$br(),
        el_input("inp_area", type = "textarea", placeholder = "多行文本…", rows = 3)
      ),
      tags$div(style = "width:220px;",
        tags$label("字数限制（maxlength=20）", style = "font-size:13px;"), tags$br(),
        el_input("inp_limit", placeholder = "最多20字", maxlength = 20, show_word_limit = TRUE)
      )
    ),
    verbatimTextOutput("inp_out")
  ),
  tags$hr(),

  # ── 2. el_select ─────────────────────────────────────────────────────────
  section("2. el_select",
    note("单选 / 多选 / 可搜索"),
    row1(
      tags$div(style = "width:200px;",
        tags$label("单选", style = "font-size:13px;"), tags$br(),
        el_select("sel_single",
          choices = c("北京" = "bj", "上海" = "sh", "广州" = "gz", "深圳" = "sz"),
          placeholder = "请选择城市"
        )
      ),
      tags$div(style = "width:260px;",
        tags$label("多选 + collapse-tags", style = "font-size:13px;"), tags$br(),
        el_select("sel_multi",
          choices = c("Vue" = "vue", "React" = "react", "Angular" = "angular",
                      "Svelte" = "svelte", "Solid" = "solid"),
          multiple = TRUE, collapse_tags = TRUE, placeholder = "选择框架"
        )
      ),
      tags$div(style = "width:200px;",
        tags$label("可搜索 + 可清空", style = "font-size:13px;"), tags$br(),
        el_select("sel_filter",
          choices = c("苹果" = "apple", "香蕉" = "banana", "橙子" = "orange",
                      "葡萄" = "grape", "西瓜" = "watermelon"),
          filterable = TRUE, clearable = TRUE, placeholder = "搜索水果"
        )
      )
    ),
    verbatimTextOutput("sel_out")
  ),
  tags$hr(),

  # ── 3. el_radio_group ────────────────────────────────────────────────────
  section("3. el_radio_group",
    note("普通 radio / button 样式"),
    row1(
      tags$div(
        tags$label("普通样式", style = "font-size:13px;"), tags$br(),
        el_radio_group("rg_normal",
          choices = c("选项A" = "a", "选项B" = "b", "选项C" = "c"),
          selected = "a"
        )
      ),
      tags$div(
        tags$label("按钮样式（button=TRUE）", style = "font-size:13px;"), tags$br(),
        el_radio_group("rg_btn",
          choices = c("月" = "month", "季" = "quarter", "年" = "year"),
          selected = "month",
          button = TRUE
        )
      )
    ),
    verbatimTextOutput("rg_out")
  ),
  tags$hr(),

  # ── 4. el_checkbox_group ─────────────────────────────────────────────────
  section("4. el_checkbox_group",
    note("普通 checkbox / button 样式 / min-max 限制"),
    row1(
      tags$div(
        tags$label("普通样式", style = "font-size:13px;"), tags$br(),
        el_checkbox_group("cbg_normal",
          choices  = c("苹果" = "apple", "香蕉" = "banana", "橙子" = "orange", "葡萄" = "grape"),
          selected = c("apple", "orange")
        )
      ),
      tags$div(
        tags$label("按钮样式 + 最多选2个", style = "font-size:13px;"), tags$br(),
        el_checkbox_group("cbg_btn",
          choices = c("周一" = "mon", "周二" = "tue", "周三" = "wed",
                      "周四" = "thu", "周五" = "fri"),
          button = TRUE, max = 2
        )
      )
    ),
    verbatimTextOutput("cbg_out")
  ),
  tags$hr(),

  # ── 5. el_switch ─────────────────────────────────────────────────────────
  section("5. el_switch",
    note("Boolean 值 / 自定义文本 / 自定义颜色"),
    row1(
      tags$div(
        tags$label("默认", style = "font-size:13px;"), tags$br(),
        el_switch("sw_default", value = TRUE)
      ),
      tags$div(
        tags$label("带文本", style = "font-size:13px;"), tags$br(),
        el_switch("sw_text", value = FALSE,
          active_text = "开启", inactive_text = "关闭")
      ),
      tags$div(
        tags$label("自定义颜色", style = "font-size:13px;"), tags$br(),
        el_switch("sw_color", value = TRUE,
          active_color = "#13ce66", inactive_color = "#ff4949")
      ),
      tags$div(
        tags$label("禁用", style = "font-size:13px;"), tags$br(),
        el_switch("sw_dis", value = TRUE, disabled = TRUE)
      )
    ),
    verbatimTextOutput("sw_out")
  ),
  tags$hr(),

  # ── 6. el_slider ─────────────────────────────────────────────────────────
  section("6. el_slider",
    note("单值 / 范围 / 带停靠点"),
    tags$div(style = "max-width:500px;",
      tags$label("单值滑块（0-100，step=5）", style = "font-size:13px;"),
      el_slider("sl_single", value = 30, min = 0, max = 100, step = 5, show_input = TRUE)
    ),
    tags$div(style = "max-width:500px; margin-top:16px;",
      tags$label("范围滑块（range=TRUE）", style = "font-size:13px;"),
      el_slider("sl_range", value = c(20, 70), range = TRUE, show_stops = TRUE, step = 10)
    ),
    verbatimTextOutput("sl_out")
  ),
  tags$hr(),

  # ── 7. el_date_picker ────────────────────────────────────────────────────
  section("7. el_date_picker",
    note("日期 / 日期范围 / 月份"),
    row1(
      tags$div(
        tags$label("日期", style = "font-size:13px;"), tags$br(),
        el_date_picker("dp_date", value = Sys.Date(), clearable = TRUE)
      ),
      tags$div(
        tags$label("日期范围", style = "font-size:13px;"), tags$br(),
        el_date_picker("dp_range", type = "daterange",
          start_placeholder = "开始", end_placeholder = "结束",
          range_separator = "至")
      ),
      tags$div(
        tags$label("月份", style = "font-size:13px;"), tags$br(),
        el_date_picker("dp_month", type = "month", value_format = "yyyy-MM",
          placeholder = "选择月份")
      )
    ),
    verbatimTextOutput("dp_out")
  )
)

server <- function(input, output, session) {
  output$inp_out <- renderText({
    paste0(
      "text: ",   input$inp_text,  "\n",
      "pwd:  ",   input$inp_pwd,   "\n",
      "icon: ",   input$inp_icon,  "\n",
      "small: ",  input$inp_small, "\n",
      "area: ",   input$inp_area,  "\n",
      "limit: ",  input$inp_limit
    )
  })

  output$sel_out <- renderText({
    paste0(
      "single: ",  input$sel_single,             "\n",
      "multi:  ",  paste(input$sel_multi, collapse=", "), "\n",
      "filter: ",  input$sel_filter
    )
  })

  output$rg_out <- renderText({
    paste0("normal: ", input$rg_normal, "  |  button: ", input$rg_btn)
  })

  output$cbg_out <- renderText({
    paste0(
      "normal: ", paste(input$cbg_normal, collapse=", "), "\n",
      "button: ", paste(input$cbg_btn, collapse=", ")
    )
  })

  output$sw_out <- renderText({
    paste0(
      "default: ", input$sw_default, "  ",
      "text: ",    input$sw_text,    "  ",
      "color: ",   input$sw_color
    )
  })

  output$sl_out <- renderText({
    paste0(
      "single: ", input$sl_single, "\n",
      "range:  ", paste(input$sl_range, collapse=" ~ ")
    )
  })

  output$dp_out <- renderText({
    paste0(
      "date:  ", input$dp_date,  "\n",
      "range: ", paste(input$dp_range, collapse=" ~ "), "\n",
      "month: ", input$dp_month
    )
  })
}

shinyApp(ui, server)
