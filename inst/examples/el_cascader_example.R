library(shiny)  
library(vueR)  
library(htmltools)  
  

# cascader_options --------------------------------------------------------------

# 级联选择器数据  
cascader_options <- list(  
  list(  
    value = "zhinan",  
    label = "指南",  
    children = list(  
      list(value = "shejiyuanze", label = "设计原则"),  
      list(value = "daohang", label = "导航")  
    )  
  ),  
  list(  
    value = "zujian",  
    label = "组件",  
    children = list(  
      list(value = "basic", label = "Basic"),  
      list(value = "form", label = "Form", disabled = TRUE)  
    )  
  )  
)  
  
# 自定义 props 配置  
custom_props <- list(  
  expandTrigger = "hover",  # 次级菜单展开方式  
  multiple = FALSE,         # 是否多选  
  checkStrictly = FALSE,    # 是否严格的选择任意一级选项  
  emitPath = TRUE,          # 是否返回完整路径  
  lazy = FALSE,             # 是否动态加载  
  value = "value",  
  label = "label",  
  children = "children"  
)  
  
ui <- el_page(  
  h3("基础级联选择器"),  
  el_cascader(  
    options = cascader_options,  
    placeholder = "请选择分类",  
    clearable = TRUE,  
    id = "cascader1"  
  ),  
    
  h3("可搜索的级联选择器"),  
  el_cascader(  
    options = cascader_options,  
    placeholder = "可搜索",  
    clearable = TRUE,  
    filterable = TRUE,  
    id = "cascader2"  
  ),  
    
  h3("自定义配置的级联选择器"),  
  el_cascader(  
    options = cascader_options,  
    placeholder = "hover 展开",  
    props = custom_props,  
    clearable = TRUE,  
    size = "medium",  
    show_all_levels = FALSE,  
    separator = " > ",  
    id = "cascader3"  
  ),  
    
  actionButton("toggle_disabled", "切换禁用状态"),  
  actionButton("update_options", "更新选项"),  
  verbatimTextOutput("selected")  
)  
  
server <- function(input, output, session) {  
  # 监听选择变化  
  observeEvent(input$cascader1_value, {  
    print(paste("Cascader 1:", input$cascader1_value))  
  })  
    
  observeEvent(input$cascader2_value, {  
    print(paste("Cascader 2:", input$cascader2_value))  
  })  
    
  observeEvent(input$cascader3_value, {  
    print(paste("Cascader 3:", input$cascader3_value))  
  })  
    
  # 显示选中值  
  output$selected <- renderPrint({  
    list(  
      cascader1 = input$cascader1_value,  
      cascader2 = input$cascader2_value,  
      cascader3 = input$cascader3_value  
    )  
  })  
    
  # 切换禁用状态  
  disabled_state <- reactiveVal(FALSE)  
  observeEvent(input$toggle_disabled, {  
    new_state <- !disabled_state()  
    disabled_state(new_state)  
    update_el_cascader(session, "cascader1", disabled = new_state)  
  })  
    
  # 更新选项  
  observeEvent(input$update_options, {  
    new_options <- list(  
      list(  
        value = "new1",  
        label = "新分类1",  
        children = list(  
          list(value = "child1", label = "子选项1"),  
          list(value = "child2", label = "子选项2")  
        )  
      ),  
      list(  
        value = "new2",  
        label = "新分类2"  
      )  
    )  
    update_el_cascader(session, "cascader1", options = new_options)  
  })  
}  
  
shinyApp(ui, server)



# df_to_cascader_options -----------------------------------------------

library(shiny)
library(shiny.element)

df1 <- data.frame(
  value1 = c("A", "A", "B"),
  value2 = c("a1", "a2", "b1"),
  value3 = c("x", "y", "z"),
  stringsAsFactors = FALSE
)

df2 <- data.frame(
  value1 = c("A", "A", "B"),
  label1 = c("Group A", "Group A", "Group B"),
  value2 = c("a1", "a2", "b1"),
  label2 = c("A-1", "A-2", "B-1"),
  value3 = c("x", "y", "z"),
  label3 = c("X", "Y", "Z"),
  stringsAsFactors = FALSE
)

df3 <- data.frame(
  value1 = c("A", "A", "B"),
  label1 = c("Group A", "Group A", "Group B"),
  value2 = c("a1", "a2", "b1"),
  value3 = c("x", "y", "z"),
  label3 = c("X", "Y", "Z"),
  stringsAsFactors = FALSE
)

ui <- el_page(
  title = "Element UI Cascader Demo",

  h3("No label (label_cols = NULL)"),
  el_cascader(
    id = "cascader1",
    options = cascader_options1,
    placeholder = "Please select",
    clearable = TRUE
  ),

  h3("All levels have label (label_cols = c('label1', 'label2', 'label3'))"),
  el_cascader(
    id = "cascader2",
    options = cascader_options2,
    placeholder = "Please select",
    clearable = TRUE
  ),

  h3("Some levels have label (label_cols = c('label1', NA, 'label3'))"),
  el_cascader(
    id = "cascader3",
    options = cascader_options3,
    placeholder = "Please select",
    clearable = TRUE
  )
)

server <- function(input, output, session) {}

shinyApp(ui, server)