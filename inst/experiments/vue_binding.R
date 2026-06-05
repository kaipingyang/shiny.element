# Shiny 组件在 Vue 管理区域之外 ------------------------------------------

library(shiny)  
library(shiny.element)  
library(vueR)  
  
ui <- el_page(  
  titlePanel("Element UI Calendar 单选测试"),  
    
  # Shiny 组件在 Vue 管理区域之外  
  fluidRow(  
    # 左侧:纯 Shiny 控制面板  
    column(  
      width = 3,  
      wellPanel(  
        h4("控制面板"),  
        actionButton("set_today", "设置为今天"),  
        actionButton("set_tomorrow", "设置为明天"),  
        actionButton("set_custom", "设置为自定义日期"),  
        hr(),  
        h4("当前选中日期:"),  
        verbatimTextOutput("selected_date")  
      )  
    ),  
      
    # 右侧:Vue 管理的日历组件  
    column(  
      width = 9,  
      tags$div(  
        id = "calendar_vue",  
        el$card(  
          h3("日历组件"),  
          el$calendar(  
            `v-model` = "value",  
            `:first-day-of-week` = "firstDayOfWeek",  
            template(  
              tags$p(  
                `:class` = "data.isSelected ? 'is-selected' : ''",  
                "{{ data.day.split('-').slice(1).join('-') }}",  
                tags$span("\u2714\ufe0f", `v-if` = "data.isSelected")  
              ),  
              slot = "dateCell",  
              scope = "{date, data}"  
            )  
          )  
        )  
      ),  
      vueR::vue(  
        elementId = "calendar_vue_instance",  
        list(  
          el = "#calendar_vue",  
          data = list(  
            value = format(Sys.Date(), "%Y-%m-%d"),  
            firstDayOfWeek = 1  
          ),  
          watch = list(  
            value = htmlwidgets::JS(  
              "function(val) { Shiny.setInputValue('my_calendar', val); }"  
            )  
          )  
        )  
      )  
    )  
  )  
)  
  
server <- function(input, output, session) {  
  output$selected_date <- renderPrint({  
    if (is.null(input$my_calendar)) {  
      "未选择日期"  
    } else {  
      cat("选中日期:", input$my_calendar)  
    }  
  })   

  observeEvent(input$set_today, {
    update_vue_component(session, "calendar_vue_instance", value = format(Sys.Date(), "%Y-%m-%d"))
  })

  observeEvent(input$set_tomorrow, {
    update_vue_component(session, "calendar_vue_instance", value = format(Sys.Date() + 1, "%Y-%m-%d"))
  })

  observeEvent(input$set_custom, {
    # Example: set to a fixed custom date
    update_vue_data(session, "calendar_vue_instance", list(
      value = "2025-12-31",
      first_day_of_week = 3
    ))
  })
}  
  
shinyApp(ui, server)


# all el components with one vue instance --------------------------

library(shiny)  
library(shiny.element)  
library(vueR)  
  
# 定义 JavaScript 处理器  
js_handlers <- "  
  window.js_handler = (function() {  
    var vueInstances = {};  
      
    return {  
      registerVueInstance: function(id, instance) {  
        vueInstances[id] = instance;  
        console.log('Vue instance registered:', id);  
      },  
        
      getVueInstance: function(id) {  
        if (vueInstances[id]) {  
          return vueInstances[id];  
        }  
        var widget = HTMLWidgets.find('#' + id);  
        if (widget && widget.instance) {  
          return widget.instance;  
        }  
        var el = document.getElementById(id);  
        if (el && el.__vue__) {  
          return el.__vue__;  
        }  
        console.warn('Vue instance not found for id:', id);  
        return null;  
      },  
        
      updateVueComponent: function(message) {  
        var instance = this.getVueInstance(message.id);  
        if (instance) {  
          Object.keys(message).forEach(function(key) {  
            if (key !== 'id') {  
              if (typeof Vue !== 'undefined' && Vue.set) {  
                Vue.set(instance, key, message[key]);  
              } else {  
                instance[key] = message[key];  
              }  
            }  
          });  
          console.log('Vue component updated:', message.id);  
        }  
      },  
        
      updateVueData: function(message) {  
        var instance = this.getVueInstance(message.id);  
        if (instance && message.data) {  
          Object.keys(message.data).forEach(function(key) {  
            if (typeof Vue !== 'undefined' && Vue.set) {  
              Vue.set(instance, key, message.data[key]);  
            } else {  
              instance[key] = message.data[key];  
            }  
          });  
          console.log('Vue data updated:', message.id);  
        }  
      }  
    };  
  })();  
    
  Shiny.addCustomMessageHandler('update_vue_component', function(message) {  
    js_handler.updateVueComponent(message);  
  });  
    
  Shiny.addCustomMessageHandler('update_vue_data', function(message) {  
    js_handler.updateVueData(message);  
  });  
