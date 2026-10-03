# Element Plus Divider

Renders a horizontal or vertical dividing line, optionally with inline
text.

## Usage

``` r
el_divider(
  content = NULL,
  direction = "horizontal",
  content_position = "center",
  border_style = "solid"
)
```

## Arguments

- content:

  Optional text/tag placed inside the divider. Only for
  `direction = "horizontal"`.

- direction:

  Divider orientation: `"horizontal"` (default) or `"vertical"`.

- content_position:

  Position of inline text when `content` is supplied: `"center"`
  (default), `"left"`, or `"right"`.

- border_style:

  The line's style, as CSS `border-style`: `"solid"` (the default),
  `"dashed"`, `"dotted"`.

## Value

An `htmltools` tag.

## Examples

``` r
el_divider()
#> <div class="el-divider el-divider--horizontal" role="separator"></div>
el_divider("Title Text", content_position = "left")
#> <div class="el-divider el-divider--horizontal" role="separator">
#>   <div class="el-divider__text is-left">Title Text</div>
#> </div>
el_divider(direction = "vertical")
#> <div class="el-divider el-divider--vertical" role="separator"></div>
```
