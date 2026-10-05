# Element Plus Text

Text in Element's colours and sizes, truncated to a line or a number of
lines if asked.

## Usage

``` r
el_text(
  ...,
  id = NULL,
  type = NULL,
  size = NULL,
  truncated = NULL,
  line_clamp = NULL,
  tag = NULL,
  width = NULL,
  slots = NULL
)
```

## Arguments

- ...:

  Its content: any Shiny UI. Components of this package are folded into
  this one's Vue instance, as
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/reference/el_button_group.md)
  folds its buttons.

- id:

  Component ID. Auto-generated if `NULL`.

- type:

  Text type. Element Plus's `type` ('primary' \| 'success' \| 'warning'
  \| 'danger' \| 'info').

- size:

  Text size. Element Plus's `size` ('large' \| 'default' \| 'small').

- truncated:

  Render ellipsis. Element Plus's `truncated` (boolean).

- line_clamp:

  Maximum lines. Element Plus's `line-clamp` (string / number).

- tag:

  Custom element tag. Element Plus's `tag` (string).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

None: it reports nothing.

## Examples

``` r
el_text("Primary text", type = "primary")
#> <div id="el_text_06da59bc-0778-4808-885b-5ac69fff10d6" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_text_06da59bc-0778-4808-885b-5ac69fff10d6_container" style="display: contents">
#>   <el-text :type="type === null ? undefined : type" :size="size === null ? undefined : size" :truncated="truncated === null ? undefined : truncated" :line-clamp="lineClamp === null ? undefined : lineClamp" :tag="tag === null ? undefined : tag">Primary text</el-text>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"type":"primary","size":null,"truncated":null,"lineClamp":null,"tag":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":[]}</script>
#> </div>
el_text(strrep("A long sentence. ", 20), truncated = TRUE)
#> <div id="el_text_0b823c6b-9a9a-4543-959e-4a3200d48a5d" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_text_0b823c6b-9a9a-4543-959e-4a3200d48a5d_container" style="display: contents">
#>   <el-text :type="type === null ? undefined : type" :size="size === null ? undefined : size" :truncated="truncated === null ? undefined : truncated" :line-clamp="lineClamp === null ? undefined : lineClamp" :tag="tag === null ? undefined : tag">A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. </el-text>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"type":null,"size":null,"truncated":true,"lineClamp":null,"tag":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":[]}</script>
#> </div>
```
