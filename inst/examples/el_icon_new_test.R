devtools::load_all()

# 1. 基础用法
el_icon("search")

# 2. 大写 + 空格标准化
el_icon("ARROW LEFT")

# 3. 误传前缀不会重复
el_icon("el-icon-edit")

# 4. 带 size
el_icon("star", size = "2em")

# 5. 带 title → 自动 sem（aria-label）
el_icon("delete", title = "删除")

# 6. 强制 deco（aria-hidden）
el_icon("close", a11y = "deco")

# 7. 强制 none（无 aria）
el_icon("check", a11y = "none")

# 8. 额外 class
el_icon("search", class = "my-icon")

# 9. 额外 HTML 属性
el_icon("search", id = "icon-search")

# 10. lib = "none"（纯 <i>）
el_icon("search", lib = "none", class = "custom")

# 11. lib = "font-awesome"
el_icon("magnifying-glass", lib = "font-awesome")
