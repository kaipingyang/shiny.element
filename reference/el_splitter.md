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
  slots = NULL,
  events = NULL,
  on = NULL
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

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/reference/el_events.md);
  a name it does not have is an error.

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

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>_resize_start` | `events = "resize_start"` | Triggered when starting to resize a panel, index is the drag bar index |
| `input$<id>_resize` | `events = "resize"` | the sizes, at most every 200 ms |
| `input$<id>_resize_end` | unasked | Triggered when panel resizing ends, index is the drag bar index |
| `input$<id>_collapse` | unasked | Triggered when a panel is collapsed, index is the drag bar index |

The same list as `el_events("el_splitter")`, which says how an event's
arguments travel.

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
#> <div id="el_splitter_bead26cb-f301-46b8-af2e-3d8a60ed0a6a" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_splitter_bead26cb-f301-46b8-af2e-3d8a60ed0a6a_container" style="display: contents">
#>   <el-splitter :layout="layout === null ? undefined : layout" :lazy="lazy === null ? undefined : lazy" @resize-end="svEmitResizeEnd" @collapse="svEmitCollapse">
#>     <el-splitter-panel :size="size === null ? undefined : size" :min="min === null ? undefined : min" :max="max === null ? undefined : max" :resizable="resizable === null ? undefined : resizable" :collapsible="collapsible === null ? undefined : collapsible" ref="sv_el_splitter_panel_6f03598e_67f2_4d2e_9405_a556fecf3c48" id="el_splitter_panel_6f03598e-67f2-4d2e-9405-a556fecf3c48">Left</el-splitter-panel>
#>     <el-splitter-panel :size="el3_size === null ? undefined : el3_size" :min="el3_min === null ? undefined : el3_min" :max="el3_max === null ? undefined : el3_max" :resizable="el3_resizable === null ? undefined : el3_resizable" :collapsible="el3_collapsible === null ? undefined : el3_collapsible" ref="sv_el_splitter_panel_adb7d096_cbc1_4f4e_a195_78dc7e9eb392" id="el_splitter_panel_adb7d096-cbc1-4f4e-a195-78dc7e9eb392">Right</el-splitter-panel>
#>   </el-splitter>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"layout":null,"lazy":null,"size":"30%","min":null,"max":null,"resizable":null,"collapsible":null,"el3_size":null,"el3_min":null,"el3_max":null,"el3_resizable":null,"el3_collapsible":null},"methods":{"svEmitResizeEnd":"function() { window.shinyVue.emit('el_splitter_bead26cb-f301-46b8-af2e-3d8a60ed0a6a', 'resize_end', arguments); }","svEmitCollapse":"function() { window.shinyVue.emit('el_splitter_bead26cb-f301-46b8-af2e-3d8a60ed0a6a', 'collapse', arguments); }"}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"el_splitter_panel_6f03598e-67f2-4d2e-9405-a556fecf3c48":{"fields":{"size":"size","min":"min","max":"max","resizable":"resizable","collapsible":"collapsible"},"ref":"sv_el_splitter_panel_6f03598e_67f2_4d2e_9405_a556fecf3c48"},"el_splitter_panel_adb7d096-cbc1-4f4e-a195-78dc7e9eb392":{"fields":{"size":"el3_size","min":"el3_min","max":"el3_max","resizable":"el3_resizable","collapsible":"el3_collapsible"},"ref":"sv_el_splitter_panel_adb7d096_cbc1_4f4e_a195_78dc7e9eb392"}},"generated":true,"evals":["options.methods.svEmitResizeEnd","options.methods.svEmitCollapse"]}</script>
#> </div>
```
