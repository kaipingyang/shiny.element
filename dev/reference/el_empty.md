# Element Plus Empty

A placeholder for a view with nothing in it yet.

## Usage

``` r
el_empty(
  id = NULL,
  ...,
  description = NULL,
  image = NULL,
  image_size = NULL,
  width = NULL,
  slots = NULL,
  on = NULL,
  session = NULL
)

update_el_empty(
  session = shiny::getDefaultReactiveDomain(),
  id,
  description = NULL,
  image = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- ...:

  Content under the description – usually a button that fixes the
  emptiness. A shiny.element component here is absorbed, not nested.

- description:

  Text under the picture. `NULL` for Element's own ("No Data", in the
  page's locale).

- image:

  URL of a picture to use instead of Element's.

- image_size:

  Width of the picture, in pixels.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `image`, `description`.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_widget.md).

- session:

  In `el_empty()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_empty()`, the Shiny session, the current
  one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Updating from the server

Server-side update for `el_empty()`.

`update_el_empty()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_empty("none", description = "No reports yet")
#> <div id="none" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="none_container" style="display: contents">
#>   <el-empty v-bind="$optional(&#39;empty&#39;)"></el-empty>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"emptyDescription":"No reports yet","emptyImage":null,"emptyImageSize":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"empty":{"description":"emptyDescription","image":"emptyImage","image-size":"emptyImageSize"}},"evals":[]}</script>
#> </div>

el_empty(
  "none",
  description = "No reports yet",
  el_button("create", "Create one", type = "primary")
)
#> <div id="none" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="none_container" style="display: contents">
#>   <el-empty v-bind="$optional(&#39;empty&#39;)">
#>     <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" ref="sv_create" id="create">{{label}}</el-button>
#>   </el-empty>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Create one","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":"primary","plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null,"emptyDescription":"No reports yet","emptyImage":null,"emptyImageSize":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('create:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"create:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"empty":{"description":"emptyDescription","image":"emptyImage","image-size":"emptyImageSize"},"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"absorbed":{"create":{"fields":{"label":"label","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","count":"count","state":"state","size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_create"}},"evals":["options.methods.handleClick","options.mounted"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$search, {
    update_el_empty(
      session,
      "none",
      description = paste("Nothing matches", input$search)
    )
  })
}
```
