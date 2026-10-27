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
  slots = NULL,
  events = NULL,
  on = NULL
)

update_el_affix(
  session = shiny::getDefaultReactiveDomain(),
  id,
  offset = NULL,
  position = NULL,
  z_index = NULL,
  target = NULL,
  teleported = NULL,
  append_to = NULL
)
```

## Arguments

- ...:

  Its content: any Shiny UI. Components of this package are folded into
  this one's Vue instance, as
  [`el_button_group()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_button_group.md)
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
  [`template()`](https://kaipingyang.github.io/shiny.element/dev/reference/template.md).

- events:

  Element's events to report besides those reported unasked, by name:
  `events = "node_drop"` reports `input$<id>_node_drop`. The component's
  are listed under "Shiny inputs", and by
  [`el_events()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_events.md);
  a name it does not have is an error.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_widget.md).

- session:

  Shiny session; the current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Shiny inputs

|  |  |  |
|----|----|----|
| Input | Reported | Value |
| `input$<id>_change` | unasked | triggers when fixed state changed |
| `input$<id>_scroll` | `events = "scroll"` | `list(scrollTop, fixed)`, at most every 200 ms |

The same list as `el_events("el_affix")`, which says how an event's
arguments travel.

## Element methods

Callable with
[`call_el()`](https://kaipingyang.github.io/shiny.element/dev/reference/call_el.md):
[`update()`](https://rdrr.io/r/stats/update.html), `updateRoot()`.

## Updating from the server

`update_el_affix()` changes the component from the server: every
argument of `el_affix()` that can change once it is drawn, under the
same name. One left `NULL` stays as it is; `NA` returns it to Element's
default.

`update_el_affix()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_affix(el_button("top", "Stays on top"), offset = 120)
#> <div id="el_affix_be4a89cb-add9-413f-9b76-5d8faa6b077e" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="el_affix_be4a89cb-add9-413f-9b76-5d8faa6b077e_container" style="display: contents">
#>   <el-affix v-bind="$optional(&#39;affix&#39;)" @change="svEmitChange">
#>     <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" ref="sv_top" id="top">{{label}}</el-button>
#>   </el-affix>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"offset":120,"position":null,"target":null,"zIndex":null,"teleported":null,"appendTo":null,"label":"Stays on top","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":null,"plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"svEmitChange":"function() { window.shinyVue.emit('el_affix_be4a89cb-add9-413f-9b76-5d8faa6b077e', 'change', arguments); }","handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('top:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"top:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"affix":{"offset":"offset","position":"position","target":"target","z-index":"zIndex","teleported":"teleported","append-to":"appendTo"},"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"absorbed":{"top":{"fields":{"label":"label","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","count":"count","state":"state","size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_top"}},"generated":true,"evals":["options.methods.svEmitChange","options.methods.handleClick","options.mounted"]}</script>
#> </div>
```
