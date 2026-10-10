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
  slots = NULL,
  on = NULL
)

update_el_text(
  session = shiny::getDefaultReactiveDomain(),
  id,
  type = NULL,
  size = NULL,
  truncated = NULL,
  line_clamp = NULL,
  tag = NULL
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

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

None: it reports nothing.

## Updating from the server

`update_el_text()` changes the component from the server: every argument
of `el_text()` that can change once it is drawn, under the same name.
One left `NULL` stays as it is; `NA` returns it to Element's default.

`update_el_text()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_text("Primary text", type = "primary")
#> <div id="el_text_a0942afc-31cf-45a3-bd71-06af4b0566e2" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_text_a0942afc-31cf-45a3-bd71-06af4b0566e2_container" style="display: contents">
#>   <el-text :type="type === null ? undefined : type" :size="size === null ? undefined : size" :truncated="truncated === null ? undefined : truncated" :line-clamp="lineClamp === null ? undefined : lineClamp" :tag="tag === null ? undefined : tag">Primary text</el-text>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"type":"primary","size":null,"truncated":null,"lineClamp":null,"tag":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":[]}</script>
#> </div>
el_text(strrep("A long sentence. ", 20), truncated = TRUE)
#> <div id="el_text_3b24ee67-069a-49b5-9ba8-eb3f3e37e665" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_text_3b24ee67-069a-49b5-9ba8-eb3f3e37e665_container" style="display: contents">
#>   <el-text :type="type === null ? undefined : type" :size="size === null ? undefined : size" :truncated="truncated === null ? undefined : truncated" :line-clamp="lineClamp === null ? undefined : lineClamp" :tag="tag === null ? undefined : tag">A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. A long sentence. </el-text>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"type":null,"size":null,"truncated":true,"lineClamp":null,"tag":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":[]}</script>
#> </div>
```
