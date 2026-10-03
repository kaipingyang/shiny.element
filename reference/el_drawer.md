# Element Plus Drawer

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
  close_on_press_escape = TRUE,
  custom_class = NULL,
  append_to_body = FALSE,
  destroy_on_close = FALSE,
  before_close = NULL,
  footer = NULL,
  resizable = FALSE,
  modal_penetrable = FALSE,
  close_on_click_modal = TRUE,
  lock_scroll = TRUE,
  modal_class = NULL,
  header_class = NULL,
  body_class = NULL,
  footer_class = NULL,
  append_to = NULL,
  open_delay = NULL,
  close_delay = NULL,
  z_index = NULL,
  header_aria_level = "2",
  session = NULL
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

  Whether it starts open: Element Plus's `model-value`.

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

- close_on_press_escape:

  Close on Escape.

- custom_class:

  Extra class name for the panel.

- append_to_body:

  `append_to = "body"`.

- destroy_on_close:

  Re-create the content each time it opens, and remove it when it
  closes: inputs inside start from their initial values again.

- before_close:

  `htmltools::JS()` function `function(done)`, run when the user closes
  it – by the cross, the backdrop or Escape; call `done()` to let it
  close.

- footer:

  Footer content, usually buttons. `NULL` for none.

- resizable:

  Let the drawer be resized by dragging its inner edge.

- modal_penetrable:

  Let clicks through the backdrop to the page beneath, when
  `modal = FALSE`.

