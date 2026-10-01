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
  lock_scroll = TRUE,
  custom_class = NULL,
  append_to_body = FALSE,
  modal_append_to_body = TRUE,
  destroy_on_close = FALSE,
  before_close = NULL,
  session = NULL
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

- lock_scroll:

  Whether the page stops scrolling while it is open.

- custom_class:

  Extra class name for the panel.

- append_to_body:

  Move the overlay to `<body>` when it opens, so a container's
  `overflow` or `transform` cannot clip it. Its components keep working;
  they are moved, not re-created.

- modal_append_to_body:

  Whether the backdrop goes on `<body>` (the default) or beside the
  overlay.

- destroy_on_close:

  Re-create the content each time it opens, and remove it when it
  closes: inputs inside start from their initial values again.

- before_close:

  `htmltools::JS()` function `function(done)`, run when the user closes
  it – by the cross, the backdrop or Escape; call `done()` to let it
  close.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element's own classes, driven by a
Shiny input binding rather than a Vue instance, so the body can hold
other components from this package. See `.claude/docs/lessons.md` §1.2.

## Shiny inputs

- `input$<id>` – whether it is open.

- `input$<id>_open`, `input$<id>_opened` – fire as it opens, and once it
  has.

- `input$<id>_close`, `input$<id>_closed` – likewise as it closes.

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
#> <div id="d1" class="el-dialog__wrapper" style="display:none" data-el-overlay="true" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true" data-lock-scroll="true" data-append-to-body="false" data-modal-append-to-body="true" data-destroy-on-close="false">
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
#>       <div id="ok" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="ok_container" style="display: contents">
#>   <el-button :type="type" :plain="plain" :round="round" :circle="circle" :loading="loading" :disabled="disabled" :native-type="native_type" @click="handleClick" :size="size === null ? undefined : size" :icon="icon === null ? undefined : icon" :autofocus="autofocus === null ? undefined : autofocus">{{label}}</el-button>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"label":"OK","type":"primary","size":null,"plain":false,"round":false,"circle":false,"loading":false,"disabled":false,"native_type":"button","icon":null,"count":0,"autofocus":false},"methods":{"handleClick":"function() { if (!this.disabled && !this.loading) { this.count++; window.Shiny && Shiny.setInputValue && Shiny.setInputValue('ok', this.count); } }"}},"input":null,"rate":null,"type":null,"evals":["options.methods.handleClick"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>

# The body can hold other components
el_dialog("d2", title = "Filters",
          content = shiny::tagList(el_input("q"), el_switch("live")))
#> <div id="d2" class="el-dialog__wrapper" style="display:none" data-el-overlay="true" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true" data-lock-scroll="true" data-append-to-body="false" data-modal-append-to-body="true" data-destroy-on-close="false">
#>   <div role="dialog" aria-modal="true" aria-label="Filters" class="el-dialog" style="margin-top: 15vh; width: 50%;">
#>     <div class="el-dialog__header">
#>       <span class="el-dialog__title">Filters</span>
#>       <button type="button" aria-label="Close" class="el-dialog__headerbtn">
#>         <i class="el-dialog__close el-icon el-icon-close"></i>
#>       </button>
#>     </div>
#>     <div class="el-dialog__body">
#>       <div id="q" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="q_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear"></el-input>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null},"methods":{"elEmitInput":"function() { window.shinyElement.emit('q', 'input', arguments); }","elEmitBlur":"function() { window.shinyElement.emit('q', 'blur', arguments); }","elEmitFocus":"function() { window.shinyElement.emit('q', 'focus', arguments); }","elEmitClear":"function() { window.shinyElement.emit('q', 'clear', arguments); }","handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('q', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.handleChange"]}</script>
#>       </div>
#>       <div id="live" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="live_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :active-icon-class="activeIconClass === null ? undefined : activeIconClass" :inactive-icon-class="inactiveIconClass === null ? undefined : inactiveIconClass" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent"></el-switch>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"activeIconClass":null,"inactiveIconClass":null,"name":null,"validateEvent":null},"methods":{"handleChange":"function(value) { window.Shiny && Shiny.setInputValue && Shiny.setInputValue('live', value); }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleChange"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
