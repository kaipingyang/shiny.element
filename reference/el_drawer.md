# Element UI Drawer

A panel that slides in from an edge of the viewport.

## Usage

``` r
el_drawer(
  id = NULL,
  title = "",
  content = NULL,
  visible = FALSE,
  direction = "rtl",
  size = "30%",
  modal = TRUE,
  with_header = TRUE,
  show_close = TRUE,
  wrapper_closable = TRUE,
  close_on_press_escape = TRUE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Drawer ID. Auto-generated UUID if `NULL`.

- title:

  Header text.

- content:

  Drawer body. Any tag or tagList, including this package's own
  components.

- visible:

  Whether it starts open.

- direction:

  Edge it slides from: `"rtl"` (from the right, the default), `"ltr"`,
  `"ttb"` or `"btt"`.

- size:

  Width for a horizontal drawer, height for a vertical one.

- modal:

  Show the backdrop.

- with_header:

  Show the header bar.

- show_close:

  Show the close button in the header.

- wrapper_closable:

  Close when the backdrop is clicked.

- close_on_press_escape:

  Close on Escape.

- session:

  Shiny session for module support.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance, so the body can hold
other components from this package. See `.claude/docs/lessons.md` §1.2.

## Shiny input

`input$<id>` — `TRUE` while the drawer is open, reported whenever it
opens or closes, however that happens. (It was `input$<id>_visible`
while this was a Vue component; see
[`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md).)

## Examples

``` r
el_drawer("w1", title = "Settings", content = shiny::tags$p("Body"))
#> <div id="w1" tabindex="-1" class="el-drawer__wrapper" style="display:none" data-el-overlay="true" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true">
#>   <div role="document" tabindex="-1" class="el-drawer__container">
#>     <div aria-modal="true" aria-labelledby="w1-title" aria-label="Settings" role="dialog" tabindex="-1" class="el-drawer rtl" style="width: 30%;">
#>       <header id="w1-title" class="el-drawer__header">
#>         <span role="heading" tabindex="0" title="Settings">Settings</span>
#>         <button aria-label="close Settings" type="button" class="el-drawer__close-btn">
#>           <i class="el-dialog__close el-icon el-icon-close"></i>
#>         </button>
#>       </header>
#>       <section class="el-drawer__body">
#>         <p>Body</p>
#>       </section>
#>     </div>
#>   </div>
#> </div>

# Sliding up from the bottom, holding other components
el_drawer("w2", title = "Filters", direction = "btt", size = "40%",
          content = shiny::tagList(el_input("q"), el_switch("live")))
#> <div id="w2" tabindex="-1" class="el-drawer__wrapper" style="display:none" data-el-overlay="true" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true">
#>   <div role="document" tabindex="-1" class="el-drawer__container">
#>     <div aria-modal="true" aria-labelledby="w2-title" aria-label="Filters" role="dialog" tabindex="-1" class="el-drawer btt" style="height: 40%;">
#>       <header id="w2-title" class="el-drawer__header">
#>         <span role="heading" tabindex="0" title="Filters">Filters</span>
#>         <button aria-label="close Filters" type="button" class="el-drawer__close-btn">
#>           <i class="el-dialog__close el-icon el-icon-close"></i>
#>         </button>
#>       </header>
#>       <section class="el-drawer__body">
#>         <div id="q_container" style="display: contents">
#>           <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent"></el-input>
#>         </div>
#>         <div id="q" style="width:0px;height:0px;" class="vue html-widget"></div>
#>         <script type="application/json" data-for="q">{"x":{"el":"#q_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('q', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"q\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>         <div id="live_container" style="display: contents">
#>           <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :active-icon-class="activeIconClass === null ? undefined : activeIconClass" :inactive-icon-class="inactiveIconClass === null ? undefined : inactiveIconClass" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent"></el-switch>
#>         </div>
#>         <div id="live" style="width:0px;height:0px;" class="vue html-widget"></div>
#>         <script type="application/json" data-for="live">{"x":{"el":"#live_container","data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"activeIconClass":null,"inactiveIconClass":null,"name":null,"validateEvent":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('live', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"live\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>       </section>
#>     </div>
#>   </div>
#> </div>
```
