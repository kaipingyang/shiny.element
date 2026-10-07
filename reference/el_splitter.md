# Element Plus Splitter

Panels side by side, or one above the other, resized by dragging the
bars between them. Give it
[`el_splitter_panel()`](https://kaipingyang.github.io/shiny.element/reference/el_splitter_panel.md)s.

## Usage

``` r
el_splitter(
  ...,
  id = NULL,
  layout = NULL,
  lazy = NULL,
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

- layout:

  Layout direction of the splitter. Element Plus's `layout`
  ('horizontal' \| 'vertical').

- lazy:

  Whether to enable lazy mode. Element Plus's `lazy` (boolean).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_resize_start` – Element Plus's `resize-start` event.

- `input$<id>_resize` – Element Plus's `resize` event.

- `input$<id>_resize_end` – Element Plus's `resize-end` event.

- `input$<id>_collapse` – Element Plus's `collapse` event.

## Examples

``` r
el_splitter(el_splitter_panel("Left", size = "30%"), el_splitter_panel("Right"))
#> <div id="el_splitter_768efa6a-c186-479e-bf37-185c35750f9a" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_splitter_768efa6a-c186-479e-bf37-185c35750f9a_container" style="display: contents">
#>   <el-splitter :layout="layout === null ? undefined : layout" :lazy="lazy === null ? undefined : lazy" @resize-start="elEmitResizeStart" @resize="elEmitResize" @resize-end="elEmitResizeEnd" @collapse="elEmitCollapse">
#>     <el-splitter-panel :size="size === null ? undefined : size" :min="min === null ? undefined : min" :max="max === null ? undefined : max" :resizable="resizable === null ? undefined : resizable" :collapsible="collapsible === null ? undefined : collapsible">Left</el-splitter-panel>
#>     <el-splitter-panel :size="el3_size === null ? undefined : el3_size" :min="el3_min === null ? undefined : el3_min" :max="el3_max === null ? undefined : el3_max" :resizable="el3_resizable === null ? undefined : el3_resizable" :collapsible="el3_collapsible === null ? undefined : el3_collapsible">Right</el-splitter-panel>
#>   </el-splitter>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"layout":null,"lazy":null,"size":"30%","min":null,"max":null,"resizable":null,"collapsible":null,"el3_size":null,"el3_min":null,"el3_max":null,"el3_resizable":null,"el3_collapsible":null},"methods":{"elEmitResizeStart":"function() { window.shinyVue.emit('el_splitter_768efa6a-c186-479e-bf37-185c35750f9a', 'resize_start', arguments); }","elEmitResize":"function() { window.shinyVue.emit('el_splitter_768efa6a-c186-479e-bf37-185c35750f9a', 'resize', arguments, 200); }","elEmitResizeEnd":"function() { window.shinyVue.emit('el_splitter_768efa6a-c186-479e-bf37-185c35750f9a', 'resize_end', arguments); }","elEmitCollapse":"function() { window.shinyVue.emit('el_splitter_768efa6a-c186-479e-bf37-185c35750f9a', 'collapse', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.elEmitResizeStart","options.methods.elEmitResize","options.methods.elEmitResizeEnd","options.methods.elEmitCollapse"]}</script>
#> </div>
```