"  
  
ui <- el_page(  
  # 内联 JavaScript 处理器  
  tags$head(tags$script(HTML(js_handlers))),  
    
  tags$h2("Element UI Calendar 完整示例"),  
    
  # 完全使用 el$ 组件构建布局  
  tags$div(  
    id = "app",  
    el$container(  
      # 左侧控制面板  
      el$aside(  
        style = "width: 280px; background: #f5f7fa; padding: 20px;",  
        el$card(  
          tags$div(  
            slot = "header",  
            tags$h3("控制面板", style = "margin: 0;")  
          ),  
          # 使用 Element UI 按钮  
          el$button(  
            "设置为今天",  
            type = "primary",  
            "@click" = "setToday",  
            style = "width: 100%; margin-bottom: 10px;"  
          ),  
          el$button(  
            "设置为明天",  
            type = "success",  
            "@click" = "setTomorrow",  
            style = "width: 100%; margin-bottom: 10px;"  
          ),  
          el$button(  
            "设置为自定义日期",  
            type = "warning",  
            "@click" = "setCustom",  
            style = "width: 100%; margin-bottom: 10px;"  
          ),  
          el$divider(),  
          tags$h4("当前选中日期:"),  
          # 使用 Vue 模板显示数据  
          el$tag(  
            type = "info",  
            size = "medium",  
            "{{ value }}"  
          ),  
          el$divider(),  
          tags$h4("星期设置:"),  
          el$tag(  
            type = "success",  
            size = "medium",  
            "第一天: {{ firstDayOfWeek === 1 ? '星期一' : '星期日' }}"  
          )  
        )  
      ),  
        
      # 右侧主内容区  
      el$main(  
        el$card(  
          tags$div(  
            slot = "header",  
            tags$h3("日历组件", style = "margin: 0;")  
          ),  
          el$calendar(  
            `v-model` = "value",  
            `:first-day-of-week` = "firstDayOfWeek",  
            template(  
              tags$div(  
                `:class` = "data.isSelected ? 'is-selected' : ''",  
                style = "text-align: center;",  
                tags$div("{{ data.day.split('-').slice(1).join('-') }}"),  
                tags$span(  
                  "\u2714\ufe0f",  
                  `v-if` = "data.isSelected",  
                  style = "color: #409EFF;"  
                )  
              ),  
              slot = "dateCell",  
              scope = "{date, data}"  
            )  
          )  
        )  
      )  
    )  
  ),  
    
  # 挂载 Vue 实例激活所有 el 组件  
  vueR::vue(  
    elementId = "app_instance",  
    list(  
      el = "#app",  
      data = list(  
        value = format(Sys.Date(), "%Y-%m-%d"),  
        firstDayOfWeek = 1  
      ),  
      methods = list(  
        # 设置为今天  
        setToday = htmlwidgets::JS(  
          "function() {  
            this.value = new Date().toISOString().split('T')[0];  
            Shiny.setInputValue('calendar_action', {  
              action: 'today',  
              value: this.value  
            }, {priority: 'event'});  
          }"  
        ),  
        # 设置为明天  
        setTomorrow = htmlwidgets::JS(  
          "function() {  
            var tomorrow = new Date();  
            tomorrow.setDate(tomorrow.getDate() + 1);  
            this.value = tomorrow.toISOString().split('T')[0];  
            Shiny.setInputValue('calendar_action', {  
              action: 'tomorrow',  
              value: this.value  
            }, {priority: 'event'});  
          }"  
        ),  
        # 设置为自定义日期  
        setCustom = htmlwidgets::JS(  
          "function() {  
            this.value = '2025-12-31';  
            this.firstDayOfWeek = 7;  // 星期日  
            Shiny.setInputValue('calendar_action', {  
              action: 'custom',  
              value: this.value,  
              firstDayOfWeek: this.firstDayOfWeek  
            }, {priority: 'event'});  
          }"  
        )  
      ),  
      watch = list(  
        # 监听日期变化  
        value = htmlwidgets::JS(  
          "function(val) {  
            Shiny.setInputValue('my_calendar', val, {priority: 'event'});  
          }"  
        )  
      ),  
      # 注册 Vue 实例  
      mounted = htmlwidgets::JS(  
        "function() {  
          if (window.js_handler && window.js_handler.registerVueInstance) {  
            window.js_handler.registerVueInstance('app_instance', this);  
          }  
          console.log('Vue instance mounted and all el components activated');  
        }"  
      )  
    ),  
    minified = FALSE  
  )  
)  
  
