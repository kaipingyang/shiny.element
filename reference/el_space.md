# Element Plus Space

Even spacing between its items, in a row or a column, wrapping if asked.

## Usage

``` r
el_space(
  ...,
  id = NULL,
  alignment = NULL,
  direction = NULL,
  spacer = NULL,
  size = NULL,
  wrap = NULL,
  fill = NULL,
  fill_ratio = NULL,
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

- alignment:

  Controls the alignment of items. Element Plus's `alignment` ('center'
  \| 'normal' \| 'stretch' \| ...).

- direction:

  Placement direction. Element Plus's `direction` ('vertical' \|
  'horizontal').

- spacer:

  Spacer. Element Plus's `spacer` (string / number / VNode).

- size:

  Spacing size. Element Plus's `size`
  (`'default' | 'small' | 'large' / number / [number, number]`).

- wrap:

  Auto wrapping. Element Plus's `wrap` (boolean).

- fill:

  Whether to fill the container. Element Plus's `fill` (boolean).

- fill_ratio:

  Ratio of fill. Element Plus's `fill-ratio` (number).

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
el_space(
  el_button("a", "One"),
  el_button("b", "Two"),
  el_button("c", "Three"),
  size = 20
)
#> <div id="el_space_ed1f2c87-ef42-4bf8-bb76-e322546875dd" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_space_ed1f2c87-ef42-4bf8-bb76-e322546875dd_container" style="display: contents">
#>   <el-space :alignment="alignment === null ? undefined : alignment" :direction="direction === null ? undefined : direction" :spacer="spacer === null ? undefined : spacer" :size="size === null ? undefined : size" :wrap="wrap === null ? undefined : wrap" :fill="fill === null ? undefined : fill" :fill-ratio="fillRatio === null ? undefined : fillRatio">
#>     <el-button :type="el2_type" :plain="el2_plain" :round="el2_round" :circle="el2_circle" :loading="el2_loading" :disabled="el2_disabled" :native-type="el2_native_type" @click="el2_handleClick" :size="el2_size === null ? undefined : el2_size" :icon="el2_icon === null ? undefined : el2_icon" :autofocus="el2_autofocus === null ? undefined : el2_autofocus" :auto-insert-space="el2_autoInsertSpace === null ? undefined : el2_autoInsertSpace" :bg="el2_bg === null ? undefined : el2_bg" :color="el2_color === null ? undefined : el2_color" :dark="el2_dark === null ? undefined : el2_dark" :dashed="el2_dashed === null ? undefined : el2_dashed" :link="el2_link === null ? undefined : el2_link" :loading-icon="el2_loadingIcon === null ? undefined : el2_loadingIcon" :tag="el2_tag === null ? undefined : el2_tag" :text="el2_text === null ? undefined : el2_text">{{el2_label}}</el-button>
#>     <el-button :type="el3_type" :plain="el3_plain" :round="el3_round" :circle="el3_circle" :loading="el3_loading" :disabled="el3_disabled" :native-type="el3_native_type" @click="el3_handleClick" :size="el3_size === null ? undefined : el3_size" :icon="el3_icon === null ? undefined : el3_icon" :autofocus="el3_autofocus === null ? undefined : el3_autofocus" :auto-insert-space="el3_autoInsertSpace === null ? undefined : el3_autoInsertSpace" :bg="el3_bg === null ? undefined : el3_bg" :color="el3_color === null ? undefined : el3_color" :dark="el3_dark === null ? undefined : el3_dark" :dashed="el3_dashed === null ? undefined : el3_dashed" :link="el3_link === null ? undefined : el3_link" :loading-icon="el3_loadingIcon === null ? undefined : el3_loadingIcon" :tag="el3_tag === null ? undefined : el3_tag" :text="el3_text === null ? undefined : el3_text">{{el3_label}}</el-button>
#>     <el-button :type="el4_type" :plain="el4_plain" :round="el4_round" :circle="el4_circle" :loading="el4_loading" :disabled="el4_disabled" :native-type="el4_native_type" @click="el4_handleClick" :size="el4_size === null ? undefined : el4_size" :icon="el4_icon === null ? undefined : el4_icon" :autofocus="el4_autofocus === null ? undefined : el4_autofocus" :auto-insert-space="el4_autoInsertSpace === null ? undefined : el4_autoInsertSpace" :bg="el4_bg === null ? undefined : el4_bg" :color="el4_color === null ? undefined : el4_color" :dark="el4_dark === null ? undefined : el4_dark" :dashed="el4_dashed === null ? undefined : el4_dashed" :link="el4_link === null ? undefined : el4_link" :loading-icon="el4_loadingIcon === null ? undefined : el4_loadingIcon" :tag="el4_tag === null ? undefined : el4_tag" :text="el4_text === null ? undefined : el4_text">{{el4_label}}</el-button>
#>   </el-space>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"alignment":null,"direction":null,"spacer":null,"size":20,"wrap":null,"fill":null,"fillRatio":null,"el2_label":"One","el2_type":"default","el2_size":null,"el2_plain":false,"el2_round":false,"el2_circle":false,"el2_loading":false,"el2_disabled":false,"el2_native_type":"button","el2_icon":null,"el2_count":0,"el2_autofocus":false,"el2_autoInsertSpace":null,"el2_bg":null,"el2_color":null,"el2_dark":null,"el2_dashed":null,"el2_link":null,"el2_loadingIcon":null,"el2_tag":null,"el2_text":null,"el3_label":"Two","el3_type":"default","el3_size":null,"el3_plain":false,"el3_round":false,"el3_circle":false,"el3_loading":false,"el3_disabled":false,"el3_native_type":"button","el3_icon":null,"el3_count":0,"el3_autofocus":false,"el3_autoInsertSpace":null,"el3_bg":null,"el3_color":null,"el3_dark":null,"el3_dashed":null,"el3_link":null,"el3_loadingIcon":null,"el3_tag":null,"el3_text":null,"el4_label":"Three","el4_type":"default","el4_size":null,"el4_plain":false,"el4_round":false,"el4_circle":false,"el4_loading":false,"el4_disabled":false,"el4_native_type":"button","el4_icon":null,"el4_count":0,"el4_autofocus":false,"el4_autoInsertSpace":null,"el4_bg":null,"el4_color":null,"el4_dark":null,"el4_dashed":null,"el4_link":null,"el4_loadingIcon":null,"el4_tag":null,"el4_text":null},"methods":{"el2_handleClick":"function() { if (this.el2_disabled || this.el2_loading) return; this.el2_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('a:shiny.action', this.el2_count); }","el3_handleClick":"function() { if (this.el3_disabled || this.el3_loading) return; this.el3_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('b:shiny.action', this.el3_count); }","el4_handleClick":"function() { if (this.el4_disabled || this.el4_loading) return; this.el4_count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('c:shiny.action', this.el4_count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"a:shiny.action\", self.el2_count); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"b:shiny.action\", self.el3_count); window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"c:shiny.action\", self.el4_count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._elReport; self._elReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"evals":["options.methods.el2_handleClick","options.methods.el3_handleClick","options.methods.el4_handleClick","options.mounted"]}</script>
#> </div>
```
