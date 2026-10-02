# PageHeader

If the path of the page is simple, a page header instead of a
breadcrumb. `input$<id>_back` fires when the back arrow is clicked.

## Basic

``` r

el_page_header("head", content = "detail")
```

## API

### Attributes

| Element   | In R      | Description | Type   | Accepted | Default |
|-----------|-----------|-------------|--------|----------|---------|
| `title`   | `title`   | main title  | string | —        | Back    |
| `content` | `content` | content     | string | —        | —       |

### Events

| Element | In R              | Description                         |
|---------|-------------------|-------------------------------------|
| `back`  | `input$<id>_back` | triggers when right side is clicked |

### Slots

| Element   | In R                       | Description   |
|-----------|----------------------------|---------------|
| `title`   | `slots = list(title = )`   | title content |
| `content` | `slots = list(content = )` | content       |
