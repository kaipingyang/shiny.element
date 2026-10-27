# Element Plus Badge

Wraps any content with a numeric badge or red dot in the top-right
corner. When used without content, renders a standalone badge element.

## Usage

``` r
el_badge(
  ...,
  value = NULL,
  max = NULL,
  is_dot = FALSE,
  hidden = FALSE,
  type = NULL,
  id = NULL,
  show_zero = TRUE,
  color = NULL,
  offset = NULL,
  badge_style = NULL,
  badge_class = NULL,
  on = NULL
)

update_el_badge(
  session = shiny::getDefaultReactiveDomain(),
  id,
  value = NULL,
  max = NULL,
  is_dot = NULL,
  hidden = NULL,
  type = NULL
)
```

## Arguments

- ...:

  Content to wrap (e.g. a button or icon).

- value:

  Badge value: number or string. Ignored when `is_dot = TRUE`.

- max:

  Maximum numeric value to display. When `value > max` the badge shows
  `"<max>+"`. Only applies when `value` is numeric.

- is_dot:

  Show a small dot instead of a number. Default `FALSE`.

- hidden:

  Whether to hide the badge. Default `FALSE`.

- type:

  Badge colour type: `NULL` (red, default), `"primary"`, `"success"`,
  `"warning"`, `"info"`, `"danger"`.

- id:

  Give the badge an id and `update_el_badge()` can change it – a count
  of unread messages, say. A component inside is then folded into the
  badge's Vue instance, as for
  [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_tooltip.md):
  it keeps reporting, but is reached through
  [`update_vue()`](https://kaipingyang.github.io/shiny.element/dev/reference/update_vue.md)
  on the badge's id.

- show_zero:

  Whether a value of `0` is shown. Default `TRUE`.

- color:

  Background colour of the badge.

- offset:

  Offset of the badge, `c(x, y)` in pixels.

- badge_style, badge_class:

  Extra CSS – a string or a named list – and class names for the badge.

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

An `htmltools` tag, or with an `id` a Shiny UI element.

## Updating from the server

Server-side update for an `el_badge()` given an `id`.

`update_el_badge()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_badge(el_button("btn1", "Messages"), value = 5)
#> <div class="el-badge">
#>   <div id="btn1" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn1_container" style="display: contents">
#>   <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Messages","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":null,"plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"optional":{"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content el-badge__content--danger is-fixed">5</sup>
#> </div>
el_badge(el_button("btn2", "Alerts"), value = 200, max = 99)
#> <div class="el-badge">
#>   <div id="btn2" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn2_container" style="display: contents">
#>   <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Alerts","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":null,"plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"optional":{"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content el-badge__content--danger is-fixed">99+</sup>
#> </div>
el_badge(el_button("btn3", "Updates"), is_dot = TRUE)
#> <div class="el-badge">
#>   <div id="btn3" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn3_container" style="display: contents">
#>   <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Updates","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":null,"plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"optional":{"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content el-badge__content--danger is-fixed is-dot"></sup>
#> </div>

# Updated from the server: update_el_badge(session, "unread", value = 7)
el_badge(el_button("inbox", "Inbox"), value = 3, id = "unread")
#> <div id="unread" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="unread_container" style="display: contents">
#>   <el-badge v-bind="$optional(&#39;badge&#39;)" :is-dot="badgeIsDot" :hidden="badgeHidden">
#>     <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" ref="sv_inbox" id="inbox">{{label}}</el-button>
#>   </el-badge>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"badgeIsDot":false,"badgeHidden":false,"label":"Inbox","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":null,"plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null,"badgeValue":3,"badgeMax":null,"badgeType":null,"badgeShowZero":true,"badgeColor":null,"badgeOffset":null,"badgeBadgeStyle":null,"badgeBadgeClass":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('inbox:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"inbox:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"badge":{"value":"badgeValue","max":"badgeMax","type":"badgeType","show-zero":"badgeShowZero","color":"badgeColor","offset":"badgeOffset","badge-style":"badgeBadgeStyle","badge-class":"badgeBadgeClass"},"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"absorbed":{"inbox":{"fields":{"label":"label","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","count":"count","state":"state","size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_inbox"}},"evals":["options.methods.handleClick","options.mounted"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observe(update_el_badge(
    session,
    "unread",
    value = unread_count(),
    hidden = unread_count() == 0
  ))
}
```
