library(shiny)  
library(shiny.element)  
  
# 示例 1: 基础用法  
ui1 <- el_page(  
  title = "Steps 基础示例",  
  el_steps(  
    id = "steps1",  
    active = 0,  
    finish_status = "success",  
    steps = list(  
      list(title = "步骤 1"),  
      list(title = "步骤 2"),  
      list(title = "步骤 3")  
    )  
  ),  
  el_button("next_btn", "下一步", type = "primary"),  
  verbatimTextOutput("current_step")  
)  
  
server1 <- function(input, output, session) {  
  output$current_step <- renderPrint({  
    paste("当前步骤:", input$steps1)  
  })  
    
  observeEvent(input$next_btn, {  
    current <- input$steps1 %||% 0  
    new_active <- if (current >= 2) 0 else current + 1  
    update_el_steps(session, "steps1", active = new_active)  
  })  
}  

shinyApp(ui1, server1)
  
# 示例 2: 带描述和图标  
ui2 <- el_page(  
  title = "Steps 完整示例",  
  el_steps(  
    id = "steps2",  
    active = 1,  
    finish_status = "success",  
    steps = list(  
      list(  
        title = "步骤 1",  
        description = "这是一段很长很长很长的描述性文字",  
        icon = "el-icon-edit"  
      ),  
      list(  
        title = "步骤 2",  
        description = "这是一段很长很长很长的描述性文字",  
        icon = "el-icon-upload"  
      ),  
      list(  
        title = "步骤 3",  
        description = "这段就没那么长了",  
        icon = "el-icon-picture"  
      )  
    )  
  )  
)  

server2 <- function(input, output, session) {
  
}

shinyApp(ui2, server2)
  
# 示例 3: 竖式步骤条  
ui3 <- el_page(  
  title = "竖式步骤条",  
  tags$div(  
    style = "height: 300px;",  
    el_steps(  
      id = "steps3",  
      direction = "vertical",  
      active = 1,  
      steps = list(  
        list(title = "步骤 1"),  
        list(title = "步骤 2"),  
        list(title = "步骤 3", description = "这是一段很长很长很长的描述性文字")  
      )  
    )  
  )  
)  
  
# 示例 4: 简洁风格  
ui4 <- el_page(  
  title = "简洁风格步骤条",  
  el_steps(  
    id = "steps4",  
    active = 1,  
    simple = TRUE,  
    steps = list(  
      list(title = "步骤 1", icon = "el-icon-edit"),  
      list(title = "步骤 2", icon = "el-icon-upload"),  
      list(title = "步骤 3", icon = "el-icon-picture")  
    )  
  ),  
  tags$br(),  
  el_steps(  
    id = "steps5",  
    active = 1,  
    finish_status = "success",  
    simple = TRUE,  
    steps = list(  
      list(title = "步骤 1"),  
      list(title = "步骤 2"),  
      list(title = "步骤 3")  
    )  
  )  
)  
  
# 示例 5: 动态生成步骤  
ui5 <- el_page(  
  title = "动态步骤",  
  el_steps(  
    id = "steps6",  
    active = 0,  
    steps = lapply(1:5, function(i) {  
      list(  
        title = paste("步骤", i),  
        description = paste("这是第", i, "步的描述")  
      )  
    })  
  )  
)  
  

