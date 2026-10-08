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
#>   <el-empty :description="emptyDescription === null ? undefined : emptyDescription" :image="emptyImage === null ? undefined : emptyImage" :image-size="emptyImageSize === null ? undefined : emptyImageSize"></el-empty>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"emptyDescription":"No reports yet","emptyImage":null,"emptyImageSize":null}},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"evals":[]}</script>
#> </div>

el_empty(
  "none",
  description = "No reports yet",
  el_button("create", "Create one", type = "primary")
)
#> <div id="none" data-shiny-vue style="display: contents">
#>   <script type="text/x-template" data-shiny-vue-template><div id="none_container" style="display: contents">
#>   <el-empty :description="emptyDescription === null ? undefined : emptyDescription" :image="emptyImage === null ? undefined : emptyImage" :image-size="emptyImageSize === null ? undefined : emptyImageSize">
#>     <el-button :type="type === null ? undefined : type" :plain="plain === null ? undefined : plain" :round="round === null ? undefined : round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus" :auto-insert-space="autoInsertSpace === null ? undefined : autoInsertSpace" :bg="bg === null ? undefined : bg" :color="color === null ? undefined : color" :dark="dark === null ? undefined : dark" :dashed="dashed === null ? undefined : dashed" :link="link === null ? undefined : link" :loading-icon="loadingIcon === null ? undefined : loadingIcon" :tag="tag === null ? undefined : tag" :text="text === null ? undefined : text" ref="sv_create">{{label}}</el-button>
#>   </el-empty>
#> </div></script>
#>   <script type="application/json" data-shiny-vue-options>{"options":{"data":{"emptyDescription":"No reports yet","emptyImage":null,"emptyImageSize":null,"label":"Create one","type":"primary","size":null,"plain":null,"round":null,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false,"autoInsertSpace":null,"bg":null,"color":null,"dark":null,"dashed":null,"link":null,"loadingIcon":null,"tag":null,"text":null},"methods":{"handleClick":"function() { if (this.disabled || this.loading) return; this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('create:shiny.action', this.count); }"},"mounted":"function() { var self = this; var send = function() { window.Shiny && Shiny.setInputValue && Shiny.setInputValue(\"create:shiny.action\", self.count); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else if (window.jQuery) { jQuery(document).one('shiny:connected', send); } var prev = self._svReport; self._svReport = function() { if (prev) prev(); self.$nextTick(send); }; }"},"input":null,"rate":null,"type":null,"use":["shinyElement.plugin"],"absorbed":{"create":{"fields":{"label":"label","type":"type","size":"size","plain":"plain","round":"round","circle":"circle","loading":"loading","disabled":"disabled","native_type":"native_type","icon":"icon","count":"count","autofocus":"autofocus","autoInsertSpace":"autoInsertSpace","bg":"bg","color":"color","dark":"dark","dashed":"dashed","link":"link","loadingIcon":"loadingIcon","tag":"tag","text":"text","handleClick":"handleClick"},"ref":"sv_create"}},"evals":["options.methods.handleClick","options.mounted"]}</script>
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
