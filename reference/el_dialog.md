# Element UI Dialog

A modal dialog.

## Usage

``` r
el_dialog(
  id = NULL,
  title = "",
  content = NULL,
  footer = NULL,
  visible = FALSE,
  width = "50%",
  top = "15vh",
  fullscreen = FALSE,
  modal = TRUE,
  close_on_click_modal = TRUE,
  close_on_press_escape = TRUE,
  show_close = TRUE,
  center = FALSE,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Dialog ID. Auto-generated UUID if `NULL`.

- title:

  Header text. `""` renders the header bar without a title.

- content:

  Dialog body. Any tag or tagList, including this package's own
  components.

- footer:

  Footer content, usually buttons. `NULL` for none.

- visible:

  Whether it starts open.

- width:

  Dialog width, e.g. `"50%"` or `"600px"`.

- top:

  Distance from the top of the viewport. Ignored when
  `fullscreen = TRUE`.

- fullscreen:

  Fill the viewport.

- modal:

  Show the backdrop.

- close_on_click_modal:

  Close when the backdrop is clicked.

- close_on_press_escape:

  Close on Escape.

- show_close:

  Show the close button in the header.

- center:

  Centre the header and footer.

- session:

  Shiny session for module support.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance, so the body can hold
other components from this package. See `.claude/docs/lessons.md` §1.2.

## Shiny input

`input$<id>` — `TRUE` while the dialog is open, reported whenever it
opens or closes, however that happens. (It was `input$<id>_visible`
while this was a Vue component; Shiny routes an input binding's messages
by element id, so the name now matches the id, as it does for
[`el_tabs()`](https://kaipingyang.github.io/shiny.element/reference/el_tabs.md)
and
[`el_collapse()`](https://kaipingyang.github.io/shiny.element/reference/el_collapse.md).)

## Examples

``` r
el_dialog("d1", title = "Confirm", content = shiny::tags$p("Are you sure?"),
          footer = el_button("ok", "OK", type = "primary"))
#> <div id="d1" class="el-dialog__wrapper" style="display:none" data-el-overlay="true" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true">
#>   <div role="dialog" aria-modal="true" aria-label="Confirm" class="el-dialog" style="margin-top: 15vh; width: 50%;">
#>     <div class="el-dialog__header">
#>       <span class="el-dialog__title">Confirm</span>
#>       <button type="button" aria-label="Close" class="el-dialog__headerbtn">
#>         <i class="el-dialog__close el-icon el-icon-close"></i>
#>       </button>
#>     </div>
#>     <div class="el-dialog__body">
#>       <p>Are you sure?</p>
#>     </div>
#>     <div class="el-dialog__footer">
#>       <div id="ok_container" style="display: contents">
#>         <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size">{{label}}</el-button>
#>       </div>
#>       <div id="ok" style="width:0px;height:0px;" class="vue html-widget"></div>
#>       <script type="application/json" data-for="ok">{"x":{"el":"#ok_container","data":{"label":"OK","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","count":0},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; Shiny.setInputValue('ok', this.count); } }"}},"evals":["methods.handleClick"],"jsHooks":[]}</script>
#>     </div>
#>   </div>
#> </div>

# The body can hold other components
el_dialog("d2", title = "Filters",
          content = shiny::tagList(el_input("q"), el_switch("live")))
#> <div id="d2" class="el-dialog__wrapper" style="display:none" data-el-overlay="true" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true">
#>   <div role="dialog" aria-modal="true" aria-label="Filters" class="el-dialog" style="margin-top: 15vh; width: 50%;">
#>     <div class="el-dialog__header">
#>       <span class="el-dialog__title">Filters</span>
#>       <button type="button" aria-label="Close" class="el-dialog__headerbtn">
#>         <i class="el-dialog__close el-icon el-icon-close"></i>
#>       </button>
#>     </div>
#>     <div class="el-dialog__body">
#>       <div id="q_container" style="display: contents">
#>         <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label"></el-input>
#>       </div>
#>       <div id="q" style="width:0px;height:0px;" class="vue html-widget"></div>
#>       <script type="application/json" data-for="q">{"x":{"el":"#q_container","data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('q', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"q\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>       <div id="live_container" style="display: contents">
#>         <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width"></el-switch>
#>       </div>
#>       <div id="live" style="width:0px;height:0px;" class="vue html-widget"></div>
#>       <script type="application/json" data-for="live">{"x":{"el":"#live_container","data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null},"methods":{"handleChange":"function(value) { Shiny.setInputValue('live', value); }"},"mounted":"function() { var self = this; var send = function() { Shiny.setInputValue(\"live\", self.value); }; if (window.Shiny && Shiny.shinyapp && typeof Shiny.shinyapp.isConnected === 'function' && Shiny.shinyapp.isConnected()) { send(); } else { $(document).one('shiny:connected', send); } }"},"evals":["methods.handleChange","mounted"],"jsHooks":[]}</script>
#>     </div>
#>   </div>
#> </div>
```
