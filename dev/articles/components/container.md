# Container

Container components for scaffolding basic structure of the page:

`<el-container>`: wrapper container. When nested with a `<el-header>` or
`<el-footer>`, all its child elements will be vertically arranged.
Otherwise horizontally.

`<el-header>`: container for headers.

`<el-aside>`: container for side sections (usually a side nav).

`<el-main>`: container for main sections.

`<el-footer>`: container for footers.

> **Tip**
>
> These components use flex for layout, so please make sure your browser
> supports it. Besides, `<el-container>`’s direct child elements have to
> be one or more of the latter four components. And father element of
> the latter four components must be a `<el-container>`.

## Common layouts

``` r

el_container(el_header("Header"), el_main("Main"))
```

Header

Main

``` r

el_container(el_header("Header"), el_main("Main"), el_footer("Footer"))
```

Header

Main

Footer

``` r

el_container(
  el_aside(width = "200px", "Aside"),
  el_main("Main"),
  el_aside(width = "200px", "Aside")
)
```

Aside

Main

Aside

``` r

el_container(
  el_header("Header"),
  el_container(el_aside(width = "200px", "Aside"), el_main("Main"))
)
```

Header

Aside

Main

``` r

el_container(
  el_header("Header"),
  el_container(
    el_aside(width = "200px", "Aside"),
    el_container(el_main("Main"), el_footer("Footer"))
  )
)
```

Header

Aside

Main

Footer

``` r

el_container(
  el_aside(width = "200px", "Aside"),
  el_container(el_header("Header"), el_main("Main"))
)
```

Aside

Header

Main

``` r

el_container(
  el_aside(width = "200px", "Aside"),
  el_container(el_header("Header"), el_main("Main"), el_footer("Footer"))
)
```

Aside

Header

Main

Footer

## Example

``` r

nav <- function(i, title, icon) {
  list(
    index = i,
    title = title,
    icon = icon,
    children = list(
      list(
        group = TRUE,
        title = "Group 1",
        children = list(
          list(index = paste0(i, "-1"), label = "Option 1"),
          list(index = paste0(i, "-2"), label = "Option 2")
        )
      ),
      list(
        group = TRUE,
        title = "Group 2",
        children = list(list(index = paste0(i, "-3"), label = "Option 3"))
      ),
      list(
        index = paste0(i, "-4"),
        title = "Option 4",
        children = list(list(index = paste0(i, "-4-1"), label = "Option 4-1"))
      )
    )
  )
}
tagList(
  tags$style(
    ".layout-container-demo .el-header { position: relative;
       background-color: var(--el-color-primary-light-7);
       color: var(--el-text-color-primary); }
     .layout-container-demo .el-aside { color: var(--el-text-color-primary);
       background: var(--el-color-primary-light-8); }
     .layout-container-demo .el-menu { border-right: none; }
     .layout-container-demo .el-main { padding: 0; }
     .layout-container-demo .toolbar { display: inline-flex; align-items: center;
       justify-content: center; height: 100%; right: 20px; }"
  ),
  el_container(
    class = "layout-container-demo",
    style = "height: 500px",
    el_aside(
      width = "200px",
      el_scrollbar(
        el_menu(
          "ctr_menu",
          default_openeds = c("1", "3"),
          items = list(
            nav("1", "Navigator One", "Message"),
            nav("2", "Navigator Two", "Menu"),
            nav("3", "Navigator Three", "Setting")
          )
        )
      )
    ),
    el_container(
      el_header(
        style = "text-align: right; font-size: 12px",
        tags$div(
          class = "toolbar",
          el_dropdown(
            "ctr_tools",
            trigger_label = el_icon(
              "Setting",
              style = "margin-right: 8px; margin-top: 1px"
            ),
            items = list(
              el_dropdown_item("view", "View"),
              el_dropdown_item("add", "Add"),
              el_dropdown_item("delete", "Delete")
            )
          ),
          tags$span("Tom")
        )
      ),
      el_main(
        el_scrollbar(
          el_table(
            data = data.frame(
              date = rep("2016-05-02", 20),
              name = "Tom",
              address = "No. 189, Grove St, Los Angeles"
            ),
            columns = list(
              el_table_column("date", "Date", width = 140),
              el_table_column("name", "Name", width = 120),
              el_table_column("address", "Address")
            )
          )
        )
      )
    )
  )
)
```

Tom

## API

Element Plus’s tables, and beside each entry where it is in R.

### Container Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `direction` | `el_container(direction =)` | layout direction for child elements | [^1]`'horizontal' \\| 'vertical'` |  | vertical when nested with `el-header` or `el-footer`; horizontal otherwise |

### Container Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Header Attributes

| Element  | In R                  | Description          | Type | Accepted | Default |
|----------|-----------------------|----------------------|------|----------|---------|
| `height` | `el_header(height =)` | height of the header | [^2] |          | 60px    |

### Header Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Aside Attributes

| Element | In R                | Description               | Type | Accepted | Default |
|---------|---------------------|---------------------------|------|----------|---------|
| `width` | `el_aside(width =)` | width of the side section | [^3] |          | 300px   |

### Aside Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Main Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

### Footer Attributes

| Element  | In R                  | Description          | Type | Accepted | Default |
|----------|-----------------------|----------------------|------|----------|---------|
| `height` | `el_header(height =)` | height of the footer | [^4] |          | 60px    |

### Footer Slots

| Element   | In R            | Description               |
|-----------|-----------------|---------------------------|
| `default` | default content | customize default content |

Main

Main

Main

Main

Main

Main

Main

[^1]: enum

[^2]: string

[^3]: string

[^4]: string
