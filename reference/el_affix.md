# Element Plus Affix

Content that stays fixed to the top or bottom of the viewport once
scrolled to it.

## Usage

``` r
el_affix(
  ...,
  id = NULL,
  offset = NULL,
  position = NULL,
  target = NULL,
  z_index = NULL,
  teleported = NULL,
  append_to = NULL,
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

- offset:

  Offset distance. Element Plus's `offset` (number).

- position:

  Position of affix. Element Plus's `position` ('top' \| 'bottom').

- target:

  Target container (CSS selector). Element Plus's `target` (string).

- z_index:

  `z-index` of affix. Element Plus's `z-index` (number).

- teleported:

  Whether affix element is teleported, if `true` it will be teleported
  to where `append-to` sets. Element Plus's `teleported` (boolean).

- append_to:

  Which element the affix element appends to. Element Plus's `append-to`
  (CSSSelector / HTMLElement).

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents. A scoped slot is written with
  [`template()`](https://kaipingyang.github.io/shiny.element/reference/template.md).

## Value

A Shiny UI element.

## Shiny inputs

- `input$<id>_change` – Element Plus's `change` event.

- `input$<id>_scroll` – Element Plus's `scroll` event.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/reference/call_el.md):
[`update()`](https://rdrr.io/r/stats/update.html), `updateRoot()`.

## Examples

``` r
el_affix(el_button("top", "Stays on top"), offset = 120)
#> <div id="el_affix_f38c01ef-7400-46b0-af03-6bd24b444fe6" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_affix_f38c01ef-7400-46b0-af03-6bd24b444fe6_container" style="display: contents">
#>   <el-affix :offset="offset === null ? undefined : offset" :position="position === null ? undefined : position" :target="target === null ? undefined : target" :z-index="zIndex === null ? undefined : zIndex" :teleported="teleported === null ? undefined : teleported" :append-to="appendTo === null ? undefined : appendTo" @change="elEmitChange" @scroll="elEmitScroll">
#>     <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#>   </el-affix>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"offset":120,"position":null,"target":null,"zIndex":null,"teleported":null,"appendTo":null,"label":"Stays on top","type":"default","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"elEmitChange":"function() { window.shinyVue.emit('el_affix_f38c01ef-7400-46b0-af03-6bd24b444fe6', 'change', arguments); }","elEmitScroll":"function() { window.shinyVue.emit('el_affix_f38c01ef-7400-46b0-af03-6bd24b444fe6', 'scroll', arguments, 200); }","handleClick":"function() { if (this.disabled || this.loading) return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('top:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"top:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"generated":true,"evals":["options.methods.elEmitChange","options.methods.elEmitScroll","options.methods.handleClick","options.mounted"]}</script>
#> </div>
```