server <- function(input, output, session) {  
  # 原有的监听器...  
  observeEvent(input$calendar_action, {  
    action_data <- input$calendar_action  
    cat("日历操作:\n")  
    cat("  动作:", action_data$action, "\n")  
    cat("  新值:", action_data$value, "\n")  
    if (!is.null(action_data$firstDayOfWeek)) {  
      cat("  星期设置:", action_data$firstDayOfWeek, "\n")  
    }  
  })  
    
  observeEvent(input$my_calendar, {  
    cat("日历值变化:", input$my_calendar, "\n")  
  })  
    
  # 新增: 定时自动更新测试  
  observe({  
    invalidateLater(10000, session)  # 每10秒触发一次  
      
    # 随机选择一个日期  
    random_days <- sample(-30:30, 1)  
    new_date <- format(Sys.Date() + random_days, "%Y-%m-%d")  
      
    cat("自动更新日历到:", new_date, "\n")  
      
    session$sendCustomMessage("update_vue_component", list(  
      id = "app_instance",  
      value = new_date  
    ))  
  })  
    
  # 新增: 响应式更新测试  
  # 假设您有一个 reactive 值  
  selected_date <- reactive({  
    # 这里可以是任何响应式逻辑  
    input$my_calendar  
  })  
    
  # 当 selected_date 变化时,更新其他字段  
  observeEvent(selected_date(), {  
    if (!is.null(selected_date())) {  
      # 根据日期判断星期设置  
      date_obj <- as.Date(selected_date())  
      weekday <- as.numeric(format(date_obj, "%u"))  
        
      # 如果是周末,设置星期日为第一天  
      if (weekday >= 6) {  
        session$sendCustomMessage("update_vue_component", list(  
          id = "app_instance",  
          firstDayOfWeek = 7  
        ))  
      } else {  
        session$sendCustomMessage("update_vue_component", list(  
          id = "app_instance",  
          firstDayOfWeek = 1  
        ))  
      }  
    }  
  })  
}
  
shinyApp(ui, server)








# 在 mounted 钩子中重新绑定 Shiny 组件 -----------------------------------------------------

library(shiny)  
library(shiny.element)  
library(vueR)  
  
ui <- el_page(  
  tags$head(tags$script(HTML(js_handlers))),  
    
  tags$div(  
    id = "app",  
    el$container(  
      el$aside(  
        style = "width: 260px; background: #f5f7fa; padding: 24px;",  
        el$card(  
          tags$h4("控制面板"),  
          # Shiny actionButton 在 Vue 管理的 DOM 中  
          actionButton("set_today", "设置为今天"),  
          actionButton("set_tomorrow", "设置为明天")  
        )  
      ),  
      el$main(  
        el$card(  
          tags$h3("日历组件"),  
          el$calendar(  
            `v-model` = "value",  
            `:first-day-of-week` = "firstDayOfWeek"  
          )  
        )  
      )  
    )  
  ),  
    
  vueR::vue(  
    elementId = "app_instance",  
    list(  
      el = "#app",  
      data = list(  
        value = format(Sys.Date(), "%Y-%m-%d"),  
        firstDayOfWeek = 1  
      ),  
      watch = list(  
        value = htmlwidgets::JS(  
          "function(val) { Shiny.setInputValue('my_calendar', val); }"  
        )  
      ),  
      # 关键: 在 mounted 钩子中重新绑定 Shiny 组件  
      mounted = htmlwidgets::JS(  
        "function() {  
          var that = this;  
          Vue.nextTick(function() {  
            if (window.Shiny && Shiny.bindAll) {  
              // 强制重新绑定 Vue 管理区域内的 Shiny 组件  
              Shiny.bindAll(that.$el);  
            }  
          });  
            
          if (window.js_handler && window.js_handler.registerVueInstance) {  
            window.js_handler.registerVueInstance('app_instance', that);  
          }  
        }"  
      )  
    ),  
    minified = FALSE  
  )  
)  
  
server <- function(input, output, session) {  
  observeEvent(input$set_today, {  
    cat("今天按钮被点击\n")  
    session$sendCustomMessage("update_vue_component", list(  
      id = "app_instance",  
      value = format(Sys.Date(), "%Y-%m-%d")  
    ))  
  })  
    
  observeEvent(input$set_tomorrow, {  
    cat("明天按钮被点击\n")  
    session$sendCustomMessage("update_vue_component", list(  
      id = "app_instance",  
      value = format(Sys.Date() + 1, "%Y-%m-%d")  
    ))  
  })  
    
  observeEvent(input$my_calendar, {  
    cat("日历值变化:", input$my_calendar, "\n")  
  })  
}  
  
shinyApp(ui, server)