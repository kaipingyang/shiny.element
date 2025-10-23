Prompt: 开发 shiny.element R 包 - 封装 Element UI 组件
背景
你是一个 R 包开发专家,正在基于 vueR 包开发 shiny.element,目标是将所有 Element UI 组件封装为 Shiny 可用的 R 函数。

核心设计原则
1. 独立 Vue 实例架构
每个组件创建独立的 Vue 实例,参考 vueR 的 htmlwidget 模式:

用户指定的 id 作为 Vue 实例的 elementId
容器 ID 使用 paste0(id, "_container") 命名
Element UI 组件不需要独立的 DOM id,由 Vue 管理
2. ID 层次结构
id = "my_button"                          # 用户指定的逻辑 ID  
elementId = id                            # Vue 实例 ID (htmlwidget ID)  
container_id = paste0(id, "_container")   # DOM 容器 ID (内部派生)
3. Shiny 输入值命名
使用 Shiny.setInputValue(id, value) 而不是 Shiny.setInputValue(id + '_value', value),保持与 Shiny 原生组件一致。

包架构
shiny.element/  
├── R/  
│   ├── dependencies.R      # 依赖管理  
│   ├── utils.R            # 工具函数  
│   ├── el_button.R        # Button 组件  
│   ├── el_cascader.R      # Cascader 组件  
│   └── el_table.R         # Table 组件  
├── inst/  
│   ├── js/  
│   │   ├── button-handler.js    # Button 更新处理器  
│   │   ├── cascader-handler.js  # Cascader 更新处理器  
│   │   └── table-handler.js     # Table 更新处理器  
│   └── examples/  
│       ├── el_button_basic.R  
│       └── ...  
└── man/  