- close_on_click_modal:

  Close when the backdrop is clicked. (Element UI's `wrapper-closable`.)

- lock_scroll:

  Whether the page stops scrolling while it is open.

- modal_class, header_class, body_class, footer_class:

  Extra class names for the backdrop, the header, the body and the
  footer.

- append_to:

  A CSS selector for where the overlay goes when it opens, so a
  container's `overflow` or `transform` cannot clip it. Its components
  keep working; they are moved, not re-created.

- open_delay, close_delay:

  Milliseconds to wait before opening and closing.

- z_index:

  The overlay's z-index, instead of the next one Element Plus hands out.

- header_aria_level:

  The title's `aria-level`. Default `"2"`.

- session:

  Deprecated. Inside a module, wrap `id` in `ns()`, as for any Shiny
  input; a session given here namespaces `id` once more, with a warning.

## Value

An `htmltools` tag.

## Details

Rendered as plain markup carrying Element Plus's own classes, driven by
a Shiny input binding rather than a Vue instance, so the body can hold
other components from this package. See `.claude/docs/lessons.md` §1.2.

## Shiny inputs

- `input$<id>` – `TRUE` while the drawer is open, reported whenever it
  opens or closes, however that happens; see
  [`el_dialog()`](https://kaipingyang.github.io/shiny.element/reference/el_dialog.md).

- `input$<id>_open`, `input$<id>_opened` – fire as it opens, and once it
  has.

- `input$<id>_close`, `input$<id>_closed` – likewise as it closes.

- `input$<id>_open_auto_focus`, `input$<id>_close_auto_focus` – as focus
  moves into it on opening, and back on closing.

- `input$<id>_resize_start`, `input$<id>_resize`,
  `input$<id>_resize_end` – with `resizable`, the size in pixels as it
  is dragged.

## Element methods

Callable with
[`el_call()`](https://kaipingyang.github.io/shiny.element/reference/el_call.md):
`handleClose()` closes it the way the user would, through `before_close`
(`closeDrawer()`, Element UI's name, too).

## Examples

``` r
el_drawer("w1", title = "Settings", content = shiny::tags$p("Body"))
#> <div id="w1" class="el-overlay" style="display:none;" data-el-overlay="drawer" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true" data-lock-scroll="true" data-destroy-on-close="false">
#>   <div aria-modal="true" aria-labelledby="w1-title" aria-label="Settings" role="dialog" tabindex="-1" class="el-drawer rtl" style="width: 30%;">
#>     <header class="el-drawer__header">
#>       <span id="w1-title" role="heading" aria-level="2" class="el-drawer__title">Settings</span>
#>       <button aria-label="close Settings" type="button" class="el-drawer__close-btn">
#>         <i class="el-icon el-drawer__close"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><path fill="currentColor" d="M764.288 214.592 512 466.88 259.712 214.592a31.936 31.936 0 0 0-45.12 45.12L466.752 512 214.528 764.224a31.936 31.936 0 1 0 45.12 45.184L512 557.184l252.288 252.288a31.936 31.936 0 0 0 45.12-45.12L557.12 512.064l252.288-252.352a31.936 31.936 0 1 0-45.12-45.184z"></path></svg></i>
#>       </button>
#>     </header>
#>     <div class="el-drawer__body">
#>       <p>Body</p>
#>     </div>
#>   </div>
#> </div>

# Sliding up from the bottom, holding other components
el_drawer("w2", title = "Filters", direction = "btt", size = "40%",
          content = shiny::tagList(el_input("q"), el_switch("live")))
#> <div id="w2" class="el-overlay" style="display:none;" data-el-overlay="drawer" data-visible="false" data-modal="true" data-mask-close="true" data-esc-close="true" data-lock-scroll="true" data-destroy-on-close="false">
#>   <div aria-modal="true" aria-labelledby="w2-title" aria-label="Filters" role="dialog" tabindex="-1" class="el-drawer btt" style="height: 40%;">
#>     <header class="el-drawer__header">
#>       <span id="w2-title" role="heading" aria-level="2" class="el-drawer__title">Filters</span>
#>       <button aria-label="close Filters" type="button" class="el-drawer__close-btn">
#>         <i class="el-icon el-drawer__close"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><path fill="currentColor" d="M764.288 214.592 512 466.88 259.712 214.592a31.936 31.936 0 0 0-45.12 45.12L466.752 512 214.528 764.224a31.936 31.936 0 1 0 45.12 45.184L512 557.184l252.288 252.288a31.936 31.936 0 0 0 45.12-45.12L557.12 512.064l252.288-252.352a31.936 31.936 0 1 0-45.12-45.184z"></path></svg></i>
#>       </button>
#>     </header>
#>     <div class="el-drawer__body">
#>       <div id="q" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="q_container" style="display: contents">
#>   <el-input v-model="value" :type="type" :disabled="disabled" :readonly="readonly" :clearable="clearable" :show-password="showPassword" :show-word-limit="showWordLimit" :autosize="autosize" :prefix-icon="prefixIcon" :suffix-icon="suffixIcon" @change="handleChange" :size="size === null ? undefined : size" :maxlength="maxlength === null ? undefined : maxlength" :rows="rows === null ? undefined : rows" :placeholder="placeholder === null ? undefined : placeholder" :label="label === null ? undefined : label" :autocomplete="autocomplete === null ? undefined : autocomplete" :autofocus="autofocus === null ? undefined : autofocus" :name="name === null ? undefined : name" :form="form === null ? undefined : form" :minlength="minlength === null ? undefined : minlength" :max="max === null ? undefined : max" :min="min === null ? undefined : min" :step="step === null ? undefined : step" :resize="resize === null ? undefined : resize" :tabindex="tabindex === null ? undefined : tabindex" :validate-event="validateEvent === null ? undefined : validateEvent" @input="elEmitInput" @blur="elEmitBlur" @focus="elEmitFocus" @clear="elEmitClear" @compositionend="elEmitCompositionend" @compositionstart="elEmitCompositionstart" @compositionupdate="elEmitCompositionupdate" @keydown="elEmitKeydown" @mouseenter="elEmitMouseenter" @mouseleave="elEmitMouseleave" :aria-label="ariaLabel === null ? undefined : ariaLabel" :clear-icon="clearIcon === null ? undefined : clearIcon" :count-graphemes="countGraphemes === null ? undefined : countGraphemes" :formatter="formatter === null ? undefined : formatter" :input-style="inputStyle === null ? undefined : inputStyle" :inputmode="inputmode === null ? undefined : inputmode" :parser="parser === null ? undefined : parser" :word-limit-position="wordLimitPosition === null ? undefined : wordLimitPosition"></el-input>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":"","type":"text","disabled":false,"readonly":false,"clearable":false,"showPassword":false,"showWordLimit":false,"autosize":false,"prefixIcon":null,"suffixIcon":null,"size":null,"maxlength":null,"rows":null,"placeholder":null,"label":null,"autocomplete":null,"autofocus":null,"name":null,"form":null,"minlength":null,"max":null,"min":null,"step":null,"resize":null,"tabindex":null,"validateEvent":null,"ariaLabel":null,"clearIcon":null,"countGraphemes":null,"formatter":null,"inputStyle":null,"inputmode":null,"parser":null,"wordLimitPosition":null},"methods":{"elEmitInput":"function() { window.shinyVue.emit('q', 'input', arguments); }","elEmitBlur":"function() { window.shinyVue.emit('q', 'blur', arguments); }","elEmitFocus":"function() { window.shinyVue.emit('q', 'focus', arguments); }","elEmitClear":"function() { window.shinyVue.emit('q', 'clear', arguments); }","elEmitCompositionend":"function() { window.shinyVue.emit('q', 'compositionend', arguments); }","elEmitCompositionstart":"function() { window.shinyVue.emit('q', 'compositionstart', arguments); }","elEmitCompositionupdate":"function() { window.shinyVue.emit('q', 'compositionupdate', arguments); }","elEmitKeydown":"function() { window.shinyVue.emit('q', 'keydown', arguments); }","elEmitMouseenter":"function() { window.shinyVue.emit('q', 'mouseenter', arguments); }","elEmitMouseleave":"function() { window.shinyVue.emit('q', 'mouseleave', arguments); }","handleChange":"function(value) { }"}},"input":"value","rate":{"policy":"debounce","delay":250},"type":null,"evals":["options.methods.elEmitInput","options.methods.elEmitBlur","options.methods.elEmitFocus","options.methods.elEmitClear","options.methods.elEmitCompositionend","options.methods.elEmitCompositionstart","options.methods.elEmitCompositionupdate","options.methods.elEmitKeydown","options.methods.elEmitMouseenter","options.methods.elEmitMouseleave","options.methods.handleChange"]}</script>
#>       </div>
#>       <div id="live" data-shiny-vue style="display: contents">
#>         <script type="text/x-template" data-shiny-vue-template><div id="live_container" style="display: contents">
#>   <el-switch v-model="value" :disabled="disabled" :active-text="activeText" :inactive-text="inactiveText" :active-color="activeColor" :inactive-color="inactiveColor" :active-value="activeValue" :inactive-value="inactiveValue" @change="handleChange" :width="width === null ? undefined : width" :name="name === null ? undefined : name" :validate-event="validateEvent === null ? undefined : validateEvent" :active-action-icon="activeActionIcon === null ? undefined : activeActionIcon" :active-icon="activeIcon === null ? undefined : activeIcon" :aria-label="ariaLabel === null ? undefined : ariaLabel" :before-change="beforeChange === null ? undefined : beforeChange" :border-color="borderColor === null ? undefined : borderColor" :inactive-action-icon="inactiveActionIcon === null ? undefined : inactiveActionIcon" :inactive-icon="inactiveIcon === null ? undefined : inactiveIcon" :inline-prompt="inlinePrompt === null ? undefined : inlinePrompt" :loading="loading === null ? undefined : loading" :size="size === null ? undefined : size" :tabindex="tabindex === null ? undefined : tabindex"></el-switch>
#> </div></script>
#>         <script type="application/json" data-shiny-vue-options>{"options":{"data":{"value":false,"disabled":false,"activeText":"","inactiveText":"","activeColor":"","inactiveColor":"","activeValue":true,"inactiveValue":false,"width":null,"name":null,"validateEvent":null,"activeActionIcon":null,"activeIcon":null,"ariaLabel":null,"beforeChange":null,"borderColor":null,"inactiveActionIcon":null,"inactiveIcon":null,"inlinePrompt":null,"loading":null,"size":null,"tabindex":null},"methods":{"handleChange":"function(value) { }"}},"input":"value","rate":null,"type":null,"evals":["options.methods.handleChange"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
