# Element Plus Watermark

Text or an image repeated over its content, faintly.

## Usage

``` r
el_watermark(
  ...,
  id = NULL,
  watermark_width = NULL,
  height = NULL,
  rotate = NULL,
  z_index = NULL,
  image = NULL,
  content = NULL,
  font = NULL,
  gap = NULL,
  offset = NULL,
  width = NULL,
  slots = NULL,
  on = NULL
)

update_el_watermark(
  session = shiny::getDefaultReactiveDomain(),
  id,
  watermark_width = NULL,
  height = NULL,
  rotate = NULL,
  z_index = NULL,
  image = NULL,
  content = NULL,
  font = NULL,
  gap = NULL,
  offset = NULL
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

- watermark_width:

  The width of the watermark, the default value of `content` is its own
  width. Element Plus's `width` (number).

- height:

  The height of the watermark, the default value of `content` is its own
  height. Element Plus's `height` (number).

- rotate:

  When the watermark is drawn, the rotation angle, in degrees. Element
  Plus's `rotate` (number).

- z_index:

  The z-index of the appended watermark element. Element Plus's
  `z-index` (number).

- image:

  Image source, it is recommended to export 2x or 3x image, high
  priority. Element Plus's `image` (string).

- content:

  Watermark text content. Element Plus's `content`
  (`string / string[]`).

- font:

  Text style. Element Plus's `font`.

- gap:

  The spacing between watermarks. Element Plus's `gap`
  (`[number, number]`).

- offset:

  The offset of the watermark from the upper left corner of the
  container. The default is `gap/2`. Element Plus's `offset`
  (`[number, number]`).

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

`update_el_watermark()` changes the component from the server: every
argument of `el_watermark()` that can change once it is drawn, under the
same name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

`update_el_watermark()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_watermark(content = "Confidential", shiny::tags$div(style = "height: 300px"))
#> <div id="el_watermark_7ffb4c23-eb9c-4a16-8e44-ffe1c9c1e3a0" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_watermark_7ffb4c23-eb9c-4a16-8e44-ffe1c9c1e3a0_container" style="display: contents">
#>   <el-watermark :width="width === null ? undefined : width" :height="height === null ? undefined : height" :rotate="rotate === null ? undefined : rotate" :z-index="zIndex === null ? undefined : zIndex" :image="image === null ? undefined : image" :content="content === null ? undefined : content" :font="font === null ? undefined : font" :gap="gap === null ? undefined : gap" :offset="offset === null ? undefined : offset">
#>     <div style="height: 300px"></div>
#>   </el-watermark>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"width":null,"height":null,"rotate":null,"zIndex":null,"image":null,"content":"Confidential","font":null,"gap":null,"offset":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":[]}</script>
#> </div>
```
