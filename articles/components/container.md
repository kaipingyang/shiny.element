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

el_container(
  style = "height: 400px; border: 1px solid var(--el-border-color)",
  el_aside(
    width = "200px",
    el_menu(
      "ctr_menu",
      active = "1-1",
      items = list(
        list(
          index = "1",
          title = "Navigator One",
          icon = "Message",
          children = list(
            list(index = "1-1", label = "Option 1"),
            list(index = "1-2", label = "Option 2")
          )
        ),
        list(
          index = "2",
          title = "Navigator Two",
          icon = "Menu",
          children = list(
            list(index = "2-1", label = "Option 1")
          )
        )
      )
    )
  ),
  el_container(
    el_header(style = "text-align: right; font-size: 12px", tags$span("Tom")),
    el_main(el_table(
      data = data.frame(
        Date = rep("2016-05-02", 4),
        Name = rep("Tom", 4),
        Address = rep("No. 189, Grove St, Los Angeles", 4)
      )
    ))
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
