# Page

If path of the page is simple, it is recommended to use PageHeader
instead of the Breadcrumb.

## Complete example

Back is `input$<id>_back`.

``` r

el_page_header(
  "ph_full",
  slots = list(
    breadcrumb = el_breadcrumb(
      "ph_crumbs",
      items = list(
        list(label = "homepage", to = "./page-header.html"),
        list(label = "route 1"),
        list(label = "route 2")
      )
    ),
    content = tags$div(
      style = "display: flex; align-items: center",
      el_avatar(
        size = 32,
        src = "https://avatars.githubusercontent.com/u/72015883?v=4"
      ),
      tags$span(style = "margin: 0 12px; font-weight: 600", "Title"),
      tags$span(style = "margin-right: 12px; font-size: 13px", "Sub title"),
      el_tag("ph_tag", "Default")
    ),
    extra = tags$div(
      el_button("ph_print", "Print"),
      el_button("ph_edit", "Edit", type = "primary")
    )
  )
)
```

## Basic usage

Standard page header, for simply scenarios.

``` r

el_page_header(
  "ph_basic",
  slots = list(content = tags$span(style = "font-weight: 600", "Title"))
)
```

## Custom icon

The default icon might not meet your satisfaction, you can customize the
icon by setting `icon` attribute like the example.

``` r

el_page_header(
  "ph_icon",
  icon = "ArrowLeft",
  slots = list(content = tags$span(style = "font-weight: 600", "Title"))
)
```

## No icon

Sometimes the page is just full of elements, and you might not want the
icon to show up on the page, you can set the `icon` attribute to `""` to
get rid of it.

``` r

el_page_header(
  "ph_noicon",
  icon = "",
  slots = list(content = tags$span(style = "font-weight: 600", "Title"))
)
```

## Breadcrumbs

Page header allows you to add breadcrumbs for giving route information
to the users by `breadcrumb` slot.

``` r

el_page_header(
  "ph_bc",
  slots = list(
    breadcrumb = el_breadcrumb(
      "ph_bc_crumbs",
      items = list(
        list(label = "homepage", to = "./page-header.html"),
        list(label = "route 1"),
        list(label = "route 2")
      )
    ),
    content = tags$span(style = "font-weight: 600", "Title")
  )
)
```

## Additional operation section

The header can be as complicated as needed, you may add additional
sections to the header, to allow rich interactions.

``` r

el_page_header(
  "ph_extra",
  icon = "",
  slots = list(
    content = tags$div(
      style = "display: flex; align-items: center",
      el_avatar(size = 32, content = "T"),
      tags$span(style = "margin-left: 12px; font-weight: 600", "Title")
    ),
    extra = tags$div(
      el_button("ph_x1", "Print"),
      el_button("ph_x2", "Edit", type = "primary")
    )
  )
)
```

## Main content

Sometimes we want the head to show with some co-responding content, we
can utilize the `default` slot for doing so.

``` r

el_page_header(
  "ph_main",
  slots = list(
    content = tags$span(style = "font-weight: 600", "Title"),
    default = tags$div(
      style = "margin-top: 16px; font-size: 13px; font-weight: bold",
      "Your additional content can be added with default slot, You may put as many content as you want here."
    )
  )
)
```

## Anatomy

The component is consisted of these parts

## API

Element Plus’s tables, and beside each entry where it is in R.

### Attributes

| Element | In R | Description | Type | Accepted | Default |
|----|----|----|----|----|----|
| `icon` | `icon` | icon component of page header | [^1] / [^2] |  | Back |
| `title` | `title` | main title of page header, default is Back that built-in a11y | [^3] |  | ’’ |
| `content` | `content` | content of page header | [^4] |  | ’’ |

### Events

| Element | In R              | Description                         |
|---------|-------------------|-------------------------------------|
| `back`  | `input$<id>_back` | triggers when right side is clicked |

### Slots

| Element      | In R                          | Description           |
|--------------|-------------------------------|-----------------------|
| `icon`       | `slots = list(icon = )`       | content as icon       |
| `title`      | `slots = list(title = )`      | content as title      |
| `content`    | `slots = list(content = )`    | content               |
| `extra`      | `slots = list(extra = )`      | extra                 |
| `breadcrumb` | `slots = list(breadcrumb = )` | content as breadcrumb |
| `default`    | default content               | main content          |

[^1]: string

[^2]: Component

[^3]: string

[^4]: string
