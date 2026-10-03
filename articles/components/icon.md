# Icon

Element Plus provides a set of common icons: the SVG components of
`@element-plus/icons-vue`, which this package bundles and registers.
Each has a PascalCase name – `Edit`, `Search`, `CircleCloseFilled` – and
[`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md)
draws one by that name. Any component argument that takes an icon
(`icon`, `prefix_icon`, `suffix_icon`, …) takes the same names.

Element UI’s class names still work: `"el-icon-edit"` and `"edit"` are
read as `Edit`, and the few renamed upstream – `"el-icon-user-solid"` –
as their new names (`UserFilled`).

## Simple Usage

`size` and `color` are `el-icon`’s own props.

``` r

tagList(
  el_icon("Edit", size = 30),
  el_icon("Edit", size = 30, color = "#409efc"))
```

## Combined with el-icon

An icon inherits the colour and size of the text around it, unless it is
given its own; `class = "is-loading"` spins it.

``` r

tags$p(style = "font-size: 20px",
  el_icon("Edit", size = 20),
  el_icon("Share", color = "#409efc"),
  el_icon("Delete"),
  el_icon("Loading", class = "is-loading"),
  el_button("search", "Search", type = "primary", icon = "Search"))
```

## In a Vue template

Inside a component’s slot or
[`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md),
write the icon as Element Plus does: `<el-icon><Edit /></el-icon>`. Each
icon is also registered as `el-icon-<kebab-name>`, so `<el-icon-edit />`
draws the bare SVG.

``` r

el_button("tpl", type = "primary", slots = list(
  default = template(HTML("<el-icon><Upload /></el-icon><span>Upload</span>"))))
```

## Other libraries

`el_icon(lib = "font-awesome")` draws a Font Awesome icon instead,
through the fontawesome package.

``` r

tagList(el_icon("r-project", lib = "font-awesome", size = 24),
        el_icon("github", lib = "font-awesome", size = 24))
```

## Icon Collection

Every icon of `@element-plus/icons-vue`, by the name
[`el_icon()`](https://kaipingyang.github.io/shiny.element/reference/el_icon.md)
takes:

``` r

js <- readLines(system.file("element-plus", "icons-vue.iife.min.js",
                            package = "shiny.element"), warn = FALSE)
names <- sort(unique(regmatches(js, gregexpr('(?<=name:")[A-Z][A-Za-z0-9]*(?=")', js, perl = TRUE))[[1]]))
tags$div(style = "display: flex; flex-wrap: wrap; border-top: 1px solid var(--el-border-color)",
  lapply(names, function(n) tags$div(
    style = "width: 16.66%; min-width: 110px; height: 90px; text-align: center; font-size: 12px;
             color: var(--el-text-color-regular); border-right: 1px solid var(--el-border-color);
             border-bottom: 1px solid var(--el-border-color); padding-top: 18px",
    el_icon(n, size = 22), tags$div(style = "margin-top: 8px", n))))
```

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `color` | `color` | SVG tag’s fill attribute | [^1] |  | inherit from color |
| `size` | `size` | SVG icon size, size x size | [^2] / [^3] |  | inherit from font size |

### Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | Customize default content |

[^1]: string

[^2]: number

[^3]: string
