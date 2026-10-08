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

update_el_splitter(
  session = shiny::getDefaultReactiveDomain(),
  id,
  layout = NULL,
  lazy = NULL
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

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_resize_start` – Element Plus's `resize-start` event.

- `input$<id>_resize` – Element Plus's `resize` event.

- `input$<id>_resize_end` – Element Plus's `resize-end` event.

- `input$<id>_collapse` – Element Plus's `collapse` event.

## Updating from the server

`update_el_splitter()` changes the component from the server: every
argument of `el_splitter()` that can change once it is drawn, under the
same name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

`update_el_splitter()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_splitter(el_splitter_panel("Left", size = "30%"), el_splitter_panel("Right"))
#> <div id="el_splitter_b3f3e864-e510-4f37-9663-71546f217766" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_splitter_b3f3e864-e510-4f37-9663-71546f217766_container" style="display: contents">
#>   <el-splitter :layout="layout === null ? undefined : layout" :lazy="lazy === null ? undefined : lazy" @resize-start="elEmitResizeStart" @resize="elEmitResize" @resize-end="elEmitResizeEnd" @collapse="elEmitCollapse">
#>     <el-splitter-panel :size="size === null ? undefined : size" :min="min === null ? undefined : min" :max="max === null ? undefined : max" :resizable="resizable === null ? undefined : resizable" :collapsible="collapsible === null ? undefined : collapsible" ref="sv_el_splitter_panel_06485701_4340_4282_99b3_e6248e20afcd" id="el_splitter_panel_06485701-4340-4282-99b3-e6248e20afcd">Left</el-splitter-panel>
#>     <el-splitter-panel :size="el3_size === null ? undefined : el3_size" :min="el3_min === null ? undefined : el3_min" :max="el3_max === null ? undefined : el3_max" :resizable="el3_resizable === null ? undefined : el3_resizable" :collapsible="el3_collapsible === null ? undefined : el3_collapsible" ref="sv_el_splitter_panel_67c58d1e_9f8d_493a_a591_e842654da06b" id="el_splitter_panel_67c58d1e-9f8d-493a-a591-e842654da06b">Right</el-splitter-panel>
#>   </el-splitter>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"layout":null,"lazy":null,"size":"30%","min":null,"max":null,"resizable":null,"collapsible":null,"el3_size":null,"el3_min":null,"el3_max":null,"el3_resizable":null,"el3_collapsible":null},"methods":{"elEmitResizeStart":"function() { window.shinyVue.emit('el_splitter_b3f3e864-e510-4f37-9663-71546f217766', 'resize_start', arguments); }","elEmitResize":"function() { window.shinyVue.emit('el_splitter_b3f3e864-e510-4f37-9663-71546f217766', 'resize', arguments, 200); }","elEmitResizeEnd":"function() { window.shinyVue.emit('el_splitter_b3f3e864-e510-4f37-9663-71546f217766', 'resize_end', arguments); }","elEmitCollapse":"function() { window.shinyVue.emit('el_splitter_b3f3e864-e510-4f37-9663-71546f217766', 'collapse', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"el_splitter_panel_06485701-4340-4282-99b3-e6248e20afcd":{"fields":{"size":"size","min":"min","max":"max","resizable":"resizable","collapsible":"collapsible"},"ref":"sv_el_splitter_panel_06485701_4340_4282_99b3_e6248e20afcd"},"el_splitter_panel_67c58d1e-9f8d-493a-a591-e842654da06b":{"fields":{"size":"el3_size","min":"el3_min","max":"el3_max","resizable":"el3_resizable","collapsible":"el3_collapsible"},"ref":"sv_el_splitter_panel_67c58d1e_9f8d_493a_a591_e842654da06b"}},"generated":true,"evals":["options.methods.elEmitResizeStart","options.methods.elEmitResize","options.methods.elEmitResizeEnd","options.methods.elEmitCollapse"]}</script>
#> </div>
```
