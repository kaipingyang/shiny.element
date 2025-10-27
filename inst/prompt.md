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
```
id = "my_button"                          # 用户指定的逻辑 ID  
elementId = id                            # Vue 实例 ID (htmlwidget ID)  
container_id = paste0(id, "_container")   # DOM 容器 ID (内部派生)
```
3. **Shiny 输入值命名** 
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
│   │   ├── el-button-handler.js    # Button 更新处理器  
│   │   ├── el-cascader-handler.js  # Cascader 更新处理器  
│   │   └── table-handler.js     # Table 更新处理器  
│   └── examples/  
│       ├── el_button_basic.R  
│       └── ...  
└── man/  



## 开发模板

基于 `el_button` 的实现模式,以下是开发新 Element UI 组件的标准 prompt:

---

### Prompt: 开发 shiny.element 组件 - [组件名称]

**背景**
你是 R 包开发专家,正在为 `shiny.element` 包开发 `[el_component_name]` 组件,封装 Element UI 的 `<el-component>` 为 Shiny 可用的 R 函数。<cite></cite>

**核心架构要求**

1. **ID 管理** 
   - 如果 `id` 为 `NULL`,使用 `uuid::UUIDgenerate()` 生成唯一 ID
   - 应用 `session$ns(id)` 支持 Shiny 模块
   - 创建 `container_id = paste0(ns_id, "_container")`

2. **Vue 实例配置** 
   - 使用 `vueR::vue()` 创建独立 Vue 实例
   - `elementId`: 使用 `ns_id`
   - `el`: 挂载点为 `paste0("#", container_id)`
   - `data`: 定义响应式数据属性
   - `methods`: 定义事件处理函数,使用 `htmlwidgets::JS()` 包装

3. **Element-UI 标签构建** 
   - 使用 `htmltools::tag("el-component", attrs)` 创建 Element-UI 标签
   - Vue 指令语法:
     - `:attr="data"` - 绑定到响应式数据
     - `@event="method"` - 绑定事件处理器
     - `v-model="data"` - 双向绑定(如需要)

4. **客户端到服务器通信** 
   - 在 Vue methods 中使用 `Shiny.setInputValue(ns_id, value)`
   - 输入值在服务器端通过 `input$[id]` 访问

5. **依赖附加** 
   - 使用 `htmltools::attachDependencies()` 附加组件特定的 handler dependency

6. **Update 函数** 
   - 创建 `update_el_[component]()` 函数
   - 应用 `session$ns(id)` 到目标 ID
   - 构建 message 对象,仅包含非 NULL 参数
   - 使用 `session$sendCustomMessage('updateEl[Component]', message)`

7. **JavaScript Handler** 
   - 在 `inst/js/el-[component]-handler.js` 创建处理器
   - 监听 `'shiny:connected'` 事件
   - 使用 `Shiny.addCustomMessageHandler()` 注册
   - 通过 `HTMLWidgets.find('#' + message.id)` 定位 Vue 实例
   - 更新 `widget.instance.[property]` 触发 Vue 响应式更新

**实现示例结构**

```r
el_[component] <- function(id = NULL,
                           [params],
                           session = getDefaultReactiveDomain()) {
  # 1. ID 生成和命名空间
  if (is.null(id)) {
    id <- paste0("el_[component]_", uuid::UUIDgenerate())
  }
  ns_id <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")
  
  # 2. 构建 Element-UI 属性
  component_attrs <- list(
    ":prop" = "dataProp",
    "@event" = "handleEvent"
  )
  
  # 3. 创建组件 UI
  component_ui <- tagList(
    tags$div(
      id = container_id,
      tag("el-[component]", component_attrs)
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el = paste0("#", container_id),
        data = list([reactive_data]),
        methods = list(
          handleEvent = htmlwidgets::JS(sprintf(
            "function(value) { Shiny.setInputValue('%s', value); }", 
            ns_id))
        )
      )
    )
  )
  
  # 4. 附加依赖
  htmltools::attachDependencies(
    component_ui,
    el_[component]_handler_dependency()
  )
}

update_el_[component] <- function(session, id, [params]) {
  ns_id <- session$ns(id)
  message <- list(id = ns_id)
  if (!is.null([param])) message$[param] <- [param]
  
  session$sendCustomMessage('updateEl[Component]', message)
}
```

**关键注意事项**
- 所有组件函数必须导出到 NAMESPACE
- 保持与 Shiny 原生组件一致的输入值命名(直接使用 `id`,不添加后缀)
- 确保 handler dependency 函数名与 JavaScript 文件名匹配
- Vue 响应式系统会自动处理 DOM 更新,无需手动操作 <cite></cite>

