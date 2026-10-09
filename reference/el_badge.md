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
  [`el_tooltip()`](https://kaipingyang.github.io/shiny.element/reference/el_tooltip.md):
  it keeps reporting, but is reached through
  [`update_vue()`](https://kaipingyang.github.io/shiny.element/reference/update_vue.md)
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
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

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
#>   <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Messages","type":null,"size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content el-badge__content--danger is-fixed">5</sup>
#> </div>
el_badge(el_button("btn2", "Alerts"), value = 200, max = 99)
#> <div class="el-badge">
#>   <div id="btn2" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn2_container" style="display: contents">
#>   <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Alerts","type":null,"size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content el-badge__content--danger is-fixed">99+</sup>
#> </div>
el_badge(el_button("btn3", "Updates"), is_dot = TRUE)
#> <div class="el-badge">
#>   <div id="btn3" data-shiny-vue style="display: contents">
#>     <script type="text/x-template" data-shiny-vue-template><div id="btn3_container" style="display: contents">
#>   <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text">{{label}}</el-button>
#> </div></script>
#>     <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Updates","type":null,"size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; }"}},"input":"count","rate":null,"type":"shiny.action","use":["shinyElement.plugin"],"evals":["options.methods.handleClick"]}</script>
#>   </div>
#>   <sup class="el-badge__content el-badge__content--danger is-fixed is-dot"></sup>
#> </div>

# Updated from the server: update_el_badge(session, "unread", value = 7)
el_badge(el_button("inbox", "Inbox"), value = 3, id = "unread")
#> <div id="unread" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="unread_container" style="display: contents">
#>   <el-badge :value="badgeValue === null ? undefined : badgeValue" :max="badgeMax === null ? undefined : badgeMax" :is-dot="badgeIsDot" :hidden="badgeHidden" :type="badgeType === null ? undefined : badgeType" :show-zero="badgeShowZero === null ? undefined : badgeShowZero" :color="badgeColor === null ? undefined : badgeColor" :offset="badgeOffset === null ? undefined : badgeOffset" :badge-style="badgeBadgeStyle === null ? undefined : badgeBadgeStyle" :badge-class="badgeBadgeClass === null ? undefined : badgeBadgeClass">
#>     <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text" ref="sv_inbox" id="inbox">{{label}}</el-button>
#>   </el-badge>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"badgeValue":3,"badgeMax":null,"badgeIsDot":false,"badgeHidden":false,"badgeType":null,"label":"Inbox","type":null,"size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null,"badgeShowZero":true,"badgeColor":null,"badgeOffset":null,"badgeBadgeStyle":null,"badgeBadgeClass":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('inbox:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"inbox:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"inbox":{"fields":{"label":"label","type":"type","size":"size","plain":"plain","round":"round","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","icon":"icon","count":"count","autofocus":"autofocus","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_inbox"}},"evals":["options.methods.handleClick","options.mounted"]}</script>
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
