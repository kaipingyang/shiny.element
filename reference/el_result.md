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
  [`JS()`](https://kaipingyang.github.io/shiny.element/reference/JS.md)
  functions, one per event – Element's, or a DOM event with Vue's
  modifiers (`"keyup.enter"`). Each is called with `report` and the
  event's arguments; `report(name, value)` sets `input$<id>_<name>`. See
  [`el_widget()`](https://kaipingyang.github.io/shiny.element/reference/el_widget.md).

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
#>   <el-result :icon="resultIcon === null ? undefined : resultIcon" :title="resultTitle === null ? undefined : resultTitle" :sub-title="resultSubTitle === null ? undefined : resultSubTitle">
#>     <template v-slot:extra>
#>       <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text" ref="sv_back" id="back">{{label}}</el-button>
#>     </template>
#>   </el-result>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"resultIcon":"success","resultTitle":"Report submitted","resultSubTitle":"It will be reviewed within a day","label":"Back to the list","type":"primary","size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"state":"ready","autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading || this.state === 'busy') return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('back:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"back:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"back":{"fields":{"label":"label","type":"type","size":"size","plain":"plain","round":"round","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","icon":"icon","count":"count","state":"state","autofocus":"autofocus","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_back"}},"evals":["options.methods.handleClick","options.mounted"]}</script>
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