## Notes

这个 prompt 模板基于 `el_button` 的完整实现模式 ,涵盖了三层架构(R 层、依赖管理层、客户端渲染层)的所有关键要素。<cite></cite> 开发者可以将此模板应用于任何 Element UI 组件的封装,只需替换组件特定的参数和属性配置。<cite></cite>

### Citations

**File:** R/el_button.R (L1-81)
```r
#' Element UI Button with Vue Instance
#' @param id Button ID (auto-generated if NULL)
#' @param label Button text
#' @param type Button type (primary, success, warning, danger, info, text)
#' @param size Button size (medium, small, mini)
#' @param disabled Whether button is disabled
#' @param icon Icon tag (e.g. el_icon("search"), shiny::icon("star"), fontawesome::fa_icon("github"))
#' @param session Shiny session for module support
#' @export
el_button <- function(id = NULL,
                      label = "Button",
                      type = "default",
                      size = NULL,
                      disabled = FALSE,
                      icon = NULL,
                      session = getDefaultReactiveDomain()) {
  if (is.null(id)) {
    id <- paste0("el_button_", uuid::UUIDgenerate())
  }
  ns_id <- if (!is.null(session)) session$ns(id) else id
  container_id <- paste0(ns_id, "_container")

  button_attrs <- list(
    ":type" = "type",
    ":disabled" = "disabled",
    "@click" = "handleClick"
  )
  if (!is.null(size)) button_attrs[[":size"]] <- "size"

  # 构建按钮内容，只接受 icon 为 shiny.tag
  button_content <- tagList(
    if (!is.null(icon) && inherits(icon, "shiny.tag")) icon,
    "{{label}}"
  )

  component_ui <- tagList(
    tags$div(
      id = container_id,
      tag("el-button", append(button_attrs, button_content))
    ),
    vueR::vue(
      elementId = ns_id,
      list(
        el = paste0("#", container_id),
        data = list(
          label = label,
          type = type,
          size = size,
          disabled = disabled,
          count = 0
        ),
        methods = list(
          handleClick = htmlwidgets::JS(sprintf(
            "function() {\n  if (!this.disabled) {\n    this.count++;\n    Shiny.setInputValue('%s', this.count);\n  }\n}", ns_id))
        )
      )
    )
  )

  htmltools::attachDependencies(
    component_ui,
    el_button_handler_dependency()
  )
}

#' Update Element UI Button
#' @param session Shiny session object
#' @param id Button ID
#' @param label New button label
#' @param type New button type
#' @param disabled New disabled state
#' @export
update_el_button <- function(session, id, label = NULL, type = NULL, disabled = NULL) {
  ns_id <- session$ns(id)
  message <- list(id = ns_id)
  if (!is.null(label)) message$label <- label
  if (!is.null(type)) message$type <- type
  if (!is.null(disabled)) message$disabled <- disabled
  
  session$sendCustomMessage('updateElButton', message)
```

**File:** inst/js/el-button-handler.js (L1-10)
```javascript
$(document).on('shiny:connected', function() {
  Shiny.addCustomMessageHandler('updateElButton', function(message) {
    var widget = HTMLWidgets.find('#' + message.id);
    if (widget && widget.instance) {
      if (message.label !== undefined) widget.instance.label = message.label;
      if (message.type !== undefined) widget.instance.type = message.type;
      if (message.disabled !== undefined) widget.instance.disabled = message.disabled;
    }
  });
});
```

**File:** inst/prompt.md 
```markdown
使用 Shiny.setInputValue(id, value) 而不是 Shiny.setInputValue(id + '_value', value),保持与 Shiny 原生组件一致。
```


## Important
Shiny.setInputValue 在 Vue 实例中用于将前端数据或事件同步到 Shiny input。  
你应该根据交互需求选择注册位置：  

1. **watch**

- 用于监听数据（如 v-model 绑定的 value）变化时自动同步到 Shiny。
- 推荐场景：表单输入、日历选中、滑块等。
- 示例：
```
watch: {
  value: function(val) {
    Shiny.setInputValue('input_id', val);
  }
}
```

2. **methods**

- 用于响应用户操作（如点击、切换、提交等），在事件处理函数中调用。
- 推荐场景：按钮点击、表单提交、手动触发。
- 示例：
```
methods: {
  handleClick: function() {
    Shiny.setInputValue('btn_click', true, {priority: "event"});
  }
}
```

总结：

数据变化自动同步：用 watch
事件驱动同步：用 methods