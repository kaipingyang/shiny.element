# Element Plus Result

The outcome of an operation: an icon, a title, a line of detail, and
what to do next.

## Usage

``` r
el_result(
  id = NULL,
  ...,
  icon = NULL,
  title = NULL,
  sub_title = NULL,
  width = NULL,
  slots = NULL,
  on = NULL,
  session = NULL
)

update_el_result(
  session = shiny::getDefaultReactiveDomain(),
  id,
  icon = NULL,
  title = NULL,
  sub_title = NULL
)
```

## Arguments

- id:

  Component ID. Auto-generated if `NULL`.

- ...:

  What to do next, shown under the text – usually buttons. A
  shiny.element component here is absorbed, not nested, and keeps
  reporting its inputs.

- icon:

  `"primary"`, `"success"`, `"warning"`, `"info"` or `"error"`.

- title:

  Headline.

- sub_title:

  Detail under the headline.

- width:

  Component width, as a CSS unit.

- slots:

  Named list of Element slot contents: `icon`, `title`, `sub-title`,
  `extra`.

- on:

  Handlers of your own, for an event not reported or to send something
  else: a named list of
  [`JS()`](https://kaipingyang.github.io/shiny.element/dev/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/dev/reference/el_widget.md).

- session:

  In `el_result()`, deprecated: inside a module, wrap `id` in `ns()`, as
  for any Shiny input; a session given here namespaces `id` once more,
  with a warning. In `update_el_result()`, the Shiny session, the
  current one by default, as for
  [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html).

## Value

A Shiny UI element.

## Updating from the server

Server-side update for `el_result()`.

`update_el_result()` is called for its side effect and returns `NULL`
invisibly.

## Examples

``` r
el_result(
  "done",
  icon = "success",
  title = "Report submitted",
  sub_title = "It will be reviewed within a day",
  el_button("back", "Back to the list", type = "primary")
)
#> <div id="done" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="done_container" style="display: contents">
#>   <el-result v-bind="$optional(&#39;result&#39;)">
#>     <template v-slot:extra>
#>       <el-button v-bind="$optional(&#39;button&#39;)" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" ref="sv_back" id="back">{{label}}</el-button>
#>     </template>
#>   </el-result>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"Back to the list","circle":false,"loading":false,"disabled":false,"native_type":"button","count":0,"state":"ready","size":null,"icon":null,"autofocus":false,"type":"primary","plain":null,"round":null,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null,"resultIcon":"success","resultTitle":"Report submitted","resultSubTitle":"It will be reviewed within a day"},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('back:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"back:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"optional":{"result":{"icon":"resultIcon","title":"resultTitle","sub-title":"resultSubTitle"},"button":{"size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","auto-insert-space":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loading-icon":"loadingIcon","tag":"tag","text":"text"}},"absorbed":{"back":{"fields":{"label":"label","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","count":"count","state":"state","size":"size","icon":"icon","autofocus":"autofocus","type":"type","plain":"plain","round":"round","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_back"}},"evals":["options.methods.handleClick","options.mounted"]}</script>
#> </div>
if (interactive()) {
  # inside a server function
  observeEvent(input$submit, {
    ok <- tryCatch(
      {
        save()
        TRUE
      },
      error = function(e) FALSE
    )
    update_el_result(
      session,
      "outcome",
      icon = if (ok) "success" else "error",
      title = if (ok) "Saved" else "Could not save"
    )
  })
}
```
